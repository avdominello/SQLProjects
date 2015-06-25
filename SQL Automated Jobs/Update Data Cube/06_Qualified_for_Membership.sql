BEGIN TRANSACTION

UPDATE dimPopulation
SET MembershipQualification = 'Yes'
WHERE iMISID IN (
		SELECT n.ID
		FROM SHMSQL03.SHM_iMIS.dbo.NAME n
		INNER JOIN SHMSQL03.SHM_iMIS.dbo.name_address na ON n.mail_address_num = na.address_num
		INNER JOIN SHMSQL03.SHM_iMIS.dbo.demographics d ON n.ID = d.ID
		WHERE n.STATUS NOT IN (
				'S'
				,'D'
				,'F'
				,'I'
				)
			AND n.PAID_THRU >= CONVERT(VARCHAR(25), DATEADD(dd, - (DAY(DATEADD(mm, 1, GETDATE()))), DATEADD(mm, 1, GETDATE())), 101)
			AND datediff(yyyy, n.join_date, n.paid_thru) >= 3
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
