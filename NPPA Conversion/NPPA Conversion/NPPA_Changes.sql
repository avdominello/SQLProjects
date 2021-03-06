BEGIN TRANSACTION

UPDATE NAME
SET MEMBER_TYPE = 'NPPA'
WHERE ID IN (
		SELECT n.ID
		FROM NAME n
		INNER JOIN Name_Address na ON n.ID = na.ID
		WHERE n.MEMBER_TYPE = 'ALLH'
			AND na.PREFERRED_MAIL = 1
			AND na.COUNTRY IN (
				''
				,'Canada'
				,'United States'
				)
		)
	-- ROLLBACK
	-- COMMIT
