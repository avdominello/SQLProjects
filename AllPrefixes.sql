SELECT Prefix
	,COUNT(*)
FROM NAME
where Prefix <> ''
GROUP BY Prefix
ORDER BY PREFIX
