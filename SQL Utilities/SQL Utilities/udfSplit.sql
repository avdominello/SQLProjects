/****** Object:  UserDefinedFunction [dbo].[udfSplit]    Script Date: 6/19/2015 1:42:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* udfSplit (A Fast String Splitter) **************************************************************
 *
 * Uses a number table to *very* quickly split the text (@text). Splits on the delimiter (@d)
 * Returns Table of ( [RowID], [SplitText] ). Inlineable for CROSS APPLY etc.
 *
 * Charlie
 *
 *************************************************************************************************/
CREATE FUNCTION [dbo].[udfSplit] (
	@text NVARCHAR(4000)
	,@d NVARCHAR(50)
	)
RETURNS TABLE
AS
RETURN (
		WITH numbers(n) AS (
				SELECT ROW_NUMBER() OVER (
						ORDER BY a.[n]
						)
				FROM (
					VALUES (0)
						,(1)
						,(2)
						,(3)
						,(4)
						,(5)
						,(6)
						,(7)
						,(8)
						,(9)
					) AS a([n])
				CROSS JOIN (
					VALUES (0)
						,(1)
						,(2)
						,(3)
						,(4)
						,(5)
						,(6)
						,(7)
						,(8)
						,(9)
					) AS b([n])
				CROSS JOIN (
					VALUES (0)
						,(1)
						,(2)
						,(3)
						,(4)
						,(5)
						,(6)
						,(7)
						,(8)
						,(9)
					) AS c([n])
				CROSS JOIN (
					VALUES (0)
						,(1)
						,(2)
						,(3)
						,(4)
					) AS d([n])
				)
		SELECT [RowID] = ROW_NUMBER() OVER (
				ORDER BY [n] ASC
				)
			,[SplitText] = SUBSTRING(@d + @text + @d, [n] + LEN(@d), CHARINDEX(@d, @d + @text + @d, [n] + LEN(@d)) - [n] - LEN(@d))
		FROM numbers AS n
		WHERE [n] <= LEN(@d + @text + @d) - LEN(@d)
			AND SUBSTRING(@d + @text + @d, [n], LEN(@d)) = @d
		)
GO


