BEGIN TRANSACTION

UPDATE dimPopulation
SET OnCommittee = 'Yes'
WHERE iMISID IN (
		SELECT DISTINCT ID
		FROM SHMSQL03.shm_imis.dbo.vBoCsActivity
		WHERE productcode LIKE '%COMMITTEE%'
			AND EffectiveDate = '2015-03-06'
			AND ThruDate = '2016-03-05'
		)
	AND LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
	-- ROLLBACK
	-- COMMIT
