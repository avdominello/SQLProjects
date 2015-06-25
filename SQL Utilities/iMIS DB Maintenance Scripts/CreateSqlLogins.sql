-- script to fix up a restored iMIS db for iMIS15
--    Henry Huey 13 Sept 2006
--    Paul Bradshaw 15 Feb 2010
--    Paul Bradshaw 22 Aug 2012
SET NOCOUNT ON
SET ANSI_DEFAULTS ON
SET IMPLICIT_TRANSACTIONS OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET NOCOUNT ON
GO

-------------------------------------------------------------------------------
-- Ensure required Name_Fin, Name_Security, and Name_Security_Groups rows exist
-------------------------------------------------------------------------------
PRINT '   Ensuring Contact Integrity'

INSERT INTO Name_Fin (ID)
SELECT a.ID
FROM NAME a
LEFT OUTER JOIN Name_Fin b ON a.ID = b.ID
WHERE b.ID IS NULL
GO

INSERT INTO Name_Security (ID)
SELECT a.ID
FROM NAME a
LEFT OUTER JOIN Name_Security b ON a.ID = b.ID
WHERE b.ID IS NULL
GO

INSERT INTO Name_Security_Groups (ID)
SELECT a.ID
FROM NAME a
LEFT OUTER JOIN Name_Security_Groups b ON a.ID = b.ID
WHERE b.ID IS NULL
GO

-- Create defaults required by desktop if necessary and
-- ensure ANSI and Compatibility Settings are correct on the DB
PRINT '   Ensuring proper database settings'

