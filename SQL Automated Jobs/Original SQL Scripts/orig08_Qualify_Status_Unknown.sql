BEGIN TRANSACTION

UPDATE dimPopulation
SET MembershipQualification = 'Unknown'
WHERE iMISID IN (
		SELECT n.ID
		FROM shm_imis.dbo.NAME n
		INNER JOIN shm_imis.dbo.name_address na ON n.mail_address_num = na.address_num
		INNER JOIN shm_imis.dbo.demographics d ON n.ID = d.ID
		WHERE n.STATUS NOT IN (
				'S'
				,'D'
				,'F'
				,'I'
				)
			AND n.paid_thru >= '2015-05-31'
			AND (
				n.join_date IS NULL
				OR n.paid_thru IS NULL
				)
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
