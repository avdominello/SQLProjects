BEGIN TRANSACTION

UPDATE dimPopulation
SET ActiveMember = 'Yes'
WHERE iMISID IN (
		SELECT n.ID
		FROM SHMSQL03.SHM_iMIS.dbo.NAME n
		WHERE n.STATUS NOT IN (
				'S'
				,'D'
				,'F'
				,'I'
				)
			AND n.paid_thru >= '2013-01-31'
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
