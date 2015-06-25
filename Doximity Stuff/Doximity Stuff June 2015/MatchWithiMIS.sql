SELECT d.NewRecID
	,i.imis_ID
	,m.[DESCRIPTION]
	,n.[STATUS]
	,d.hospitalist_probability_score
	,d.npi
	,d.firstname
	,n.FIRST_NAME
	,d.lastname
	,n.LAST_NAME
	,d.MD_AddressLine1 AS MD_Addr1
	,na.ADDRESS_1
	,ISNULL(d.MD_AddressLine2, '') AS MD_Addr2
	,na.ADDRESS_2
	,d.MD_City
	,na.CITY
	,d.MD_State
	,na.STATE_PROVINCE
FROM From_Doximity_June_2015 d
INNER JOIN IMIS_201506_Complete i
	ON i.MatchString = d.MatchString
INNER JOIN SHM_iMIS..NAME n
	ON i.imis_ID = n.ID
INNER JOIN SHM_iMIS..Name_Address na
	ON i.imis_ID = na.ID
INNER JOIN SHM_iMIS..Member_Types m
	ON n.MEMBER_TYPE = m.MEMBER_TYPE
WHERE na.PREFERRED_MAIL = 1
	AND BAD_ADDRESS = ''
/*	AND na.email = ''
	AND n.MEMBER_TYPE NOT IN (
		'PHYS'
		,'PHYP'
		,'RES'
		,'RESP'
		)
		*/
ORDER BY m.[DESCRIPTION]
