DECLARE @imisid VARCHAR(10);

DECLARE cs CURSOR
FOR
SELECT [iMIS Id]
FROM dba..adHMX_STATUS

OPEN cs

BEGIN TRANSACTION

FETCH NEXT
FROM cs
INTO @imisid

WHILE (@@FETCH_STATUS <> - 1)
BEGIN
	UPDATE NAME
	SET MEMBER_TYPE = 'HMX'
		,[STATUS] = 'A'
	WHERE ID = @imisid

	FETCH NEXT
	FROM cs
	INTO @imisid
END

CLOSE cs

DEALLOCATE cs
	-- ROLLBACK
	-- COMMIT
