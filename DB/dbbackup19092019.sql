USE [master]
GO
/****** Object:  Database [dbWCPM]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_CREATECHILDREELS]    Script Date: 19-09-2019 11:27:43 ******/
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
	@PRODUCTIONORDER VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @cnt INT = 0;
	 DECLARE @UNIQUENUM VARCHAR(MAX)
	
WHILE @cnt < @NOOFREELS
BEGIN

 SET @UNIQUENUM=@LOTNUMBER+'-'+CONVERT(varchar(50), @cnt+1)
 IF NOT EXISTS(SELECT R_REELID FROM TBL_REELS WHERE R_REELID=@UNIQUENUM)
 BEGIN
 INSERT INTO TBL_REELS (R_REELID,R_SIZE,R_REMARKS,R_ROLLID,R_USERNAME,R_MACHINENUMBER,R_PRODUCTIONORDER) VALUES (@UNIQUENUM,@SIZE,'',@LOTNUMBER,@USER,@MACHINENUMBER,@PRODUCTIONORDER)
 INSERT INTO TBL_REELHISTORY(RH_REELID,RH_ACTION,RH_DATETIME,RH_USER,RH_LINE) VALUES (@UNIQUENUM,'REEL GENERATION',GETDATE(),@USER,
@MACHINENUMBER)

UPDATE  TBL_PRODUCTIONORDER  SET PO_STATUS='LABELLED' WHERE PO_ROLLID=@LOTNUMBER
UPDATE  TBL_REELS  SET R_STATUS='LABELLED' WHERE R_ROLLID=@LOTNUMBER
UPDATE TBL_REELS SET R_DATETIME=GETDATE(), R_USERNAME=@USER
 END
   SET @cnt = @cnt + 1;
END;
	
	SELECT * FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER
	DECLARE @POCOUNT INT;
	DECLARE @RCOUNT INT;
	SELECT @POCOUNT= COUNT(PO_ROLLID) FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID=@LOTNUMBER
	SELECT  @RCOUNT=  COUNT(DISTINCT R_ROLLID) FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER
	IF (@POCOUNT=@RCOUNT)
	BEGIN
	UPDATE TBL_PRODUCTIONORDER SET PO_STATUS='DONE' WHERE PO_ROLLID=@LOTNUMBER
	END

	ELSE

	BEGIN
		UPDATE TBL_PRODUCTIONORDER SET PO_STATUS='INPROGRESS' WHERE PO_ROLLID=@LOTNUMBER
	END


	END
	


	
	--SELECT * FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER
	--DECLARE @POCOUNT INT;
	--DECLARE @RCOUNT INT;
	--SELECT @POCOUNT= COUNT(*) FROM TBL_PRODUCTIONORDER WHERE PO_PODUCTIONORDER=@PRODUCTIONORDER
	--SELECT DISTINCT @RCOUNT=  COUNT(*) FROM TBL_REELS WHERE R_PRODUCTIONORDER=@PRODUCTIONORDER
	--IF (@POCOUNT=@RCOUNT)
	--BEGIN
	--UPDATE TBL_PRODUCTIONORDER SET PO_STATUS='DONE' WHERE PO_PODUCTIONORDER=@PRODUCTIONORDER
	--END

	--ELSE

	--BEGIN
	--	UPDATE TBL_PRODUCTIONORDER SET PO_STATUS='INPROGRESS' WHERE PO_PODUCTIONORDER=@PRODUCTIONORDER
	--END


	--END




