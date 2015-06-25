SELECT COUNT(*)
FROM Name
WHERE MEMBER_TYPE = 'ALLHP'
AND DESIGNATION IN (
		'PA'
		,'PA-C'
		,'RPA'
		,'RPA-C'
		,'NP'
		,'DNP'
		,'FNP'
		,'ACNP'
		,'APN-BC'
		,'AGNP'
		,'APRN'
		,'PNP'
		,'CRNA'
		,'CNS'
		)
