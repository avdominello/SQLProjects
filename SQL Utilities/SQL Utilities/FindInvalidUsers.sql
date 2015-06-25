SET NOCOUNT ON

CREATE TABLE #invalid_logins (
	[sid] VARBINARY(85)
	,[name] SYSNAME
	)

CREATE TABLE #Logins (
	account_name SYSNAME NULL
	,type CHAR(8) NULL
	,privilege CHAR(9) NULL
	,mapped_login_name SYSNAME NULL
	,permission_path SYSNAME NULL
	)

INSERT #invalid_logins
EXEC sp_validatelogins

DECLARE @name SYSNAME

DECLARE csr CURSOR FAST_FORWARD READ_ONLY
FOR
SELECT sl.NAME
FROM sys.syslogins sl
LEFT OUTER JOIN #invalid_logins il ON sl.NAME = il.NAME
WHERE sl.isntname = 1
	AND sl.isntgroup = 0
	AND il.NAME IS NULL

OPEN csr

FETCH NEXT
FROM csr
INTO @name

WHILE @@FETCH_STATUS <> - 1
BEGIN
	INSERT #Logins
	EXEC xp_logininfo @acctname = @name
		,@option = 'all'

	FETCH NEXT
	FROM csr
	INTO @name
END

CLOSE csr

DEALLOCATE csr

PRINT 'The following logins are no longer valid and should be removed from this server:'

SELECT NAME
FROM #invalid_logins

PRINT 'The following logins have access by login and by group and might not need access by login:'

SELECT COUNT(*) AS num_of_groups
	,account_name
	,REPLACE(RTRIM((
				SELECT permission_path + ' '
				FROM #Logins
				WHERE account_name = l.account_name
				FOR XML PATH('')
				)), ' ', ', ') AS group_names
	,'EXEC xp_logininfo @acctname=' + QUOTENAME(account_name) + ', @option=''all''' AS command_to_see_groups
FROM #Logins l
GROUP BY account_name
	,[type]
HAVING COUNT(*) > 1
ORDER BY num_of_groups DESC

DROP TABLE #invalid_logins

DROP TABLE #Logins

PRINT 'The following result set shows users that were deleted from the server but not the individual databases'

CREATE TABLE #databases_with_orphan_users (
	db_with_orphan_login SYSNAME
	,orphan_login SYSNAME
	,permissions_count INT
	)


EXEC sp_MSforeachdb
'USE ?
INSERT #databases_with_orphan_users
SELECT ''?'' AS db_with_orphan_login,
dp.name,
(SELECT COUNT(*) FROM sys.database_permissions WHERE grantee_principal_id = sp.principal_id) AS permissions_count
FROM sys.server_principals sp
RIGHT OUTER JOIN sys.database_principals dp
ON sp.sid = dp.sid
WHERE sp.sid IS NULL
AND dp.type NOT IN (''R'')
AND dp.name NOT IN (''guest'', ''sys'', ''INFORMATION_SCHEMA'')
AND dp.type_desc NOT IN (''APPLICATION_ROLE'')
'


SELECT db_with_orphan_login
	,orphan_login
	,permissions_count
FROM #databases_with_orphan_users

DROP TABLE #databases_with_orphan_users

