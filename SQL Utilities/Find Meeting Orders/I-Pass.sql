DECLARE @userk UNIQUEIDENTIFIER;

DECLARE cs CURSOR
FOR
SELECT u.UserKey
FROM [I-pass] i
LEFT OUTER JOIN SHM_iMIS..UserMain u ON i.[imis id] = u.ContactMaster
WHERE u.UserKey IS NOT NULL

OPEN cs

BEGIN TRANSACTION

FETCH NEXT
FROM cs
INTO @userk

WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM SHM_iMIS..UserRole
			WHERE RoleKey = '92400550-2A69-4A13-A9F5-FE8773DEDE46'
				AND UserKey = @userk
			)
	BEGIN
		INSERT INTO SHM_iMIS..UserRole (
			UserKey
			,RoleKey
			)
		VALUES (
			@userk
			,'92400550-2A69-4A13-A9F5-FE8773DEDE46'
			)
	END

	FETCH NEXT
	FROM cs
	INTO @userk
END

CLOSE cs

DEALLOCATE cs
	-- ROLLBACK
	-- COMMIT
