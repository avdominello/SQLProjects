BEGIN TRANSACTION

UPDATE dimPopulation
SET AttendedAnnualMeeting = 'Yes'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM SHMSQL03.shm_imis.dbo.vBoCsActivity
		WHERE ProductCode IN (
				'AM11/MR_AM'
				,'AM12/MR_AM'
				,'AM13/MR_AM'
				,'AM14/MR_AM'
				)
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
