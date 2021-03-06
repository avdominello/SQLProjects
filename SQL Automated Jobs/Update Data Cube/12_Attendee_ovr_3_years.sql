BEGIN TRANSACTION

UPDATE dimPopulation
SET AttendedEvent = '3+ Years'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM SHMSQL03.SHM_iMIS.dbo.vBoCsActivity
		WHERE activityType = 'MEETING'
			AND TransactionDate < CONVERT(VARCHAR(25), DATEADD(YEAR, DATEDIFF(YEAR, 0, DATEADD(YEAR, - 4, GETDATE())), 0), 101)
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
