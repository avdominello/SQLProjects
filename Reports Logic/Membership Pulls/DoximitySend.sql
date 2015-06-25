SELECT n.ID
	,n.LAST_NAME
	,n.FIRST_NAME
	,n.MIDDLE_NAME
	,n.COMPANY
	,na.ADDRESS_1
	,na.ADDRESS_2
	,na.CITY
	,na.STATE_PROVINCE
	,na.ZIP
	,na.COUNTRY
FROM NAME n
INNER JOIN Name_Address na ON n.ID = na.ID
WHERE na.PREFERRED_MAIL = 1
	--	AND n.company <> ''
	AND n.MEMBER_TYPE IN (
		'PHYS'
		,'PHYP'
		,'RESF'
		,'RESFP'
		)
	AND na.COUNTRY IN (
		'United States'
		,'Canada'
		)
	AND n.[STATUS] IN (
		'A'
		,'G'
		)
ORDER BY n.LAST_FIRST
