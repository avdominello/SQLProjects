SELECT o.NAME AS TableName
	,i.NAME AS indexname
	,user_seeks + user_scans + user_lookups AS NumOfReads
	,user_updates AS NumOfWrites
	,i.is_primary_key AS PrimaryKey
	,(
		SELECT SUM(p.rows)
		FROM sys.partitions p
		WHERE p.index_id = s.index_id
			AND s.object_id = p.object_id
		) AS TableRows
	,CASE 
		WHEN s.user_updates < 1
			THEN 100
		ELSE 1.00 * (s.user_seeks + s.user_scans + s.user_lookups) / s.user_updates
		END AS ReadsPerWrites
	,'DROP INDEX ' + QUOTENAME(i.NAME) + ' ON ' + QUOTENAME(c.NAME) + '.' + QUOTENAME(OBJECT_NAME(s.object_id)) AS 'DropStatement'
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON i.index_id = s.index_id
	AND s.object_id = i.object_id
INNER JOIN sys.objects o ON s.object_id = o.object_id
INNER JOIN sys.schemas c ON o.schema_id = c.schema_id
WHERE OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1
	AND s.database_id = DB_ID()
	AND i.type_desc = 'nonclustered'
	AND i.is_primary_key = 0
	AND i.is_unique_constraint = 0
	AND (
		SELECT SUM(p.rows)
		FROM sys.partitions p
		WHERE p.index_id = s.index_id
			AND s.object_id = p.object_id
		) > 10000 -- rows in table
ORDER BY NumOfReads
