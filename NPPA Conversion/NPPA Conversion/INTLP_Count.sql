BEGIN TRANSACTION

UPDATE NAME
SET MEMBER_TYPE = 'INTLP'
WHERE ID IN (
		SELECT n.ID
		FROM NAME n
		INNER JOIN Name_Address na ON n.ID = na.ID
		WHERE na.PREFERRED_MAIL = 1
			AND na.COUNTRY NOT IN (
				''
				,'Canada'
				,'United States'
				,'CAN'
				)
			AND n.MEMBER_TYPE <> 'HMX'
			AND n.MEMBER_TYPE LIKE '%P'
		)
	-- ROLLBACK
	-- COMMIT
