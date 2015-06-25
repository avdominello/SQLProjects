USE [SHM_iMIS]
GO

/****** Object:  StoredProcedure [dbo].[NAS_SP_ChapterCodeImport]    Script Date: 04/01/2015 12:25:56 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[NAS_SP_ChapterCodeImport]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[NAS_SP_ChapterCodeImport]
GO

USE [SHM_iMIS]
GO

/****** Object:  StoredProcedure [dbo].[NAS_SP_ChapterCodeImport]    Script Date: 04/01/2015 12:25:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[NAS_SP_ChapterCodeImport] (@FileName VARCHAR(255))
AS
BEGIN
	/*****************************************************************************************************************    
     Create by:  NAS Consulting, TX / Nassir Althamary      
     Date     :  03/22/2010 10:30 AM          
     Usage    :  exec NAS_SP_ChapterCodeImport '\\shmsql03\ImportExcelFiles\SyncChapters\ChaptersByZipCodeImport\ChaptersByZipCodeImport.csv'     
     
     select *  from NAS_ChapterCodeImport    
     
          
     create index ChapterCode on NAS_ChapterCodeImport(ChapterCode)
     create index ChapterCounty on NAS_ChapterCodeImport(ChapterCounty)
     create index ChapterZipCode on NAS_ChapterCodeImport(ChapterZipCode)
     
   
    *******************************************************************************************************************/
	SET ROWCOUNT 0
	SET NOCOUNT ON

	TRUNCATE TABLE NAS_ChapterCodeImport

	DECLARE @db_name VARCHAR(30)
		,@msg VARCHAR(2000)
		,@server_name VARCHAR(100)
		,@server_pasword VARCHAR(50)

	SELECT @db_name = NAME
		,@server_name = @@servername
		,@server_pasword = 'shmsql8406235'
	FROM master..sysdatabases
	WHERE dbid = db_id()

	SELECT @msg = 'EXEC master..xp_cmdshell ' + '''' + 'bcp  ' + @db_name + '..NAS_ChapterCodeImport in ' + @FileName + ' /c /t, /Usa /P' + @server_pasword + ' /S' + @server_name + ''''

	EXEC (@msg)

	DELETE NAS_ChapterCodeImport
	WHERE ChapterCode = ''
		OR ChapterCounty = ''
		OR ChapterZipCode = ''

	-- update zip that is les than five
	UPDATE NAS_ChapterCodeImport
	SET ChapterZipCode = CASE 
			WHEN LEN(ChapterZipCode) = 3
				THEN '00' + ChapterZipCode
			WHEN LEN(ChapterZipCode) = 4
				THEN '0' + ChapterZipCode
			ELSE ChapterZipCode
			END
	WHERE LEN(ChapterZipCode) < 5

	--- next update Name table    
	DECLARE @ChapterImport AS TABLE (
		SEQN INT IDENTITY(1, 1)
		,ID VARCHAR(10) NOT NULL DEFAULT ''
		,ChapterCode VARCHAR(15) NOT NULL DEFAULT ''
		)

	INSERT @ChapterImport (
		ID
		,ChapterCode
		)
	SELECT n.ID
		,left(ltrim(rtrim(c.ChapterCode)), 15)
	FROM NAS_ChapterCodeImport c
		,NAME n
	WHERE Left(n.ZIP, 5) = left(c.ChapterZipCode, 5)
		AND c.ChapterCode <> ''
		AND c.ChapterCounty <> ''
		AND c.ChapterZipCode <> ''
		AND n.CHAPTER <> c.ChapterCode

	DECLARE @seqn INT
		,@id VARCHAR(10)
		,@ChapterCode VARCHAR(15)

	SET ROWCOUNT 1

	SELECT @seqn = SEQN
		,@id = ID
		,@ChapterCode = ChapterCode
	FROM @ChapterImport

	WHILE (@@rowcount > 0)
	BEGIN
		UPDATE NAME
		SET CHAPTER = @ChapterCode
		WHERE ID = @id

		DELETE @ChapterImport
		WHERE SEQN = @seqn

		SELECT @seqn = SEQN
			,@id = ID
			,@ChapterCode = ChapterCode
		FROM @ChapterImport
	END
END
GO


