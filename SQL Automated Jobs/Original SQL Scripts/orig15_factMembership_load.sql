BEGIN TRANSACTION 
INSERT INTO dbo.factMembership (
	PopulationID
	,DateID
	,MemberTypeID
	,MemberStatusID
	,FellowTypeID
	,PopulationCount
	,ActiveMemberCount
	)
SELECT p.populationID
	,p.LoadDate
	,mt.memberTypeID
	,ms.memberStatusID
	,ft.FellowTypeID
	,count(*) AS PopulationCount
	,CASE 
		WHEN p.ActiveMember = 'Yes'
			THEN 1
		ELSE 0
		END AS ActiveMemberCount
FROM dimPopulation p
LEFT JOIN dimMemberType mt ON p.MembershipTypeCode = mt.MemberTypeCode
LEFT JOIN dimMemberStatus ms ON p.MembershipStatusCode = ms.MemberStatusCode
LEFT JOIN dimFellowType ft ON p.FellowCode = ft.FellowTypeCode
WHERE p.LoadDate = CONVERT(VARCHAR(8), GETDATE(), 112)
GROUP BY p.populationID
	,p.LoadDate
	,mt.memberTypeID
	,ms.memberStatusID
	,ft.FellowTypeID
	,p.ActiveMember
ORDER BY p.populationID
	,p.LoadDate
	,mt.memberTypeID
	,ms.memberStatusID
	,ft.FellowTypeID
	,p.ActiveMember

-- ROLLBACK
-- COMMIT