IF NOT EXISTS (
		SELECT 1
		FROM sys.sysobjects
		WHERE [name] = 'char_default'
		)
	EXECUTE (N'CREATE DEFAULT [dbo].[char_default] AS '''' ')

IF NOT EXISTS (
		SELECT 1
		FROM sys.sysobjects
		WHERE [name] = 'boolean_default'
		)
	EXECUTE (N'CREATE DEFAULT [dbo].[boolean_default] AS 0 ')

DECLARE @sql NVARCHAR(400)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET ANSI_NULL_DEFAULT ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET ANSI_NULLS ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET ANSI_PADDING ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET ANSI_WARNINGS ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET ARITHABORT ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET CONCAT_NULL_YIELDS_NULL ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET QUOTED_IDENTIFIER ON WITH NO_WAIT'

EXEC (@sql)

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET NUMERIC_ROUNDABORT OFF WITH NO_WAIT'

EXEC (@sql)

DECLARE @level NVARCHAR(10)

SELECT @level = LEFT(CONVERT(NVARCHAR(10), SERVERPROPERTY(N'ProductVersion')), CHARINDEX('.', CONVERT(NVARCHAR(10), SERVERPROPERTY(N'ProductVersion'))) - 1) + N'0'

SET @sql = N'ALTER DATABASE ' + DB_NAME() + N' SET COMPATIBILITY_LEVEL = ' + @level

EXEC (@sql)
GO

-- Update temp file paths in System Config
PRINT '   Updating temp file paths in System Config'

DECLARE @dir NVARCHAR(400)
DECLARE @slashPos INT

SELECT @dir = [ParameterValue]
FROM [dbo].[SystemConfig]
WHERE [ParameterName] = N'TempDirectory'

SET @slashPos = LEN(@dir) - CHARINDEX('\', REVERSE(@dir))

IF (
		@slashPos > 0
		AND @slashPos < LEN(@dir)
		)
BEGIN
	SET @dir = LEFT(@dir, @slashpos + 1)

	DECLARE @tempDir NVARCHAR(400)

	SELECT @tempDir = REPLACE(@@SERVERNAME, '\', '-') + '_' + DB_NAME()

	SET @dir = @dir + @tempDir

	UPDATE [dbo].[SystemConfig]
	SET [ParameterValue] = @dir
	WHERE [ParameterName] = 'TempDirectory'
END
GO

DECLARE @dir NVARCHAR(400)
DECLARE @slashPos INT

SELECT @dir = [ParameterValue]
FROM [dbo].[SystemConfig]
WHERE [ParameterName] = N'CrystalReports.TempPath'

SET @slashPos = LEN(@dir) - CHARINDEX('\', REVERSE(@dir))

IF (
		@slashPos > 0
		AND @slashPos < LEN(@dir)
		)
BEGIN
	SET @dir = LEFT(@dir, @slashpos + 1)

	DECLARE @tempDir NVARCHAR(400)

	SELECT @tempDir = REPLACE(@@SERVERNAME, '\', '-') + '_' + DB_NAME()

	SET @dir = @dir + @tempDir

	UPDATE [dbo].[SystemConfig]
	SET [ParameterValue] = @dir
	WHERE [ParameterName] = 'CrystalReports.TempPath'
END
GO

DECLARE @dir NVARCHAR(400)
DECLARE @slashPos INT

SELECT @dir = [ParameterValue]
FROM [dbo].[SystemConfig]
WHERE [ParameterName] = 'ReportingServices.TempPath'

SET @slashPos = LEN(@dir) - CHARINDEX('\', REVERSE(@dir))

IF (
		@slashPos > 0
		AND @slashPos < LEN(@dir)
		)
BEGIN
	SET @dir = LEFT(@dir, @slashpos + 1)

	DECLARE @tempDir NVARCHAR(400)

	SELECT @tempDir = REPLACE(@@SERVERNAME, '\', '-') + '_' + DB_NAME()

	SET @dir = @dir + @tempDir

	UPDATE [dbo].[SystemConfig]
	SET [ParameterValue] = @dir
	WHERE [ParameterName] = 'ReportingServices.TempPath'
END
GO

---------------------------------------------------------
-- Delete all orphaned database users in a given database
---------------------------------------------------------
PRINT '   Deleting orphaned iMIS database users'

DECLARE @sql NVARCHAR(max)
DECLARE @userName SYSNAME

DECLARE theCursor CURSOR FAST_FORWARD
FOR
SELECT CAST(NAME AS SYSNAME) AS [Orphaned User]
FROM sys.sysusers su
WHERE su.islogin = 1
	AND su.STATUS <> 16
	AND (
		su.NAME LIKE 'MANAGER_%'
		OR su.NAME LIKE 'IMISUSER_%'
		)
	AND su.NAME <> 'MANAGER_' + db_name()
	AND su.NAME <> 'IMISUSER_' + db_name()
	AND NOT EXISTS (
		SELECT 1
		FROM master.sys.syslogins sl
		WHERE su.sid = sl.sid
		)

OPEN theCursor

FETCH NEXT
FROM theCursor
INTO @userName

WHILE @@FETCH_STATUS = 0 -- spin through user entries
BEGIN
	PRINT '       ' + @userName

	SELECT @sql = N'IF EXISTS (SELECT 1 FROM sys.schemas WHERE [name] = ''' + @userName + N''') DROP SCHEMA [' + @userName + N']'

	EXEC (@sql)

	SELECT @sql = N'DROP USER [' + @userName + N']'

	EXEC (@sql)

	FETCH NEXT
	FROM theCursor
	INTO @userName
END

CLOSE theCursor

DEALLOCATE theCursor

------------------------------------
-- create the IMIS role if necessary
------------------------------------
IF NOT EXISTS (
		SELECT 1
		FROM sys.database_principals
		WHERE [name] = N'IMIS'
			AND [type_desc] = N'DATABASE_ROLE'
		)
BEGIN
	CREATE ROLE [IMIS] AUTHORIZATION [dbo]
END
GO

-- Drop obsolete System_Param values if present
DELETE
FROM System_Params
WHERE ParameterName = 'System_Control.WebServerURL'

-- Ensure correct security model is set for backwards compatibility
UPDATE System_Params
SET ShortValue = '3'
WHERE ParameterName = 'System_Control.SQLSecurityModel'
GO

----------------------------------------------
-- Create the Master and Manager SQL passwords
----------------------------------------------
DECLARE @password NVARCHAR(50)

SELECT @password = newid()

----------------------------------------
-- Create the MANAGER reserved SQL login
----------------------------------------
DECLARE @execSQL NVARCHAR(1000)
DECLARE @userName NVARCHAR(200)

SELECT @userName = 'MANAGER' + '_' + DB_NAME()

PRINT '   Ensuring Manager Login ' + @userName + ' is Present'

-- Drop MANAGER schema, alias, db user, and login if they already exist
IF EXISTS (
		SELECT 1
		FROM sys.schemas
		WHERE [name] = @userName
		)
BEGIN
	SELECT @execSQL = 'DROP SCHEMA [' + @userName + ']'

	EXEC (@execSQL)
END

IF EXISTS (
		SELECT 1
		FROM sys.sysusers
		WHERE NAME = @userName
		)
BEGIN
	EXEC sp_dropuser @userName
END

BEGIN TRY
	IF EXISTS (
			SELECT 1
			FROM sys.sql_logins
			WHERE NAME = @userName
			)
	BEGIN
		EXEC sp_droplogin @userName
	END
END TRY

BEGIN CATCH
	PRINT '   *** ERROR Attempting to Create Manager Login'
	PRINT '   *** ' + ERROR_MESSAGE()
	PRINT '   *** Please ensure all iMIS Desktop users are logged out'

	-- Restore user
	IF NOT EXISTS (
			SELECT 1
			FROM sys.sysusers
			WHERE [name] = @userName
			)
	BEGIN
		SELECT @execSQL = 'sp_adduser [' + @userName + '],  [' + @userName + ']'

		EXEC (@execSQL)
	END

	-- restore role
	SELECT @execSQL = 'sp_addrolemember ''db_owner'', [' + @userName + ']'

	EXEC (@execSQL)

	RETURN
END CATCH

-- Add MANAGER login, user, and add user to roles
IF NOT EXISTS (
		SELECT NAME
		FROM sys.syslogins
		WHERE [name] = @userName
		)
BEGIN
	SELECT @execSQL = 'sp_addlogin [' + @userName + '], ''' + @password + ''', ' + db_name()

	EXEC (@execSQL)
END

IF NOT EXISTS (
		SELECT 1
		FROM sys.sysusers
		WHERE [name] = @userName
		)
BEGIN
	SELECT @execSQL = 'sp_adduser [' + @userName + '],  [' + @userName + ']'

	EXEC (@execSQL)
END

-- Add MANAGER to db_owner
SELECT @execSQL = 'sp_addrolemember ''db_owner'', [' + @userName + ']'

EXEC (@execSQL)

-----------------------------------------
-- create the IMISUSER reserved SQL login
-----------------------------------------
SELECT @userName = 'IMISUSER' + '_' + db_name()

PRINT '   Ensuring User Logon ' + @userName + ' is Present'

-- Drop IMISUSER schema, user, and login
IF EXISTS (
		SELECT 1
		FROM sys.schemas
		WHERE [name] = @userName
		)
BEGIN
	SELECT @execSQL = 'DROP SCHEMA [' + @userName + ']'

	EXEC (@execSQL)
END

IF EXISTS (
		SELECT 1
		FROM sys.sysusers
		WHERE [name] = @userName
		)
BEGIN
	EXEC sp_dropuser @userName
END

BEGIN TRY
	IF EXISTS (
			SELECT 1
			FROM master..syslogins
			WHERE [name] = @userName
			)
	BEGIN
		EXEC sp_droplogin @userName
	END
END TRY

BEGIN CATCH
	PRINT '   *** ERROR Attempting to Create Manager Login'
	PRINT '   *** ' + ERROR_MESSAGE()
	PRINT '   *** Please ensure all iMIS Desktop users are logged out'

	-- Restore user
	IF NOT EXISTS (
			SELECT 1
			FROM sys.sysusers
			WHERE [name] = @userName
			)
	BEGIN
		SELECT @execSQL = 'sp_adduser [' + @userName + '], [' + @userName + ']'

		EXEC (@execSQL)
	END

	-- restore user to IMIS role
	SELECT @execSQL = 'sp_addrolemember ''IMIS'', [' + @userName + ']'

	EXEC (@execSQL)

	RETURN
END CATCH

-- Add the IMIS login, user, and add user to roles
IF NOT EXISTS (
		SELECT [name]
		FROM master.dbo.syslogins
		WHERE [name] = @userName
		)
BEGIN
	SELECT @execSQL = 'sp_addlogin [' + @userName + '], ''' + @password + ''', ' + db_name()

	EXEC (@execSQL)
END

IF NOT EXISTS (
		SELECT 1
		FROM sys.sysusers
		WHERE [name] = @userName
		)
BEGIN
	SELECT @execSQL = 'sp_adduser [' + @userName + '], [' + @userName + ']'

	EXEC (@execSQL)
END

-- Add IMISUSER to IMIS role
SELECT @execSQL = 'sp_addrolemember ''IMIS'', [' + @userName + ']'

EXEC (@execSQL)

-- Update password in database
DELETE
FROM System_Params
WHERE ParameterName = 'System_Control.SQLManagerPassword'

INSERT INTO System_Params (
	ParameterName
	,ShortValue
	)
VALUES (
	'System_Control.SQLManagerPassword'
	,@password
	)

DELETE
FROM System_Params
WHERE ParameterName = 'System_Control.SQLMasterPassword'

INSERT INTO System_Params (
	ParameterName
	,ShortValue
	)
VALUES (
	'System_Control.SQLMasterPassword'
	,@password
	)
GO

-- Create ASIGOPHER user
PRINT '   Ensuring iMIS Standard Users are Present'

IF EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE NAME = N'ASIGOPHER'
		)
BEGIN
	ALTER AUTHORIZATION ON SCHEMA::ASIGOPHER TO dbo

	DROP SCHEMA [ASIGOPHER]
END
GO

IF EXISTS (
		SELECT *
		FROM sys.database_principals
		WHERE NAME = N'ASIGOPHER'
		)
BEGIN
	DROP USER [ASIGOPHER]
END
GO

CREATE USER [ASIGOPHER] WITHOUT LOGIN
	WITH DEFAULT_SCHEMA = [ASIGOPHER]
GO

CREATE SCHEMA [ASIGOPHER] AUTHORIZATION [ASIGOPHER]
GO

-- Create IMISUser user
IF EXISTS (
		SELECT *
		FROM sys.schemas
		WHERE NAME = N'IMISUSER'
		)
BEGIN
	ALTER AUTHORIZATION ON SCHEMA::IMISUSER TO dbo

	DROP SCHEMA [IMISUSER]
END

IF EXISTS (
		SELECT *
		FROM sys.database_principals
		WHERE NAME = N'IMISUSER'
		)
BEGIN
	DROP USER [IMISUSER]
END
GO

CREATE USER [IMISUSER] WITHOUT LOGIN
	WITH DEFAULT_SCHEMA = [IMISUSER]
GO

PRINT '   Complete'

SET NOCOUNT OFF
GO


