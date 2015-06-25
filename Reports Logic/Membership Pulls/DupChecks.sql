SELECT n.ID
	,n.FIRST_NAME
	,n.LAST_NAME
	,n.MAJOR_KEY
	,n.MEMBER_TYPE
	,n.[STATUS]
	,n.CO_ID
	,n.COMPANY
	,na.ADDRESS_1
	,na.ADDRESS_2
	,na.CITY
	,na.STATE_PROVINCE
	,na.ZIP
	,na.COUNTRY
	,na.PHONE
	,h.HOSPITAL_MEDICAL_CENTER
	,d.LICENSE_SPLTY
	,o.CERTI
	,d.SCHOOL_NAME
	,f.FELLOW
	,f.SR_FELLOW
	,f.MAST_FELLOW
	,a.Interest_Advocacy
	,a.Interest_Academic
	,a.Interest_Rural
	,a.Interest_Urban
	,a.Interest_PAC
	,a.Interest_Global
	,a.Interest_QI
	,d.RES_Program
	,d.RES_Complete
	,n.LAST_NAME + LEFT(n.FIRST_NAME, 1) + CASE CHARINDEX(' ', n.COMPANY)
		WHEN 0
			THEN n.COMPANY
		ELSE SUBSTRING(n.COMPANY, 1, CHARINDEX(' ', n.COMPANY, 1) - 1)
		END AS MatchString
FROM NAME n
INNER JOIN Name_Address na ON n.ID = na.ID
LEFT OUTER JOIN Demographics d ON n.ID = d.ID
LEFT OUTER JOIN shm_other o ON n.ID = o.ID
LEFT OUTER JOIN FHM f ON n.ID = f.ID
LEFT OUTER JOIN HMG h ON n.ID = h.ID
LEFT OUTER JOIN Awards_Interests a ON n.ID = a.ID
WHERE na.PREFERRED_MAIL = 1
	AND n.COMPANY_RECORD = 0
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
