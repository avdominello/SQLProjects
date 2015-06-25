BEGIN TRANSACTION

UPDATE dimPopulation
SET AttendedEvent = 'Last Year'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM shmsql03.shm_imis.dbo.vBoCsActivity
		WHERE activityType = 'MEETING'
			AND TransactionDate BETWEEN '2014-01-01'
				AND '2014-12-31'
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
