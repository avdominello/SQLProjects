SELECT vBoCsContact.ID
	,vBoCsContact.Email
	,vBoCsAddress.Email AS 'CsAddress_Email'
FROM vBoCsAddress
INNER JOIN vBoCsContact
	ON vBoCsAddress.AddressNumber = vBoCsContact.BillAddressNum
INNER JOIN vBoCsDemographics
	ON vBoCsContact.ID = vBoCsDemographics.ID
WHERE (
		vBoCsContact.Email <> ''
		OR vBoCsAddress.Email <> ''
		)
	AND (
		(
			vBoCsContact.MemberType = 'INTLP'
			OR vBoCsContact.MemberType = 'INTL'
			OR vBoCsContact.MemberType = 'NPPAP'
			OR vBoCsContact.MemberType = 'NPPA'
			OR vBoCsContact.MemberType = 'STUP'
			OR vBoCsContact.MemberType = 'STU'
			OR vBoCsContact.MemberType = 'RESFP'
			OR vBoCsContact.MemberType = 'HMX'
			OR vBoCsContact.MemberType = 'RESF'
			OR vBoCsContact.MemberType = 'PHYP'
			OR vBoCsContact.MemberType = 'PHYS'
			OR vBoCsContact.MemberType = 'ALLHP'
			OR vBoCsContact.MemberType = 'ALLH'
			OR vBoCsContact.MemberType = 'AFFP'
			OR vBoCsContact.MemberType = 'AFFIL'
			OR vBoCsContact.MemberType = 'ARA'
			OR vBoCsContact.MemberType = 'AQI'
			)
		AND (
			vBoCsContact.STATUS = 'I'
			OR vBoCsContact.STATUS = 'G'
			OR vBoCsContact.STATUS = 'A'
			)
		AND vBoCsDemographics.DO_NOT_SEND_UNSUB = 0
		)
