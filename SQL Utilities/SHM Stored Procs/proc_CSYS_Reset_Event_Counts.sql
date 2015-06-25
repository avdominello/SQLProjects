USE [SHM_iMIS]
GO

/****** Object:  StoredProcedure [dbo].[proc_CSYS_Reset_Event_Counts]    Script Date: 04/01/2015 11:54:46 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[proc_CSYS_Reset_Event_Counts]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[proc_CSYS_Reset_Event_Counts]
GO

USE [SHM_iMIS]
GO

/****** Object:  StoredProcedure [dbo].[proc_CSYS_Reset_Event_Counts]    Script Date: 04/01/2015 11:54:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_CSYS_Reset_Event_Counts]
AS
-- drop table #totalreg
SELECT om.MEETING
	,count(*) TOTAL_REG
	,sum(CASE left(o.STATUS, 1)
			WHEN 'C'
				THEN 1
			ELSE 0
			END) COUNT_CAN
INTO #totalreg
FROM Orders o
JOIN Order_Meet om ON o.ORDER_NUMBER = om.ORDER_NUMBER
JOIN Meet_Master m ON om.MEETING = m.MEETING
WHERE m.STATUS <> 'C'
GROUP BY om.MEETING

-- drop table #headcount
SELECT om.MEETING
	,count(*) HEAD_COUNT
INTO #headcount
FROM Orders o
JOIN Order_Meet om ON o.ORDER_NUMBER = om.ORDER_NUMBER
JOIN Order_Badge ob ON o.ORDER_NUMBER = ob.ORDER_NUMBER
JOIN #totalreg tr ON om.MEETING = tr.MEETING
WHERE o.STATUS = ''
GROUP BY om.MEETING

-- Update Meet Master with counts from temp tables
UPDATE Meet_Master
SET TOTAL_REGISTRANTS = tr.TOTAL_REG
	,TOTAL_CANCELATIONS = tr.COUNT_CAN
FROM Meet_Master m
JOIN #totalreg tr ON m.MEETING = tr.MEETING

UPDATE Meet_Master
SET HEAD_COUNT = h.HEAD_COUNT
FROM Meet_Master m
JOIN #headcount h ON m.HEAD_COUNT = h.HEAD_COUNT
WHERE m.HEAD_COUNT <> h.HEAD_COUNT
GO


