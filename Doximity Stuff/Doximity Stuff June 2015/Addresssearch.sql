SELECT COUNT(*)
	,MD_AddressKey
FROM From_Doximity_June_2015
GROUP BY MD_AddressKey
HAVING COUNT(*) > 1
