WITH FellowsEligibles (
	Years
	,imisid
	,Product
	)
AS (
	SELECT COUNT(*)
		,ID
		,member_type
	FROM Activity
	WHERE ACTIVITY_TYPE = 'DUES'
		AND MEMBER_TYPE IN (
			'PHYS'
			,'NPPA'
			,'ALLH'
			,'AFFIL'
			)
		AND DATEPART(YYYY, TRANSACTION_DATE) < DATEPART(YYYY, GETDATE())
	GROUP BY ID
		,MEMBER_TYPE
	HAVING COUNT(*) >= 3
	)
SELECT n.ID
	,n.MEMBER_TYPE
	,n.PREFIX
	,n.FULL_NAME
	,n.FIRST_NAME
	,n.LAST_NAME
	,n.SUFFIX
	,n.DESIGNATION
	,n.TITLE
	,n.COMPANY
	,na.ADDRESS_1
	,na.ADDRESS_2
	,na.CITY
	,na.STATE_PROVINCE
	,na.ZIP
	,na.COUNTRY
	,na.EMAIL
	,d.DO_NOT_SEND_UNSUB
	,na.BAD_ADDRESS
	,n.JOIN_DATE
	,FellowsEligibles.Years
FROM NAME n
INNER JOIN Name_Address na ON n.id = na.id
INNER JOIN Demographics d ON n.id = d.id
LEFT OUTER JOIN FHM f ON n.ID = f.ID
INNER JOIN FellowsEligibles ON n.ID = FellowsEligibles.imisid
WHERE n.COMPANY_RECORD = 0
	AND na.PREFERRED_MAIL = 1
	AND n.MEMBER_TYPE IN (
		'PHYS'
		,'NPPA'
		,'ALLH'
		,'AFFIL'
		)
	AND n.[STATUS] = 'A'
	AND f.FELLOW <> 1
	AND f.SR_FELLOW <> 1
	AND f.MAST_FELLOW <> 1
	AND n.ID IN (
		SELECT ID
		FROM Activity
		WHERE ACTIVITY_TYPE = 'MEETING'
			AND PRODUCT_CODE LIKE 'AM%'
			OR PRODUCT_CODE IN (
				'06AMM'
				,'05AMM'
				,'SHM04'
				,'SHMWM03'
				)
		)
ORDER BY FellowsEligibles.Years DESC
