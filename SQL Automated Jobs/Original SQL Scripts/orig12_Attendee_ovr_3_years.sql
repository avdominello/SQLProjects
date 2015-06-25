BEGIN TRANSACTION

UPDATE dimPopulation
SET AttendedEvent = '3+ Years'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM SHMSQL03.shm_imis.dbo.vBoCsActivity
		WHERE activityType = 'MEETING'
			AND TransactionDate < '2011-01-01'
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
