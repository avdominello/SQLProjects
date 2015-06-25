SELECT *
FROM From_Doximity_June_2015 f
WHERE f.MD_AddressKey IN (
		SELECT t.MD_AddressKey
		FROM To_Doximity_June_2015_Verified t
		)
