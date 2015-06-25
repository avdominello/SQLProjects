SELECT DISTINCT n.ID AS 'iMISID'
	,CASE 
		WHEN n.member_type = ''
			THEN 'U'
		ELSE n.member_type
		END AS 'MembershipTypeCode'
	,CASE 
		WHEN n.STATUS = ''
			THEN 'U'
		ELSE n.STATUS
		END AS 'MembershipStatusCode'
	,n.prefix AS 'Prefix'
	,n.first_name AS 'FirstName'
	,n.middle_name AS 'MiddleName'
	,n.last_name AS 'LastName'
	,n.suffix AS 'Suffix'
	,CASE 
		WHEN n.designation = ''
			THEN 'Unknown'
		ELSE n.designation
		END AS 'Designation'
	,n.join_date AS 'JoinDate'
	,n.paid_thru AS 'PaidThruDate'
	,ISNULL(cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)), 'Unknown') AS 'Age'
	,CASE 
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 0
				AND 10
			THEN '0-10'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 11
				AND 20
			THEN '11-20'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 21
				AND 30
			THEN '21-30'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 31
				AND 40
			THEN '31-40'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 41
				AND 50
			THEN '41-50'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 51
				AND 60
			THEN '51-60'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) BETWEEN 61
				AND 70
			THEN '61-70'
		WHEN cast(datediff(yyyy, n.birth_date, getdate()) AS VARCHAR(10)) >= 71
			THEN '71+'
		ELSE 'Unknown'
		END AS 'AgeGroup'
	,CASE 
		WHEN n.gender = ''
			THEN 'U'
		ELSE n.gender
		END AS 'GenderCode'
	,CASE 
		WHEN n.chapter = ''
			THEN 'Unknown'
		ELSE n.chapter
		END AS 'ChapterCode'
	,CASE 
		WHEN n.us_congress = ''
			THEN 'Unknown'
		ELSE n.us_congress
		END AS 'USDistrict'
	,CASE 
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) = '0'
			THEN '<1'
		ELSE ISNULL(cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)), 'Unknown')
		END AS 'MembershipYearLength'
	,CASE 
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) = 0
			THEN '1'
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) = 1
			AND cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) < 2
			THEN '1-2'
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) = 2
			AND cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) < 3
			THEN '2-3'
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) = 3
			AND cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) < 5
			THEN '3-5'
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) = 5
			AND cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) < 10
			THEN '5-10'
		WHEN cast(datediff(yyyy, n.join_date, n.paid_thru) AS VARCHAR(10)) >= 10
			THEN '10+'
		ELSE 'Unknown'
		END AS 'MembershipYearGroup'
	,CASE 
		WHEN na.city = ''
			THEN 'Unknown'
		ELSE na.city
		END AS 'City'
	,CASE 
		WHEN na.state_province = ''
			THEN 'Unknown'
		ELSE na.state_province
		END AS 'StateProvince'
	,CASE 
		WHEN na.state_province IN (
				'ME'
				,'NH'
				,'VT'
				,'MA'
				,'RI'
				,'CT'
				,'NY'
				,'PA'
				,'NJ'
				)
			THEN 'Northeast'
		WHEN na.state_province IN (
				'WI'
				,'MI'
				,'IL'
				,'IN'
				,'OH'
				,'MO'
				,'ND'
				,'SD'
				,'NE'
				,'KS'
				,'MN'
				,'IA'
				)
			THEN 'Midwest'
		WHEN na.state_province IN (
				'DE'
				,'MD'
				,'DC'
				,'VA'
				,'WV'
				,'NC'
				,'SC'
				,'GA'
				,'FL'
				,'KY'
				,'TN'
				,'MS'
				,'AL'
				,'OK'
				,'TX'
				,'AR'
				,'LA'
				)
			THEN 'South'
		WHEN na.state_province IN (
				'ID'
				,'MT'
				,'WY'
				,'NV'
				,'UT'
				,'CO'
				,'AZ'
				,'NM'
				,'AK'
				,'WA'
				,'OR'
				,'CA'
				,'HI'
				)
			THEN 'West'
		ELSE 'Unknown'
		END AS 'USRegion'
	,CASE 
		WHEN na.country IN (
				'Belarus'
				,'Belgium'
				,'Croatia'
				,'Denmark'
				,'England'
				,'France'
				,'Germany'
				,'Greece'
				,'Ireland'
				,'Italy'
				,'Malta'
				,'Netherlands'
				,'Norway'
				,'Portugal'
				,'Scotland'
				,'Spain'
				,'Ukraine'
				,'United Kingdom'
				)
			THEN 'Europe'
		WHEN na.country IN (
				'Syrian Arab Republic'
				,'Indonesia'
				,'Afghanistan'
				,'Bahrain'
				,'Bangladesh'
				,'Cambodia'
				,'China'
				,'Georgia'
				,'India'
				,'Iraq'
				,'Israel'
				,'Japan'
				,'Lebanon'
				,'Pakistan'
				,'Philippines'
				,'Saudi Arabia'
				,'Singapore'
				,'Taiwan'
				,'Thailand'
				,'UAE'
				,'United Arab Emirates'
				,'Viet Nam'
				)
			THEN 'Asia'
		WHEN na.country IN (
				'Argentina'
				,'Brazil'
				,'Chile'
				,'Colombia'
				,'Peru'
				,'Uruguay'
				,'Venezuela'
				)
			THEN 'South America'
		WHEN na.country IN (
				'AUS'
				,'Australia'
				,'New Zealand'
				,'NZL'
				,'Vanuatu'
				)
			THEN 'Australia'
		WHEN na.country IN (
				'Benin'
				,'Egypt'
				,'Nigeria'
				,'South Africa'
				,'Algeria'
				,'Angola'
				,'Ghana'
				,'Kenya'
				,'Uganda'
				)
			THEN 'Africa'
		WHEN na.country IN (
				'Bermuda'
				,'Anguilla'
				,'CAN'
				,'Canada'
				,'Grenada'
				,'Haiti'
				,'Mexico'
				,'Panama'
				,'Puerto Rico'
				,'United States'
				,'Aruba'
				,'Jamaica'
				)
			THEN 'North America'
		ELSE 'Unknown'
		END AS 'Continent'
	,CASE 
		WHEN d.grad_year IS NULL
			THEN 'Unknown'
		WHEN d.grad_year = ''
			THEN 'Unknown'
		ELSE d.grad_year
		END AS 'GraduationYear'
	,CASE 
		WHEN d.license_splty IS NULL
			THEN 'Unknown'
		WHEN d.license_splty = ''
			THEN 'Unknown'
		ELSE d.license_splty
		END AS 'LicenseSpecialty'
	,CONVERT(VARCHAR(8), GETDATE(), 112) AS 'LoadDate'
FROM NAME n
LEFT JOIN name_address na ON n.mail_address_num = na.address_num
LEFT JOIN demographics d ON n.ID = d.ID
WHERE n.member_type NOT IN (
		'AQI'
		,'ARA'
		,'HMX'
		)
	AND n.STATUS IN (
		'A'
		,'G'
		)
	AND n.FIRST_NAME <> ''