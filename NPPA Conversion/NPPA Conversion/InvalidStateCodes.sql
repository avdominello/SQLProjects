SELECT n.ID
	,na.STATE_PROVINCE
FROM NAME n
INNER JOIN Name_Address na ON n.ID = na.ID
WHERE na.PREFERRED_MAIL = 1
	AND na.STATE_PROVINCE <> ''
	AND na.COUNTRY IN (
		'United States'
		,'Canada'
		,''
		)
	AND na.STATE_PROVINCE NOT IN (
		SELECT STATE_PROVINCE
		FROM State_Codes
		)
