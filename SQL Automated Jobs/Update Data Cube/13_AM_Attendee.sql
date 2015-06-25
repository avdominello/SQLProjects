BEGIN TRANSACTION

UPDATE dimPopulation
SET AttendedAnnualMeeting = 'Yes'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM SHMSQL03.SHM_iMIS.dbo.vBoCsActivity
		WHERE ActivityType = 'MEETING'
			AND ProductCode LIKE '%MR_AM'
			AND YEAR(TransactionDate) >= YEAR(GETDATE()) - 4
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
