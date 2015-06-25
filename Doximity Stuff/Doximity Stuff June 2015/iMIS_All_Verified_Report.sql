SELECT [ID] as RowID
	,ISNULL([imis_ADDRESS_1],'') as imis_Addr1
	,ISNULL([imis_ADDRESS_2],'') as imis_Addr2
	,[imis_ADDRESS_NUM]
	,[imis_CITY]
	,[imis_COMPANY]
	,[imis_COUNTRY]
	,[imis_EMAIL]
	,[imis_FIRST_NAME]
	,[imis_LAST_NAME]
	,[imis_PHONE]
	,[imis_STATE_PROVINCE]
	,[imis_ID]
	,[imis_ZIP]
	,[MD_NameFull]
	,[MD_CompanyName]
	,[MD_Gender]
	,[MD_AddressLine1]
	,[MD_AddressLine2]
	,[MD_AddressExtras]
	,[MD_City]
	,[MD_State]
	,[MD_PostalCode]
	,[MD_AddressKey]
	,[MD_AddressTypeCode]
	,[MD_CarrierRoute]
	,[MD_CityAbbreviation]
	,[MD_CountryCode]
	,[MD_DeliveryIndicator]
	,[MD_DeliveryPointCheckDigit]
	,[MD_DeliveryPointCode]
	,[MD_StateName]
	,[MD_UrbanizationName]
	,[MD_UTC]
	,[MD_CBSACode]
	,[MD_CBSADivisionCode]
	,[MD_CBSADivisionLevel]
	,[MD_CBSADivisionTitle]
	,[MD_CBSALevel]
	,[MD_CBSATitle]
	,[MD_CensusBlock]
	,[MD_CensusTract]
	,[MD_CongressionalDistrict]
	,[MD_CountyFIPS]
	,[MD_CountyName]
	,[MD_PlaceCode]
	,[MD_PlaceName]
	,[MD_Latitude]
	,[MD_Longitude]
	,[MD_PhoneNumber]
	,[MD_EmailAddress]
	,[MD_Results]
	,[MatchString]
	,[NewRecID]
FROM [IMIS_201506_Complete]
