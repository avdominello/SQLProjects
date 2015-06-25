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
	,vBoCsContact.DateAdded
	,vBoCsAddress.BadAddress
	,vBoCsContact.Country
FROM vBoCsContact
INNER JOIN vBoCsAddress
	ON vBoCsContact.BillAddressNum = vBoCsAddress.AddressNumber
INNER JOIN vBoCsDemographics
	ON vBoCsContact.ID = vBoCsDemographics.ID
WHERE (
		(
			vBoCsContact.MemberStatus <> 'PRE'
			AND vBoCsContact.MemberStatus <> 'B'
			)
		AND (
			vBoCsContact.MemberType = 'NPPAP'
			OR vBoCsContact.MemberType = 'RESFP'
			OR vBoCsContact.MemberType = 'PHYP'
			OR vBoCsContact.MemberType = 'ALLHP'
			OR vBoCsContact.MemberType = 'AFFP'
			)
		AND vBoCsContact.STATUS = 'A'
		AND vBoCsDemographics.DigitalNewspaper = 0
		AND vBoCsDemographics.NEWSPAPER <> 'NO'
		)
