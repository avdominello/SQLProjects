CREATE FUNCTION [dbo].[fn_Occurences] (
	@pattern VARCHAR(255)
	,@expression VARCHAR(max)
	)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT = 0;
	DECLARE @index BIGINT = 0
	DECLARE @patLen INT = len(@pattern)

	SET @index = CHARINDEX(@pattern, @expression, @index)

	WHILE @index > 0
	BEGIN
		SET @Result = @Result + 1;
		SET @index = CHARINDEX(@pattern, @expression, @index + @patLen)
	END

	RETURN @Result
END
