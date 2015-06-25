DECLARE @imisid VARCHAR(10);

DECLARE cs CURSOR
FOR
SELECT n.ID
FROM NAME n
LEFT OUTER JOIN Higher_Logic_Groups h ON n.ID = h.ID
WHERE h.ID IS NULL

OPEN cs

BEGIN TRANSACTION

FETCH NEXT
FROM cs
INTO @imisid

WHILE (@@FETCH_STATUS <> - 1)
BEGIN
	INSERT INTO Higher_Logic_Groups (ID)
	VALUES (@imisid)

	FETCH NEXT
	FROM cs
	INTO @imisid
END

CLOSE cs

DEALLOCATE cs
	-- ROLLBACK
	-- COMMIT