GO
/****** Object:  StoredProcedure [dbo].[SP_GETREELDETAILSFORA4PRINT]    Script Date: 19-09-2019 11:27:43 ******/
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
	TBL_REELS.R_PRODUCTIONORDER ,
	TBL_PRODUCTIONORDER.PO_QUALITY AS [P1],
	TBL_PRODUCTIONORDER.PO_GSM AS [P2],
	TBL_PRODUCTIONORDER.PO_DIA,
	TBL_PRODUCTIONORDER.PO_SIZE AS [P3],
	TBL_PRODUCTIONORDER.PO_NOOFREELS,
	TBL_PRODUCTIONORDER.PO_SHIFT,
	TBL_PRODUCTIONORDER.PO_STATUS,
	TBL_PRODUCTIONORDER.PO_DATEOFMANUFACTURING AS [P6]
	FROM dbo.TBL_REELS INNER JOIN TBL_PRODUCTIONORDER ON PO_ROLLID=R_ROLLID
	 WHERE R_REELID = @REELID;
END

GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTLOG_REPRINT]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTREELHISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_LOTNUMBERS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORDASHBOARD]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORDASHBOARDNEW]    Script Date: 19-09-2019 11:27:43 ******/
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
		SELECT COUNT(R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_NOOFPRINTS>0

		SELECT COUNT(R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE) AND R_NOOFPRINTS>0

		SELECT COUNT(R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS WHERE R_NOOFPRINTS>0



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())AND R_NOOFPRINTS>0

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)AND R_NOOFPRINTS>0

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS  WHERE R_NOOFPRINTS>0
		 
	END
	ELSE
	BEGIN
		SELECT COUNT(R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_MACHINENUMBER=@LOCATIONNUMBWR AND R_NOOFPRINTS>0

		SELECT COUNT(R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=@LOCATIONNUMBWR AND R_NOOFPRINTS>0

		SELECT COUNT(R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE  R_MACHINENUMBER=@LOCATIONNUMBWR AND R_NOOFPRINTS>0



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND R_MACHINENUMBER=@LOCATIONNUMBWR AND R_NOOFPRINTS>0

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=@LOCATIONNUMBWR AND R_NOOFPRINTS>0

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE  R_MACHINENUMBER=@LOCATIONNUMBWR AND R_NOOFPRINTS>0
		 
	END



		END
	




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTHISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLINEFORUPDATE]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLINESFORWEB]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOCATIONDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTMONTHWISEREPORTFORDASHBOARD]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTPOFORWEB]    Script Date: 19-09-2019 11:27:43 ******/
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
	
	
	SELECT ROW_NUMBER() OVER(ORDER BY PO_INSERTEDTIME ) as[PO_SERIALNUMBER],PO_PODUCTIONORDER,PO_ROLLID,PO_QUALITY,PO_GSM,PO_DIA,PO_SIZE,PO_NOOFJOINTS,PO_NOOFREELS,PO_DATEOFMANUFACTURING,PO_STATUS,PO_JUMBOID,PO_USER,PO_INSERTEDTIME

	
FROM TBL_PRODUCTIONORDER WHERE PO_MACHINENUMBER=@LINENUMNER ORDER BY PO_INSERTEDTIME DESC
	END
	




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
	TS.PO_GSM AS [GSM],TS.PO_DATEOFMANUFACTURING AS [MFG],TS.PO_SHIFT AS [SHIFT] from TBL_REELS TR inner join TBL_PRODUCTIONORDER TS  
ON tr.R_ROLLID=TS.PO_ROLLID AND TR.R_REELID=@REELID ORDER BY R_ID ASC


UPDATE  TBL_REELS  SET R_STATUS='PRINTED' WHERE  R_REELID=@REELID
	
	END
	






	

	




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILSFORDASHBOARD]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILSHISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELHISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
	SELECT  ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID],
 TBL_PRODUCTIONORDER.PO_PODUCTIONORDER AS [PRODUCTION ORDER]
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM],
TBL_PRODUCTIONORDER.PO_DIA AS [DIA]
,TBL_PRODUCTIONORDER.PO_NOOFREELS AS[NO OF REELS],
TBL_PRODUCTIONORDER.PO_NOOFJOINTS AS [NO OF JOINTS]
,TBL_PRODUCTIONORDER.PO_DATEOFMANUFACTURING AS [MFG DATE]
,TBL_PRODUCTIONORDER.PO_SHIFT AS [SHIFT]
,TBL_PRODUCTIONORDER.PO_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT],

