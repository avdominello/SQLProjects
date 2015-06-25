SELECT vBoCsContact.ID AS 'iMIS Id'
	,vBoCsContact.MemberType AS 'Member Type'
	,vBoCsContact.Prefix
	,vBoCsContact.FirstName AS 'First Name'
	,vBoCsContact.LastName AS 'Last Name'
	,vBoCsContact.Suffix
	,vBoCsContact.Designation
	,vBoCsContact.Title
	,vBoCsContact.Company
	,vBoCsAddress.Address1 AS 'Address 1'
	,vBoCsAddress.Address2 AS 'Address 2'
	,vBoCsAddress.Address3 AS 'Address 3'
	,vBoCsAddress.City
	,vBoCsAddress.StateProvince AS 'State Province'
	,vBoCsAddress.Zip
	,vBoCsAddress.Country
	,vBoCsAddress.Phone
	,vBoCsAddress.BadAddress AS 'Bad Address'
FROM vBoCsContact
INNER JOIN vBoCsAddress
	ON vBoCsContact.MailAddressNumber = vBoCsAddress.AddressNumber
INNER JOIN vBoCsDemographics
	ON vBoCsContact.ID = vBoCsDemographics.ID
WHERE (
		(
			vBoCsContact.MemberType = 'NPPAP'
			OR vBoCsContact.MemberType = 'NPPA'
			OR vBoCsContact.MemberType = 'INTLP'
			OR vBoCsContact.MemberType = 'INTL'
			OR vBoCsContact.MemberType = 'HMX'
			OR vBoCsContact.MemberType = 'ARA'
			OR vBoCsContact.MemberType = 'AQI'
			OR vBoCsContact.MemberType = 'AFFIL'
			OR vBoCsContact.MemberType = 'AFFP'
			OR vBoCsContact.MemberType = 'ALLH'
			OR vBoCsContact.MemberType = 'ALLHP'
			OR vBoCsContact.MemberType = 'PHYS'
			OR vBoCsContact.MemberType = 'PHYP'
			OR vBoCsContact.MemberType = 'RESF'
			OR vBoCsContact.MemberType = 'RESFP'
			OR vBoCsContact.MemberType = 'STU'
			OR vBoCsContact.MemberType = 'STUP'
			)
		AND (
			vBoCsContact.STATUS = 'G'
			OR vBoCsContact.STATUS = 'A'
			)
		AND (vBoCsAddress.Address1 > ' ')
		AND (
			vBoCsAddress.BadAddress IS NULL
			OR vBoCsAddress.BadAddress = ''
			)
		AND (vBoCsAddress.Zip > ' ')
		)
