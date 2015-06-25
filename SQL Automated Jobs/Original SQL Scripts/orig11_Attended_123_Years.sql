BEGIN TRANSACTION

UPDATE dimPopulation
SET AttendedEvent = '1-3 Years'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM shmsql03.shm_imis.dbo.vBoCsActivity
		WHERE activityType = 'MEETING'
			AND TransactionDate >= '2011-01-01'
			AND TransactionDate < '2013-12-31'
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
