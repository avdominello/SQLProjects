SELECT vBoCsContact.ID
	,vBoCsContact.MemberType
	,vBoCsContact.FunctionalTitle
	,vBoCsContact.FirstName
	,vBoCsContact.LastName
	,vBoCsContact.Designation
	,vBoCsContact.Company
	,vBoCsAddress.Address1
	,vBoCsAddress.Address2
	,vBoCsAddress.City
	,vBoCsAddress.StateProvince AS STATE
	,vBoCsAddress.Zip
	,vBoCsContact.Country
	,vBoCsContact.DateAdded
	,vBoCsAddress.BadAddress
FROM vBoCsContact
INNER JOIN vBoCsAddress
	ON vBoCsContact.BillAddressNum = vBoCsAddress.AddressNumber
INNER JOIN vBoCsDemographics
	ON vBoCsContact.ID = vBoCsDemographics.ID
WHERE (
		(
			vBoCsContact.MemberType = 'NPPA'
			OR vBoCsContact.MemberType = 'STU'
			OR vBoCsContact.MemberType = 'RESF'
			OR vBoCsContact.MemberType = 'PHYS'
			OR vBoCsContact.MemberType = 'ALLH'
			OR vBoCsContact.MemberType = 'AFFIL'
			)
		AND (
			vBoCsContact.STATUS = 'A'
			OR vBoCsContact.STATUS = 'G'
			)
		AND vBoCsAddress.BadAddress <> 'B'
		AND vBoCsDemographics.DigitalNewspaper = 0
		AND vBoCsDemographics.NEWSPAPER <> 'NO'
		)
ORDER BY vBoCsContact.LastFirst
