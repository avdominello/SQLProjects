--Refresh the underlying metadata of all views in the 'dbo' schema
DECLARE @viewName AS VARCHAR(255)

DECLARE listOfViews CURSOR
FOR
SELECT v.[TABLE_NAME]
FROM INFORMATION_SCHEMA.VIEWS v
LEFT OUTER JOIN sys.sql_dependencies d ON v.[TABLE_NAME] = OBJECT_NAME(d.object_id)
WHERE v.[TABLE_SCHEMA] = 'dbo'
	AND (
		d.[class_desc] IS NULL
		OR d.[class_desc] <> 'OBJECT_OR_COLUMN_REFERENCE_SCHEMA_BOUND'
		)
GROUP BY v.[TABLE_NAME]
ORDER BY v.[TABLE_NAME]

OPEN listOfViews

FETCH NEXT
FROM listOfViews
INTO @viewName

WHILE (@@FETCH_STATUS <> - 1)
BEGIN
	PRINT @viewName

	EXEC sp_refreshview @viewName

	FETCH NEXT
	FROM listOfViews
	INTO @viewName
END

CLOSE listOfViews

DEALLOCATE listOfViews
	-- ROLLBACK
	-- COMMIT
