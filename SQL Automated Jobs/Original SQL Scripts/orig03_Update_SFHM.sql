BEGIN TRANSACTION

UPDATE dimPopulation
SET FellowCode = 'SFHM'
WHERE iMISID IN (
		SELECT ID
		FROM SHM_iMIS.dbo.fhm
		WHERE (
				sr_fellow = 1
				AND sfhm_app_status = 'Accept'
				)
		
		UNION
		
		SELECT ID
		FROM SHM_iMIS.dbo.Sr_Fellow_Application
		WHERE date_started IS NOT NULL
			AND date_completed IS NOT NULL
		
		UNION
		
		SELECT ID
		FROM SHM_iMIS.dbo.sr_fellows_app
		WHERE date_started IS NOT NULL
			AND date_completed IS NOT NULL
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- rollback
	-- commit
