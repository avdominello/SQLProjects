SELECT n.MEMBER_TYPE
	,CASE n.FIRST_NAME
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoFN
	,CASE n.LAST_NAME
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoLN
	,CASE na.ADDRESS_1
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoAd
	,CASE na.CITY
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoCity
	,CASE na.STATE_PROVINCE
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoState
	,CASE na.ZIP
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoZip
	,CASE na.COUNTRY
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoCountry
	,CASE n.EMAIL
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoEm
FROM NAME n
INNER JOIN Name_Address na ON n.ID = na.ID
INNER JOIN Hospital h ON n.ID = h.ID
INNER JOIN Demographics d ON n.ID = d.ID
WHERE n.MEMBER_TYPE IN (
		'PHYP'
		,'AFFP'
		,'ALLHP'
		,'RESFP'
		,'STUP'
		,'NPPAP'
		,'INTLP'
		,'HMX'
		)
	/*	AND n.[STATUS] IN (
		'A'
		,'G'
		)
*/
