SELECT t.ID
FROM To_Doximity_June_2015_Verified t
INNER JOIN From_Doximity_June_2015 f ON t.MatchString = f.MatchString
WHERE f.lastname is not null
