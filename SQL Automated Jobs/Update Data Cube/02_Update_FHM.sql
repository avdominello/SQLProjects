BEGIN TRANSACTION

UPDATE dimPopulation
SET FellowCode = 'FHM'
WHERE iMISID IN (
		SELECT ID
		FROM SHMSQL03.SHM_iMIS.dbo.fhm
		WHERE fellow = 1
			AND app_status = 'Accept'
		
		UNION
		
		SELECT ID
		FROM SHMSQL03.SHM_iMIS.dbo.Fellow_Application
		WHERE start_date IS NOT NULL
			AND completion_date IS NOT NULL
		
		UNION
		
		SELECT ID
		FROM SHMSQL03.SHM_iMIS.dbo.fellows_app
		WHERE start_date IS NOT NULL
			AND completion_date IS NOT NULL
		)
	AND LoadDate = CONVERT(VARCHAR(10), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
