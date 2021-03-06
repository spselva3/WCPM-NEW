USE [master]
GO
/****** Object:  Database [dbWCPM]    Script Date: 29-12-2019 09:38:41 ******/
CREATE DATABASE [dbWCPM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbWCPM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dbWCPM.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'dbWCPM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\dbWCPM_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [dbWCPM] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [dbWCPM].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [dbWCPM] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [dbWCPM] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [dbWCPM] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [dbWCPM] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [dbWCPM] SET ARITHABORT OFF 
GO
ALTER DATABASE [dbWCPM] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [dbWCPM] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [dbWCPM] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [dbWCPM] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [dbWCPM] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [dbWCPM] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [dbWCPM] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [dbWCPM] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [dbWCPM] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [dbWCPM] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [dbWCPM] SET  DISABLE_BROKER 
GO
ALTER DATABASE [dbWCPM] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [dbWCPM] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [dbWCPM] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [dbWCPM] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [dbWCPM] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [dbWCPM] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [dbWCPM] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [dbWCPM] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [dbWCPM] SET  MULTI_USER 
GO
ALTER DATABASE [dbWCPM] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [dbWCPM] SET DB_CHAINING OFF 
GO
ALTER DATABASE [dbWCPM] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [dbWCPM] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [dbWCPM]
GO
/****** Object:  StoredProcedure [dbo].[SELECTLOTNUMBERSFORTESTING]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SELECTLOTNUMBERSFORTESTING] 
	
	@LOTNUMBER VARCHAR(50)
 AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT DISTINCT R_ROLLID FROM TBL_REELS

	SELECT DISTINCT R_REELID FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SELECTREELFORPRINTING]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SELECTREELFORPRINTING] 
	
	
 AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT P_REELID FROM BL_PRINT WHERE P_FLAG=1;
	
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_CREATECHILDREELS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_CREATECHILDREELS] 
	-- Add the parameters for the storedprocedure here
	@NOOFREELS NUMERIC(18,0),
	@LOTNUMBER VARCHAR(50),
	@SIZE VARCHAR(50),
	@USER VARCHAR(50),
	@MACHINENUMBER VARCHAR(50),
	@ACTUALSIZE VARCHAR(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @TYPE VARCHAR(50)
	SET @TYPE=(SELECT DISTINCT PO_TYPE FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID=@LOTNUMBER)

SET @MACHINENUMBER=	(SELECT SUBSTRING (@LOTNUMBER,(PatIndex('%[0-9.-]%', @LOTNUMBER)),1))
    -- Insert statements for procedure here
	DECLARE @cnt INT = 0;
	 DECLARE @UNIQUENUM VARCHAR(MAX)
	DECLARE @SRNUM INT =0;
WHILE @cnt < @NOOFREELS
BEGIN
--SELECT ROW_NUMBER() OVER(ORDER BY PO_INSERTEDTIME )
SET @SRNUM= (SELECT COUNT(*) FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER AND R_SIZE=@SIZE)
SET @SRNUM=@SRNUM+1;
 SET @UNIQUENUM=@LOTNUMBER+'-'+@SIZE+'-'+CONVERT(varchar(50), @SRNUM)
 IF NOT EXISTS(SELECT R_REELID FROM TBL_REELS WHERE R_REELID=@UNIQUENUM)
 BEGIN


  
 INSERT INTO TBL_REELS (R_REELID,R_SIZE,R_REMARKS,R_ROLLID,R_USERNAME,R_MACHINENUMBER,R_TYPE,R_PREFIX,R_DATETIME,R_ORDEREDQTY,R_ACTUALSIZE,R_SHIFT) 
               VALUES (@UNIQUENUM,@SIZE,'',       @LOTNUMBER,@USER,   @MACHINENUMBER,@TYPE,(SELECT TOP 1 PREFIX FROM TBL_REELSERIALPREFIX),GETDATE(),(SELECT PO_ORDEREDQTY FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID=@LOTNUMBER AND PO_SIZE=@ACTUALSIZE ),@ACTUALSIZE,DBO.GETSHIFT())
 INSERT INTO TBL_REELHISTORY(RH_REELID,RH_ACTION,RH_DATETIME,RH_USER,RH_LINE) VALUES (@UNIQUENUM,'REEL GENERATION',GETDATE(),@USER,
@MACHINENUMBER)


UPDATE  TBL_REELS  SET R_STATUS='LABELLED' WHERE R_ROLLID=@LOTNUMBER

 END
   SET @cnt = @cnt + 1;
END;
	
	SELECT * FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER AND R_SIZE=@SIZE ORDER BY R_ID DESC



	END
	


	
	


GO
/****** Object:  StoredProcedure [dbo].[SP_DELEETCHILDREELS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_DELEETCHILDREELS]
	-- Add the parameters for the storedprocedure here
	@NOOFREELS INT,
	@ROLLID VARCHAR(50),
	@SIZE VARCHAR(50)
	
AS
BEGIN
	DECLARE @cnt INT = 0;
WHILE @cnt < @NOOFREELS
BEGIN
	DELETE FROM TBL_REELS WHERE R_ID=(SELECT TOP 1 R_ID FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE ORDER BY R_ID DESC )
	SET @CNT=@CNT+1;
	--sudhakar1234
	END
	SELECT * FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE ORDER BY R_ID DESC
	END
	


	
	


GO
/****** Object:  StoredProcedure [dbo].[SP_DELEETCHILDREELSNEW]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_DELEETCHILDREELSNEW]
	-- Add the parameters for the storedprocedure here
	@REELID VARCHAR(50),
	@ROLLID VARCHAR(50),
	@SIZE VARCHAR(50),
	@USER VARCHAR(50),
	@LINENO VARCHAR(50)
	
AS
BEGIN
	IF EXISTS (SELECT TOP (1)R_REELID  FROM TBL_REELS WHERE R_WEIGHT IS  NULL AND R_REELID=@REELID ORDER BY R_ID DESC)
	BEGIN


	UPDATE TBL_REELS SET R_FLAGTODELETE='0', R_STATUS='DELETED' WHERE R_REELID=@REELID
	 INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'REEL DELETED',@USER,@LINENO)


	SELECT 1 AS [RESULT]
	END
	ELSE

	BEGIN
	SELECT 0 AS [RESULT]

	END
	SELECT * FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE ORDER BY R_ID DESC
	END
	


	
	


GO
/****** Object:  StoredProcedure [dbo].[SP_GETREELDETAILSFORA4PRINT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GETREELDETAILSFORA4PRINT]
    (@REELID AS VARCHAR(50))
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    
--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
BEGIN
    SELECT TBL_REELS.R_ID, 
	TBL_REELS.R_REELID AS [P5], 
	TBL_REELS.R_REELID AS [P10], 
	TBL_REELS.R_REELID AS [P15], 
	TBL_REELS.R_SIZE, 
	TBL_REELS.R_REMARKS, 
	TBL_REELS.R_ROLLID AS [P4], 
	TBL_REELS.R_DATETIME, 
	TBL_REELS.R_NOOFPRINTS, 
	TBL_REELS.R_USERNAME, 
	TBL_REELS.R_WEIGHT AS [P7], 
	TBL_REELS.R_MACHINENUMBER, 

	TBL_PRODUCTIONORDER.PO_QUALITY AS [P1],
	TBL_PRODUCTIONORDER.PO_GSM AS [P2],

	TBL_PRODUCTIONORDER.PO_SIZE AS [P3],
	
	TBL_REELS.R_DATETIME AS [P6]
	FROM dbo.TBL_REELS INNER JOIN TBL_PRODUCTIONORDER ON PO_ROLLID=R_ROLLID
	 WHERE R_REELID = @REELID;
END



GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTFORPRINTING]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_INSERTFORPRINTING] 
	-- Add the parameters for the stored procedure here
 @REELNUMBER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	INSERT INTO BL_PRINT(P_REELID,P_FLAG) VALUES (@REELNUMBER,1);
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTLOG_REPRINT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE  PROCEDURE [dbo].[SP_INSERTLOG_REPRINT]
    (@REELID AS VARCHAR(50),
	@USER VARCHAR(50),
	@LINENO VARCHAR(50)
	)
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
    


	    INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'FINAL LABEL RE PRINTED',@USER,@LINENO)
END
    



GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTREELHISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_INSERTREELHISTORY] 
	-- Add the parameters for the stored procedure here
	

    -- Insert statements for procedure here
	


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

	-- Add the parameters for the stored procedure here
	@REELID VARCHAR(50),
	@ACTION VARCHAR(50),
	@USER VARCHAR(50),
	@LINE VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
IF (@ACTION='PRINT')
BEGIN
DECLARE @PRINTCOUNT NUMERIC (18,0)
SELECT @PRINTCOUNT=(SELECT R_NOOFPRINTS FROM TBL_REELS WHERE R_REELID=@REELID)
IF (@PRINTCOUNT>1)
BEGIN
SET @ACTION='REPRINT'
END
ELSE
BEGIN
SET @ACTION='PRINT'
END
END
    -- Insert statements for procedure here
INSERT INTO TBL_REELHISTORY(RH_REELID,RH_ACTION,RH_DATETIME,RH_USER,RH_LINE) VALUES (@REELID,@ACTION,GETDATE(),@USER,
@LINE)


	
	END
	






	

	






GO
/****** Object:  StoredProcedure [dbo].[SP_LOTNUMBERS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_LOTNUMBERS] 
	-- Add the parameters for the stored procedure here
 @LOTNUMER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT TOP 1000 [LT_ID]
      ,[LT_LOTNUMBER]
      ,[LT_LOTNUMBER1]
      ,[LT_LOTNUMBER2]
      ,[LT_LOTNUMBER3]
  FROM [dbWCPM].[dbo].[TBL_LOTNUMBERS] WHERE LT_LOTNUMBER=@LOTNUMER
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTBALANCEREELREPORT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTBALANCEREELREPORT] 
	-- Add the parameters for the stored procedure here
	@FROMDATE VARCHAR(50),
	@TODATE VARCHAR(50),
	@FLAG VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	IF (@FLAG ='ALL')
	BEGIN
	 SELECT top 1000  TBL_REELS.R_ROLLID, TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,

	TBL_REELS.R_SIZE,DBO.GETBALREELS(TBL_REELS.R_ROLLID,TBL_REELS.R_SIZE) AS [BALANCE REELS] FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID
	
	WHERE TBL_REELS.R_WEIGHT IS NULL 
	GROUP BY TBL_REELS.R_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,

	TBL_REELS.R_SIZE
	END
	ELSE
	BEGIN
   SELECT  TBL_REELS.R_ROLLID, TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,

	TBL_REELS.R_SIZE,DBO.GETBALREELS(TBL_REELS.R_ROLLID,TBL_REELS.R_SIZE) AS [BALANCE REELS] FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID
	
	WHERE TBL_REELS.R_WEIGHT IS NULL AND (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) )
	GROUP BY TBL_REELS.R_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,

	TBL_REELS.R_SIZE
	END

		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTCHILDREELS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTCHILDREELS]
	-- Add the parameters for the storedprocedure here
	
	@ROLLID VARCHAR(50),
	@SIZE VARCHAR(50)
	
AS
BEGIN
	
	SELECT * FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE ORDER BY R_ID DESC
	END
	


	
	


GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTCOLORMASTERDATA]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTCOLORMASTERDATA] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   sELECT C_ID,C_CODE,C_COLOR FROM TBL_COLORMASTER ORDER BY C_ID ASC

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORDASHBOARD]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTFORDASHBOARD]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select * from TBL_REELS where  MONTH(R_DATETIME) = MONTH(getdate())
	


	SELECT COUNT(R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())

		SELECT COUNT(R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)

		SELECT COUNT(R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS 



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS  
		 
		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORDASHBOARDNEW]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTFORDASHBOARDNEW]
	-- Add the parameters for the stored procedure here
	@LOCATIONNUMBWR VARCHAR(50)
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select * from TBL_REELS where  MONTH(R_DATETIME) = MONTH(getdate())
	
	IF (@LOCATIONNUMBWR='ALL')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS WHERE R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS  WHERE R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	ELSE
	BEGIN
	IF ( @LOCATIONNUMBWR='1')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND (R_MACHINENUMBER=1 OR R_MACHINENUMBER=2 OR R_MACHINENUMBER=3)  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND (R_MACHINENUMBER=1 OR R_MACHINENUMBER=2 OR R_MACHINENUMBER=3) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE   (R_MACHINENUMBER=1 OR R_MACHINENUMBER=2 OR R_MACHINENUMBER=3) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND (R_MACHINENUMBER=1 OR R_MACHINENUMBER=2 OR R_MACHINENUMBER=3) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND (R_MACHINENUMBER=1 OR R_MACHINENUMBER=2 OR R_MACHINENUMBER=3) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   (R_MACHINENUMBER=1 OR R_MACHINENUMBER=2 OR R_MACHINENUMBER=3) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	IF ( @LOCATIONNUMBWR='2')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE   (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 )AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ) AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	END



		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTGSMMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTGSMMASTER] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT GSM_ID,GSM_MCNO,GSM_FROM,GSM_TO FROM TBL_GSMMASTER 
    -- Insert statements for procedure here
	

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTHISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTHISTORY] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT TOP 1000 H_ID AS [SERIAL NO]
	,H_TRANSACTION_CODE AS [TRANSACTION CODE]
	,H_REMARKS AS [REMARKS]
	,H_USER AS [USER]
	,H_DATETIME  AS [DATETIME],
	H_LINENUMBER AS [LOCATIONNUMBER]
	FROM TBL_HISTORY ORDER BY H_ID ASC


	SELECT TOP 1000 H_ID AS [SERIAL NO]
	,H_TRANSACTION_CODE AS [TRANSACTION CODE]
	,H_REMARKS AS [REMARKS]
	,H_USER AS [USER]
	,H_DATETIME  AS [DATETIME],
	H_LINENUMBER AS [LOCATIONNUMBER],
	H_FILENAME,H_STATUS
	FROM TBL_HISTORY WHERE H_TRANSACTION_CODE='IMPORT_DATA' ORDER BY H_ID DESC 
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLINEFORUPDATE]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTLINEFORUPDATE] 
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT ID,LOCATIONNAME,LOCATIONDESCRIPTION,LOCATIONNUMBER FROM TBL_LOCATIONS

   WHERE ID =@ID
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLINESFORWEB]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTLINESFORWEB] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
SELECT ID AS[ID]
,LOCATIONNAME AS[LOCATION NAME]
,LOCATIONDESCRIPTION AS[DESCRIPTION]
,LOCATIONNUMBER [LOCATION NUMBER]
,LOCATIONDATE [DATE TIME]
FROM TBL_LOCATIONS ORDER BY ID ASC
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOCATIONDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTLOCATIONDETAILS] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	SELECT * FROM TBL_LOCATIONS	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOTWISEREPORT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTLOTWISEREPORT] 
	-- Add the parameters for the stored procedure here
	@LOTNUMBER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT * FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOTWISEREPORTNEW]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTLOTWISEREPORTNEW] 
	-- Add the parameters for the stored procedure here
	@LOTNUMBER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	

SELECT 
CASE WHEN 
(GROUPING(CONVERT(date, R_DATETIME))  = 1 AND GROUPING(R_SIZE)  = 1) THEN 'G TOTAL' 
WHEN (GROUPING(CONVERT(date, R_DATETIME))  = 1 AND GROUPING(R_SIZE)  = 0) THEN 'TOTAL' 

ELSE R_SIZE END 'SIZE',
COUNT(R_REELID) 'NO OF REELS',
R_ORDEREDQTY,

R_ROLLID,CONVERT(date, R_DATETIME) AS [DATE TIME] 
FROM TBL_REELS WHERE  R_ROLLID=@LOTNUMBER

GROUP BY
GROUPING sets
(

 (R_ROLLID,R_SIZE ,CONVERT(date, R_DATETIME)),
   (R_ROLLID,R_SIZE,R_ORDEREDQTY)  ,
  (R_ROLLID,R_ORDEREDQTY)
  
  )
  ORDER BY 
  R_SIZE DESC,CONVERT(date, R_DATETIME) DESC, R_ROLLID DESC


SELECT 
CASE WHEN 
(GROUPING(CONVERT(date,R_WEIGHTCAPUREDTIME))  = 1 AND GROUPING(R_SIZE)  = 1) THEN 'G TOTAL' 
WHEN (GROUPING(CONVERT(date,R_WEIGHTCAPUREDTIME))  = 1 AND GROUPING(R_SIZE)  = 0) THEN 'TOTAL' 

ELSE R_SIZE END 'SIZE',


 COUNT (R_REELID) AS [PACKED REELS],
 SUM(R_WEIGHT)AS [QTY IN KGS]
,



R_ROLLID,CONVERT(date,R_WEIGHTCAPUREDTIME) AS [DATE TIME] 
FROM TBL_REELS WHERE  R_ROLLID=@LOTNUMBER
AND R_WEIGHT IS NOT NULL
GROUP BY
GROUPING sets
(

 (R_ROLLID,R_SIZE ,CONVERT(date, R_DATETIME),CONVERT(date,R_WEIGHTCAPUREDTIME)),
   (R_ROLLID,R_SIZE)  ,
  (R_ROLLID)
  
  )
  ORDER BY 
  R_SIZE DESC,CONVERT(date, R_DATETIME) DESC, R_ROLLID DESC


  DECLARE @SIZE1 VARCHAR(50);
  DECLARE @SIZE2 VARCHAR(50);
  SET @SIZE1=(SELECT TOP 1 R_SIZE FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER);
  SET @SIZE2=(SELECT DISTINCT R_ACTUALSIZE FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER AND R_REPROCESS<>'REPROCESSED')
  IF (@SIZE1=@SIZE2)
  BEGIN
  SELECT 1 AS [RESULT]
  END
  ELSE
  BEGIN
   SELECT 0 AS [RESULT]
  END
		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOWERINGORDERREPORT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_SELECTLOWERINGORDERREPORT] 
	-- Add the parameters for the stored procedure here
	@FROMDATE VARCHAR(50),
	@TODATE VARCHAR(50),
	@FROMMACHINENUMBER NUMERIC(18,0),
	@TOMACHINENUMBER  NUMERIC(18,0)
AS
BEGIN

	SET NOCOUNT ON;

  
	  SELECT  TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_REELS.R_SIZE, 
			TBL_REELS.R_REPROCESS,
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
		TBL_PRODUCTIONORDER.PO_ORDEREDQTY ,
		SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 0 ELSE 1 END) as[COMPLETED REELS],
		'' as[PACKED DATE],
			SUM(TBL_REELS.R_WEIGHT) as[GROSS WEIGHT],
			SUM(TBL_REELS.R_TAREWEIGHT) as[TARE WEIGHT],
			SUM(TBL_REELS.R_NETWEIGHT) as[NET WEIGHT],

	SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 1 ELSE 0 END) as[PENDING REELS]

	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID  WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) ) AND 
	R_MACHINENUMBER BETWEEN @FROMMACHINENUMBER AND @TOMACHINENUMBER
	GROUP BY TBL_REELS.R_SIZE,TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,TBL_PRODUCTIONORDER.PO_ORDEREDQTY,
			TBL_REELS.R_REPROCESS
				END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTMONTHWISEREPORTFORDASHBOARD]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTMONTHWISEREPORTFORDASHBOARD] 
	-- Add the parameters for the stored procedure here
	@MONTHNUMBER NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT DATENAME( MONTH , DATEADD( MONTH , @MONTHNUMBER , 0 ) - 1 ) AS [MONTHNAME], COUNT (R_REELID)  AS [REELCOUNT] FROM TBL_REELS WHERE   DATEPART(MONTH, R_DATETIME) =@MONTHNUMBER

	

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTPACKEDANDBALANCEDREELS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTPACKEDANDBALANCEDREELS] 
	-- Add the parameters for the stored procedure here
	@FROMDATE VARCHAR(50),
	@TODATE VARCHAR(50),
	@FLAG VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;
	IF (@FLAG='ALL')
	BEGIN
	SELECT TOP 1000 TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_REELS.R_SIZE, 
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
		TBL_PRODUCTIONORDER.PO_ORDEREDQTY ,
		SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 0 ELSE 1 END) as[COMPLETED REELS],
		TBL_REELS.R_WEIGHTCAPUREDTIME as[PACKED DATE],
			SUM(TBL_REELS.R_WEIGHT) as[TOTAL QTY],

	SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 1 ELSE 0 END) as[PENDING REELS]

	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID  
	GROUP BY TBL_REELS.R_SIZE,TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,TBL_PRODUCTIONORDER.PO_ORDEREDQTY,
		TBL_REELS.R_DATETIME,TBL_REELS.R_WEIGHT,	TBL_REELS.R_WEIGHTCAPUREDTIME
	END
	ELSE
	BEGIN
	  SELECT  TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_REELS.R_SIZE, 
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
		TBL_PRODUCTIONORDER.PO_ORDEREDQTY ,
		SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 0 ELSE 1 END) as[COMPLETED REELS],
		TBL_REELS.R_WEIGHTCAPUREDTIME as[PACKED DATE],
			SUM(TBL_REELS.R_WEIGHT) as[TOTAL QTY],

	SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 1 ELSE 0 END) as[PENDING REELS]

	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID  WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) )
	GROUP BY TBL_REELS.R_SIZE,TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,TBL_PRODUCTIONORDER.PO_ORDEREDQTY,
		TBL_REELS.R_DATETIME,TBL_REELS.R_WEIGHT,	TBL_REELS.R_WEIGHTCAPUREDTIME
	END

  
	  
				END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTPOFORWEB]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTPOFORWEB] 
	-- Add the parameters for the stored procedure here
	@LINENUMNER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	IF @LINENUMNER='1'
	BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY PO_INSERTEDTIME ) as[PO_SERIALNUMBER],

	  PO_ROLLID  AS [LOT NUMBER],
	PO_QUALITY AS [QUALITY],
	PO_GSM AS [GSM],
	
	PO_SIZE AS [SIZE],
	
	PO_QULAITYCODE AS [QUALITY CODE],
	PO_LOTPREFIX  AS [LOT PREFIX], 
	PO_REMARKS AS [REMARKS],
	PO_USER AS [USER],
	PO_INSERTEDTIME AS [DATE TIME]

	
FROM TBL_PRODUCTIONORDER WHERE PO_MACHINENUMBER=1 OR PO_MACHINENUMBER=2 OR PO_MACHINENUMBER=3 ORDER BY PO_SERIALNUMBER DESC
	END
	ELSE
	BEGIN
	SELECT ROW_NUMBER() OVER(ORDER BY PO_INSERTEDTIME ) as[PO_SERIALNUMBER],

	  PO_ROLLID  AS [LOT NUMBER],
	PO_QUALITY AS [QUALITY],
	PO_GSM AS [GSM],
	
	PO_SIZE AS [SIZE],
	
	PO_QULAITYCODE AS [QUALITY CODE],
	PO_LOTPREFIX  AS [LOT PREFIX], 
	PO_REMARKS AS [REMARKS],
	PO_USER AS [USER],
	PO_INSERTEDTIME AS [DATE TIME]

	
FROM TBL_PRODUCTIONORDER WHERE PO_MACHINENUMBER=4 OR PO_MACHINENUMBER=5 ORDER BY PO_SERIALNUMBER DESC
	END


	
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTPREFIXMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_SELECTPREFIXMASTER] 
	-- Add the parameters for the stored procedure here
	@NEWPREFIX VARCHAR(50),
	@FLAG VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF (@FLAG='SELECT')
	BEGIN
	SELECT PREFIX FROM TBL_REELSERIALPREFIX 
	END
	ELSE
	BEGIN 
	UPDATE TBL_REELSERIALPREFIX SET PREFIX=@NEWPREFIX
	END
    -- Insert statements for procedure here
	

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTQCMASTERDATA]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTQCMASTERDATA] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT QCMASTER_ID AS[ID] 
	,QCMASTER_MCNO AS[MACHINENUMBER]
	,QCMASTER_QCCODE AS[QCCODE]
	,QCMASTER_DESCRIPTION [DESCRIPTION]
	,QCMASTER_TYPE  AS [TYPE]
	FROM TBL_QCMASTER
    -- Insert statements for procedure here
	

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTQUALITYDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTQUALITYDETAILS] 
	-- Add the parameters for the stored procedure here
	@QCDESCRIPTION VARCHAR(50),
	@QCCODE VARCHAR(50),
	@FLAG VARCHAR(50),
	@COLOR VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	IF (@FLAG='QCDESC')
	BEGIN
	
SELECT QCMASTER_DESCRIPTION FROM TBL_QCMASTER WHERE QCMASTER_DESCRIPTION LIKE '%' + @QCDESCRIPTION + '%'  
	
	END
	ELSE IF (@FLAG='QCCODE')
	BEGIN
SELECT QCMASTER_QCCODE FROM TBL_QCMASTER WHERE QCMASTER_QCCODE LIKE '%' + @QCCODE + '%'  

	END
	ELSE
	BEGIN
	SELECT C_COLOR FROM TBL_COLORMASTER WHERE C_COLOR LIKE '%' + @COLOR + '%'  
	END

	END
	






	

	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTREELDETAILS] 
	-- Add the parameters for the stored procedure here
	@REELID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	select TR.R_REELID AS [REELID],TS.PO_ROLLID AS [LOT NO],TS.PO_QUALITY AS[QUALITY],TS.PO_SIZE AS [SIZE],
	TS.PO_GSM AS [GSM],TR.R_DATETIME AS [MFG],TR.R_SHIFT AS [SHIFT] from TBL_REELS TR inner join TBL_PRODUCTIONORDER TS  
ON tr.R_ROLLID=TS.PO_ROLLID AND TR.R_REELID=@REELID ORDER BY R_ID ASC


UPDATE  TBL_REELS  SET R_STATUS='PRINTED' WHERE  R_REELID=@REELID
	
	END
	






	

	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILSFORDASHBOARD]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTREELDETAILSFORDASHBOARD]
	-- Add the parameters for the stored procedure here
	@REELID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--select * from TBL_REELS where  MONTH(R_DATETIME) = MONTH(getdate())
	
	IF (@REELID='ALL')
	BEGIN

	SELECT TOP 1000  [R_ID] AS[SERIALNUMBER]
      ,[R_REELID] AS [REELID]
      ,[R_SIZE] AS [SIZE]
      ,[R_ROLLID] AS [LOTNUMBER]
      ,[R_DATETIME] AS[CREATEDDATETIME]
      ,[R_NOOFPRINTS] AS [NO_OF_PRINTS]
      ,[R_USERNAME] AS[USER]
      ,[R_WEIGHT] AS [WEIGHT]
      ,[R_MACHINENUMBER] AS[LINENUMBER]
    
      ,[R_PRODUCTIONORDER] AS [PRODUCTION_ORDER] FROM TBL_REELS ORDER BY R_DATETIME ASC

		END
		

		ELSE
		BEGIN
		SELECT TOP 1000  [R_ID] AS[SERIALNUMBER]
      ,[R_REELID] AS [REELID]
      ,[R_SIZE] AS [SIZE]
      ,[R_ROLLID] AS [LOTNUMBER]
      ,[R_DATETIME] AS[CREATEDDATETIME]
      ,[R_NOOFPRINTS] AS [NO_OF_PRINTS]
      ,[R_USERNAME] AS[USER]
      ,[R_WEIGHT] AS [WEIGHT]
      ,[R_MACHINENUMBER] AS[LINENUMBER]
     
      ,[R_PRODUCTIONORDER] AS [PRODUCTION_ORDER] FROM TBL_REELS WHERE R_REELID LIKE '%'+@REELID+'%' ORDER BY R_DATETIME ASC
	  END
	  END

	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILSHISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTREELDETAILSHISTORY] 
	-- Add the parameters for the storedprocedure here
	
	@REELNUMBER VARCHAR(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT R_DATETIME AS [CREATIONTIMESTAMP],
	R_USERNAME AS [CREATEDUSER],
	R_MACHINENUMBER AS [CREATEDLINE],
	R_PRINTUSER AS [PRINT USER],
	R_PRINTDATETIME AS [PRINT DATETIME],
	R_REPRINTDATETIME AS [REPRINT DATETIME],
	R_REPRINTUSER AS [REPRINT USER],
	R_WEIGHTUPDATEDUSER AS [WEIGHT UPDATED USER],
	R_WEIGHTUPDATEDDATE AS [WEIGHT UPDATED DATETIME],
	R_WEIGHTUPDATEDLINE AS [WEIGHT UPDATED LINE] 
	FROM TBL_REELS WHERE R_REELID=@REELNUMBER

 
	

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELHISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_SELECTREELHISTORY] 
	-- Add the parameters for the stored procedure here
	@REELNUMBER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID]
 
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM],
TBL_PRODUCTIONORDER.PO_QULAITYCODE AS [QUALITY CODE],
TBL_PRODUCTIONORDER.PO_LOTPREFIX AS [LOT PREFIX],
--TBL_PRODUCTIONORDER.PO_DIA AS [DIA]
--,TBL_PRODUCTIONORDER.PO_NOOFREELS AS[NO OF REELS],
--TBL_PRODUCTIONORDER.PO_NOOFJOINTS AS [NO OF JOINTS]
--,TBL_PRODUCTIONORDER.PO_DATEOFMANUFACTURING AS [MFG DATE]
--,TBL_PRODUCTIONORDER.PO_SHIFT AS [SHIFT]
TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT],

TBL_REELS.R_STATUS  AS [STATUS],


 TBL_REELHISTORY.RH_ACTION AS [ACTION]
 ,TBL_REELHISTORY.RH_DATETIME AS [DATETIME],
 TBL_REELHISTORY.RH_USER AS [USER]  from ((TBL_PRODUCTIONORDER 
 INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE )
 INNER JOIN TBL_REELHISTORY ON RH_REELID= TBL_REELS.R_REELID)  WHERE RH_REELID =@REELNUMBER ORDER BY RH_DATETIME
DESC
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELSDETAILSFORREPORT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTREELSDETAILSFORREPORT] 
	-- Add the parameters for the storedprocedure here
	
	@FLAG VARCHAR(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
 BEGIN
 IF (@FLAG='ALL')
 BEGIN
 SELECT  ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID]
 
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM]
,TBL_REELS.R_SHIFT AS [SHIFT]
,TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND 
TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE
WHERE  TBL_REELS.R_NOOFPRINTS>0   ORDER BY TBL_REELS.R_ID ASC
END
ELSE IF (@FLAG='MONTH')
BEGIN
 select ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc ) AS [ID]
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM]

,TBL_REELS.R_SHIFT AS [SHIFT]
,TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND 
TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND MONTH(TBL_REELS.R_DATETIME)= MONTH(GETDATE()) ORDER BY TBL_REELS.R_ID ASC
END
ELSE
BEGIN
 select ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc ) AS [ID]

 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM]
,TBL_REELS.R_SHIFT AS [SHIFT]
,TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND 
TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND TBL_REELS.R_DATETIME>= CAST(GETDATE() AS DATE)  ORDER BY TBL_REELS.R_ID ASC


END



 


 
	

	END
	END

	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREPORTFORINVENTORYFINAL]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTREPORTFORINVENTORYFINAL] 
	-- Add the parameters for the storedprocedure here
	
	@FLAG VARCHAR(50),
	@LOTNUMBER VARCHAR(50),
	@REELNUMBER VARCHAR(50),
	@FROMDATWE VARCHAR(50),
	@TODATE VARCHAR(50)
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
 BEGIN
 IF (@FLAG='FIL')
 BEGIN

 DECLARE @Query varchar(max)
 SET @Query='
 SELECT  ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID]
 
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM]
,TBL_REELS.R_SHIFT AS [SHIFT]
,TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND 
TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1 '  
--ORDER BY TBL_REELS.R_ID ASC
IF (@LOTNUMBER<>'')
BEGIN

                           SET @Query=@Query+ ' and (R_ROLLID like ''%'+@LOTNUMBER+'%'' ) '
END

IF (@REELNUMBER<>'')
BEGIN
 SET @Query=@Query+ ' and (R_REELID like ''%'+@REELNUMBER+'%'' ) '
END

IF (@FROMDATWE <>@TODATE)
BEGIN
 SET @Query=@Query+' and convert(Date, R_DATETIME,103)
                     BETWEEN convert(date,'''+@FROMDATWE+''',103) AND convert(date,'''+@TODATE+''',103) '

END


SET @Query=@Query+' order by R_ID desc'

EXEC (@Query)


 


 
	


	END
	ELSE  IF (@FLAG='ALL')
 BEGIN
  SELECT  ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID]
 
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM]
,TBL_REELS.R_SHIFT AS [SHIFT]
,TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND 
TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1  ORDER BY TBL_REELS.R_ID ASC
	END
	END


	

	END




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTROLLETAILSFORWEB]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTROLLETAILSFORWEB] 
	-- Add the parameters for the stored procedure here
	@ROLLID VARCHAR(50),
	@SIZE VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	SELECT PO_ROLLID,PO_QUALITY,PO_GSM,PO_SIZE,PO_QULAITYCODE,PO_REMARKS,PO_LOTPREFIX

FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID=@ROLLID AND PO_SIZE=@SIZE

IF EXISTS(SELECT R_ROLLID FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE)
BEGIN
SELECT * FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE ORDER BY R_ID DESC

END

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTSEQWISEREPORT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTSEQWISEREPORT] 
	-- Add the parameters for the stored procedure here
	@FROMDATE VARCHAR(50),
	@TODATE VARCHAR(50),
	@FROMREELSERIALNO NUMERIC(18,0),
	@TOREELSERIALNUMBER  NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  
	SELECT R_REELID,R_ACTUALSIZE,R_REELSNOFORPRINT,R_ROLLID,R_WEIGHT,R_TAREWEIGHT,R_NETWEIGHT FROM TBL_REELS
	 WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) ) AND 
	R_REELSNO BETWEEN @FROMREELSERIALNO AND @TOREELSERIALNUMBER 
	
	
	END
	






	

	





GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTTAREWEIGHTMASTERDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTTAREWEIGHTMASTERDETAILS] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT MASTERTWEIGHT_ID AS[ID],
	MASTERTWEIGHT_TARECODE AS[TARECODE]
	,MASTERTWEIGHT_DESCRIPTION AS[DESCRIPTION]
		,MASTERTWEIGHT_REELSIZEFROM AS[REELSIZEFROM]
	,MASTERTWEIGHT_REELSIZETO AS [REELSIZETO],
	MASTERTWEIGHT_TAREWEIGHT AS [TAREWEIGHT]
	,MASTERTWEIGHT_TYPE AS [TYPE]
	 FROM TBL_TAREWEIGHTMASTER
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTUSERFORUPDATE]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTUSERFORUPDATE] 
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT ID,EMPNAME,EMPID,[ROLE],LOGINUSERNAME,[PASSWORD],CREATEDDATE,
	ISLOGGEDIN,LASTLOGGEDIN,
	 
CASE 
    WHEN [ACTIVEUSER] =1 THEN 'ACTIVE' 
    WHEN [ACTIVEUSER] =0 THEN 'IN ACTIVE' 
    ELSE 'NULL'
	
	END
	as [ACTIVEUSER]

 from TBLLOGIN  WHERE ID =@ID
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTUSERFORWEB]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_SELECTUSERFORWEB] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	SELECT ID,EMPNAME,EMPID,[ROLE],LOGINUSERNAME,[PASSWORD],CREATEDDATE,
	ISLOGGEDIN,LASTLOGGEDIN,UPDATEDDATETIME,
	 
CASE 
    WHEN [ACTIVEUSER] =1 THEN 'ACTIVE' 
    WHEN [ACTIVEUSER] =0 THEN 'IN ACTIVE' 
    ELSE 'NULL'
	
	END
	as [ACTIVEUSER]

 from TBLLOGIN 
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_TBL_REELS_SELECTREEL]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TBL_REELS_SELECTREEL]
    (@REELID AS VARCHAR(50))
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
        --SELECT * FROM dbo.TBL_REELS WHERE R_REELID = @REELID;
        SELECT * FROM dbo.TBL_REELS INNER JOIN dbo.TBL_PRODUCTIONORDER ON  PO_ROLLID = R_ROLLID WHERE R_REELID = @REELID;
END





GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTHISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_TBLINSERTHISTORY] 
	-- Add the parameters for the stored procedure here
	@TRANSACTIONCODE VARCHAR(50),
	@REMARKS VARCHAR(250),
	@USER VARCHAR(50),
	@LINENUMBER VARCHAR(50),
	@FILENAME VARCHAR(250),
	@STATUS VARCHAR(50)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
INSERT INTO TBL_HISTORY (H_TRANSACTION_CODE,H_REMARKS,H_USER,H_LINENUMBER,H_FILENAME,H_STATUS) VALUES
(@TRANSACTIONCODE,@REMARKS,@USER,@LINENUMBER,@FILENAME,@STATUS)
  

	
	 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLINEDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_TBLINSERTLINEDETAILS] 
	-- Add the parameters for the stored procedure here
@LINENUMBER VARCHAR(50),
@LINENAME VARCHAR(50),
@LINEDESCRIPTION VARCHAR(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	IF EXISTS (SELECT LOCATIONNUMBER FROM TBL_LOCATIONS WHERE LOCATIONNUMBER=@LINENUMBER)
	BEGIN
	SELECT 0 AS [RESULT]
	END
	ELSE
	BEGIN
	INSERT INTO TBL_LOCATIONS (LOCATIONNAME,LOCATIONDESCRIPTION,LOCATIONNUMBER)
	 VALUES (@LINENAME,@LINEDESCRIPTION,@LINENUMBER)
	 SELECT 1 AS [RESULT]
	END

	

	
	 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLOGINDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TBLINSERTLOGINDETAILS] 
	-- Add the parameters for the stored procedure here
@EMPNAME VARCHAR(50),
@EMPID VARCHAR(50),
@DESIGNATION VARCHAR(50),
@USERNAME VARCHAR(50),
@PASSWORD VARCHAR(250),
@STATUS VARCHAR(50)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF  EXISTS(SELECT EMPID FROM TBLLOGIN WHERE EMPID=@EMPID)
BEGIN
	SELECT 2 AS [RESULT]
END
 ELSE IF EXISTS(SELECT LOGINUSERNAME FROM TBLLOGIN WHERE LOGINUSERNAME=@USERNAME)
BEGIN
SELECT 0 AS [RESULT]
END
 
ELSE
BEGIN
INSERT INTO TBLLOGIN (EMPNAME,EMPID,[ROLE],LOGINUSERNAME,[PASSWORD],ACTIVEUSER) VALUES(@EMPNAME,@EMPID,@DESIGNATION,@USERNAME,@PASSWORD,@STATUS)
SELECT 1 AS [RESULT]

END
  

	
	 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLOTNUMBERS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TBLINSERTLOTNUMBERS] 
	-- Add the parameters for the stored procedure here

@LT_LOTNUMBER VARCHAR(50),
@LT_LOTNUMBER1 VARCHAR(50),
@LT_LOTNUMBER2 VARCHAR(50),
@LT_LOTNUMBER3 VARCHAR(50)





AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
		BEGIN
			
	
    -- Insert statements for procedure here
	INSERT INTO TBL_LOTNUMBERS(LT_LOTNUMBER,LT_LOTNUMBER1,LT_LOTNUMBER2,LT_LOTNUMBER3)VALUES (@LT_LOTNUMBER,@LT_LOTNUMBER1,
	@LT_LOTNUMBER2,@LT_LOTNUMBER3)
END
END








GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTPRODUCTIONORDERS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TBLINSERTPRODUCTIONORDERS] 
	-- Add the parameters for the stored procedure here

@PO_ROLLID VARCHAR(50),
@PO_QUALITY VARCHAR(50),
@PO_GSM VARCHAR(50),
@LOTPREFOX VARCHAR(50),
@PO_QUALITYCODE VARCHAR(50),
@PO_SIZE VARCHAR(50),

@USER VARCHAR(50),
@PO_REMARKS VARCHAR(50),
@COLORGRAIN  VARCHAR(150),
@ORDEREDQTY NUMERIC (18,0)




AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF not exists(select PO_ROLLID,PO_SIZE from TBL_PRODUCTIONORDER where PO_ROLLID=@PO_ROLLID  AND PO_SIZE=@PO_SIZE )
		BEGIN
			
	DECLARE @PO_MACHINENUMBER VARCHAR(50)
	SET @PO_MACHINENUMBER=(SELECT SUBSTRING (@PO_ROLLID,(PatIndex('%[0-9.-]%', @PO_ROLLID)),1))
	DECLARE @TYPE VARCHAR(50)
	IF (@LOTPREFOX='BC' OR @LOTPREFOX='DC')
	BEGIN
	SET @TYPE=@LOTPREFOX
	END

ELSE IF EXISTS(SELECT QCMASTER_QCCODE FROM TBL_QCMASTER WHERE QCMASTER_QCCODE=@PO_QUALITYCODE AND QCMASTER_TYPE='MICR')
	
	BEGIN
	SET @TYPE='MICR'
	END
	ELSE
	BEGIN
	SET @TYPE='MARKET'
	END
    -- Insert statements for procedure here
	INSERT INTO TBL_PRODUCTIONORDER ( 
PO_ROLLID ,
PO_QUALITY ,
PO_GSM ,
 PO_SIZE ,
 PO_QULAITYCODE,
 PO_LOTPREFIX,
 PO_REMARKS,
 
PO_MACHINENUMBER,PO_USER,PO_TYPE ,PO_COLOURGRAIN,PO_ORDEREDQTY)VALUES (
@PO_ROLLID ,
@PO_QUALITY ,
@PO_GSM,
 
@PO_SIZE,
@PO_QUALITYCODE,
@LOTPREFOX,
@PO_REMARKS,
@PO_MACHINENUMBER,@USER,@TYPE,@COLORGRAIN,@ORDEREDQTY )

SELECT '1' AS RESULT
		END
		ELSE
		BEGIN

		SELECT '0' AS RESULT
		END
	 

END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTQCMASTERDATA]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_TBLINSERTQCMASTERDATA] 
	-- Add the parameters for the stored procedure here

@QCMASTER_MCNO INT ,
@QCMASTER_QCCODE INT,
@QCMASTER_DESCRIPTION VARCHAR(50)





AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF not exists(select QCMASTER_QCCODE from TBL_QCMASTER where QCMASTER_QCCODE=@QCMASTER_QCCODE )
		BEGIN
		DECLARE @TYPE VARCHAR(50)
		IF (@QCMASTER_DESCRIPTION like '%MICR%')
		BEGIN
	SET 	@TYPE='MICR'
		END

		INSERT INTO 	TBL_QCMASTER (QCMASTER_MCNO,QCMASTER_QCCODE,QCMASTER_DESCRIPTION,QCMASTER_TYPE) VALUES(
		@QCMASTER_MCNO,@QCMASTER_QCCODE,@QCMASTER_DESCRIPTION,@TYPE)

		SELECT '1' AS [RESULT]
	END
	ELSE
	BEGIN

	SELECT '0' AS [RESULT]
	END
	 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLLOGINSELECTUSER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_TBLLOGINSELECTUSER] 
	-- Add the parameters for the stored procedure here
@LI_UserName VARCHAR(50)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	select * from TBLLOGIN 
	where LOGINUSERNAME = @LI_UserName
	 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLUPDATELOGINDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASSWORD,ACTIVEUSERAuthor:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_TBLUPDATELOGINDETAILS] 
	-- Add the parameters for the stored procedure here
@ID NUMERIC(18,0),
@DESIGNATION VARCHAR(50),
@USERNAME VARCHAR(50),
@PASSWORD VARCHAR(250),
@STATUS VARCHAR(50)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    -- Insert statements for procedure here
	

	UPDATE TBLLOGIN SET [ROLE]=@DESIGNATION,LOGINUSERNAME=@USERNAME,[PASSWORD]=@PASSWORD,
	ACTIVEUSER=@STATUS, UPDATEDDATETIME=GETDATE() WHERE ID=@ID
	 
END









GO
/****** Object:  StoredProcedure [dbo].[SP_TBLUPDATETAREMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_TBLUPDATETAREMASTER] 
	-- Add the parameters for the stored procedure here
	@ID INT,
	@FROMVALUE NUMERIC(18,3),
	@TOVALUE NUMERIC(18,3),
	@TAREWEIGHT NUMERIC(18,3)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	UPDATE  TBL_TAREWEIGHTMASTER SET MASTERTWEIGHT_REELSIZEFROM=@FROMVALUE,
	MASTERTWEIGHT_REELSIZETO=@TOVALUE,
	MASTERTWEIGHT_TAREWEIGHT=@TAREWEIGHT WHERE MASTERTWEIGHT_ID=@ID
		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATELASTLOGEEDINTIME]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_UPDATELASTLOGEEDINTIME] 
	-- Add the parameters for the stored procedure here
	@USER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	
	UPDATE TBLLOGIN SET LASTLOGGEDIN=GETDATE() WHERE LOGINUSERNAME=@USER

 
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATELINEDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE [dbo].[SP_UPDATELINEDETAILS] 
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),
	@LOCATIONNAME VARCHAR(50),
	@LOCATIONDESCRIPTION VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	UPDATE TBL_LOCATIONS SET LOCATIONNAME=@LOCATIONNAME, LOCATIONDESCRIPTION=@LOCATIONDESCRIPTION WHERE ID=@ID

   
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATELOGINSTATUS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_UPDATELOGINSTATUS] 
	-- Add the parameters for the stored procedure here
	@USER VARCHAR(50),
	@STATUS BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	
	UPDATE TBLLOGIN SET ISLOGGEDIN=@STATUS WHERE LOGINUSERNAME=@USER

 
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATEPRINTCOUNT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATEPRINTCOUNT] 
	-- Add the parameters for the stored procedure here
	@REELNUMBER VARCHAR(50),
	@USER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	DECLARE @CURRENTCOUNT NUMERIC(18,0);

	SELECT @CURRENTCOUNT=R_NOOFPRINTS FROM TBL_REELS WHERE R_REELID=@REELNUMBER
	IF @CURRENTCOUNT=NULL
	BEGIN
SET 	@CURRENTCOUNT=0;
	END
	SET @CURRENTCOUNT=@CURRENTCOUNT+1;
	UPDATE TBL_REELS SET R_NOOFPRINTS=@CURRENTCOUNT WHERE R_REELID=@REELNUMBER
	UPDATE TBL_REELS SET R_DATETIME=GETDATE(), R_USERNAME=@USER
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATEREELWEIGHT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--SET QUOTED_IDENTIFIER ON|OFF
--SET ANSI_NULLS ON|OFF
--GO
CREATE PROCEDURE [dbo].[SP_UPDATEREELWEIGHT]
    (@WEIGHT AS NUMERIC(9,3), @REELID AS VARCHAR(50),
	@USER VARCHAR(50),
	@LINENO VARCHAR(50)
	)
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN

-------------------------------------------------------------------------------------------------------------
DECLARE @MACHINENUMBER INT
DECLARE @LOTNUMBER VARCHAR(50)
SET @LOTNUMBER=(SELECT DISTINCT R_ROLLID FROM TBL_REELS WHERE R_REELID=@REELID)
SET @MACHINENUMBER=	(SELECT SUBSTRING (@LOTNUMBER,(PatIndex('%[0-9.-]%', @LOTNUMBER)),1))
DECLARE @LINENUMBER INT

IF @MACHINENUMBER=1 OR @MACHINENUMBER=2 OR @MACHINENUMBER=3
BEGIN
SET @LINENUMBER=1

END
ELSE
BEGIN
SET @LINENUMBER=2
END

-------------------------------------------------------------------------------------------------------------
IF EXISTS(SELECT R_WEIGHT FROM TBL_REELS WHERE R_REELID = @REELID AND R_WEIGHT IS NULL)
BEGIN

DECLARE @TAREWEIGHT NUMERIC(18,3)
     
	  DECLARE @SN INT
	  DECLARE @PREFIX VARCHAR(50)
	  --SET @PREFIX=(SELECT R_PREFIX FROM TBL_REELS WHERE  R_REELID=@REELID)
	  SET @PREFIX=(SELECT PREFIX FROM TBL_REELSERIALPREFIX )
	  DECLARE @TYPE VARCHAR(50)
	  SET @TYPE=(SELECT R_TYPE FROM TBL_REELS WHERE  R_REELID=@REELID)
------------------------------------------------------------------------------------------------------------
	  IF (@TYPE='MICR')
	  BEGIN 

	  IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  BEGIN
  SET @SN= 900000
  END
  ELSE
  BEGIN
  SET @SN=(SELECT MAX(ISNULL(R_REELSNO,900000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
 END
	
	SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='MICR')
	 	  END
----------------------------------------------------------------------------------------------------------
	 ELSE  IF (@TYPE='BC')
	  BEGIN
	   IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  BEGIN
  SET @SN= 100000
  END
  ELSE
  BEGIN
  SET @SN=(SELECT MAX(ISNULL(R_REELSNO,100000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
 END
	 --SET @SN=(SELECT MAX(ISNULL(R_REELSNO,100000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
	 SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='BC')
	 	  END
----------------------------------------------------------------------------------------------------------
	   ELSE  IF (@TYPE='DC')
	  BEGIN
	  IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  BEGIN
  SET @SN= 400000
  END
  ELSE
  BEGIN
  SET @SN=(SELECT MAX(ISNULL(R_REELSNO,400000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  END
	 --SET @SN=(SELECT MAX(ISNULL(R_REELSNO,400000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
	 SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='DC')
	 	  END
-----------------------------------------------------------------------------------------------------------
	   ELSE  IF (@TYPE='MARKET')
	  BEGIN
	  IF (@LINENUMBER='1')
	  BEGIN
	    IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  BEGIN
  SET @SN= 200000
  END
  ELSE
  BEGIN
  SET @SN=(SELECT MAX(ISNULL(R_REELSNO,200000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  END
	 --SET @SN=(SELECT MAX(ISNULL(R_REELSNO,200000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
	 END
	 ELSE
	 BEGIN
	   IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  BEGIN
  SET @SN= 0
  END
  ELSE
  BEGIN
  SET @SN=(SELECT MAX(ISNULL(R_REELSNO,0)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
  END
	 --SET @SN=(SELECT MAX(ISNULL(R_REELSNO,0)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)

	 END
	 SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='MARKET')
	  END
-------------------------------------------------------------------------------------------------------------
	
	 SET @SN=@SN+1;
	 DECLARE @PINTSN VARCHAR(50)
	SET @PINTSN =CONCAT(@PREFIX,'',@SN)
	DECLARE @NETWEIGHT NUMERIC(18,3)
	SET @NETWEIGHT=@WEIGHT-@TAREWEIGHT;
	   UPDATE dbo.TBL_REELS SET R_REELSNO = @SN, R_REELSNOFORPRINT=@PINTSN,R_WEIGHT = @WEIGHT,R_TAREWEIGHT=@TAREWEIGHT,R_NETWEIGHT=@NETWEIGHT, R_WEIGHTCAPUREDTIME=GETDATE() WHERE R_REELID = @REELID;
	    
	  END
--------------------------------------------------------------------------------------------------------------
	  ELSE
	  BEGIN
	    DECLARE @SN1 INT
	    DECLARE @TYPE1 VARCHAR(50)
		  DECLARE @PREFIX1 VARCHAR(50)
	  --SET @PREFIX1=(SELECT DISTINCT R_PREFIX FROM TBL_REELS WHERE  R_REELID=@REELID)
	  SET @PREFIX1=(SELECT PREFIX FROM TBL_REELSERIALPREFIX)
	  SET @TYPE1=(SELECT DISTINCT R_TYPE FROM TBL_REELS WHERE  R_REELID=@REELID)
	   IF (@TYPE1='MICR')
	   BEGIN
	    IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  BEGIN
  SET @SN1= 900000
  END
  ELSE
  BEGIN
  SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,900000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  END
	   SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='MICR')
	   END
	   ELSE  IF (@TYPE1='BC')
	  BEGIN
	  IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  BEGIN
  SET @SN1= 400000
  END
  ELSE
  BEGIN
  SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,400000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  END
	  SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='BC')
	  END
	   ELSE  IF (@TYPE1='DC')
	  BEGIN
	   IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  BEGIN
  SET @SN1= 400000
  END
  ELSE
  BEGIN
  SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,400000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  END
	  SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='DC')
	  END
	   ELSE  IF (@TYPE1='MARKET')
	  BEGIN
	   IF (@LINENUMBER='1')
	  BEGIN
	    IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  BEGIN
  SET @SN1= 200000
  END
  ELSE
  BEGIN
  SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,200000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  END
	 --SET @SN=(SELECT MAX(ISNULL(R_REELSNO,200000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
	 END
	 ELSE
	 BEGIN
	   IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  BEGIN
  SET @SN1= 0
  END
  ELSE
  BEGIN
   SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,0)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
  END
  END
	   SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@WEIGHT AND MASTERTWEIGHT_REELSIZETO>=@WEIGHT AND MASTERTWEIGHT_TYPE='MARKET')
	  END
	  DECLARE @NETWEIGHT1 NUMERIC(18,3)
	SET @NETWEIGHT1=@WEIGHT-@TAREWEIGHT;
	 
	
	 --SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,0)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1)
	
	 SET @SN1=@SN1+1;
	 DECLARE @PINTSN1 VARCHAR(50)
	SET @PINTSN1 =CONCAT(@PREFIX1,'',@SN1)

	DECLARE @MAXID INT
SET @MAXID=(SELECT MAX(R_ID) FROM  TBL_REELS WHERE R_REELID=@REELID)
	INSERT INTO TBL_REELS(R_REELID,R_SIZE,R_REMARKS,R_ROLLID,R_NOOFPRINTS,R_USERNAME,R_WEIGHT,R_MACHINENUMBER,R_STATUS,
	R_SHIFT,R_TYPE,R_PREFIX,R_ACTUALSIZE)  (SELECT R_REELID,R_SIZE,R_REMARKS,R_ROLLID,R_NOOFPRINTS,R_USERNAME,R_WEIGHT,R_MACHINENUMBER,R_STATUS,
	R_SHIFT,R_TYPE,(SELECT PREFIX FROM TBL_REELSERIALPREFIX),R_ACTUALSIZE FROM TBL_REELS WHERE R_REELID=@REELID AND R_ID=@MAXID)
	SET @MAXID=(SELECT MAX(R_ID) FROM  TBL_REELS WHERE R_REELID=@REELID)

  UPDATE dbo.TBL_REELS SET R_REELSNO = @SN1, R_REELSNOFORPRINT=@PINTSN1,R_REPROCESS='REPROCESSED',R_WEIGHT=@WEIGHT,R_TAREWEIGHT=@TAREWEIGHT,R_NETWEIGHT=@NETWEIGHT1,R_WEIGHTCAPUREDTIME=GETDATE() WHERE R_ID = @MAXID;
	  END
	  	  INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'WEIGHT CAPTURED',@USER,@LINENO)
	    INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'FINAL LABEL PRINTED',@USER,@LINENO)
END
    

GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATEUSERDETAILS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_UPDATEUSERDETAILS] 
	-- Add the parameters for the stored procedure here
	@ID NUMERIC(18,0),
	@EMPNAME VARCHAR(50),
	@EMPID VARCHAR(50),
	@ROLE VARCHAR(50),
	@USERNAME VARCHAR(50),
	@PASSWORD VARCHAR(50),
	@STATUS VARCHAR(50)
AS 	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	UPDATE TBLLOGIN SET EMPNAME=@EMPNAME,EMPID=@EMPID   ,[ROLE]=@ROLE   ,LOGINUSERNAME=@USERNAME
	   ,[PASSWORD]=@PASSWORD ,ACTIVEUSER=@STATUS WHERE ID=@ID

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDATEGSM]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_VALIDATEGSM] 
	-- Add the parameters for the stored procedure here
	@LOTNUMBER VARCHAR(50),
	@GSM INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @PO_MACHINENUMBER NUMERIC(18,0);
	SET @PO_MACHINENUMBER=(SELECT SUBSTRING (@LOTNUMBER,(PatIndex('%[0-9.-]%', @LOTNUMBER)),1))
   	DECLARE @FROMGSM INT
	DECLARE @TOGSM INT

	SET @FROMGSM=(SELECT GSM_FROM FROM TBL_GSMMASTER WHERE GSM_MCNO=@PO_MACHINENUMBER)
	SET @TOGSM=(SELECT GSM_TO FROM TBL_GSMMASTER WHERE GSM_MCNO=@PO_MACHINENUMBER)
	IF (@GSM>@FROMGSM-1 AND @GSM<@TOGSM+1)
	BEGIN
	SELECT '1' AS [RESULT]
	END
	ELSE
	BEGIN
	SELECT '0' AS [RESULT]

	END

	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SPUPDATEAFTERPRINTING]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SPUPDATEAFTERPRINTING] 
	@REELID VARCHAR(50)
	
 AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE BL_PRINT SET P_FLAG=0 WHERE P_REELID=@REELID
	
	
	END
	






GO
/****** Object:  UserDefinedFunction [dbo].[COPYROWDATA]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[COPYROWDATA](@REELNUMBER VARCHAR(50))

RETURNS INT
AS
BEGIN
DECLARE @R_SIZE VARCHAR(50)
DECLARE @R_REMARKS VARCHAR(50)
DECLARE @R_ROLLID VARCHAR(50)
DECLARE @R_NOOFPRINTS NUMERIC(18,0)
DECLARE @R_USERNAME VARCHAR(50)
DECLARE @R_WEIGHT VARCHAR(50)
DECLARE @R_MACHINENUMBER NUMERIC(18,0)
DECLARE @R_STATUS VARCHAR(50)
	DECLARE @R_SHIFT VARCHAR(50)
	DECLARE @R_TYPE VARCHAR(50)
	DECLARE @R_PREFIX VARCHAR(50)
	SET @R_SIZE=( SELECT R_SIZE FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_REMARKS=(SELECT R_REMARKS  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	
	SET @R_ROLLID=(SELECT R_ROLLID  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_NOOFPRINTS=(SELECT R_NOOFPRINTS  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_USERNAME=(SELECT R_USERNAME  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_WEIGHT=(SELECT R_WEIGHT  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_MACHINENUMBER=(SELECT R_MACHINENUMBER  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_STATUS=(SELECT R_STATUS  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_SHIFT=(SELECT R_SHIFT  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_TYPE=(SELECT R_TYPE  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
	SET @R_PREFIX=(SELECT R_PREFIX  FROM TBL_REELS WHERE R_REELID=@REELNUMBER)
 
RETURN 0
END



GO
/****** Object:  UserDefinedFunction [dbo].[GETBALREELS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GETBALREELS]
(@LOTNUMBER VARCHAR(50),@SIZE VARCHAR(50))
RETURNS VARCHAR(256)
AS
BEGIN


DECLARE @Locations varchar(500)

SET @Locations=( Select SUBSTRING(
(
    SELECT ',' +DBO.GETREELSERIALNUMBER(TBL_REELS.R_REELID) AS 'data()'
        FROM TBL_REELS 
              where R_ROLLID=@LOTNUMBER AND R_SIZE=@SIZE AND R_WEIGHT IS NULL AND R_FLAGTODELETE=1
        FOR XML PATH('')
), 2 , 9999))

RETURN @Locations




END



GO
/****** Object:  UserDefinedFunction [dbo].[GETREELSERIALNUMBER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GETREELSERIALNUMBER]
(@REELID VARCHAR(50))
RETURNS VARCHAR(256)
AS
BEGIN




declare @seccode varchar(50);
set @seccode=(SELECT SUBSTRING(@REELID, CHARINDEX('-', @REELID) + 2, 100))
DECLARE @ETVAL VARCHAR(50)
SET @ETVAL=(SELECT SUBSTRING(@seccode, CHARINDEX('-', @seccode) + 1, 100))
RETURN @ETVAL




END



GO
/****** Object:  UserDefinedFunction [dbo].[GETSHIFT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[GETSHIFT]
()
RETURNS VARCHAR(256)
AS
BEGIN




DECLARE @CURHOUR DATETIME
DECLARE @SHIFT VARCHAR(50)
SET @CURHOUR=(SELECT DATEPART(HOUR, GETDATE()))
IF (@CURHOUR>=6 AND @CURHOUR<14)
BEGIN
SET @SHIFT='A'
END
ELSE IF (@CURHOUR>=14 AND @CURHOUR<22)
BEGIN
SET @SHIFT='B'
END
ELSE IF @CURHOUR<6 
BEGIN
SET @SHIFT='C'
END

RETURN @SHIFT




END



GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetNumeric]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_GetNumeric]
(@strAlphaNumeric VARCHAR(256))
RETURNS VARCHAR(256)
AS
BEGIN
DECLARE @intAlpha INT
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric)
BEGIN
WHILE @intAlpha > 0
BEGIN
SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
SET @intAlpha = PATINDEX('%[^0-9]%', @strAlphaNumeric )
END
END
RETURN ISNULL(@strAlphaNumeric,0)
END



GO
/****** Object:  Table [dbo].[BL_PRINT]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BL_PRINT](
	[P_ID] [int] IDENTITY(1,1) NOT NULL,
	[P_REELID] [varchar](50) NULL,
	[P_FLAG] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_COLORMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_COLORMASTER](
	[C_ID] [int] IDENTITY(1,1) NOT NULL,
	[C_CODE] [numeric](18, 0) NULL,
	[C_COLOR] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_GSMMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_GSMMASTER](
	[GSM_ID] [int] IDENTITY(1,1) NOT NULL,
	[GSM_MCNO] [int] NULL,
	[GSM_FROM] [int] NULL,
	[GSM_TO] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL_HISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_HISTORY](
	[H_ID] [int] IDENTITY(1,1) NOT NULL,
	[H_TRANSACTION_CODE] [varchar](50) NULL,
	[H_REMARKS] [varchar](250) NULL,
	[H_USER] [varchar](50) NULL,
	[H_DATETIME] [datetime] NULL,
	[H_LINENUMBER] [varchar](50) NULL,
	[H_FILENAME] [varchar](250) NULL,
	[H_STATUS] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_LOCATIONS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_LOCATIONS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LOCATIONNAME] [varchar](50) NULL,
	[LOCATIONDESCRIPTION] [varchar](50) NULL,
	[LOCATIONNUMBER] [varchar](50) NULL,
	[LOCATIONDATE] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_PRODUCTIONORDER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PRODUCTIONORDER](
	[PO_SERIALNUMBER] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[PO_ROLLID] [varchar](50) NULL,
	[PO_QUALITY] [varchar](50) NULL,
	[PO_GSM] [varchar](50) NULL,
	[PO_SIZE] [varchar](50) NULL,
	[PO_INSERTEDTIME] [datetime] NULL,
	[PO_MACHINENUMBER] [numeric](18, 0) NULL,
	[PO_USER] [varchar](50) NULL,
	[PO_QULAITYCODE] [varchar](50) NULL,
	[PO_REMARKS] [varchar](50) NULL,
	[PO_LOTPREFIX] [varchar](50) NULL,
	[PO_TYPE] [varchar](50) NULL,
	[PO_COLOURGRAIN] [varchar](50) NULL,
	[PO_ORDEREDQTY] [numeric](18, 0) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_QCCODEMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_QCCODEMASTER](
	[MATER_ID] [int] IDENTITY(1,1) NOT NULL,
	[MASTER_QCCODE] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_QCMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_QCMASTER](
	[QCMASTER_ID] [int] IDENTITY(1,1) NOT NULL,
	[QCMASTER_MCNO] [int] NULL,
	[QCMASTER_QCCODE] [int] NULL,
	[QCMASTER_DESCRIPTION] [varchar](50) NULL,
	[QCMASTER_TYPE] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REELHISTORY]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_REELHISTORY](
	[RH_REELID] [varchar](50) NULL,
	[RH_ACTION] [varchar](50) NULL,
	[RH_DATETIME] [datetime] NULL,
	[RH_USER] [varchar](50) NULL,
	[RH_LINE] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REELS]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_REELS](
	[R_ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[R_REELID] [varchar](50) NULL,
	[R_SIZE] [varchar](50) NULL,
	[R_REMARKS] [varchar](50) NULL,
	[R_ROLLID] [varchar](50) NULL,
	[R_DATETIME] [datetime] NULL,
	[R_NOOFPRINTS] [numeric](18, 0) NULL,
	[R_USERNAME] [varchar](50) NULL,
	[R_WEIGHT] [numeric](18, 3) NULL,
	[R_MACHINENUMBER] [numeric](18, 0) NULL,
	[R_STATUS] [varchar](50) NULL,
	[R_SHIFT] [varchar](50) NULL,
	[R_TYPE] [varchar](50) NULL,
	[R_REELSNO] [int] NULL,
	[R_PREFIX] [varchar](50) NULL,
	[R_REELSNOFORPRINT] [varchar](50) NULL,
	[R_REPROCESS] [varchar](50) NULL,
	[R_ORDEREDQTY] [numeric](18, 0) NULL,
	[R_ACTUALSIZE] [varchar](50) NULL,
	[R_TAREWEIGHT] [numeric](18, 3) NULL,
	[R_NETWEIGHT] [numeric](18, 3) NULL,
	[R_WEIGHTCAPUREDTIME] [datetime] NULL,
	[R_FLAGTODELETE] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REELSERIALPREFIX]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_REELSERIALPREFIX](
	[PREFIX] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_TAREWEIGHTMASTER]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_TAREWEIGHTMASTER](
	[MASTERTWEIGHT_ID] [int] IDENTITY(1,1) NOT NULL,
	[MASTERTWEIGHT_TARECODE] [int] NULL,
	[MASTERTWEIGHT_DESCRIPTION] [varchar](50) NULL,
	[MASTERTWEIGHT_REELSIZEFROM] [numeric](18, 3) NULL,
	[MASTERTWEIGHT_REELSIZETO] [numeric](18, 3) NULL,
	[MASTERTWEIGHT_TAREWEIGHT] [numeric](18, 3) NULL,
	[MASTERTWEIGHT_TYPE] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBLLOGIN]    Script Date: 29-12-2019 09:38:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBLLOGIN](
	[ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[EMPNAME] [varchar](50) NULL,
	[EMPID] [nvarchar](50) NULL,
	[ROLE] [nvarchar](50) NULL,
	[LOGINUSERNAME] [nvarchar](50) NULL,
	[PASSWORD] [nvarchar](250) NULL,
	[CREATEDDATE] [datetime] NULL,
	[ISLOGGEDIN] [bit] NULL,
	[LASTLOGGEDIN] [datetime] NULL,
	[ACTIVEUSER] [bit] NULL,
	[UPDATEDDATETIME] [datetime] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[BL_PRINT] ON 

INSERT [dbo].[BL_PRINT] ([P_ID], [P_REELID], [P_FLAG]) VALUES (4, N'E1046096-26.7-1', 0)
INSERT [dbo].[BL_PRINT] ([P_ID], [P_REELID], [P_FLAG]) VALUES (5, N'1046188-25.4-1', 0)
SET IDENTITY_INSERT [dbo].[BL_PRINT] OFF
SET IDENTITY_INSERT [dbo].[TBL_COLORMASTER] ON 

INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (1, CAST(0 AS Numeric(18, 0)), N'DEFAULT')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (2, CAST(1 AS Numeric(18, 0)), N'L_GRAIN')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (3, CAST(2 AS Numeric(18, 0)), N'S_GRAIN')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (4, CAST(3 AS Numeric(18, 0)), N'WHITE')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (5, CAST(4 AS Numeric(18, 0)), N'WHITE LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (6, CAST(5 AS Numeric(18, 0)), N'WHITE SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (7, CAST(7 AS Numeric(18, 0)), N'')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (8, CAST(10 AS Numeric(18, 0)), N'BLUE')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (9, CAST(11 AS Numeric(18, 0)), N'BLUE LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (10, CAST(12 AS Numeric(18, 0)), N'BLUE SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (11, CAST(13 AS Numeric(18, 0)), N'TBLUE')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (12, CAST(20 AS Numeric(18, 0)), N'GREEN')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (13, CAST(21 AS Numeric(18, 0)), N'GREEN LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (14, CAST(22 AS Numeric(18, 0)), N'GREEN SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (15, CAST(23 AS Numeric(18, 0)), N'LGREEN')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (16, CAST(24 AS Numeric(18, 0)), N'LGREEN LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (17, CAST(25 AS Numeric(18, 0)), N'LGREEN SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (18, CAST(26 AS Numeric(18, 0)), N'SEA GREEN')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (19, CAST(30 AS Numeric(18, 0)), N'NS')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (20, CAST(31 AS Numeric(18, 0)), N'NS LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (21, CAST(32 AS Numeric(18, 0)), N'NS SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (22, CAST(40 AS Numeric(18, 0)), N'LS')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (23, CAST(41 AS Numeric(18, 0)), N'LS LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (24, CAST(42 AS Numeric(18, 0)), N'LS SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (25, CAST(50 AS Numeric(18, 0)), N'PINK')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (26, CAST(51 AS Numeric(18, 0)), N'PINK LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (27, CAST(52 AS Numeric(18, 0)), N'PINK SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (28, CAST(53 AS Numeric(18, 0)), N'LPINK')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (29, CAST(54 AS Numeric(18, 0)), N'LPINK LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (30, CAST(55 AS Numeric(18, 0)), N'LPINK SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (31, CAST(60 AS Numeric(18, 0)), N'YELLOW')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (32, CAST(61 AS Numeric(18, 0)), N'YELLOW LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (33, CAST(62 AS Numeric(18, 0)), N'YELLOW SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (34, CAST(63 AS Numeric(18, 0)), N'LYELLOW')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (35, CAST(64 AS Numeric(18, 0)), N'LYELLOW  LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (36, CAST(65 AS Numeric(18, 0)), N'LYELLOW SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (37, CAST(66 AS Numeric(18, 0)), N'LEMON')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (38, CAST(67 AS Numeric(18, 0)), N'LEMON LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (39, CAST(68 AS Numeric(18, 0)), N'LEMON SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (40, CAST(70 AS Numeric(18, 0)), N'NSL')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (41, CAST(71 AS Numeric(18, 0)), N'NSL LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (42, CAST(72 AS Numeric(18, 0)), N'NSL SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (43, CAST(80 AS Numeric(18, 0)), N'BUFF')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (44, CAST(81 AS Numeric(18, 0)), N'BUFF LG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (45, CAST(82 AS Numeric(18, 0)), N'BUFF SG')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (46, CAST(85 AS Numeric(18, 0)), N'DEFAULT')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (47, CAST(87 AS Numeric(18, 0)), N'DEFAULT')
INSERT [dbo].[TBL_COLORMASTER] ([C_ID], [C_CODE], [C_COLOR]) VALUES (48, CAST(88 AS Numeric(18, 0)), N'DEFAULT')
SET IDENTITY_INSERT [dbo].[TBL_COLORMASTER] OFF
SET IDENTITY_INSERT [dbo].[TBL_GSMMASTER] ON 

INSERT [dbo].[TBL_GSMMASTER] ([GSM_ID], [GSM_MCNO], [GSM_FROM], [GSM_TO]) VALUES (1, 1, 70, 300)
INSERT [dbo].[TBL_GSMMASTER] ([GSM_ID], [GSM_MCNO], [GSM_FROM], [GSM_TO]) VALUES (2, 2, 75, 300)
INSERT [dbo].[TBL_GSMMASTER] ([GSM_ID], [GSM_MCNO], [GSM_FROM], [GSM_TO]) VALUES (3, 3, 54, 90)
INSERT [dbo].[TBL_GSMMASTER] ([GSM_ID], [GSM_MCNO], [GSM_FROM], [GSM_TO]) VALUES (4, 4, 140, 600)
INSERT [dbo].[TBL_GSMMASTER] ([GSM_ID], [GSM_MCNO], [GSM_FROM], [GSM_TO]) VALUES (5, 5, 140, 600)
SET IDENTITY_INSERT [dbo].[TBL_GSMMASTER] OFF
SET IDENTITY_INSERT [dbo].[TBL_LOCATIONS] ON 

INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (1, N'LINE 1', N'LINE 1', N'1', CAST(0x0000AAE2009F4A01 AS DateTime))
INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (2, N'LINE 2', N'LINE 2', N'2', CAST(0x0000AAE2009F636F AS DateTime))
SET IDENTITY_INSERT [dbo].[TBL_LOCATIONS] OFF
SET IDENTITY_INSERT [dbo].[TBL_PRODUCTIONORDER] ON 

INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(1 AS Numeric(18, 0)), N'1148836', N'AZURE LAID', N'80', N'43 X 69', CAST(0x0000AAD600AC9CD7 AS DateTime), CAST(1 AS Numeric(18, 0)), N'By Win Service', N'0', N'', N'', N'MARKET', N'', CAST(40 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(2 AS Numeric(18, 0)), N'E1046096', N'MICR CHEQUE PAPER', N'95', N'26.7', CAST(0x0000AAD600AC9CD8 AS DateTime), CAST(1 AS Numeric(18, 0)), N'By Win Service', N'1521', N'Shipping Marks :MADE IN INDIA', N'E', N'MICR', N'', CAST(10 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(3 AS Numeric(18, 0)), N'HD1046102', N'WESCO MICR', N'95', N'43.5', CAST(0x0000AAD600AC9CD8 AS DateTime), CAST(1 AS Numeric(18, 0)), N'By Win Service', N'7203', N'', N'HD', N'MICR', N'', CAST(28 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(4 AS Numeric(18, 0)), N'UB1046098', N'WESCO MICR', N'95', N'43.5', CAST(0x0000AAD600AC9CD9 AS DateTime), CAST(1 AS Numeric(18, 0)), N'By Win Service', N'7203', N'', N'UB', N'MICR', N'', CAST(95 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(5 AS Numeric(18, 0)), N'IDB1045344', N'WESCO MICR', N'95', N'23', CAST(0x0000AAD600AC9CDA AS DateTime), CAST(1 AS Numeric(18, 0)), N'By Win Service', N'7203', N'', N'IDB', N'MICR', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(6 AS Numeric(18, 0)), N'1046188', N'WESCO PARCHMENT', N'105', N'25.4', CAST(0x0000AAD600AC9CDA AS DateTime), CAST(1 AS Numeric(18, 0)), N'By Win Service', N'7201', N'', N'', N'MARKET', N'', CAST(5 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(7 AS Numeric(18, 0)), N'E2033635', N'MANILA BOARD', N'160', N'76', CAST(0x0000AAD600AC9CDB AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'4332', N'Shipping Marks :MADE IN INDIA', N'E', N'MARKET', N'LPINK', CAST(9 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(8 AS Numeric(18, 0)), N'ENV2032529', N'WESCO MF BUFF', N'100', N'106.5', CAST(0x0000AAD600AC9CDC AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'8205', N'', N'ENV', N'MARKET', N'', CAST(1 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(9 AS Numeric(18, 0)), N'2034468', N'WESCO COLOUR POSTER', N'90', N'46', CAST(0x0000AAD600AC9CDD AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'8201', N'', N'', N'MARKET', N'YELLOW', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(10 AS Numeric(18, 0)), N'2020278', N'SUD NATURAL GREETING', N'90', N'56', CAST(0x0000AAD600AC9CDD AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'1548', N'', N'', N'MARKET', N'NSL', CAST(3 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(11 AS Numeric(18, 0)), N'2020278', N'SUD NATURAL GREETING', N'90', N'58.5', CAST(0x0000AAD600AC9CDE AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'1548', N'', N'', N'MARKET', N'NSL', CAST(3 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(12 AS Numeric(18, 0)), N'2020278', N'SUD NATURAL GREETING', N'90', N'86.5', CAST(0x0000AAD600AC9CDF AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'1548', N'', N'', N'MARKET', N'NSL', CAST(3 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(13 AS Numeric(18, 0)), N'SUN3044098', N'WESCO INDIGO CLASSIC', N'57', N'33', CAST(0x0000AAD600AC9CDF AS DateTime), CAST(3 AS Numeric(18, 0)), N'By Win Service', N'3203', N'', N'SUN', N'MARKET', N'', CAST(6 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(14 AS Numeric(18, 0)), N'3044821', N'WESCO PRINTEX NS', N'58', N'154.5', CAST(0x0000AAD600AC9CE0 AS DateTime), CAST(3 AS Numeric(18, 0)), N'By Win Service', N'3213', N'', N'', N'MARKET', N'', CAST(10 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(15 AS Numeric(18, 0)), N'3146934', N'WESCO INDIGO CLASSIC', N'60', N'45.5 X 58.5', CAST(0x0000AAD600AC9CE0 AS DateTime), CAST(3 AS Numeric(18, 0)), N'By Win Service', N'3203', N'', N'', N'MARKET', N'', CAST(10 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(16 AS Numeric(18, 0)), N'BC3041171', N'AZURE WOVE', N'60', N'39', CAST(0x0000AAD600AC9CE1 AS DateTime), CAST(3 AS Numeric(18, 0)), N'By Win Service', N'1300', N'', N'BC', N'BC', N'', CAST(14 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(17 AS Numeric(18, 0)), N'DC2158799', N'WESCO COLOUR POSTER', N'110', N'56 X 71', CAST(0x0000AAD600AC9CE2 AS DateTime), CAST(2 AS Numeric(18, 0)), N'By Win Service', N'8201', N'', N'DC', N'DC', N'GREEN', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(18 AS Numeric(18, 0)), N'4041336', N'WESCO PRIME', N'160', N'73.5', CAST(0x0000AAD600AC9CE2 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'FOR EXPORT', N'', N'MARKET', N'', CAST(3 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(19 AS Numeric(18, 0)), N'4041341', N'WESCO BASE', N'150', N'120', CAST(0x0000AAD600AC9CE3 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4495', N'', N'', N'MARKET', N'', CAST(25 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(20 AS Numeric(18, 0)), N'EVE5022428', N'DUP BD DLX KFT BK', N'550', N'89', CAST(0x0000AAD600AC9CE3 AS DateTime), CAST(5 AS Numeric(18, 0)), N'By Win Service', N'4008', N'', N'EVE', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(21 AS Numeric(18, 0)), N'EVE5022428', N'DUP BD DLX KFT BK', N'550', N'78', CAST(0x0000AAD600AC9CE4 AS DateTime), CAST(5 AS Numeric(18, 0)), N'By Win Service', N'4008', N'', N'EVE', N'MARKET', N'', CAST(3 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(22 AS Numeric(18, 0)), N'DC4142855', N'DUP BD COATED SUPER', N'296', N'63.5 X 76', CAST(0x0000AAD600AC9CE5 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4068', N'', N'DC', N'DC', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(23 AS Numeric(18, 0)), N'4041346', N'WESCO PRIME', N'230', N'68', CAST(0x0000AAD600AC9CE5 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'', N'', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(24 AS Numeric(18, 0)), N'4041346', N'WESCO PRIME', N'230', N'84', CAST(0x0000AAD600AC9CE6 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'', N'', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(25 AS Numeric(18, 0)), N'4041346', N'WESCO PRIME', N'230', N'88', CAST(0x0000AAD600AC9CE6 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'', N'', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(26 AS Numeric(18, 0)), N'4041347', N'WESCO PRIME', N'230', N'69', CAST(0x0000AAD600AC9CE7 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'Shipping Marks :MADE IN INDIA', N'', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(27 AS Numeric(18, 0)), N'4041347', N'WESCO PRIME', N'230', N'84', CAST(0x0000AAD600AC9CE9 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'Shipping Marks :MADE IN INDIA', N'', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(28 AS Numeric(18, 0)), N'4041347', N'WESCO PRIME', N'230', N'89', CAST(0x0000AAD600AC9CE9 AS DateTime), CAST(4 AS Numeric(18, 0)), N'By Win Service', N'4490', N'Shipping Marks :MADE IN INDIA', N'', N'MARKET', N'', CAST(2 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(29 AS Numeric(18, 0)), N'123456', N'SUD PARCH PAPER NS', N'80', N'56', CAST(0x0000AAD600B69DC9 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'1200', N'', N'E', N'MARKET', N'WHITE', CAST(300 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(30 AS Numeric(18, 0)), N'1234561', N'SUD LEGAL PAPER', N'80', N'12', CAST(0x0000AAD800E9C92C AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'1220', N'qwqw', N'E', N'MARKET', N'DEFAULT', CAST(300 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(31 AS Numeric(18, 0)), N'121212a', N'SUD CARTRIDGE SS', N'80', N'12', CAST(0x0000AAD800E9F3EB AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'1221', N'qwqw', N'E', N'MARKET', N'DEFAULT', CAST(300 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(32 AS Numeric(18, 0)), N'121212b', N'SUD LEGAL PAPER', N'80', N'12', CAST(0x0000AAD800EA0A83 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'1220', N'qwqw', N'E', N'MARKET', N'DEFAULT', CAST(300 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(33 AS Numeric(18, 0)), N'sbi12345', N'SSS MAPLITHO - LIC', N'71', N'12', CAST(0x0000AAE300A587D2 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'4111', N'', N'', N'MARKET', N'', CAST(22 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(34 AS Numeric(18, 0)), N'hdfc1212121212', N'SSS MAPLITHO - LIC', N'71', N'12', CAST(0x0000AAE300AAE6BC AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'4111', N'', N'hdfc', N'MARKET', N'DEFAULT', CAST(22 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(35 AS Numeric(18, 0)), N'HDFC34343434', N'SSS MAPLITHO WHITE HB', N'89', N'12', CAST(0x0000AAE300AB8DAE AS DateTime), CAST(3 AS Numeric(18, 0)), N'ADMIN', N'1221', N'', N'hdfc', N'MARKET', N'', CAST(55 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(36 AS Numeric(18, 0)), N'E12', N'SSS MAPLITHO - LIC', N'70', N'45x70', CAST(0x0000AAE600AE71B2 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', N'1220', N'', N'E', N'MARKET', N'', CAST(100 AS Numeric(18, 0)))
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_SIZE], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_USER], [PO_QULAITYCODE], [PO_REMARKS], [PO_LOTPREFIX], [PO_TYPE], [PO_COLOURGRAIN], [PO_ORDEREDQTY]) VALUES (CAST(37 AS Numeric(18, 0)), N'20989766', N'SUD LEGAL PAPER', N'80', N'45X76', CAST(0x0000AAE600AEFBEE AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', N'1220', N'', N'', N'MARKET', N'DEFAULT', CAST(40 AS Numeric(18, 0)))
SET IDENTITY_INSERT [dbo].[TBL_PRODUCTIONORDER] OFF
SET IDENTITY_INSERT [dbo].[TBL_QCCODEMASTER] ON 

INSERT [dbo].[TBL_QCCODEMASTER] ([MATER_ID], [MASTER_QCCODE]) VALUES (1, N'11112')
SET IDENTITY_INSERT [dbo].[TBL_QCCODEMASTER] OFF
SET IDENTITY_INSERT [dbo].[TBL_QCMASTER] ON 

INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (1, 1, 1200, N'AZURE LAID', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (2, 1, 1201, N'AZURELAID YS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (3, 1, 1204, N'WESCO LEDGER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (4, 1, 1220, N'AZURELAID TSAD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (5, 1, 1221, N'SUD LEGAL PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (6, 1, 1415, N'ICR/OCR PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (7, 1, 1499, N'RAILWAY BOND PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (8, 1, 1500, N'SUD CARTRIDGE DELUXE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (9, 1, 1510, N'SUD CARTRIDGE SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (10, 1, 1515, N'SUD.CHEQUE PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (11, 1, 1516, N'SUD.MICR CHQ.PAPER', N'MICR')
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (12, 1, 1521, N'MICR CHEQUE PAPER', N'MICR')
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (13, 1, 1530, N'SUD.PARCH.PAP.WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (14, 1, 1532, N'SUD PARCH PAPER NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (15, 1, 1547, N'COPIER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (16, 1, 1554, N'SUD ROYAL EXE PTG', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (17, 1, 1559, N'LEGEND COPIER FS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (18, 1, 1568, N'SUD.GREETINGS NSL HB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (19, 1, 1570, N'SUD MICR CHQ PAPER (W)', N'MICR')
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (20, 1, 1571, N'SUD MICR CHQ PAPER (WCTS)', N'MICR')
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (21, 1, 1998, N'MISC PRINTING PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (22, 1, 1999, N'MISC MF REELS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (23, 1, 2103, N'M.L.PTG BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (24, 1, 2126, N'SSS MAPLITHO - LIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (25, 1, 2130, N'SS MAPLITHO CLASSIC NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (26, 1, 2132, N'MLPTG DLX PUNCH CARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (27, 1, 2135, N'M.L.PTG DELX', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (28, 1, 2136, N'ML PTG DELX NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (29, 1, 2147, N'PLAIN PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (30, 1, 2148, N'PLAIN PAPER S/S', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (31, 1, 2157, N'MAPLITHO PTG WH SH', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (32, 1, 2158, N'SUD.EXCLUSIVE ML PPR', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (33, 1, 2168, N'SURFACE SIZED MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (34, 1, 2173, N'SSS MAPLITHO WHITE HB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (35, 1, 2174, N'SSS MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (36, 1, 2176, N'S S MAPLITHO CLASSIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (37, 1, 2177, N'SS MAPLITHO CLASSIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (38, 1, 2179, N'MAPLITHO COVER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (39, 1, 2182, N'N.S.SSS MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (40, 1, 2185, N'PAPER PRINTING S.S.MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (41, 1, 2189, N'SUD ULTRA SHINE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (42, 1, 2190, N'SS MAPLITHO CLASSIC PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (43, 1, 2191, N'SUD ULTRA SHINE MAP.', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (44, 1, 2198, N'ML PTG BASE HIGH BRIGHT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (45, 1, 2199, N'PLAIN PAPERS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (46, 1, 2215, N'WRITING PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (47, 1, 2237, N'VERICOLOUR PIGMENT COATED PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (48, 1, 2239, N'SS MAPLITHO W/F PTG PAPER(CLASSIC)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (49, 1, 2241, N'MAPLITHO PRINTING DELUXE (HS)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (50, 1, 2950, N'M F COVER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (51, 1, 2958, N'HQ POSTER HL-1', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (52, 1, 2965, N'MF COVER PPR TDL', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (53, 1, 2970, N'MF COVER PPR NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (54, 1, 2973, N'MF COVER PAPER BASE/NS/NSL (RF)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (55, 1, 2978, N'MF COVER PAPER BASE HIGH BRIGHT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (56, 1, 4100, N'MF WH.PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (57, 1, 4102, N'BUFF PULP BD SUP FIN', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (58, 1, 4103, N'MFW PULP BD BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (59, 1, 4111, N'MF PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (60, 1, 4115, N'MF WH P BD BASE HIGH BRIGHT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (61, 1, 4123, N'SS PULP BOARD UHB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (62, 1, 4135, N'MF WH PULP BOARD HL', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (63, 1, 4332, N'MANILA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (64, 1, 4510, N'MANILLA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (65, 1, 4511, N'MF BUFF PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (66, 1, 4516, N'PAPER BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (67, 1, 4531, N'DRAWING SHEETS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (68, 1, 7201, N'WESCO PARCHMENT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (69, 1, 7202, N'WESCO CHEQUE PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (70, 1, 7203, N'WESCO MICR', N'MICR')
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (71, 1, 7301, N'WESCO MARVEL WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (72, 1, 7302, N'WESCO MARVEL NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (73, 1, 7303, N'WESCO PUNCH CARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (74, 1, 7304, N'WESCO EXCLUSIVE ML', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (75, 1, 7305, N'WESCO CARTRIDGE DLX', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (76, 1, 7306, N'WESCO CATRIDGE DLX (NSL)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (77, 1, 7307, N'WHITE MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (78, 1, 7309, N'WESCO FILE BOARD BUFF (NSS)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (79, 1, 7352, N'WESCO FILE BOARD ECO BUFF NONSS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (80, 1, 7501, N'WESCO CLASSIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (81, 1, 7502, N'WESCO ULTRASHINE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (82, 1, 7503, N'WESCO CARTRIDGE  SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (83, 1, 7504, N'WESCO UHB  BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (84, 1, 7505, N'WESCO CARTRIDGE SS LS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (85, 1, 7506, N'WESCO CARTRIDGE SS NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (86, 1, 7507, N'WESCO COVER PAPER (HSFB)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (87, 1, 7508, N'WESCO FILE BOARD BUFF (SS)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (88, 1, 7510, N'WESCO WHITE FILE BOARD (SS)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (89, 1, 7512, N'WESCO UHB BS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (90, 1, 7513, N'WESCO UHB AS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (91, 1, 7514, N'WESCO SUPER PRINTING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (92, 1, 7515, N'WESCO FILE BOARD ECO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (93, 1, 7517, N'WESCO UHB BOARD PC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (94, 1, 7518, N'WESCO CLASSIC GREEN', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (95, 1, 7521, N'WESCO CLASSIC SUPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (96, 1, 7522, N'WESCO CLASSIC1', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (97, 1, 7525, N'WESCO SUPERSHINE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (98, 1, 7530, N'WESCO DURAPRINT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (99, 1, 7531, N'WESCO CLASSIC NS LS', NULL)
GO
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (100, 1, 7551, N'WESCO FILE BOARD ECO WHITE SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (101, 1, 7560, N'WESCO STRAW BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (102, 1, 7561, N'WESCO STRAW FOLD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (103, 1, 7577, N'WESCO BOND', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (104, 1, 7578, N'WESCO BOND FS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (105, 1, 7701, N'WESCO COAT BASE WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (106, 1, 7702, N'WESCO COAT  BASE NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (107, 1, 7901, N'WESCO STIFFENER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (108, 1, 7906, N'WESCO CB BASE ECO MF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (109, 1, 7910, N'WESCO WALLKUP', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (110, 1, 7920, N'WESCO AQUABASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (111, 2, 1499, N'RAILWAY BOND PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (112, 2, 1501, N'SUD CARTRIDGE DLX', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (113, 2, 1548, N'SUD NATURAL GREETING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (114, 2, 1550, N'SUDARSHAN GREETING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (115, 2, 1568, N'SUD.GREETINGS NSL HB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (116, 2, 1569, N'MG LEMON GREETING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (117, 2, 2700, N'MG WH.POSTER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (118, 2, 2702, N'MG WHITE POSTER BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (119, 2, 2705, N'MG WH POSTER NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (120, 2, 2707, N'WESCO COATING BASE  PAPER NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (121, 2, 2710, N'MF POSTER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (122, 2, 2711, N'MG WH POSTER JS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (123, 2, 2712, N'MF WHITE POSTER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (124, 2, 2800, N'MG COLOR POSTER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (125, 2, 2802, N'MG SEA GREEN POSTER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (126, 2, 2803, N'COLOURED PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (127, 2, 2941, N'MF BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (128, 2, 2950, N'M F COVER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (129, 2, 2958, N'HQ POSTER HL-1', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (130, 2, 2959, N'STIFFNER BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (131, 2, 2987, N'MG CVR MANILA PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (132, 2, 2988, N'MG COV MANILA PPR', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (133, 2, 2989, N'MG COVER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (134, 2, 2990, N'MG WH COVER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (135, 2, 2993, N'MG WHITE COVER PAPER (MSIX)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (136, 2, 2997, N'M G (MACH. GLZD) WITH M.W.MARK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (137, 2, 2999, N'MISC MG REELS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (138, 2, 4100, N'MF WH.PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (139, 2, 4107, N'MF COL PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (140, 2, 4111, N'MF PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (141, 2, 4112, N'MG WH PULP BD (JH)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (142, 2, 4114, N'BUFF PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (143, 2, 4135, N'MF WH PULP BOARD HL', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (144, 2, 4300, N'MG WH PULP BD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (145, 2, 4301, N'MG WH PULP BOARD BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (146, 2, 4306, N'WHITE PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (147, 2, 4307, N'MG WH PULP BD(PGF)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (148, 2, 4309, N'MGW PULP WOOD CVR PPR', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (149, 2, 4310, N'PULP BOARD (CUP STOCK)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (150, 2, 4315, N'MG WH.PULP BD.NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (151, 2, 4320, N'MG COL PULP BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (152, 2, 4332, N'MANILA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (153, 2, 4333, N'COLOUR PRINTING BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (154, 2, 4510, N'MANILLA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (155, 2, 4516, N'PAPER BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (156, 2, 4519, N'MG MANILA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (157, 2, 4521, N'COL PTG PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (158, 2, 4524, N'COL.MANILA BD.', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (159, 2, 4526, N'WHITE MF MANILA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (160, 2, 4527, N'PAPER MANILA BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (161, 2, 4530, N'PAPER BOARD MANILA', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (162, 2, 4531, N'DRAWING SHEETS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (163, 2, 4532, N'MF COVER PAPER (C)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (164, 2, 8100, N'WESCO POSTER WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (165, 2, 8101, N'WESCO POSTER NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (166, 2, 8102, N'WESCO POSTER JS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (167, 2, 8103, N'WESCO COVER PAPER WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (168, 2, 8104, N'WESCO PULP BOARD WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (169, 2, 8105, N'WESCO PULP BOARD NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (170, 2, 8111, N'WESCO CARTRIDGE DLX WHT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (171, 2, 8200, N'WESCO POSTER BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (172, 2, 8201, N'WESCO COLOUR POSTER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (173, 2, 8202, N'WESCO PULP BOARD BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (174, 2, 8203, N'WESCO COLOUR BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (175, 2, 8205, N'WESCO MF BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (176, 2, 8207, N'WESCO MF COL POSTER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (177, 2, 8208, N'WESCO MF COLOUR BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (178, 2, 8212, N'WESCO MANILA BOARD MF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (179, 2, 8300, N'WESCO COATING BASE NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (180, 2, 8400, N'WESCO NATURAL GREETING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (181, 2, 8411, N'WESCO CARTRIDGE DLX NSL', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (182, 2, 8412, N'WESCO CARTRIDGE DLX LS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (183, 2, 8500, N'WESCO STIFFENER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (184, 2, 8501, N'WESCO STIFFENER IVORY', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (185, 2, 8502, N'WESCO CB STIFFNER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (186, 2, 8503, N'WESCO CB BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (187, 2, 8504, N'WESCO ULTRA', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (188, 2, 8505, N'WESCO EXCEL MF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (189, 2, 8506, N'WESCO CB BASE ECO MG', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (190, 2, 8507, N'WESCO STIFFENER ECO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (191, 2, 8510, N'WESCO WALLKUP MG', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (192, 2, 8511, N'WESCO WALLKUP MF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (193, 2, 8520, N'WESCO AQUABASE MG', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (194, 2, 8601, N'WESCO CB BASE BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (195, 2, 8602, N'WESCO EXCEL MF BUFF', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (196, 3, 1300, N'AZURE WOVE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (197, 3, 1301, N'AZUREWOVE SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (198, 3, 1402, N'CREAM WOVE (SW)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (199, 3, 1403, N'SUD COPY BOOK PAPER', NULL)
GO
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (200, 3, 1404, N'COPY BOOK PAPER (NON SS)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (201, 3, 1405, N'COLOUR WOVE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (202, 3, 1406, N'WESCOMPRINT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (203, 3, 1490, N'OFFICE DEPOT COPIER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (204, 3, 1491, N'MULTIPURPOSE STATIONERY PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (205, 3, 1492, N'WESCO MULTI PURPOSE OFFICE PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (206, 3, 1504, N'SUD SUPER PRINT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (207, 3, 1506, N'SUPER PRINTING PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (208, 3, 1536, N'SUD DLX COPIER CS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (209, 3, 1540, N'SUD SS COPIER(FS)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (210, 3, 1542, N'SUD. ECO COPIER CS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (211, 3, 1543, N'SUD DLX COPIER FS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (212, 3, 1547, N'COPIER PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (213, 3, 1549, N'LEGEND COPIER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (214, 3, 1551, N'COPIER PAPER NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (215, 3, 1552, N'ML HIGH BRIGHT CG', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (216, 3, 1554, N'SUD ROYAL EXE PTG', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (217, 3, 1558, N'B2B COPIER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (218, 3, 1559, N'LEGEND COPIER FS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (219, 3, 1565, N'SUD SS COPIER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (220, 3, 1567, N'SUD MAP PTG HIGH BRIGHT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (221, 3, 1999, N'MISC MF REELS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (222, 3, 2099, N'MAPLITHO PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (223, 3, 2102, N'PRINTING PAPER(SUPER)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (224, 3, 2103, N'M.L.PTG BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (225, 3, 2104, N'MAPLITHO PRINTING DELUXE (BUFF)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (226, 3, 2105, N'ML PTG DLX (SW)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (227, 3, 2125, N'M.L.PTG.SSS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (228, 3, 2126, N'SSS MAPLITHO - LIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (229, 3, 2130, N'SS MAPLITHO CLASSIC NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (230, 3, 2135, N'M.L.PTG DELX', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (231, 3, 2136, N'ML PTG DELX NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (232, 3, 2146, N'MLP.DX(SW)WOOD FREE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (233, 3, 2147, N'PLAIN PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (234, 3, 2157, N'MAPLITHO PTG WH SH', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (235, 3, 2158, N'SUD.EXCLUSIVE ML PPR', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (236, 3, 2169, N'SURFACE SIZED MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (237, 3, 2173, N'SSS MAPLITHO WHITE HB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (238, 3, 2174, N'SSS MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (239, 3, 2177, N'SS MAPLITHO CLASSIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (240, 3, 2178, N'SS MAPLITHO B W', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (241, 3, 2181, N'PLAIN PAPER CHAMOIS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (242, 3, 2182, N'N.S.SSS MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (243, 3, 2183, N'MAPLITHO SSS NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (244, 3, 2184, N'PAPER PRINTING (SUPER) WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (245, 3, 2185, N'PAPER PRINTING S.S.MAPLITHO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (246, 3, 2187, N'ML PTG DLX PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (247, 3, 2191, N'SUD ULTRA SHINE MAP.', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (248, 3, 2192, N'BUDGET COPIER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (249, 3, 2193, N'MAPLITHO DELUXE WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (250, 3, 2194, N'MAPLITHO DELUXE PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (251, 3, 2196, N'DELUX MAPLITO PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (252, 3, 2197, N'SSS MAPLITHO DLX PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (253, 3, 2198, N'ML PTG BASE HIGH BRIGHT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (254, 3, 2199, N'PLAIN PAPERS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (255, 3, 2200, N'BUDGET COPIER SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (256, 3, 2204, N'MAP PTG. DLX(SW)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (257, 3, 2215, N'WRITING PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (258, 3, 2232, N'SS MAPLITHO W/F PTG.PAPER (C/W)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (259, 3, 2233, N'ML PTG DLX (AN)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (260, 3, 2234, N'MAPLITHO WHITE TINT PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (261, 3, 2235, N'MAPLITHO GREEN TINT PAPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (262, 3, 2236, N'MAPLITHO PTG.DLX NSL (HB)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (263, 3, 2238, N'SS MAPLITHO W/F PTG PAPER (DLX)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (264, 3, 2239, N'SS MAPLITHO W/F PTG PAPER(CLASSIC)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (265, 3, 2240, N'NOVA PRINT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (266, 3, 2660, N'SUD DLX MAPLITHO (HB)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (267, 3, 2955, N'MF COVER PPR HL', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (268, 3, 3101, N'WESCO IMPRESSION', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (269, 3, 3102, N'WESCO DLX WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (270, 3, 3103, N'WESCO DLX NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (271, 3, 3104, N'WESCO NOVA PRINT NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (272, 3, 3105, N'WESCO NOVA PRINT WHITE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (273, 3, 3106, N'WESCO SSS MAPLITHO WHITE HB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (274, 3, 3107, N'WESCO SAPPHIRE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (275, 3, 3108, N'WESCO DLX WHITE BT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (276, 3, 3109, N'WESCO INDIGO', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (277, 3, 3111, N'WESCO IMPRESSION - S', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (278, 3, 3112, N'WESCO DURA DELUXE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (279, 3, 3200, N'WESCO VIBRANT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (280, 3, 3201, N'WESCO ULTRA SHINE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (281, 3, 3202, N'WESCO VIBRANT (HB)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (282, 3, 3203, N'WESCO INDIGO CLASSIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (283, 3, 3204, N'WESCO IMPRESSION CLASSIC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (284, 3, 3205, N'WESCO NATURAL SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (285, 3, 3206, N'WESCO ARSR SS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (286, 3, 3207, N'WESCO WAX COTE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (287, 3, 3212, N'WESCO PRINTEX V', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (288, 3, 3213, N'WESCO PRINTEX NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (289, 3, 3225, N'WESCO SUPERSHINE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (290, 3, 3230, N'WESCO SILK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (291, 3, 3300, N'WESCO COATING BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (292, 3, 3400, N'WESCO COVER ARSR', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (293, 3, 3558, N'WESCO DOCUMATE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (294, 3, 8181, N'WESCO GLOBAL PRINT', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (295, 4, 7, N'', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (296, 4, 4001, N'DUPLEX BD LWC KRFTBK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (297, 4, 4002, N'MISC DUP REELS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (298, 4, 4004, N'FOLDING BOX BD GRY BK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (299, 4, 4011, N'COATED PPR BD SUPER', NULL)
GO
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (300, 4, 4015, N'SUD COATED BD HWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (301, 4, 4016, N'DUP BD COATED MBB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (302, 4, 4017, N'SUD COATED BD NS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (303, 4, 4018, N'COATED PAPER BD LC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (304, 4, 4019, N'SUDARSHAN COATED BOARD PREMIUM', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (305, 4, 4020, N'SUD ULTRA WH CTD BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (306, 4, 4021, N'SUDARSHAN ULTRAWHITE PREMIUM BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (307, 4, 4043, N'DUP.BD LWC R', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (308, 4, 4055, N'DUPLEX BOARD COATED', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (309, 4, 4056, N'DUP BOARD COATED X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (310, 4, 4058, N'COATED DUPLEX BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (311, 4, 4065, N'FOLDING BOX BD WH BACK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (312, 4, 4068, N'DUP BD COATED SUPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (313, 4, 4069, N'DUP BD CTD SUPER X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (314, 4, 4070, N'DUP BD WHITE BACK HWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (315, 4, 4071, N'DUP BD WH BK HWC X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (316, 4, 4072, N'DUP BD WHITE BACK R', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (317, 4, 4073, N'DUP BD WHITE BACK LWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (318, 4, 4076, N'DUP BD CTD SUPER H/L', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (319, 4, 4077, N'COATED PAPER BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (320, 4, 4078, N'DUP BD WH BK LWC X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (321, 4, 4079, N'COATED PAPER BOARD (WHITE BACK)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (322, 4, 4083, N'CTD PPR BD WBK LWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (323, 4, 4084, N'D BD CTD SUP HI GLOSS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (324, 4, 4085, N'SUD COATED F.B.BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (325, 4, 4088, N'ONE SIDE CTD. DUP BD. (SUPER)', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (326, 4, 4089, N'SUDHARSHAN COATED SBS BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (327, 4, 4090, N'SUDHARSHAN CUP STOCK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (328, 4, 4092, N'ONE SIDE CTD DUP BD GRY BK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (329, 4, 4093, N'COATED DUPLEX BRD.(GREY BACK) SUPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (330, 4, 4094, N'COATED DUP.BRD.(GREY BACK) LWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (331, 4, 4095, N'WESCO CUP BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (332, 4, 4096, N'WESCO COATED CUP STOCK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (333, 4, 4099, N'MISC DUP BORAD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (334, 4, 4485, N'WESCO FOLDING BOX BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (335, 4, 4490, N'WESCO PRIME', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (336, 4, 4491, N'WESCO POLYPRIME', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (337, 4, 4492, N'WESCO BASE COATED', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (338, 4, 4494, N'WESCO PRIME PLUS', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (339, 4, 4495, N'WESCO BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (340, 4, 4496, N'WESCO COATED PRIME', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (341, 4, 4497, N'WESCO GREETING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (342, 4, 5400, N'ECF BLEACHED HARDWOOD PULP', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (343, 5, 4001, N'DUPLEX BD LWC KRFTBK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (344, 5, 4004, N'FOLDING BOX BD GRY BK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (345, 5, 4005, N'DUP BD LWC KFT BK X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (346, 5, 4006, N'CTD PPR BD KRAFT BK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (347, 5, 4007, N'DUP BD LWC KFT BK R', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (348, 5, 4008, N'DUP BD DLX KFT BK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (349, 5, 4009, N'DUP BD DLX KFT BK X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (350, 5, 4011, N'COATED PPR BD SUPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (351, 5, 4014, N'CTD DUP BOARD MBB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (352, 5, 4016, N'DUP BD COATED MBB', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (353, 5, 4018, N'COATED PAPER BD LC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (354, 5, 4022, N'DUPLEX BOARD DELUXE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (355, 5, 4023, N'DUPLEX BOARD DLX X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (356, 5, 4040, N'COATED PAPER BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (357, 5, 4042, N'DUPLEX BD LWC X', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (358, 5, 4043, N'DUP.BD LWC R', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (359, 5, 4048, N'COATED DUPLEX BOARD GREY BACK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (360, 5, 4053, N'COATED DUPLEX BD LWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (361, 5, 4063, N'DUP BD LWC WH BACK SUPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (362, 5, 4075, N'COATED PPR BD GREY BK', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (363, 5, 4083, N'CTD PPR BD WBK LWC', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (364, 5, 4091, N'ONE SIDE COATED DUPLEX BOARD', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (365, 5, 4097, N'WESCO BASE', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (366, 5, 5000, N'MILL WRAPPER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (367, 5, 5001, N'WESCO LINER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (368, 5, 5002, N'WESCO ECO LINER', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (369, 5, 5003, N'WESCO HB GREETING', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (370, 5, 5400, N'ECF BLEACHED HARDWOOD PULP', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (371, 5, 123456, N'qwerty', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (372, 22, 22, N'222', NULL)
INSERT [dbo].[TBL_QCMASTER] ([QCMASTER_ID], [QCMASTER_MCNO], [QCMASTER_QCCODE], [QCMASTER_DESCRIPTION], [QCMASTER_TYPE]) VALUES (373, 33, 0, N'', NULL)
SET IDENTITY_INSERT [dbo].[TBL_QCMASTER] OFF
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -1', N'REEL GENERATION', CAST(0x0000AAE600A9217A AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -1', N'REEL DELETED', CAST(0x0000AAE600A929DD AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -2', N'REEL GENERATION', CAST(0x0000AAE600A968CE AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -2', N'REEL DELETED', CAST(0x0000AAE600A97477 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -3', N'REEL GENERATION', CAST(0x0000AAE600A97A8D AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'REEL GENERATION', CAST(0x0000AAE600A98753 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'PRINT', CAST(0x0000AAE600AAF6E4 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'REPRINT', CAST(0x0000AAE600AAFD75 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'REPRINT', CAST(0x0000AAE600AAFE1D AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -4', N'REEL GENERATION', CAST(0x0000AAE600ACD562 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -4', N'PRINT', CAST(0x0000AAE600ACD9A0 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -4', N'REPRINT', CAST(0x0000AAE600ACE1FD AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -5', N'REEL GENERATION', CAST(0x0000AAE600ACF23C AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -5', N'PRINT', CAST(0x0000AAE600ACF632 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -5', N'REPRINT', CAST(0x0000AAE600ACFDBB AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -6', N'REEL GENERATION', CAST(0x0000AAE600AD2B0B AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -6', N'PRINT', CAST(0x0000AAE600AD3243 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-76-1', N'REEL GENERATION', CAST(0x0000AAE600AF79B7 AS DateTime), N'admin', N'2')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-76-2', N'REEL GENERATION', CAST(0x0000AAE600AF79BB AS DateTime), N'admin', N'2')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-76-2', N'PRINT', CAST(0x0000AAE600AF860A AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-76-2', N'REPRINT', CAST(0x0000AAE600AF924A AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-76-2', N'REEL DELETED', CAST(0x0000AAE600AFA6B0 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-76-3', N'REEL GENERATION', CAST(0x0000AAE600AFB6B5 AS DateTime), N'admin', N'2')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-2', N'REEL GENERATION', CAST(0x0000AAE600B1F0B4 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-2', N'PRINT', CAST(0x0000AAE600B1F7BE AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-2', N'REPRINT', CAST(0x0000AAE600B1F7DA AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-3', N'REEL GENERATION', CAST(0x0000AAE600B20BAE AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-3', N'PRINT', CAST(0x0000AAE600B2132D AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-4', N'REEL GENERATION', CAST(0x0000AAE600B21A6D AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-4', N'PRINT', CAST(0x0000AAE600B2231B AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'REEL GENERATION', CAST(0x0000AAE600B242BA AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'PRINT', CAST(0x0000AAE600B24BBC AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -7', N'REEL GENERATION', CAST(0x0000AAE600B8FF5E AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -7', N'PRINT', CAST(0x0000AAE600B90E42 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -7', N'WEIGHT CAPTURED', CAST(0x0000AAE600BC8370 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -7', N'FINAL LABEL PRINTED', CAST(0x0000AAE600BC8371 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -2', N'WEIGHT CAPTURED', CAST(0x0000AAE600BC9CD3 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -2', N'FINAL LABEL PRINTED', CAST(0x0000AAE600BC9CD5 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -4', N'WEIGHT CAPTURED', CAST(0x0000AAE600BCB937 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -4', N'FINAL LABEL PRINTED', CAST(0x0000AAE600BCB939 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'WEIGHT CAPTURED', CAST(0x0000AAE600BD10BD AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600BD10BE AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'WEIGHT CAPTURED', CAST(0x0000AAE600BD18A1 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600BD18A2 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'WEIGHT CAPTURED', CAST(0x0000AAE600BDCBF0 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600BDCBF1 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'WEIGHT CAPTURED', CAST(0x0000AAE600E2810D AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600E2810E AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'WEIGHT CAPTURED', CAST(0x0000AAE700A024B8 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE700A024B9 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'REPRINT', CAST(0x0000AAE600AB2602 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836- 69-1', N'REPRINT', CAST(0x0000AAE600AB3C83 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -3', N'PRINT', CAST(0x0000AAE600AB527D AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -3', N'REPRINT', CAST(0x0000AAE600AB5FC6 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -3', N'REPRINT', CAST(0x0000AAE600AB5FE0 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -6', N'REPRINT', CAST(0x0000AAE600AD3712 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-1', N'REEL GENERATION', CAST(0x0000AAE600AD628E AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-1', N'PRINT', CAST(0x0000AAE600AD67DF AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'IDB1045344-23-1', N'REPRINT', CAST(0x0000AAE600AD6E75 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'WEIGHT CAPTURED', CAST(0x0000AAE600E48284 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600E48285 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'WEIGHT CAPTURED', CAST(0x0000AAE600E52B54 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600E52B55 AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -1', N'WEIGHT CAPTURED', CAST(0x0000AAE600E5616A AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -1', N'FINAL LABEL PRINTED', CAST(0x0000AAE600E5616B AS DateTime), N'MANUAL', N'12345')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'20989766-45-1', N'REEL GENERATION', CAST(0x0000AAE600FDBCE1 AS DateTime), N'admin', N'2')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'REEL GENERATION', CAST(0x0000AAE600C25022 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'PRINT', CAST(0x0000AAE600C2AF75 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1148836-43 -1', N'FINAL LABEL RE PRINTED', CAST(0x0000AB2D00CCA4D3 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'FINAL LABEL RE PRINTED', CAST(0x0000AB2F00E91469 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'FINAL LABEL RE PRINTED', CAST(0x0000AB2F00EA4FA7 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'FINAL LABEL RE PRINTED', CAST(0x0000AB2F00EB5765 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'1046188-25.4-1', N'FINAL LABEL RE PRINTED', CAST(0x0000AB2F00FD9DDD AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'WEIGHT CAPTURED', CAST(0x0000AB2F00EEACD7 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-1', N'FINAL LABEL PRINTED', CAST(0x0000AB2F00EEACD7 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-2', N'REEL GENERATION', CAST(0x0000AB3100B94CE4 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-3', N'REEL GENERATION', CAST(0x0000AB3100B94CE5 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-4', N'REEL GENERATION', CAST(0x0000AB3100B94CE5 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-5', N'REEL GENERATION', CAST(0x0000AB3100B94CE6 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'E1046096-26.7-6', N'REEL GENERATION', CAST(0x0000AB3100B94CE6 AS DateTime), N'admin', N'1')
SET IDENTITY_INSERT [dbo].[TBL_REELS] ON 

INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(1 AS Numeric(18, 0)), N'1148836-43 -1', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', CAST(2.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', 200010, N'', N'200010', NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', CAST(0.500 AS Numeric(18, 3)), CAST(1.500 AS Numeric(18, 3)), CAST(0x0000AAE600E56169 AS DateTime), 0)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(2 AS Numeric(18, 0)), N'1148836-43 -2', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', CAST(20.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', 200002, N'', N'200002', NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', CAST(0.500 AS Numeric(18, 3)), CAST(19.500 AS Numeric(18, 3)), CAST(0x0000AAE600BC9CD1 AS DateTime), 0)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(3 AS Numeric(18, 0)), N'1148836-43 -3', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(3 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(4 AS Numeric(18, 0)), N'1148836- 69-1', N' 69', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(5 AS Numeric(18, 0)), N'admin', CAST(55.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', 200006, N'', N'200006', NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', CAST(1.100 AS Numeric(18, 3)), CAST(53.900 AS Numeric(18, 3)), CAST(0x0000AAE600BDCBED AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(5 AS Numeric(18, 0)), N'1148836-43 -4', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', CAST(20.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', 200003, N'', N'200003', NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', CAST(0.500 AS Numeric(18, 3)), CAST(19.500 AS Numeric(18, 3)), CAST(0x0000AAE600BCB934 AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(6 AS Numeric(18, 0)), N'1148836-43 -5', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(7 AS Numeric(18, 0)), N'1148836-43 -6', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(8 AS Numeric(18, 0)), N'IDB1045344-23-1', N'23', N'', N'IDB1045344', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'', NULL, NULL, CAST(2 AS Numeric(18, 0)), N'23', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(9 AS Numeric(18, 0)), N'20989766-76-1', N'76', N'', N'20989766', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(2 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'45X76', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(10 AS Numeric(18, 0)), N'20989766-76-2', N'76', N'', N'20989766', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', NULL, CAST(2 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'45X76', NULL, NULL, NULL, 0)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(11 AS Numeric(18, 0)), N'20989766-76-3', N'76', N'', N'20989766', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(2 AS Numeric(18, 0)), N'LABELLED', N'A', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'45X76', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(12 AS Numeric(18, 0)), N'IDB1045344-23-2', N'23', N'', N'IDB1045344', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(2 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'', NULL, NULL, CAST(2 AS Numeric(18, 0)), N'23', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(13 AS Numeric(18, 0)), N'IDB1045344-23-3', N'23', N'', N'IDB1045344', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'', NULL, NULL, CAST(2 AS Numeric(18, 0)), N'23', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(14 AS Numeric(18, 0)), N'IDB1045344-23-4', N'23', N'', N'IDB1045344', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MICR', NULL, N'', NULL, NULL, CAST(2 AS Numeric(18, 0)), N'23', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(15 AS Numeric(18, 0)), N'1046188-25.4-1', N'25.4', N'', N'1046188', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(0.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MARKET', 200004, N'', N'200004', NULL, CAST(5 AS Numeric(18, 0)), N'25.4', NULL, NULL, CAST(0x0000AAE600BD10BC AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(16 AS Numeric(18, 0)), N'1148836-43 -7', N'43 ', N'', N'1148836', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(25.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MARKET', 200001, N'', N'200001', NULL, CAST(40 AS Numeric(18, 0)), N'43 X 69', CAST(0.500 AS Numeric(18, 3)), CAST(24.500 AS Numeric(18, 3)), CAST(0x0000AAE600BC836F AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(17 AS Numeric(18, 0)), N'1046188-25.4-1', N'25.4', N'', N'1046188', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(0.100 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MARKET', 200005, N'', N'200005', N'REPROCESSED', NULL, NULL, NULL, NULL, CAST(0x0000AAE600BD18A0 AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(18 AS Numeric(18, 0)), N'E1046096-26.7-1', N'26.7', N'', N'E1046096', CAST(0x0000AAE600C2AF73 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(123.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', 900001, N'', N'G900001', NULL, CAST(10 AS Numeric(18, 0)), N'26.7', CAST(5.600 AS Numeric(18, 3)), CAST(117.400 AS Numeric(18, 3)), CAST(0x0000AB2F00EEACD7 AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(19 AS Numeric(18, 0)), N'1046188-25.4-1', N'25.4', N'', N'1046188', CAST(0x0000AAE600E28109 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(1000.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MARKET', 200007, N'', N'200007', N'REPROCESSED', NULL, NULL, NULL, NULL, CAST(0x0000AAE600E2810C AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(20 AS Numeric(18, 0)), N'1046188-25.4-1', N'25.4', N'', N'1046188', CAST(0x0000AAE600E4827D AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(1000.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MARKET', 200008, N'', N'200008', N'REPROCESSED', NULL, NULL, NULL, NULL, CAST(0x0000AAE600E48283 AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(21 AS Numeric(18, 0)), N'1046188-25.4-1', N'25.4', N'', N'1046188', CAST(0x0000AAE600E52B50 AS DateTime), CAST(1 AS Numeric(18, 0)), N'admin', CAST(2.000 AS Numeric(18, 3)), CAST(1 AS Numeric(18, 0)), N'PRINTED', N'A', N'MARKET', 200009, N'', N'200009', N'REPROCESSED', NULL, NULL, CAST(0.500 AS Numeric(18, 3)), CAST(1.500 AS Numeric(18, 3)), CAST(0x0000AAE600E52B53 AS DateTime), 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(22 AS Numeric(18, 0)), N'20989766-45-1', N'45', N'', N'20989766', CAST(0x0000AAE600FDBCDD AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(2 AS Numeric(18, 0)), N'LABELLED', N'B', N'MARKET', NULL, N'', NULL, NULL, CAST(40 AS Numeric(18, 0)), N'45X76', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(23 AS Numeric(18, 0)), N'E1046096-26.7-2', N'26.7', N'', N'E1046096', CAST(0x0000AB3100B94CE1 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'G', NULL, NULL, CAST(10 AS Numeric(18, 0)), N'26.7', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(24 AS Numeric(18, 0)), N'E1046096-26.7-3', N'26.7', N'', N'E1046096', CAST(0x0000AB3100B94CE5 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'G', NULL, NULL, CAST(10 AS Numeric(18, 0)), N'26.7', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(25 AS Numeric(18, 0)), N'E1046096-26.7-4', N'26.7', N'', N'E1046096', CAST(0x0000AB3100B94CE5 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'G', NULL, NULL, CAST(10 AS Numeric(18, 0)), N'26.7', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(26 AS Numeric(18, 0)), N'E1046096-26.7-5', N'26.7', N'', N'E1046096', CAST(0x0000AB3100B94CE6 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'G', NULL, NULL, CAST(10 AS Numeric(18, 0)), N'26.7', NULL, NULL, NULL, 1)
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_STATUS], [R_SHIFT], [R_TYPE], [R_REELSNO], [R_PREFIX], [R_REELSNOFORPRINT], [R_REPROCESS], [R_ORDEREDQTY], [R_ACTUALSIZE], [R_TAREWEIGHT], [R_NETWEIGHT], [R_WEIGHTCAPUREDTIME], [R_FLAGTODELETE]) VALUES (CAST(27 AS Numeric(18, 0)), N'E1046096-26.7-6', N'26.7', N'', N'E1046096', CAST(0x0000AB3100B94CE6 AS DateTime), CAST(0 AS Numeric(18, 0)), N'admin', NULL, CAST(1 AS Numeric(18, 0)), N'LABELLED', N'A', N'MICR', NULL, N'G', NULL, NULL, CAST(10 AS Numeric(18, 0)), N'26.7', NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[TBL_REELS] OFF
INSERT [dbo].[TBL_REELSERIALPREFIX] ([PREFIX]) VALUES (N'G')
SET IDENTITY_INSERT [dbo].[TBL_TAREWEIGHTMASTER] ON 

INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (1, 7, N'TARE WEIGHT STRETCH
', CAST(1.000 AS Numeric(18, 3)), CAST(40.499 AS Numeric(18, 3)), CAST(0.500 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (2, 7, N'TARE WEIGHT STRETCH
', CAST(40.500 AS Numeric(18, 3)), CAST(50.999 AS Numeric(18, 3)), CAST(1.000 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (3, 7, N'TARE WEIGHT STRETCH
', CAST(51.000 AS Numeric(18, 3)), CAST(68.999 AS Numeric(18, 3)), CAST(1.100 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (4, 7, N'TARE WEIGHT STRETCH
', CAST(69.000 AS Numeric(18, 3)), CAST(96.999 AS Numeric(18, 3)), CAST(1.200 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (5, 7, N'TARE WEIGHT STRETCH
', CAST(97.000 AS Numeric(18, 3)), CAST(140.999 AS Numeric(18, 3)), CAST(1.300 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (6, 7, N'TARE WEIGHT STRETCH
', CAST(141.000 AS Numeric(18, 3)), CAST(170.999 AS Numeric(18, 3)), CAST(1.400 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (7, 7, N'TARE WEIGHT STRETCH
', CAST(171.000 AS Numeric(18, 3)), CAST(200.999 AS Numeric(18, 3)), CAST(1.500 AS Numeric(18, 3)), N'MARKET')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (8, 8, N'TARE WEIGHT FOR DC
', CAST(1.000 AS Numeric(18, 3)), CAST(200.000 AS Numeric(18, 3)), CAST(0.200 AS Numeric(18, 3)), N'DC')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (9, 12, N'TARE WEIGHT MICR
', CAST(0.000 AS Numeric(18, 3)), CAST(30.499 AS Numeric(18, 3)), CAST(4.000 AS Numeric(18, 3)), N'MICR')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (10, 12, N'TARE WEIGHT MICR
', CAST(30.500 AS Numeric(18, 3)), CAST(50.999 AS Numeric(18, 3)), CAST(4.200 AS Numeric(18, 3)), N'MICR')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (11, 12, N'TARE WEIGHT MICR
', CAST(51.000 AS Numeric(18, 3)), CAST(68.999 AS Numeric(18, 3)), CAST(4.500 AS Numeric(18, 3)), N'MICR')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (12, 12, N'TARE WEIGHT MICR
', CAST(69.000 AS Numeric(18, 3)), CAST(96.999 AS Numeric(18, 3)), CAST(5.200 AS Numeric(18, 3)), N'MICR')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (13, 12, N'TARE WEIGHT MICR
', CAST(97.000 AS Numeric(18, 3)), CAST(140.500 AS Numeric(18, 3)), CAST(5.600 AS Numeric(18, 3)), N'MICR')
INSERT [dbo].[TBL_TAREWEIGHTMASTER] ([MASTERTWEIGHT_ID], [MASTERTWEIGHT_TARECODE], [MASTERTWEIGHT_DESCRIPTION], [MASTERTWEIGHT_REELSIZEFROM], [MASTERTWEIGHT_REELSIZETO], [MASTERTWEIGHT_TAREWEIGHT], [MASTERTWEIGHT_TYPE]) VALUES (14, 8, N'TARE WEIGHT FOR DC
', CAST(1.000 AS Numeric(18, 3)), CAST(200.000 AS Numeric(18, 3)), CAST(0.200 AS Numeric(18, 3)), N'BC')
SET IDENTITY_INSERT [dbo].[TBL_TAREWEIGHTMASTER] OFF
SET IDENTITY_INSERT [dbo].[TBLLOGIN] ON 

INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(1 AS Numeric(18, 0)), N'ADMIN', N'ADMIN', N'Admin', N'ADMIN', N'vsqhc09xGjU=', CAST(0x0000AAC600BD2E32 AS DateTime), 1, CAST(0x0000AB3100B921E4 AS DateTime), 1, CAST(0x0000AAC600C173B7 AS DateTime))
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(2 AS Numeric(18, 0)), N'1', N'1', N'FINISHING', N'1', N'M40FsP+6CcI=', CAST(0x0000AAC600BE035A AS DateTime), 0, CAST(0x0000AAC600BE0DE5 AS DateTime), 1, CAST(0x0000AAE100AE7CEB AS DateTime))
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(3 AS Numeric(18, 0)), N'11', N'111', N'FINISHING', N'11', N'YP0MnlUVM6M=', CAST(0x0000AACA009E72F9 AS DateTime), NULL, NULL, 1, CAST(0x0000AAD801121754 AS DateTime))
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(10003 AS Numeric(18, 0)), N'aa', N'aa', N'FINISHING', N'aa', N'XSU0gjfI4rk=', CAST(0x0000AAD5017E5BFF AS DateTime), NULL, NULL, 1, NULL)
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(10004 AS Numeric(18, 0)), N'7', N'7', N'FINISHING', N'7', N'SjS9ESxhlRg=', CAST(0x0000AAD501848C54 AS DateTime), 1, CAST(0x0000AAD501849511 AS DateTime), 1, NULL)
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(10005 AS Numeric(18, 0)), N'XYZ', N'12', N'CONVERSION', N'XX', N'hgysLqm3/Z0=', CAST(0x0000AAE600A12530 AS DateTime), NULL, NULL, 1, NULL)
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(10006 AS Numeric(18, 0)), N'ww', N'ww', N'CONVERSION', N'xxx', N'YP0MnlUVM6M=', CAST(0x0000AAE600A77249 AS DateTime), NULL, NULL, 1, CAST(0x0000AAE600A8A34D AS DateTime))
SET IDENTITY_INSERT [dbo].[TBLLOGIN] OFF
ALTER TABLE [dbo].[TBL_HISTORY] ADD  CONSTRAINT [DF_TBL_HISTORY_H_DATETIME]  DEFAULT (getdate()) FOR [H_DATETIME]
GO
ALTER TABLE [dbo].[TBL_LOCATIONS] ADD  CONSTRAINT [DF_TBL_LOCATIONS_LOCATIONDATE]  DEFAULT (getdate()) FOR [LOCATIONDATE]
GO
ALTER TABLE [dbo].[TBL_PRODUCTIONORDER] ADD  CONSTRAINT [DF_TBL_PURCHASEORDER_PO_INSERTEDTIME]  DEFAULT (getdate()) FOR [PO_INSERTEDTIME]
GO
ALTER TABLE [dbo].[TBL_REELHISTORY] ADD  CONSTRAINT [DF_TBL_REELHISTORY_RH_DATETIME]  DEFAULT (getdate()) FOR [RH_DATETIME]
GO
ALTER TABLE [dbo].[TBL_REELS] ADD  CONSTRAINT [DF_TBL_REELS_R_DATETIME]  DEFAULT (getdate()) FOR [R_DATETIME]
GO
ALTER TABLE [dbo].[TBL_REELS] ADD  CONSTRAINT [DF_TBL_REELS_R_NOOFPRINTS]  DEFAULT ((0)) FOR [R_NOOFPRINTS]
GO
ALTER TABLE [dbo].[TBL_REELS] ADD  CONSTRAINT [DF_TBL_REELS_R_FLAGTODELETE]  DEFAULT ((1)) FOR [R_FLAGTODELETE]
GO
ALTER TABLE [dbo].[TBLLOGIN] ADD  CONSTRAINT [DF_TBLLOGIN_CREATEDDATE]  DEFAULT (getdate()) FOR [CREATEDDATE]
GO
USE [master]
GO
ALTER DATABASE [dbWCPM] SET  READ_WRITE 
GO
