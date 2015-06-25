SELECT MatchString
	,MD_CBSACode
	,ISNULL(MD_CBSADivisionCode, '') AS MD_CBSADivisionCode
	,ISNULL(MD_CBSADivisionLevel, '') AS MD_CBSADivisionLevel
	,ISNULL(MD_CBSADivisionTitle, '') AS MD_CBSADivisionTitle
	,MD_CBSALevel
	,MD_CBSATitle
	,ISNULL(MD_CongressionalDistrict, '') AS MD_CongressionalDistrict
	,MD_CountyName
	,MD_CountyFIPS
	,MD_Latitude
	,MD_Longitude
	,hospitalist_probability_score
FROM From_Doximity_June_2015
WHERE MD_CBSACode IS NOT NULL

UNION ALL

SELECT MatchString
	,MD_CBSACode
	,ISNULL(MD_CBSADivisionCode, '') AS MD_CBSADivisionCode
	,ISNULL(MD_CBSADivisionLevel, '') AS MD_CBSADivisionLevel
	,ISNULL(MD_CBSADivisionTitle, '') AS MD_CBSADivisionTitle
	,MD_CBSALevel
	,MD_CBSATitle
	,ISNULL(MD_CongressionalDistrict, '') AS MD_CongressionalDistrict
	,MD_CountyName
	,MD_CountyFIPS
	,MD_Latitude
	,MD_Longitude
	,'' AS hospitalist_probability_score
FROM IMIS_201506_Complete
WHERE MD_CBSACode IS NOT NULL
