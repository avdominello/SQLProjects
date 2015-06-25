SELECT c.ID
	,um.UserKey
	,um.UserId
	,c.MemberType
	,c.FirstName
	,c.LastName
	,c.Designation
	,c.FullName
	,c.Informal
	,c.Company
	,a.Address1
	,a.Address2
	,a.City
	,a.StateProvince
	,a.Zip
	,a.Phone
	,a.Fax
	,a.Email
	,r.OrderDate
	,r.TotalPayments
	,r.RegistrantClass
	,o.BADGE_TYPE
FROM vBoCsContact c
INNER JOIN vBoCsAddress a ON c.MailAddressNumber = a.AddressNumber
INNER JOIN vBoCsRegistration r ON c.ID = r.ShipToId
INNER JOIN vBoCsOrderBadge o ON r.OrderNumber = o.ORDER_NUMBER
LEFT OUTER JOIN UserMain um ON r.ShipToId = um.ContactMaster
WHERE r.[Status] <> 'C'
	AND r.EventCode = 'QSEA0515'
	AND um.ContactMaster = '1356456'