TBL_REELS.R_STATUS  AS [STATUS],


 TBL_REELHISTORY.RH_ACTION AS [ACTION]
 ,TBL_REELHISTORY.RH_DATETIME AS [DATETIME],
 TBL_REELHISTORY.RH_USER AS [USER],TBL_REELHISTORY.RH_LINE AS [LINE]  from ((TBL_PRODUCTIONORDER 
 INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID)
 INNER JOIN TBL_REELHISTORY ON RH_REELID= TBL_REELS.R_REELID)  WHERE RH_REELID =@REELNUMBER ORDER BY RH_DATETIME
DESC
	
	END
	




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELSDETAILSFORREPORT]    Script Date: 19-09-2019 11:27:43 ******/
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
 SELECT  ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID],
 TBL_PRODUCTIONORDER.PO_PODUCTIONORDER AS [PRODUCTION ORDER]
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM],
TBL_PRODUCTIONORDER.PO_DIA AS [DIA]
,
TBL_PRODUCTIONORDER.PO_NOOFJOINTS AS [NO OF JOINTS]
,TBL_PRODUCTIONORDER.PO_DATEOFMANUFACTURING AS [MFG DATE]
,TBL_PRODUCTIONORDER.PO_SHIFT AS [SHIFT]
,TBL_PRODUCTIONORDER.PO_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID
WHERE  TBL_REELS.R_NOOFPRINTS>0   ORDER BY TBL_REELS.R_ID ASC
END
ELSE IF (@FLAG='MONTH')
BEGIN
 select ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc ) AS [ID],
 TBL_PRODUCTIONORDER.PO_PODUCTIONORDER AS [PRODUCTION ORDER]
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM],
TBL_PRODUCTIONORDER.PO_DIA AS [DIA]
,
TBL_PRODUCTIONORDER.PO_NOOFJOINTS AS [NO OF JOINTS]
,TBL_PRODUCTIONORDER.PO_DATEOFMANUFACTURING AS [MFG DATE]
,TBL_PRODUCTIONORDER.PO_SHIFT AS [SHIFT]
,TBL_PRODUCTIONORDER.PO_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND MONTH(TBL_REELS.R_DATETIME)= MONTH(GETDATE()) ORDER BY TBL_REELS.R_ID ASC
END
ELSE
BEGIN
 select ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc ) AS [ID],
 TBL_PRODUCTIONORDER.PO_PODUCTIONORDER AS [PRODUCTION ORDER]
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM],
TBL_PRODUCTIONORDER.PO_DIA AS [DIA]
,
TBL_PRODUCTIONORDER.PO_NOOFJOINTS AS [NO OF JOINTS]
,TBL_PRODUCTIONORDER.PO_DATEOFMANUFACTURING AS [MFG DATE]
,TBL_PRODUCTIONORDER.PO_SHIFT AS [SHIFT]
,TBL_PRODUCTIONORDER.PO_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND TBL_REELS.R_DATETIME>= CAST(GETDATE() AS DATE)  ORDER BY TBL_REELS.R_ID ASC


END



 


 
	

	END
	END

	




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTROLLETAILSFORWEB]    Script Date: 19-09-2019 11:27:43 ******/
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
	@ROLLID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	
	SELECT PO_PODUCTIONORDER,PO_ROLLID,PO_QUALITY,PO_GSM,PO_DIA,PO_SIZE,PO_NOOFJOINTS,PO_NOOFREELS

FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID=@ROLLID

IF EXISTS(SELECT R_ROLLID FROM TBL_REELS WHERE R_ROLLID=@ROLLID)
BEGIN
SELECT * FROM TBL_REELS WHERE R_ROLLID=@ROLLID

