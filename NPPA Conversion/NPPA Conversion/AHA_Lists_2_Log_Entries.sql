DECLARE @imisid VARCHAR(10);
DECLARE @oldstat CHAR(1);
DECLARE @oldmt VARCHAR(5);

DECLARE cs CURSOR
FOR
SELECT ID
	,[STATUS]
	,MEMBER_TYPE
FROM dba..adHMX_STATUS_Chg

OPEN cs

BEGIN TRANSACTION

FETCH NEXT
FROM cs
INTO @imisid
	,@oldstat
	,@oldmt

WHILE (@@FETCH_STATUS <> - 1)
BEGIN
	INSERT INTO Name_Log (
		DATE_TIME
		,LOG_TYPE
		,SUB_TYPE
		,[USER_ID]
		,ID
		,LOG_TEXT
		)
	VALUES (
		'2015-04-28 14:05:00'
		,'CHANGE'
		,'CHANGE'
		,'MANAGER'
		,@imisid
		,'Name.STATUS: ' + @oldstat + ' -> A'
		)

	INSERT INTO Name_Log (
		DATE_TIME
		,LOG_TYPE
		,SUB_TYPE
		,[USER_ID]
		,ID
		,LOG_TEXT
		)
	VALUES (
		'2015-04-28 14:05:00'
		,'CHANGE'
		,'CHANGE'
		,'MANAGER'
		,@imisid
		,'Name.MEMBER_TYPE: ' + @oldmt + ' -> HMX'
		)

	FETCH NEXT
	FROM cs
	INTO @imisid
		,@oldstat
		,@oldmt
END

CLOSE cs

DEALLOCATE cs
	-- ROLLBACK
	-- COMMIT
