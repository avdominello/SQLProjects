BEGIN TRANSACTION

UPDATE dimPopulation
SET FellowCode = 'FSFHM'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM SHM_iMIS.dbo.fhm
		WHERE (
				fellow = 1
				AND app_status = 'Accept'
				)
			AND (
				sr_fellow = 1
				AND sfhm_app_status = 'Accept'
				)
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)

-- ROLLBACK

-- COMMIT