END

	END
	




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTUSERFORUPDATE]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTUSERFORWEB]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBL_REELS_SELECTREEL]    Script Date: 19-09-2019 11:27:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_TBL_REELS_SELECTREEL]
    (@REELID AS VARCHAR(50))
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
BEGIN
        SELECT * FROM dbo.TBL_REELS INNER JOIN dbo.TBL_PRODUCTIONORDER ON R_PRODUCTIONORDER = PO_PODUCTIONORDER AND PO_ROLLID = R_ROLLID WHERE R_REELID = @REELID;
END



GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTHISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLINEDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLOGINDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLOTNUMBERS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTPRODUCTIONORDERS]    Script Date: 19-09-2019 11:27:43 ******/
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
@PO_PODUCTIONORDER VARCHAR(50),
@PO_ROLLID VARCHAR(50),
@PO_QUALITY VARCHAR(50),
@PO_GSM VARCHAR(50),
@PO_DIA VARCHAR(50),
@PO_SIZE VARCHAR(50),
@PO_NOOFJOINTS VARCHAR(50),
@PO_NOOFREELS numeric(18, 0),
@PO_DATEOFMANUFACTURING VARCHAR(50),
@PO_SHIFT VARCHAR(50),
@PO_STATUS VARCHAR(50),
@PO_MACHINENUMBER VARCHAR(50),
@PO_JUMBOID VARCHAR(50),
@USER VARCHAR(50)




AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF not exists(select PO_ROLLID from TBL_PRODUCTIONORDER where PO_ROLLID=@PO_ROLLID )
		BEGIN
			
	
    -- Insert statements for procedure here
	INSERT INTO TBL_PRODUCTIONORDER (PO_PODUCTIONORDER, 
PO_ROLLID ,
PO_QUALITY ,
PO_GSM ,
PO_DIA ,
PO_SIZE ,
PO_NOOFJOINTS ,
PO_NOOFREELS ,
PO_DATEOFMANUFACTURING ,
PO_SHIFT ,
PO_STATUS,
PO_MACHINENUMBER,PO_USER,PO_JUMBOID )VALUES (@PO_PODUCTIONORDER,
@PO_ROLLID ,
@PO_QUALITY ,
@PO_GSM,
@PO_DIA ,
@PO_SIZE,
@PO_NOOFJOINTS ,
@PO_NOOFREELS,
@PO_DATEOFMANUFACTURING ,
@PO_SHIFT ,
@PO_STATUS,
@PO_MACHINENUMBER,@USER,@PO_JUMBOID )


SELECT 'DATA UPLOAD SUCCESSFULL ' AS RESULT
		END
		ELSE
		BEGIN

		SELECT 'DUPLICATE ROLL ID FOUND' AS RESULT
		END
	 
END







GO
/****** Object:  StoredProcedure [dbo].[SP_TBLLOGINSELECTUSER]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLUPDATELOGINDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATELASTLOGEEDINTIME]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATELINEDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATELOGINSTATUS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATEPRINTCOUNT]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATEREELWEIGHT]    Script Date: 19-09-2019 11:27:43 ******/
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
      UPDATE dbo.TBL_REELS SET R_WEIGHT = @WEIGHT WHERE R_REELID = @REELID;

	  INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'WEIGHT CAPTURED',@USER,@LINENO)
	    INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'FINAL LABEL PRINTED',@USER,@LINENO)
END
    

GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATEUSERDETAILS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  Table [dbo].[TBL_HISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  Table [dbo].[TBL_LOCATIONS]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  Table [dbo].[TBL_LOTNUMBERS]    Script Date: 19-09-2019 11:27:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_LOTNUMBERS](
	[LT_ID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[LT_LOTNUMBER] [varchar](50) NULL,
	[LT_LOTNUMBER1] [varchar](50) NULL,
	[LT_LOTNUMBER2] [varchar](50) NULL,
	[LT_LOTNUMBER3] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_PRODUCTIONORDER]    Script Date: 19-09-2019 11:27:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL_PRODUCTIONORDER](
	[PO_SERIALNUMBER] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[PO_PODUCTIONORDER] [varchar](50) NULL,
	[PO_ROLLID] [varchar](50) NULL,
	[PO_QUALITY] [varchar](50) NULL,
	[PO_GSM] [varchar](50) NULL,
	[PO_DIA] [nvarchar](50) NULL,
	[PO_SIZE] [varchar](50) NULL,
	[PO_NOOFJOINTS] [varchar](50) NULL,
	[PO_NOOFREELS] [numeric](18, 0) NULL,
	[PO_DATEOFMANUFACTURING] [varchar](50) NULL,
	[PO_SHIFT] [varchar](50) NULL,
	[PO_STATUS] [varchar](50) NULL,
	[PO_INSERTEDTIME] [datetime] NULL,
	[PO_MACHINENUMBER] [numeric](18, 0) NULL,
	[PO_JUMBOID] [varchar](50) NULL,
	[PO_USER] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBL_REELHISTORY]    Script Date: 19-09-2019 11:27:43 ******/
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
/****** Object:  Table [dbo].[TBL_REELS]    Script Date: 19-09-2019 11:27:43 ******/
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
	[R_WEIGHT] [varchar](50) NULL,
	[R_MACHINENUMBER] [numeric](18, 0) NULL,
	[R_PRODUCTIONORDER] [varchar](50) NULL,
	[R_STATUS] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TBLLOGIN]    Script Date: 19-09-2019 11:27:43 ******/
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
SET IDENTITY_INSERT [dbo].[TBL_HISTORY] ON 

INSERT [dbo].[TBL_HISTORY] ([H_ID], [H_TRANSACTION_CODE], [H_REMARKS], [H_USER], [H_DATETIME], [H_LINENUMBER], [H_FILENAME], [H_STATUS]) VALUES (1, N'IMPORT_DATA', N'NA', N'admin', CAST(0x0000AACC00B934F0 AS DateTime), N'1', N'Sample Data file.xlsx', N'File Upload Success')
SET IDENTITY_INSERT [dbo].[TBL_HISTORY] OFF
SET IDENTITY_INSERT [dbo].[TBL_LOCATIONS] ON 

INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (1, N'LINE 1', N'LINE 1', N'1', CAST(0x0000AAC901559B91 AS DateTime))
INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (2, N'LINE 2', N'LINE 2', N'2', CAST(0x0000AAC9016017F3 AS DateTime))
INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (3, N'LINE 3', N'LINE 3', N'3', CAST(0x0000AAC9016024B2 AS DateTime))
INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (4, N'LINE 4', N'LINE 4', N'4', CAST(0x0000AAC90160312D AS DateTime))
INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (1002, N'611', N'611', N'6', CAST(0x0000AACA00EF0ECD AS DateTime))
INSERT [dbo].[TBL_LOCATIONS] ([ID], [LOCATIONNAME], [LOCATIONDESCRIPTION], [LOCATIONNUMBER], [LOCATIONDATE]) VALUES (5, N'5', N'5', N'5', CAST(0x0000AACA00B12136 AS DateTime))
SET IDENTITY_INSERT [dbo].[TBL_LOCATIONS] OFF
SET IDENTITY_INSERT [dbo].[TBL_PRODUCTIONORDER] ON 

INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(1 AS Numeric(18, 0)), N'PROD001', N'ROL1', N'100', N'12.3', N'10.1', N'120', N'1', CAST(1 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'DONE', CAST(0x0000AACC00B934EE AS DateTime), CAST(1 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(2 AS Numeric(18, 0)), N'PROD001', N'ROL2', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F1 AS DateTime), CAST(1 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(3 AS Numeric(18, 0)), N'PROD001', N'ROL3', N'100', N'12.3', N'10.1', N'120', N'1', CAST(3 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'DONE', CAST(0x0000AACC00B934F2 AS DateTime), CAST(1 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(4 AS Numeric(18, 0)), N'PROD001', N'ROL4', N'100', N'12.3', N'10.1', N'120', N'1', CAST(4 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'DONE', CAST(0x0000AACC00B934F3 AS DateTime), CAST(1 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(5 AS Numeric(18, 0)), N'PROD001', N'ROL5', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F4 AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(6 AS Numeric(18, 0)), N'PROD001', N'ROL6', N'100', N'12.3', N'10.1', N'120', N'1', CAST(3 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F5 AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(7 AS Numeric(18, 0)), N'PROD001', N'ROL7', N'100', N'12.3', N'10.1', N'120', N'1', CAST(4 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F6 AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(8 AS Numeric(18, 0)), N'PROD001', N'ROL8', N'100', N'12.3', N'10.1', N'120', N'1', CAST(6 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F7 AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(9 AS Numeric(18, 0)), N'PROD001', N'ROL9', N'100', N'12.3', N'10.1', N'120', N'1', CAST(4 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F8 AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(10 AS Numeric(18, 0)), N'PROD001', N'ROL10', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934F9 AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(11 AS Numeric(18, 0)), N'PROD002', N'ROL11', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934FA AS DateTime), CAST(2 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(12 AS Numeric(18, 0)), N'PROD002', N'ROL12', N'100', N'12.3', N'10.1', N'120', N'1', CAST(4 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934FC AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(13 AS Numeric(18, 0)), N'PROD002', N'ROL13', N'100', N'12.3', N'10.1', N'120', N'1', CAST(5 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934FC AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(14 AS Numeric(18, 0)), N'PROD002', N'ROL14', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934FD AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(15 AS Numeric(18, 0)), N'PROD002', N'ROL15', N'100', N'12.3', N'10.1', N'120', N'1', CAST(3 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934FE AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(16 AS Numeric(18, 0)), N'PROD002', N'ROL16', N'100', N'12.3', N'10.1', N'120', N'1', CAST(6 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B934FF AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(17 AS Numeric(18, 0)), N'PROD002', N'ROL17', N'100', N'12.3', N'10.1', N'120', N'1', CAST(5 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93501 AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(18 AS Numeric(18, 0)), N'PROD002', N'ROL18', N'100', N'12.3', N'10.1', N'120', N'1', CAST(3 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93502 AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(19 AS Numeric(18, 0)), N'PROD002', N'ROL19', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93502 AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(20 AS Numeric(18, 0)), N'PROD002', N'ROL20', N'100', N'12.3', N'10.1', N'120', N'1', CAST(1 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93503 AS DateTime), CAST(3 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(21 AS Numeric(18, 0)), N'PROD002', N'ROL21', N'100', N'12.3', N'10.1', N'120', N'1', CAST(1 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93505 AS DateTime), CAST(4 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(22 AS Numeric(18, 0)), N'PROD002', N'ROL22', N'100', N'12.3', N'10.1', N'120', N'1', CAST(3 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93505 AS DateTime), CAST(4 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(23 AS Numeric(18, 0)), N'PROD002', N'ROL23', N'100', N'12.3', N'10.1', N'120', N'1', CAST(4 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93506 AS DateTime), CAST(4 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(24 AS Numeric(18, 0)), N'PROD002', N'ROL24', N'100', N'12.3', N'10.1', N'120', N'1', CAST(2 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93507 AS DateTime), CAST(4 AS Numeric(18, 0)), N'0', N'admin')
INSERT [dbo].[TBL_PRODUCTIONORDER] ([PO_SERIALNUMBER], [PO_PODUCTIONORDER], [PO_ROLLID], [PO_QUALITY], [PO_GSM], [PO_DIA], [PO_SIZE], [PO_NOOFJOINTS], [PO_NOOFREELS], [PO_DATEOFMANUFACTURING], [PO_SHIFT], [PO_STATUS], [PO_INSERTEDTIME], [PO_MACHINENUMBER], [PO_JUMBOID], [PO_USER]) VALUES (CAST(25 AS Numeric(18, 0)), N'PROD002', N'ROL25', N'100', N'12.3', N'10.1', N'120', N'1', CAST(3 AS Numeric(18, 0)), N'22-07-2019 00:00:00', N'', N'PENDING', CAST(0x0000AACC00B93508 AS DateTime), CAST(4 AS Numeric(18, 0)), N'0', N'admin')
SET IDENTITY_INSERT [dbo].[TBL_PRODUCTIONORDER] OFF
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL4-1', N'REEL GENERATION', CAST(0x0000AACC00B95792 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL4-2', N'REEL GENERATION', CAST(0x0000AACC00B95792 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL4-3', N'REEL GENERATION', CAST(0x0000AACC00B95792 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL4-4', N'REEL GENERATION', CAST(0x0000AACC00B95792 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL1-1', N'REEL GENERATION', CAST(0x0000AACC00BA2DA1 AS DateTime), N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL4-1', N'WEIGHT CAPTURED', NULL, N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL4-1', N'FINAL LABEL PRINTED', NULL, N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL3-2', N'WEIGHT CAPTURED', NULL, N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL3-2', N'FINAL LABEL PRINTED', NULL, N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'rol4-1', N'FINAL LABEL RE PRINTED', NULL, N'admin', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL3-1', N'REEL GENERATION', CAST(0x0000AACC00F71D16 AS DateTime), N'ADMIN', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL3-2', N'REEL GENERATION', CAST(0x0000AACC00F71D17 AS DateTime), N'ADMIN', N'1')
INSERT [dbo].[TBL_REELHISTORY] ([RH_REELID], [RH_ACTION], [RH_DATETIME], [RH_USER], [RH_LINE]) VALUES (N'ROL3-3', N'REEL GENERATION', CAST(0x0000AACC00F71D18 AS DateTime), N'ADMIN', N'1')
SET IDENTITY_INSERT [dbo].[TBL_REELS] ON 

INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(1 AS Numeric(18, 0)), N'ROL4-1', N'120', N'', N'ROL4', CAST(0x0000AACC00F71D18 AS DateTime), CAST(1 AS Numeric(18, 0)), N'ADMIN', N'123.000', CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(2 AS Numeric(18, 0)), N'ROL4-2', N'120', N'', N'ROL4', CAST(0x0000AACC00F71D18 AS DateTime), CAST(1 AS Numeric(18, 0)), N'ADMIN', NULL, CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(3 AS Numeric(18, 0)), N'ROL4-3', N'120', N'', N'ROL4', CAST(0x0000AACC00F71D18 AS DateTime), CAST(0 AS Numeric(18, 0)), N'ADMIN', NULL, CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(4 AS Numeric(18, 0)), N'ROL4-4', N'120', N'', N'ROL4', CAST(0x0000AACC00F71D18 AS DateTime), CAST(0 AS Numeric(18, 0)), N'ADMIN', NULL, CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(5 AS Numeric(18, 0)), N'ROL1-1', N'120', N'', N'ROL1', CAST(0x0000AACC00F71D18 AS DateTime), CAST(1 AS Numeric(18, 0)), N'ADMIN', NULL, CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(6 AS Numeric(18, 0)), N'ROL3-1', N'120', N'', N'ROL3', CAST(0x0000AACC00F71D18 AS DateTime), CAST(11 AS Numeric(18, 0)), N'ADMIN', NULL, CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(7 AS Numeric(18, 0)), N'ROL3-2', N'120', N'', N'ROL3', CAST(0x0000AACC00F71D18 AS DateTime), CAST(1 AS Numeric(18, 0)), N'ADMIN', N'123.000', CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
INSERT [dbo].[TBL_REELS] ([R_ID], [R_REELID], [R_SIZE], [R_REMARKS], [R_ROLLID], [R_DATETIME], [R_NOOFPRINTS], [R_USERNAME], [R_WEIGHT], [R_MACHINENUMBER], [R_PRODUCTIONORDER], [R_STATUS]) VALUES (CAST(8 AS Numeric(18, 0)), N'ROL3-3', N'120', N'', N'ROL3', CAST(0x0000AACC00F71D18 AS DateTime), CAST(1 AS Numeric(18, 0)), N'ADMIN', NULL, CAST(1 AS Numeric(18, 0)), N'PROD001', N'LABELLED')
SET IDENTITY_INSERT [dbo].[TBL_REELS] OFF
SET IDENTITY_INSERT [dbo].[TBLLOGIN] ON 

INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(1 AS Numeric(18, 0)), N'ADMIN', N'ADMIN', N'Admin', N'ADMIN', N'vsqhc09xGjU=', CAST(0x0000AAC600BD2E32 AS DateTime), 1, CAST(0x0000AACC00F7020E AS DateTime), 1, CAST(0x0000AAC600C173B7 AS DateTime))
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(2 AS Numeric(18, 0)), N'1', N'1', N'FINISHING', N'1', N'M40FsP+6CcI=', CAST(0x0000AAC600BE035A AS DateTime), 0, CAST(0x0000AAC600BE0DE5 AS DateTime), 0, CAST(0x0000AAC600BE1A6C AS DateTime))
INSERT [dbo].[TBLLOGIN] ([ID], [EMPNAME], [EMPID], [ROLE], [LOGINUSERNAME], [PASSWORD], [CREATEDDATE], [ISLOGGEDIN], [LASTLOGGEDIN], [ACTIVEUSER], [UPDATEDDATETIME]) VALUES (CAST(3 AS Numeric(18, 0)), N'11', N'111', N'FINISHING', N'11', N'VtmIgIWvjj8=', CAST(0x0000AACA009E72F9 AS DateTime), NULL, NULL, 1, NULL)
SET IDENTITY_INSERT [dbo].[TBLLOGIN] OFF
ALTER TABLE [dbo].[TBL_HISTORY] ADD  CONSTRAINT [DF_TBL_HISTORY_H_DATETIME]  DEFAULT (getdate()) FOR [H_DATETIME]
GO
ALTER TABLE [dbo].[TBL_LOCATIONS] ADD  CONSTRAINT [DF_TBL_LOCATIONS_LOCATIONDATE]  DEFAULT (getdate()) FOR [LOCATIONDATE]
GO
ALTER TABLE [dbo].[TBL_PRODUCTIONORDER] ADD  CONSTRAINT [DF_TBL_PRODUCTIONORDER_PO_STATUS]  DEFAULT ('PENDING') FOR [PO_STATUS]
GO
ALTER TABLE [dbo].[TBL_PRODUCTIONORDER] ADD  CONSTRAINT [DF_TBL_PURCHASEORDER_PO_INSERTEDTIME]  DEFAULT (getdate()) FOR [PO_INSERTEDTIME]
GO
ALTER TABLE [dbo].[TBL_REELS] ADD  CONSTRAINT [DF_TBL_REELS_R_DATETIME]  DEFAULT (getdate()) FOR [R_DATETIME]
GO
ALTER TABLE [dbo].[TBL_REELS] ADD  CONSTRAINT [DF_TBL_REELS_R_NOOFPRINTS]  DEFAULT ((0)) FOR [R_NOOFPRINTS]
GO
ALTER TABLE [dbo].[TBLLOGIN] ADD  CONSTRAINT [DF_TBLLOGIN_CREATEDDATE]  DEFAULT (getdate()) FOR [CREATEDDATE]
GO
USE [master]
GO
ALTER DATABASE [dbWCPM] SET  READ_WRITE 
GO
