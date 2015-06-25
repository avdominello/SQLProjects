SELECT ID 
	,LAST_NAME
	,MD_NameLast
	,FIRST_NAME
	,MD_NameFirst
	,EMAIL
	,MD_EmailAddress
	,W_PHONE
	,MD_PhoneNumber
	,MD_PhoneExtension
	,MD_Gender
	,COMPANY
	,MD_CompanyName
	,[ADDRESS_NUM] 
	,ADDRESS_1 
	,MD_AddressLine1
	,ADDRESS_2
	,MD_AddressLine2
	,ADDRESS_3 
	,MD_Suite
	,MD_PrivateMailBox
	,MD_AddressExtras
	,CITY 
	,MD_City
	,MD_CountyName
	,STATE_PROVINCE 
	,MD_State
	,ZIP 
	,MD_PostalCode
	,MD_Plus4
	,COUNTRY
	,MD_CongressionalDistrict
	,MD_CountryName
	,MD_CountryCode
	,CASE MD_AddressTypeCode
		WHEN 'G'
			THEN 'General Delivery'
		WHEN 'M'
			THEN 'Miliraty Address'
		WHEN 'P'
			THEN 'PO Box'
		WHEN 'R'
			THEN 'Rural Route address'
		WHEN 'S'
			THEN 'Standard Address'
		WHEN 'U'
			THEN 'Unique/LVR'
		ELSE 'Unknown'
		END AS AddressType
	,CASE MD_DeliveryIndicator
		WHEN 'B'
			THEN 'Business'
		WHEN 'R'
			THEN 'Residential'
		ELSE 'Unknown'
		END AS DeliveryIndicator
	,MD_Results
FROM [BadAddProspects_MD_Results]
WHERE MD_EmailAddress <> EMAIL
