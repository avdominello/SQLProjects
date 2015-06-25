EXEC sp_change_users_login 'report' --See all orphaned users in the database.

DECLARE @OrphanedUsers TABLE (
	IndexKey INT IDENTITY(1, 1) PRIMARY KEY
	,UserName SYSNAME
	,--nVarChar(128)
	UserSID VARBINARY(85)
	)

INSERT INTO @OrphanedUsers
EXEC sp_change_users_login 'report'

DECLARE @CRLF AS NVARCHAR

SET @CRLF = CHAR(10) + '&' + CHAR(13) --NOTE: Carriage-Return/Line-Feed will only appear in PRINT statements, not SELECT statements.

DECLARE @Sql AS NVARCHAR(MAX)

SET @Sql = N''

DECLARE @IndexKey AS INT

SET @IndexKey = 1

DECLARE @MaxIndexKey AS INT

SET @MaxIndexKey = (
		SELECT COUNT(*)
		FROM @OrphanedUsers
		)

DECLARE @Count AS INT

SET @Count = 0

DECLARE @UsersFixed AS NVARCHAR(MAX)

SET @UsersFixed = N''

DECLARE @UserName AS SYSNAME --This is an orphaned Database user.

WHILE (@IndexKey <= @MaxIndexKey)
BEGIN
	SET @UserName = (
			SELECT UserName
			FROM @OrphanedUsers
			WHERE IndexKey = @IndexKey
			)

	IF 1 = (
			SELECT COUNT(*)
			FROM sys.server_principals
			WHERE NAME = @UserName
			) --Look for a match in the Server Logins.
	BEGIN
		SET @Sql = @Sql + 'EXEC sp_change_users_login ''update_one'', [' + @UserName + '], [' + @UserName + ']' + @CRLF
		SET @UsersFixed = @UsersFixed + @UserName + ', '
		SET @Count = @Count + 1
	END

	SET @IndexKey = @IndexKey + 1
END

PRINT @Sql

EXEC sp_executesql @Sql

PRINT 'Total fixed: ' + CAST(@Count AS VARCHAR) + '.  Users Fixed: ' + @UsersFixed

SELECT ('Total fixed: ' + CAST(@Count AS VARCHAR) + '.  Users Fixed: ' + @UsersFixed) [Fixed]

EXEC sp_change_users_login 'report' --See all orphaned users still in the database.
