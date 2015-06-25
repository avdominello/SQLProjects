DECLARE @userk UNIQUEIDENTIFIER;

DECLARE cs CURSOR
FOR
SELECT um.UserKey
FROM vBoCsContact c
INNER JOIN vBoCsAddress a ON c.MailAddressNumber = a.AddressNumber
INNER JOIN vBoCsRegistration r ON c.ID = r.ShipToId
INNER JOIN vBoCsOrderBadge o ON r.OrderNumber = o.ORDER_NUMBER
INNER JOIN UserMain um ON r.ShipToId = um.ContactMaster
WHERE r.[Status] <> 'C'
	AND r.EventCode = 'QSEA0515'

OPEN cs

-- BEGIN TRANSACTION
FETCH NEXT
FROM cs
INTO @userk

WHILE @@FETCH_STATUS = 0
BEGIN
	IF NOT EXISTS (
			SELECT *
			FROM UserRole
			WHERE RoleKey = 'F5FE1A27-63B5-423B-B2D4-1F07329D65DA'
				AND UserKey = @userk
			)
	BEGIN
		INSERT INTO UserRole (
			UserKey
			,RoleKey
			)
		VALUES (
			@userk
			,'F5FE1A27-63B5-423B-B2D4-1F07329D65DA'
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
