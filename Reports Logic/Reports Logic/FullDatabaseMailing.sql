SELECT vBoCsContact.ID AS 'iMIS Id'
	,vBoCsContact.MemberType AS 'Member Type'
	,vBoCsContact.FirstName AS 'First Name'
	,vBoCsContact.LastName AS 'Last Name'
	,vBoCsContact.Suffix
	,vBoCsContact.Designation
	,vBoCsContact.Company
	,vBoCsAddress.Address1 AS 'Address 1'
	,vBoCsAddress.Address2 AS 'Address 2'
	,vBoCsAddress.City
	,vBoCsAddress.StateProvince AS 'State Province'
	,vBoCsAddress.Zip
	,vBoCsContact.Country
	,vBoCsContact.Email
	,vBoCsContact.PaidThrough AS 'Paid Through'
	,vBoCsAddress.BadAddress AS 'Bad Address'
	,vBoCsContact.JoinDate AS 'Join Date'
	,vBoCsContact.STATUS
	,vBoCsContact.Prefix
	,vBoCsDemographics.DO_NOT_SEND_UNSUB AS 'Do Not Send Unsub'
	,vBoCsContact.MiddleName AS 'Middle Name'
FROM vBoCsContact
INNER JOIN vBoCsAddress
	ON vBoCsContact.MailAddressNumber = vBoCsAddress.AddressNumber
INNER JOIN vBoCsDemographics
	ON vBoCsContact.ID = vBoCsDemographics.ID
WHERE (
		(
			vBoCsContact.MemberType = 'NPPAP'
			OR vBoCsContact.MemberType = 'INTL'
			OR vBoCsContact.MemberType = 'INTLP'
			OR vBoCsContact.MemberType = 'NPPA'
			OR vBoCsContact.MemberType = 'AFFIL'
			OR vBoCsContact.MemberType = 'AFFP'
			OR vBoCsContact.MemberType = 'ALLH'
			OR vBoCsContact.MemberType = 'ALLHP'
			OR vBoCsContact.MemberType = 'PHYS'
			OR vBoCsContact.MemberType = 'PHYP'
			OR vBoCsContact.MemberType = 'RESF'
			OR vBoCsContact.MemberType = 'RESFP'
			OR vBoCsContact.MemberType = 'STU'
			)
		AND (
			vBoCsContact.STATUS = 'G'
			OR vBoCsContact.STATUS = 'A'
			)
		)
