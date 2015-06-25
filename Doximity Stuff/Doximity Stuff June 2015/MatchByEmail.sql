SELECT n.ID AS iMIS_ID
	,n.LAST_FIRST
	,x.lastname + ', ' + x.firstname AS DoxLastFirst
	,n.MEMBER_TYPE
	,n.[STATUS]
	,x.MD_EmailAddress
FROM vDoxInWithEmail x
INNER JOIN SHM_iMIS..NAME n
	ON n.EMAIL = x.MD_EmailAddress
