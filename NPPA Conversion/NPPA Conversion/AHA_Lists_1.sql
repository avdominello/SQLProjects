BEGIN TRANSACTION

UPDATE Higher_Logic_Groups
SET AHA_ALUMNI = 1
WHERE ID IN (
		SELECT [iMIS Id]
		FROM dba..adHL
		)
	-- ROLLBACK
	-- COMMIT


