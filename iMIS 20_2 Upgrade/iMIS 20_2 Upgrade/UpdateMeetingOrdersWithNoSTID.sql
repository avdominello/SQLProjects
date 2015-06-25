--Step 0: (optionally) Run this script to identify whether your database has any 
--        meeting Registrations with blank Registrant IDs (Orders.ST_ID)
-- Simply uncomment the following indented block to run this script
SELECT [mm].[MEETING] AS Event
	,CONVERT(VARCHAR(10), [mm].[BEGIN_DATE], 101) AS EventDate
	,COUNT(DISTINCT ([o].[ORDER_NUMBER])) AS Records
	,o.ORDER_NUMBER AS OrderNum
	,o.ST_ID AS ST_ID
FROM [dbo].[Meet_Master] AS [mm]
INNER JOIN [dbo].[Order_Meet] AS [om] ON [mm].[MEETING] = [om].[MEETING]
INNER JOIN [dbo].[Orders] AS [o] ON [om].[ORDER_NUMBER] = [o].[ORDER_NUMBER]
WHERE [o].[STAGE] != 'CANCELED'
	AND [o].[ST_ID] IN (
		''
		,' '
		)
GROUP BY [mm].[MEETING]
	,[mm].[BEGIN_DATE]
	,[o].[ORDER_NUMBER]
	,[o].[ST_ID]
HAVING COUNT(DISTINCT ([o].[ORDER_NUMBER])) > 0
ORDER BY COUNT(DISTINCT ([o].[ORDER_DATE])) DESC

------------------------------------------------------------------------------
--Step 1: Save the order numbers with blank ST_IDs in a table
--        This is to preserve the original values in case we need to revert
SELECT [o].[ORDER_NUMBER] AS OrderNumber
	,[om].[MEETING]
	,[o].[ST_ID]
INTO asiPreUpgrade_152_MeetingOrdersWithNo_ST_IDs
FROM [dbo].[Orders] o
INNER JOIN [dbo].[Order_Meet] om ON [o].[ORDER_NUMBER] = [om].[ORDER_NUMBER]
WHERE [o].[STAGE] <> 'CANCELED'
	AND [o].[ST_ID] IN (
		''
		,' '
		)
	AND EXISTS (
		SELECT [o2].[ORDER_NUMBER]
		FROM [dbo].[Orders] o2
		INNER JOIN [dbo].[Order_Meet] om2 ON o2.ORDER_NUMBER = om2.ORDER_NUMBER
		WHERE [o].[STAGE] <> 'CANCELED'
			AND [o2].[ORDER_NUMBER] <> [o].[ORDER_NUMBER]
		)

--SELECT * FROM asiPreUpgrade_152_MeetingOrdersWithNo_ST_IDs
--Step 2: insert GUIDs into the blank ST_IDs
BEGIN TRANSACTION

UPDATE [o]
SET [ST_ID] = LEFT(CONVERT(VARCHAR(100), NEWID()), 10)
FROM [dbo].[Orders] o
INNER JOIN [dbo].[Order_Meet] om ON [o].[ORDER_NUMBER] = [om].[ORDER_NUMBER]
WHERE ISNULL([o].[ST_ID], '') IN (
		''
		,' '
		)
	AND [o].[STAGE] <> 'CANCELED'
	AND EXISTS (
		SELECT [o2].[ORDER_NUMBER]
		FROM [dbo].[Orders] o2
		INNER JOIN [dbo].[Order_Meet] om2 ON o2.ORDER_NUMBER = om2.ORDER_NUMBER
		WHERE [o].[STAGE] <> 'CANCELED'
			AND [o2].[ORDER_NUMBER] <> [o].[ORDER_NUMBER]
		)

--Step 3: Verify no dups now
SELECT CAST('EVENT-' + [mm].[MEETING] + ':' + [o].[ST_ID] AS VARCHAR(50)) AS GroupMemberId
FROM [dbo].[Meet_Master] AS [mm]
INNER JOIN [dbo].[Order_Meet] AS [om] ON [mm].[MEETING] = [om].[MEETING]
INNER JOIN [dbo].[Orders] AS [o] ON [om].[ORDER_NUMBER] = [o].[ORDER_NUMBER]
WHERE [o].[STAGE] != 'CANCELED'
GROUP BY CAST('EVENT-' + [mm].[MEETING] + ':' + [o].[ST_ID] AS VARCHAR(50))
HAVING COUNT(CAST('EVENT-' + [mm].[MEETING] + ':' + [o].[ST_ID] AS VARCHAR(50))) > 1

--Step 4: Commit transaction (or roll it back)
COMMIT TRANSACTION
