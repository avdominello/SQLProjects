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
	,CASE n.TITLE
		WHEN ''
			THEN CASE n.FUNCTIONAL_TITLE
					WHEN ''
						THEN 1
					ELSE 0
					END
		ELSE 0
		END AS NoTitle
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
	,CASE n.COMPANY
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoCo
	,CASE na.PHONE
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoPh
	,CASE n.EMAIL
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoEm
	,case d.GRAD_YEAR when '' then 1 else 0 end as NoGradYr
	
	,CASE h.HEALTH_SYS
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoHo
	,CASE n.DESIGNATION
		WHEN ''
			THEN 1
		ELSE 0
		END AS NoDz
FROM NAME n
INNER JOIN Name_Address na ON n.ID = na.ID
INNER JOIN Hospital h ON n.ID = h.ID
inner join Demographics d on n.ID = d.ID
WHERE n.MEMBER_TYPE NOT LIKE '%P'
	AND n.MEMBER_TYPE <> 'HMX'
	AND n.[STATUS] IN (
		'A'
		,'G'
		)
