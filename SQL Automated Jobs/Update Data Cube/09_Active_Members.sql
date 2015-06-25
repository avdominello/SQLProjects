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
			AND n.PAID_THRU >= CONVERT(VARCHAR(25), DATEADD(dd, - (DAY(DATEADD(mm, 1, GETDATE()))), DATEADD(mm, - 15, GETDATE())), 101)
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT