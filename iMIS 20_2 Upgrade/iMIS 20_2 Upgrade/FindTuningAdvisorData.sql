SELECT OBJECT_NAME(s.[object_id]) AS TableName
	,s.[name] AS StatName
FROM sys.stats s
WHERE OBJECTPROPERTY(s.OBJECT_ID, 'IsUserTable') = 1
	AND s.NAME LIKE '_dta_stat%';
