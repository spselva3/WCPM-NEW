USE [master]
GO
/****** Object:  Database [dbWCPM]    Script Date: 28-01-2020 14:36:30 ******/
CREATE DATABASE [dbWCPM]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'dbWCPM', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\dbWCPM.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'dbWCPM_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\dbWCPM_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
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
ALTER DATABASE [dbWCPM] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [dbWCPM] SET QUERY_STORE = OFF
GO
USE [dbWCPM]
GO
/****** Object:  UserDefinedFunction [dbo].[COPYROWDATA]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GETBALREELS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GETPRODUCTIONDATE]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[GETPRODUCTIONDATE]


()
RETURNS DATE

AS
BEGIN
-- Declare the return variable here
    DECLARE @Date AS DATE;
    -- Add the T-SQL statements to compute the return value here
    IF DATEPART(Hh, GETDATE()) >= 0
       AND DATEPART(Hh, GETDATE()) < 7
    BEGIN
        SET @Date = DATEADD(DAY, -1, GETDATE());
    END;
    ELSE
    BEGIN
        SET @Date = GETDATE();
    END;
    RETURN @Date;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[GETREELSERIALNUMBER]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  UserDefinedFunction [dbo].[GETSHIFT]    Script Date: 28-01-2020 14:36:30 ******/
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
IF (@CURHOUR>=7 AND @CURHOUR<15)
BEGIN
SET @SHIFT='A'
END
ELSE IF (@CURHOUR>=15 AND @CURHOUR<23)
BEGIN
SET @SHIFT='B'
END
ELSE IF ( @CURHOUR<7 or @CURHOUR>23)
BEGIN
SET @SHIFT='C'
END





RETURN @SHIFT




END



GO
/****** Object:  UserDefinedFunction [dbo].[GETSHIFTFROMDATE]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[GETSHIFTFROMDATE](@DATE DATETIME)


RETURNS VARCHAR(256)
AS
BEGIN




DECLARE @CURHOUR DATETIME
DECLARE @SHIFT VARCHAR(50)
SET @CURHOUR=(SELECT DATEPART(HOUR, @DATE))
IF (@CURHOUR>=7 AND @CURHOUR<15)
BEGIN
SET @SHIFT='A'
END
ELSE IF (@CURHOUR>=15 AND @CURHOUR<23)
BEGIN
SET @SHIFT='B'
END
ELSE IF @CURHOUR<7 
BEGIN
SET @SHIFT='C'
END

RETURN @SHIFT




END



GO
/****** Object:  UserDefinedFunction [dbo].[udf_GetNumeric]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  Table [dbo].[BL_PRINT]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BL_PRINT](
	[P_ID] [int] IDENTITY(1,1) NOT NULL,
	[P_REELID] [varchar](50) NULL,
	[P_FLAG] [bit] NULL,
	[P_LINENO] [int] NULL,
	[P_SERAILNUMBER] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_COLORMASTER]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_COLORMASTER](
	[C_ID] [int] IDENTITY(1,1) NOT NULL,
	[C_CODE] [numeric](18, 0) NULL,
	[C_COLOR] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_GSMMASTER]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  Table [dbo].[TBL_HISTORY]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[TBL_LOCATIONS]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_LOCATIONS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LOCATIONNAME] [varchar](50) NULL,
	[LOCATIONDESCRIPTION] [varchar](50) NULL,
	[LOCATIONNUMBER] [varchar](50) NULL,
	[LOCATIONDATE] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_PRODUCTIONORDER]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[TBL_QCCODEMASTER]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_QCCODEMASTER](
	[MATER_ID] [int] IDENTITY(1,1) NOT NULL,
	[MASTER_QCCODE] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_QCMASTER]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_QCMASTER](
	[QCMASTER_ID] [int] IDENTITY(1,1) NOT NULL,
	[QCMASTER_MCNO] [int] NULL,
	[QCMASTER_QCCODE] [int] NULL,
	[QCMASTER_DESCRIPTION] [varchar](50) NULL,
	[QCMASTER_TYPE] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_REELHISTORY]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_REELHISTORY](
	[RH_REELID] [varchar](50) NULL,
	[RH_ACTION] [varchar](50) NULL,
	[RH_DATETIME] [datetime] NULL,
	[RH_USER] [varchar](50) NULL,
	[RH_LINE] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_REELS]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[R_FLAGTODELETE] [bit] NULL,
	[R_GSM] [int] NULL,
	[R_LINE] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_REELSERIALPREFIX]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_REELSERIALPREFIX](
	[PREFIX] [varchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBL_TAREWEIGHTMASTER]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[TBL_WEIGHT]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TBL_WEIGHT](
	[WEIGHT] [decimal](18, 1) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_WeightmentIP]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_WeightmentIP](
	[Line] [nvarchar](50) NULL,
	[IP_Address] [nvarchar](50) NULL,
	[Port] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbllocationsnew]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbllocationsnew](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LOCATIONNAME] [varchar](50) NULL,
	[LOCATIONDESCRIPTION] [varchar](50) NULL,
	[LOCATIONNUMBER] [varchar](50) NULL,
	[LOCATIONDATE] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TBLLOGIN]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[tblPrintLabel]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPrintLabel](
	[P_ID] [int] IDENTITY(1,1) NOT NULL,
	[P_REELID] [varchar](50) NULL,
	[P_FLAG] [bit] NULL,
	[P_LINENO] [int] NULL
) ON [PRIMARY]
GO
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
ALTER TABLE [dbo].[tbllocationsnew] ADD  CONSTRAINT [DF_tbllocationsnew_LOCATIONDATE]  DEFAULT (getdate()) FOR [LOCATIONDATE]
GO
ALTER TABLE [dbo].[TBLLOGIN] ADD  CONSTRAINT [DF_TBLLOGIN_CREATEDDATE]  DEFAULT (getdate()) FOR [CREATEDDATE]
GO
/****** Object:  StoredProcedure [dbo].[SELECTLOTNUMBERSFORTESTING]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SELECTREELFORPRINTING]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<SUDHAKAR,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SELECTREELFORPRINTING] 
	    @LINENUMBER INT


	
 AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT P_REELID,P_SERAILNUMBER FROM BL_PRINT WHERE P_FLAG=1 AND P_LINENO=@LINENUMBER;
	
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SELECTREELFORPRINTINGLABEL]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SELECTREELFORPRINTINGLABEL] 
	    @LINENUMBER INT


	
 AS
BEGIN
	
	SET NOCOUNT ON;
	SELECT TOP 1 P_REELID FROM tblPrintLabel WHERE P_FLAG=1 AND P_LINENO=@LINENUMBER;
	
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_ADDWEIGHT]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_ADDWEIGHT]


as
begin

set nocount on

select [WEIGHT] from TBL_WEIGHT

end
GO
/****** Object:  StoredProcedure [dbo].[SP_CREATECHILDREELS]    Script Date: 28-01-2020 14:36:30 ******/
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
	 Declare @GSM int 
	DECLARE @SRNUM INT =0;

WHILE @cnt < @NOOFREELS
BEGIN
--SELECT ROW_NUMBER() OVER(ORDER BY PO_INSERTEDTIME )
SET @SRNUM= (SELECT COUNT(DISTINCT R_REELID) FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER AND R_SIZE=@SIZE  )      
SET @SRNUM=@SRNUM+1;
 SET @UNIQUENUM=@LOTNUMBER+'-'+@SIZE+'-'+CONVERT(varchar(50), @SRNUM)

 IF NOT EXISTS(SELECT R_REELID FROM TBL_REELS WHERE R_REELID=@UNIQUENUM)
 BEGIN


  
 INSERT INTO TBL_REELS (R_REELID,R_SIZE,R_REMARKS,R_ROLLID,R_USERNAME,R_MACHINENUMBER,R_TYPE,R_PREFIX,R_DATETIME,R_ORDEREDQTY,R_ACTUALSIZE,R_SHIFT)		--Added GSM
               VALUES (@UNIQUENUM,@SIZE,'',       @LOTNUMBER,@USER,   @MACHINENUMBER,@TYPE,(SELECT TOP 1 PREFIX FROM TBL_REELSERIALPREFIX),GETDATE(),(SELECT PO_ORDEREDQTY FROM TBL_PRODUCTIONORDER WHERE PO_ROLLID=@LOTNUMBER AND PO_SIZE=@ACTUALSIZE ),@ACTUALSIZE,DBO.GETSHIFT())
 INSERT INTO TBL_REELHISTORY(RH_REELID,RH_ACTION,RH_DATETIME,RH_USER,RH_LINE) VALUES (@UNIQUENUM,'REEL GENERATION',GETDATE(),@USER,
@MACHINENUMBER)


UPDATE  TBL_REELS  SET R_STATUS='LABELLED' WHERE R_ROLLID=@LOTNUMBER
UPDATE TBL_PRODUCTIONORDER SET PO_USER=@USER WHERE PO_ROLLID=@LOTNUMBER

 END
   SET @cnt = @cnt + 1;
END;
	
	SELECT * FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER AND R_SIZE=@SIZE and R_WEIGHT is null ORDER BY R_ID DESC      --Added weight is null



	END
	


	
	


GO
/****** Object:  StoredProcedure [dbo].[SP_DataHistory]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_DataHistory]


@Line int, 
@Type nvarchar(20)

as
 begin
 set nocount on
 if(@Line=1 )
 begin
 (select top 10 R_REELID as [Reel No] , R_REELSNOFORPRINT as [Serial No],R_WEIGHT as [Weight], R_REPROCESS as[Reprocess]  ,R_WEIGHTCAPUREDTIME as[Date_Time] from TBL_REELS where (R_LINE ='2' or R_LINE ='1') and (R_MACHINENUMBER='1' or R_MACHINENUMBER='2' or R_MACHINENUMBER='3') and R_TYPE=@Type)order by  R_REELSNOFORPRINT desc 
 end
if(@Line=2 )
 begin
 (select top 10 R_REELID as [Reel No] , R_REELSNOFORPRINT as [Serial No],R_WEIGHT as [Weight], R_REPROCESS as[Reprocess]  ,R_WEIGHTCAPUREDTIME as[Date_Time]  from TBL_REELS where (R_LINE ='2' or R_LINE ='1') and (R_MACHINENUMBER='1' or R_MACHINENUMBER='2' or R_MACHINENUMBER='3') and R_TYPE=@Type)order by  R_REELSNOFORPRINT desc 
 end
else  if(@Line=3 )
 begin
 (select top 10 R_REELID as [Reel No] , R_REELSNOFORPRINT as [Serial No],R_WEIGHT as [Weight],R_REPROCESS as[Reprocess]  ,R_WEIGHTCAPUREDTIME as[Date_Time]  from TBL_REELS where (R_LINE ='3') and (R_MACHINENUMBER='4' or R_MACHINENUMBER='5')and R_TYPE=@Type )order by  R_REELSNOFORPRINT desc 
 end
 
select max(R_REELSNO) as [dc] from TBL_REELS where R_TYPE='DC' 
select max(R_REELSNO) as [market123]  from TBL_REELS where R_TYPE='MARKET' and (R_MACHINENUMBER='1' or  R_MACHINENUMBER='2' or  R_MACHINENUMBER='3')
select max(R_REELSNO) as [bc]   from TBL_REELS where R_TYPE='BC'
select max(R_REELSNO) as [micr]  from TBL_REELS where R_TYPE='MICR'
select max(R_REELSNO) as [market45]  from TBL_REELS where R_TYPE='MARKET' and (R_MACHINENUMBER='4' or  R_MACHINENUMBER='5')



 end

GO
/****** Object:  StoredProcedure [dbo].[SP_DELEETCHILDREELS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DELEETCHILDREELSNEW]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_DELETECHILDREELS]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_DELETECHILDREELS] 
	-- Add the parameters for the stored procedure here
 @FROMREELNUMBER INT ,
 @TOREELNUMBER INT,
 @LOTNUMBER VARCHAR(50),
 @SIZE VARCHAR(50),
 @LINENUMBER VARCHAR(50),
 @USER VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @ACTION VARCHAR(50)
	DECLARE @cnt INT = 0;
	DECLARE @REELID VARCHAR(50)

	DECLARE @TOVAR INT
	SET @TOVAR=@TOREELNUMBER-@FROMREELNUMBER
	SET @TOVAR=@TOVAR+1;
	DECLARE @REELCOUNT INT;
	

SET @REELCOUNT=(SELECT DISTINCT COUNT(*) FROM TBL_REELS WHERE R_ROLLID=@LOTNUMBER AND R_SIZE=@SIZE);
IF (@REELCOUNT=@TOREELNUMBER)
BEGIN
	WHILE @cnt < @TOVAR

	BEGIN

	SET @REELID=CONCAT(@LOTNUMBER,'-',@SIZE,'-',@TOREELNUMBER)

	IF EXISTS(SELECT R_REELID FROM TBL_REELS WHERE R_REELID=@REELID AND R_WEIGHT IS  NULL)
	BEGIN
        
        delete from TBL_REELS where R_REELID=@REELID
           SET @ACTION='DELETE'
         
           INSERT INTO TBL_REELHISTORY(RH_REELID,RH_ACTION,RH_DATETIME,RH_USER,RH_LINE) VALUES (@REELID,@ACTION,GETDATE(),@USER,
           @LINENUMBER)
         END
		 else
		 begin
		 Break;
		 end
  SET @cnt=@cnt+1;
 SET  @TOREELNUMBER=@TOREELNUMBER-1
  END
  END

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_EditPageLogin]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_EditPageLogin]

@username nvarchar(50),
@Password nvarchar(200)



as
begin



if exists(select * from TBLLOGIN where LOGINUSERNAME=@username and PASSWORD=@Password)
begin
select 1 as [Result]
end



end
GO
/****** Object:  StoredProcedure [dbo].[SP_EditPageReelId]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_EditPageReelId]

@RollNo nvarchar(30),
@size nvarchar(20)

as
begin

set nocount on
select distinct R_REELID from TBL_REELS where R_ROLLID=@RollNo and R_SIZE =@size order by R_REELID ASC
end
GO
/****** Object:  StoredProcedure [dbo].[SP_EditPageReelWeight]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_EditPageReelWeight]

@Reelid nvarchar(50)


as
begin

set nocount on
select top 1 R_ID,R_REPROCESS ,CONVERT (NUMERIC(18,0), TBL_REELS.R_WEIGHT) as [Weight], CONVERT (NUMERIC(18,1),TBL_REELS.R_TAREWEIGHT) as Tare ,CONVERT (NUMERIC(18,1), TBL_REELS.R_NETWEIGHT) as net  from TBL_REELS where R_REELID=@Reelid order by R_ID desc
end





GO
/****** Object:  StoredProcedure [dbo].[SP_EditPageRoll]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_EditPageRoll]

@RollNo nvarchar(50)

as
begin

set nocount on
select distinct PO_QUALITY from TBL_PRODUCTIONORDER where PO_ROLLID= @RollNo

select distinct PO_COLOURGRAIN from TBL_PRODUCTIONORDER where PO_ROLLID= @RollNo

select distinct PO_SIZE  from TBL_PRODUCTIONORDER where PO_ROLLID= @RollNo

select distinct R_SIZE  from TBL_REELS where R_ROLLID =@RollNo

select distinct PO_GSM from TBL_PRODUCTIONORDER where PO_ROLLID= @RollNo



    


end
GO
/****** Object:  StoredProcedure [dbo].[SP_EditPageSelect]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  procedure [dbo].[SP_EditPageSelect]
@serialNo nvarchar(20)

as
 begin

 set nocount on
Declare @Reel nvarchar(20)
Set @Reel= (select distinct R_ROLLID from TBL_REELS where R_REELSNOFORPRINT=@serialNo)

 Declare @Qual nvarchar(20)
Set @Qual =(select distinct PO_QUALITY from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel)
Declare @colour nvarchar(20)
set @colour = ( select distinct PO_COLOURGRAIN from TBL_PRODUCTIONORDER INNER JOIN dbo.TBL_REELS  ON PO_ROLLID=R_ROLLID and PO_SIZE=R_ACTUALSIZE  where   R_REELSNOFORPRINT=@serialNo)

 SELECT top 1 TBL_REELS.R_ID ,

	TBL_REELS.R_REELID as Reel_ID, 
	@Qual as Quality,
	@colour as Colour,
	TBL_REELS.R_ROLLID  as Roll_ID, 
	TBL_REELS.R_SIZE as Size, 
    TBL_PRODUCTIONORDER.PO_GSM  as GSM,
	
	TBL_REELS.R_DATETIME as Date_Time, 

	CONVERT (NUMERIC(18,0), TBL_REELS.R_WEIGHT) as [Weight] , 

	CONVERT (NUMERIC(18,1), 	TBL_REELS.R_TAREWEIGHT) as Tare_wt, 
	CONVERT (NUMERIC(18,1), TBL_REELS.R_NETWEIGHT) as Net_wt, 
	TBL_REELS.R_REELSNOFORPRINT as Serial_No, 
	
	TBL_REELS.R_REPROCESS as Reprocess 

                                                                 
	FROM dbo.TBL_REELS INNER JOIN TBL_PRODUCTIONORDER ON PO_ROLLID=R_ROLLID and PO_SIZE=R_ACTUALSIZE where R_REELSNOFORPRINT= @serialNo order by R_ID desc


 end


GO
/****** Object:  StoredProcedure [dbo].[SP_EditPageUpdate]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_EditPageUpdate]

@SerialNo nvarchar(50),
@Rollid nvarchar(50),
@Reelid nvarchar(50),
@Size nvarchar(20),
@actualSize nvarchar(20),
@weight numeric (18,3),
@tare  numeric (18,3),
@net numeric (18,3),
@Reprocess nvarchar(30)



as
begin

set nocount on

declare @type nvarchar(50)
set @type=( select distinct PO_TYPE from TBL_PRODUCTIONORDER where PO_ROLLID =@Rollid)

declare @machineno numeric (18,0)
set @machineno=( select distinct PO_MACHINENUMBER from TBL_PRODUCTIONORDER where PO_ROLLID =@Rollid)

declare @oldserial nvarchar(40)
set @oldserial = (select distinct R_REELSNOFORPRINT from TBL_REELS where R_REELID=@Reelid)



update tbl_reels

set R_ROLLID =@Rollid ,R_REELID = @Reelid, R_SIZE =@Size , R_ACTUALSIZE = @actualSize ,R_WEIGHT =@weight, R_TAREWEIGHT =@tare, R_NETWEIGHT=@net,
 R_MACHINENUMBER = @machineno ,R_shift= dbo.GETSHIFT(), R_USERNAME='SUPER ADMIN'  ,R_TYPE =@type

 where R_REELSNOFORPRINT =@SerialNo 



 
update TBL_REELS
set R_REPROCESS = null ,R_WEIGHT=null ,R_TAREWEIGHT = null , R_NETWEIGHT = null ,R_REELSNO = null , R_REELSNOFORPRINT =null , R_WEIGHTCAPUREDTIME = null
where R_REELID =@Reelid and R_REELSNOFORPRINT =@oldserial


 end
GO
/****** Object:  StoredProcedure [dbo].[SP_GETREELDETAILSFORA4PRINT]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_GETREELDETAILSFORA4PRINT]
    (@REELID AS VARCHAR(50),@SERAILNUMBER AS VARCHAR(100))
-- WITH ENCRYPTION, RECOMPILE, EXECUTE AS CALLER|SELF|OWNER| 'user_name'
AS
    
BEGIN



DECLARE @RSIZE VARCHAR(50)
SET @RSIZE=(SELECT distinct  R_ACTUALSIZE FROM TBL_REELS WHERE R_REELID=@REELID and R_REELSNOFORPRINT=@SERAILNUMBER)



Declare @Reel nvarchar(20)
Declare @Prefix nvarchar(10)
Set @Reel= (select distinct R_ROLLID from TBL_REELS where R_REELID = @REELID)
SET @Prefix=(SELECT distinct PO_LOTPREFIX from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel AND PO_SIZE=@RSIZE)
Declare @Qual nvarchar(20)
Set @Qual =(select distinct PO_QUALITY from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel)

Declare @PrintLot nvarchar(10)

if(@Qual='WESCO MICR' and @Prefix='')
begin
Set @PrintLot='W'
END

ELSE 
begin
set @PrintLot=(select distinct PO_LOTPREFIX from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel  AND PO_SIZE=@RSIZE)
end

Declare @colour nvarchar(20)
set @colour = ( select distinct PO_COLOURGRAIN from TBL_PRODUCTIONORDER INNER JOIN dbo.TBL_REELS  ON PO_ROLLID=R_ROLLID and PO_SIZE=R_ACTUALSIZE  where  R_REELID = @REELID AND R_REELSNOFORPRINT=@SERAILNUMBER)

if(@colour = 'DEFAULT')
begin
set @colour = ''
end






    SELECT top 1 TBL_REELS.R_ID, 

--	TBL_REELS.R_ROLLID AS [P5], 
	SUBSTRING(SUBSTRING(TBL_REELS.R_REELID,CHARINDEX('-',TBL_REELS.R_REELID)+2,100),CHARINDEX('-',SUBSTRING(TBL_REELS.R_REELID,CHARINDEX('-',TBL_REELS.R_REELID)+2,100))+1,100)  AS [P5], 
	TBL_REELS.R_REELID AS [P10], 
TBL_REELS.R_REELID AS [P15], 
	TBL_REELS.R_SIZE, --
 
	TBL_REELS.R_ROLLID AS [P4], 
	TBL_REELS.R_DATETIME, 
	TBL_REELS.R_NOOFPRINTS, --
	TBL_REELS.R_USERNAME, --
	CONVERT (NUMERIC(18,0), TBL_REELS.R_WEIGHT)  AS [P7], 
	TBL_REELS.R_MACHINENUMBER, --
	CONVERT (NUMERIC(18,1), 	TBL_REELS.R_TAREWEIGHT) AS [P8], 
	CONVERT (NUMERIC(18,1), TBL_REELS.R_NETWEIGHT) AS [P9], 
	TBL_REELS.R_REELSNOFORPRINT  AS [P17], 
	
	TBL_PRODUCTIONORDER.PO_REMARKS  AS [P16], 
	
	CONCAT(TBL_PRODUCTIONORDER.PO_QUALITY,' ',@colour) AS [P1],
	TBL_PRODUCTIONORDER.PO_GSM AS [P2],							 --- TBL_REELS.R_GSM AS [P2],			--Added GSM From Production Order.
	
	TBL_REELS.R_SIZE AS [P3],

	@PrintLot As [P20],                                                   --AddedTBL_PRODUCTIONORDER.PO_LOTPREFIX
	TBL_REELS.R_REELID  As [P21],                          


	getdate() AS [P6]
	FROM dbo.TBL_REELS INNER JOIN TBL_PRODUCTIONORDER ON PO_ROLLID=R_ROLLID and PO_SIZE=R_ACTUALSIZE
	WHERE R_REELID = @REELID  AND R_REELSNOFORPRINT=@SERAILNUMBER;
END

  
GO
/****** Object:  StoredProcedure [dbo].[SP_GetWeighmentIP]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetWeighmentIP]

@Line nvarchar(50)


as 
begin
set nocount on

select Ip_Address,[Port] from tbl_WeightmentIP where Line=@Line




end
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTFORLABELPRINTING]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_INSERTFORLABELPRINTING] 
	    @LINENUMBER INT,
		  @REELNUMBER varchar(50)
		 

		
	
 AS
BEGIN
	
	SET NOCOUNT ON;
INSERT INTO tblPrintLabel  (P_REELID,P_FLAG,P_LINENO)  VALUES (@REELNUMBER,1,@LINENUMBER)
	
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTFORPRINTING]    Script Date: 28-01-2020 14:36:30 ******/
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
 @REELNUMBER VARCHAR(50),
  @LINENUMBER INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @serialno nvarchar(20)
	set @serialno=(select  max (R_REELSNOFORPRINT) from TBL_REELS where R_REELID=@REELNUMBER  )


	INSERT INTO BL_PRINT(P_REELID,P_FLAG,P_LINENO,P_SERAILNUMBER) VALUES (@REELNUMBER,1,@LINENUMBER,@serialno);
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTFORPRINTINGFROMWEB]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_INSERTFORPRINTINGFROMWEB] 
	-- Add the parameters for the stored procedure here
 @REELNUMBER VARCHAR(50),
  @LINENUMBER INT,
  @RSN VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	INSERT INTO BL_PRINT(P_REELID,P_FLAG,P_LINENO,P_SERAILNUMBER) VALUES (@REELNUMBER,1,@LINENUMBER,@RSN);
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTLOG_REPRINT]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_INSERTREELHISTORY]    Script Date: 28-01-2020 14:36:30 ******/
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
SELECT @PRINTCOUNT=(SELECT top 1 R_NOOFPRINTS FROM TBL_REELS WHERE R_REELID=@REELID)
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
/****** Object:  StoredProcedure [dbo].[SP_LOTNUMBERS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_Reprocessselect]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Reprocessselect]

@Reelid nvarchar(20)

as
begin
 set nocount on

select R_SIZE from TBL_REELS where R_REELID=@Reelid and R_WEIGHT is null and R_REPROCESS is null

 




 end
GO
/****** Object:  StoredProcedure [dbo].[SP_Reprocessweightupdate]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_Reprocessweightupdate]

@Size nvarchar(20),
@Weight numeric(18,0),
@ReelID nvarchar(20)

as
begin

update TBL_REELS
set R_WEIGHT=@Weight
where R_REELID=@ReelID and R_SIZE=@Size

end
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTBALANCEREELREPORT]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTBALANCEREELREPORT] 
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTCHILDREELS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTCOLORMASTERDATA]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTDAILYREELSHEET]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_SELECTDAILYREELSHEET] 
	-- Add the parameters for the stored procedure here
	@DATE VARCHAR(50),
	@SHIFT VARCHAR(50),
	@line int

AS
BEGIN

	SET NOCOUNT ON;
	
	  BEGIN

	  SELECT ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_REELSNO ) as[ID], 
	  TBL_PRODUCTIONORDER.PO_QUALITY as[QUALITY],
	  TBL_PRODUCTIONORDER.PO_GSM as[GSM],
	  TBL_REELS.R_ROLLID as[LOT NUMBER],
	  TBL_REELS.R_REELSNOFORPRINT as[REEL SERAIL NUMBER],
	  TBL_REELS.R_ACTUALSIZE AS [SIZE],
	  TBL_REELS.R_WEIGHT AS[GROSS WEIGHT],
	  
	  SUBSTRING(SUBSTRING(TBL_REELS.R_REELID,CHARINDEX('-',TBL_REELS.R_REELID)+2,100),CHARINDEX('-',SUBSTRING(TBL_REELS.R_REELID,CHARINDEX('-',TBL_REELS.R_REELID)+2,100))+1,100) AS [RW NO],
	   R_WEIGHTCAPUREDTIME as [TIMESTAMP]
	   FROM TBL_REELS  INNER JOIN TBL_PRODUCTIONORDER ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID and PO_SIZE =R_SIZE
	  WHERE    DBO.GETSHIFTFROMDATE(R_WEIGHTCAPUREDTIME)=@SHIFT   and CONVERT(date, R_WEIGHTCAPUREDTIME) BETWEEN 
	   CONVERT(DATE,  @DATE) AND CONVERT(DATE,  @DATE) AND R_LINE=@line
	   ORDER BY TBL_REELS.R_REELSNO asc

				END
				END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORDASHBOARD]    Script Date: 28-01-2020 14:36:30 ******/
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



		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_NETWEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_NETWEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)

		SELECT SUM(CONVERT(NUMERIC(18,3),ISNULL(R_NETWEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS  
		 
		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORDASHBOARDNEW]    Script Date: 28-01-2020 14:36:30 ******/
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



		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS  WHERE R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	ELSE
	BEGIN
	IF ( @LOCATIONNUMBWR='1')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_MACHINENUMBER=1   AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=1  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE   R_MACHINENUMBER=1  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND R_MACHINENUMBER=1  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=1 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   R_MACHINENUMBER=1 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	IF ( @LOCATIONNUMBWR='2')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_MACHINENUMBER=2  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=2 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE   R_MACHINENUMBER=2 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND R_MACHINENUMBER=2 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=2 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   R_MACHINENUMBER=2  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	IF ( @LOCATIONNUMBWR='3')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_MACHINENUMBER=3 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=3  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE   R_MACHINENUMBER=3 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND R_MACHINENUMBER=3 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=3  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   R_MACHINENUMBER=3 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	IF ( @LOCATIONNUMBWR='4')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_MACHINENUMBER=4 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=4  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE   R_MACHINENUMBER=4 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND R_MACHINENUMBER=4 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=4  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   R_MACHINENUMBER=4 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	IF ( @LOCATIONNUMBWR='5')
	BEGIN
		SELECT COUNT(DISTINCT R_REELID) AS [TOTALMONTHREELCOUNT] FROM TBL_REELS  WHERE  MONTH(R_DATETIME) = MONTH(GETDATE()) AND R_MACHINENUMBER=5 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALDAYREELCOUNT] FROM TBL_REELS WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=5 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT COUNT(DISTINCT R_REELID)  AS [TOTALCOUNT] FROM TBL_REELS  WHERE    R_MACHINENUMBER=5 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1



		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [MONTHLYWEIGHT] FROM TBL_REELS   WHERE  MONTH(R_DATETIME) = MONTH(GETDATE())  AND R_MACHINENUMBER=5 AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [DAYWEIGHT]  FROM TBL_REELS   WHERE  R_DATETIME >= CAST(GETDATE() AS DATE)  AND R_MACHINENUMBER=5  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1

		SELECT SUM(CONVERT(NUMERIC(18,1),ISNULL(R_WEIGHT,0))) AS [TOTALWEIGHT] FROM TBL_REELS    WHERE   R_MACHINENUMBER=5  AND R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1
		 
	END
	END



		END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTFORREELPRINTING]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE    PROCEDURE [dbo].[SP_SELECTFORREELPRINTING] 
	-- Add the parameters for the stored procedure here
 @FROMREELNUMBER INT ,
 @TOREELNUMBER INT,
 @LOTNUMBER VARCHAR(50),
 @SIZE VARCHAR(50),
 @LINENUMBER VARCHAR(50),
 @USER VARCHAR(50)
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @ACTION VARCHAR(50)
	DECLARE @cnt INT = 0;
	DECLARE @REELID VARCHAR(50)

	DECLARE @TOVAR INT
	SET @TOVAR=@TOREELNUMBER-@FROMREELNUMBER
	SET @TOVAR=@TOVAR+1;
	WHILE @cnt < @TOVAR

	BEGIN

	SET @REELID=CONCAT(@LOTNUMBER,'-',@SIZE,'-',@FROMREELNUMBER)
	
	IF EXISTS(SELECT R_REELID FROM TBL_REELS WHERE R_REELID=@REELID)
	BEGIN
         INSERT INTO tblPrintLabel  (P_REELID,P_FLAG,P_LINENO)  VALUES (@REELID,1,@LINENUMBER)
         DECLARE @PRINTCOUNT NUMERIC (18,0)
         SELECT @PRINTCOUNT=(SELECT top 1 R_NOOFPRINTS FROM TBL_REELS WHERE R_REELID=@REELID)
         IF (@PRINTCOUNT>1)
          BEGIN
           SET @ACTION='REPRINT'
             END
            ELSE
             BEGIN
           SET @ACTION='PRINT'
            END
           INSERT INTO TBL_REELHISTORY(RH_REELID,RH_ACTION,RH_DATETIME,RH_USER,RH_LINE) VALUES (@REELID,@ACTION,GETDATE(),@USER,
           @LINENUMBER)
         END
  SET @cnt=@cnt+1;
 SET  @FROMREELNUMBER=@FROMREELNUMBER+1
  END

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTGSMMASTER]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTHISTORY]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLINEFORUPDATE]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLINESFORWEB]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOCATIONDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
	
	
	SELECT * FROM tbllocationsnew	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOCATIONDETAILSNEW]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[SP_SELECTLOCATIONDETAILSNEW] 
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOTWISEREPORT]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOTWISEREPORTNEW]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOWERINGORDERREPORT]    Script Date: 28-01-2020 14:36:30 ******/
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
	@TOMACHINENUMBER  NUMERIC(18,0),
	@FLAGT VARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;


	IF (@FLAGT='ALL')
	 BEGIN
	 SELECT TOP 1000  TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_REELS.R_SIZE, 
		
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
	
		SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 0 ELSE 1 END) as[COMPLETED REELS],
	
			SUM(TBL_REELS.R_WEIGHT) as[GROSS WEIGHT],
			SUM(TBL_REELS.R_TAREWEIGHT) as[TARE WEIGHT],
			SUM(TBL_REELS.R_NETWEIGHT) as[NET WEIGHT],

	SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 1 ELSE 0 END) as[PENDING REELS]


	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID  WHERE R_WEIGHT IS NOT NULL
	GROUP BY TBL_REELS.R_SIZE,TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM
  END
  ELSE
  BEGIN
	  SELECT   TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_REELS.R_SIZE, 
		
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
	
		SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 0 ELSE 1 END) as[COMPLETED REELS],
	
			SUM(TBL_REELS.R_WEIGHT) as[GROSS WEIGHT],
			SUM(TBL_REELS.R_TAREWEIGHT) as[TARE WEIGHT],
			SUM(TBL_REELS.R_NETWEIGHT) as[NET WEIGHT],

	SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 1 ELSE 0 END) as[PENDING REELS]


	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID  WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) ) AND 
	R_MACHINENUMBER BETWEEN @FROMMACHINENUMBER AND @TOMACHINENUMBER AND R_WEIGHT IS NOT NULL
	GROUP BY TBL_REELS.R_SIZE,TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM
				END
	END






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTLOWERINGORDERREPORTNEW]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[SP_SELECTLOWERINGORDERREPORTNEW] 
	-- Add the parameters for the stored procedure here
	@FROMDATE VARCHAR(50),
	@TODATE VARCHAR(50),
	@FROMMACHINENUMBER NUMERIC(18,0),
	@TOMACHINENUMBER  NUMERIC(18,0)

AS
BEGIN

	SET NOCOUNT ON;


	 SELECT   TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_QULAITYCODE,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_REELS.R_SIZE, 
	
		ROW_NUMBER() OVER(PARTITION BY TBL_PRODUCTIONORDER.PO_QUALITY  ORDER BY TBL_PRODUCTIONORDER.PO_ROLLID  ) as[Header], 
	  ROW_NUMBER() OVER(PARTITION BY TBL_PRODUCTIONORDER.PO_QUALITY  ORDER BY TBL_PRODUCTIONORDER.PO_ROLLID desc) as[Footer], 
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
	
	
			SUM(CONVERT(NUMERIC(18,0),ISNULL(TBL_REELS.R_WEIGHT,0))) as[GROSS WEIGHT],
			CONVERT(NUMERIC(18,1),((SUM(CONVERT(NUMERIC(18,1),ISNULL(TBL_REELS.R_TAREWEIGHT,0)))/(COUNT(TBL_REELS.R_REELID))))) as[TARE RATE],
			SUM(CONVERT(NUMERIC(18,1),ISNULL(TBL_REELS.R_TAREWEIGHT,0)))as[TARE WEIGHT],
			SUM(CONVERT(NUMERIC(18,1),ISNULL(TBL_REELS.R_NETWEIGHT,0))) as[NET WEIGHT]

	


	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID and PO_SIZE=R_SIZE and PO_MACHINENUMBER=R_MACHINENUMBER WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) ) AND 
	R_MACHINENUMBER BETWEEN @FROMMACHINENUMBER AND @TOMACHINENUMBER AND R_WEIGHT IS NOT NULL
	GROUP BY TBL_PRODUCTIONORDER.PO_QULAITYCODE, TBL_REELS.R_SIZE,TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM
			
	END

	--
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTMONTHWISEREPORTFORDASHBOARD]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTPACKEDANDBALANCEDREELS]    Script Date: 28-01-2020 14:36:30 ******/
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
	
	  SELECT  TBL_PRODUCTIONORDER.PO_ROLLID,
	  TBL_PRODUCTIONORDER.PO_QUALITY,
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN,
	  TBL_PRODUCTIONORDER.PO_GSM,
  		TBL_PRODUCTIONORDER.PO_SIZE as [R_SIZE], 
		COUNT(TBL_REELS.R_REELID) as[TOTAL REELS],	
		TBL_PRODUCTIONORDER.PO_ORDEREDQTY ,
		SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 0 ELSE 1 END) as[COMPLETED REELS],
		
			SUM(TBL_REELS.R_WEIGHT) as[TOTAL QTY],

	SUM(CASE WHEN TBL_REELS.R_WEIGHT IS NULL THEN 1 ELSE 0 END) as[PENDING REELS]

	FROM TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON  TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID  WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) )
GROUP BY TBL_PRODUCTIONORDER.PO_ROLLID,TBL_PRODUCTIONORDER.PO_SIZE,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_PRODUCTIONORDER.PO_COLOURGRAIN,TBL_PRODUCTIONORDER.PO_GSM,TBL_PRODUCTIONORDER.PO_ORDEREDQTY
	
  
	  
				END
	
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTPOFORWEB]    Script Date: 28-01-2020 14:36:30 ******/
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

	
FROM TBL_PRODUCTIONORDER   ORDER BY PO_SERIALNUMBER DESC
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

	
FROM TBL_PRODUCTIONORDER ORDER BY PO_SERIALNUMBER DESC
	END


	
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTPREFIXMASTER]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTQCMASTERDATA]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTQUALITYDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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


declare @shift nvarchar(20)
set @shift = dbo.GETSHIFT()
declare @mydate datetime
set @mydate = GETDATE()


DECLARE @CURHOUR DATETIME
SET @CURHOUR=(SELECT DATEPART(HOUR, GETDATE()))

if( @CURHOUR>23)
begin
set @shift ='C1'
end

if @shift ='C'
begin
set @mydate = dateadd( day ,-1, @mydate)
end

else if( @shift ='C1')
begin
set @mydate = getdate()
end

Declare @Reel nvarchar(20)
Declare @Prefix nvarchar(10)
Set @Reel= (select distinct R_ROLLID from TBL_REELS where R_REELID = @REELID)
SET @Prefix=(SELECT distinct PO_LOTPREFIX from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel )
Declare @Qual nvarchar(20)
Set @Qual =(select distinct PO_QUALITY from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel)

Declare @PrintLot nvarchar(10)

if(@Qual='WESCO MICR' and @Prefix='')
begin
Set @PrintLot='W'
END

ELSE 
begin
set @PrintLot=(select distinct PO_LOTPREFIX from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel)
end
Declare @colour nvarchar(20)
set @colour = ( select distinct PO_COLOURGRAIN from TBL_PRODUCTIONORDER   where PO_ROLLID=@Reel  )

if(@colour = 'DEFAULT')
begin
set @colour = ''
end

declare @Quality nvarchar(100)
set @Quality =(select distinct PO_QUALITY from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel) +' ' + @colour






	DECLARE @SIZE VARCHAR(50)
SET @SIZE=(SELECT top 1 R_ACTUALSIZE FROM TBL_REELS WHERE R_REELID=@REELID)

	select TR.R_REELID AS [REELID],TS.PO_ROLLID AS [LOT NO], @Quality AS[QUALITY],TS.PO_SIZE AS [SIZE] ,@PrintLot as [Prefix],
	TS.PO_GSM AS [GSM], @mydate AS [MFG],TR.R_SHIFT AS [SHIFT] from TBL_REELS TR inner join TBL_PRODUCTIONORDER TS  
ON tr.R_ROLLID=TS.PO_ROLLID AND TR.R_REELID=@REELID AND PO_SIZE=@SIZE ORDER BY R_ID ASC


UPDATE  TBL_REELS  SET R_STATUS='PRINTED' WHERE  R_REELID=@REELID
	
	END
	






	

	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILSFORDASHBOARD]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELDETAILSHISTORY]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELHISTORY]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREELSDETAILSFORREPORT]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTREPORTFORINVENTORYFINAL]    Script Date: 28-01-2020 14:36:30 ******/
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
,R_USERNAME AS[USERNAME]
,TBL_REELS.R_REELSNOFORPRINT AS [RSN],
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
  SELECT TOP 1000 ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_ID asc )  AS [ID]
 
 ,TBL_PRODUCTIONORDER.PO_ROLLID AS [LOT NUMBER],
TBL_PRODUCTIONORDER.PO_SIZE AS [SIZE],
TBL_PRODUCTIONORDER.PO_QUALITY AS [QUALITY],
TBL_PRODUCTIONORDER.PO_GSM AS [GSM]
,TBL_REELS.R_SHIFT AS [SHIFT]
,TBL_REELS.R_REELSNOFORPRINT AS [RSN]
,TBL_REELS.R_MACHINENUMBER AS [MACHINE NUMBER]
,TBL_REELS.R_REELID AS [REEL ID]
, TBL_REELS.R_WEIGHT AS [WEIGHT]
,R_USERNAME AS[USERNAME],
TBL_REELS.R_STATUS  AS [STATUS]
,TBL_REELS.R_DATETIME AS  [TIME STAMP]
from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID AND 
TBL_PRODUCTIONORDER.PO_SIZE=TBL_REELS.R_ACTUALSIZE
WHERE  TBL_REELS.R_NOOFPRINTS>0 AND  R_FLAGTODELETE=1  ORDER BY R_DATETIME Desc
	END
	END


	

	END




GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTROLLETAILSFORWEB]    Script Date: 28-01-2020 14:36:30 ******/
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
SELECT * FROM TBL_REELS WHERE R_ROLLID=@ROLLID AND R_SIZE=@SIZE And R_WEIGHT is null ORDER BY R_ID DESC    --Added weight is null

END

	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTSEQWISEREPORT]    Script Date: 28-01-2020 14:36:30 ******/
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


  
	SELECT   TBL_PRODUCTIONORDER.PO_QUALITY as[Quality],TBL_PRODUCTIONORDER.PO_COLOURGRAIN as [Colour],TBL_PRODUCTIONORDER.PO_GSM as [GSM],  R_ROLLID as [Lot_No], R_SIZE as[Size], ROW_NUMBER() OVER

            (PARTITION BY R_ROLLID, R_ACTUALSIZE
             ORDER BY R_ROLLID) AS [RW_NO] ,R_REELSNOFORPRINT AS [Serial No],R_WEIGHT  as [wt],R_TAREWEIGHT as [Tare_wt],
R_NETWEIGHT as[Net_wt]	FROM TBL_REELS  INNER JOIN TBL_PRODUCTIONORDER ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID and PO_SIZE=R_SIZE
	 WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) ) AND 
	R_REELSNO BETWEEN @FROMREELSERIALNO AND @TOREELSERIALNUMBER 
	order by R_REELSNO asc
	
	

--	Select TBL_PRODUCTIONORDER.PO_QUALITY, TBL_REELS.R_ROLLID, TBL_REELS.R_ACTUALSIZE , TBL_REELS.R_REELID ,TBL_REELS.R_REELSNOFORPRINT ,ROW_NUMBER() OVER

--            (PARTITION BY TBL_REELS.R_ROLLID, TBL_REELS.R_ACTUALSIZE
--             ORDER BY TBL_REELS.R_ROLLID),TBL_REELS.R_WEIGHT,TBL_REELS.R_TAREWEIGHT,
--TBL_REELS.R_NETWEIGHT from TBL_PRODUCTIONORDER INNER JOIN TBL_REELS ON TBL_REELS.R_ROLLID =TBL_PRODUCTIONORDER.PO_ROLLID
-- WHERE (CONVERT(date, R_DATETIME) BETWEEN CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE) ) AND 
--	R_REELSNO BETWEEN @FROMREELSERIALNO AND @TOREELSERIALNUMBER 
--	order by R_REELSNO asc



	END


GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTSEQWISEREPORTNEW]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[SP_SELECTSEQWISEREPORTNEW] 
	-- Add the parameters for the stored procedure here
	@FROMDATE VARCHAR(50),
	@TODATE VARCHAR(50),
	@FROMREELNUMBER NUMERIC(18,0),
	@TOREELNUMBER NUMERIC(18,0)
	
	
AS
BEGIN

	SET NOCOUNT ON;
	

		
	  BEGIN

	  SELECT ROW_NUMBER() OVER(ORDER BY TBL_REELS.R_REELSNO ) as[ID], 
	  	  ROW_NUMBER() OVER(PARTITION BY TBL_REELS.R_REELSNO  ORDER BY TBL_REELS.R_REELSNO ) as[Header], 
	  ROW_NUMBER() OVER(PARTITION BY TBL_REELS.R_REELSNO  ORDER BY TBL_REELS.R_REELSNO desc) as[Footer], 
	  TBL_PRODUCTIONORDER.PO_QUALITY as[QUALITY],
	  TBL_PRODUCTIONORDER.PO_GSM as[GSM],
	  TBL_PRODUCTIONORDER.PO_COLOURGRAIN as[COLOR],
	  TBL_REELS.R_ROLLID as[LOT NUMBER],
	  TBL_REELS.R_REELSNOFORPRINT as[REEL SERAIL NUMBER],
	  TBL_REELS.R_ACTUALSIZE AS [SIZE],
	  TBL_REELS.R_REPROCESS AS [REPROCESS],
	  	CONVERT(NUMERIC(18,0),ISNULL(TBL_REELS.R_WEIGHT,0)) as [GROSS WEIGHT]  ,
	  
	CONVERT(NUMERIC(18,1),ISNULL(TBL_REELS.R_NETWEIGHT,0)) as [R_NETWEIGHT]  ,
	CONVERT(NUMERIC(18,1),ISNULL(TBL_REELS.R_TAREWEIGHT,0)) as [R_TAREWEIGHT]  ,
	
	CONVERT(NUMERIC(18,1),(  SUM(ISNULL(TBL_REELS.R_NETWEIGHT,0)) OVER (PARTITION BY TBL_REELS.R_ROLLID  ORDER BY TBL_REELS.R_REELSNO))) [SUMV],
	  SUBSTRING(SUBSTRING(TBL_REELS.R_REELID,CHARINDEX('-',TBL_REELS.R_REELID)+2,100),CHARINDEX('-',SUBSTRING(TBL_REELS.R_REELID,CHARINDEX('-',TBL_REELS.R_REELID)+2,100))+1,100) AS [RW NO],
	   R_WEIGHTCAPUREDTIME as [TIMESTAMP]
	   FROM TBL_REELS  INNER JOIN TBL_PRODUCTIONORDER ON TBL_PRODUCTIONORDER.PO_ROLLID=TBL_REELS.R_ROLLID and PO_SIZE=R_ACTUALSIZE
	  WHERE  CONVERT(date, R_WEIGHTCAPUREDTIME) BETWEEN 
	   CONVERT(DATE,  @FROMDATE) AND CONVERT(DATE,  @TODATE)  AND TBL_REELS.R_REELSNO BETWEEN @FROMREELNUMBER AND @TOREELNUMBER
	   ORDER BY TBL_REELS.R_REELSNO 

				END
				END
GO
/****** Object:  StoredProcedure [dbo].[SP_SELECTTAREWEIGHTMASTERDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTUSERFORUPDATE]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_SELECTUSERFORWEB]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBL_REELS_SELECTREEL]    Script Date: 28-01-2020 14:36:30 ******/
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
        SELECT  TBL_REELS.R_SIZE,TBL_REELS.R_ROLLID,TBL_PRODUCTIONORDER.PO_QUALITY,TBL_REELS.R_REELID,TBL_PRODUCTIONORDER.PO_GSM, CONVERT (NUMERIC(18,0), TBL_REELS.R_WEIGHT) AS[R_WEIGHT] FROM dbo.TBL_REELS INNER JOIN dbo.TBL_PRODUCTIONORDER ON  PO_ROLLID = R_ROLLID WHERE R_REELID = @REELID ORDER BY R_ID DESC ;
END

--TBL_PRODUCTIONORDER.PO_GSM




GO
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTHISTORY]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLINEDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLOGINDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTLOTNUMBERS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTPRODUCTIONORDERS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLINSERTQCMASTERDATA]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLLOGINSELECTUSER]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLUPDATELOGINDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TBLUPDATETAREMASTER]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_TestLabel]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_TestLabel]
@REELID VARCHAR(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @shift nvarchar(20)
set @shift = dbo.GETSHIFT()
declare @mydate datetime
set @mydate = GETDATE()
if @shift ='C'
 
begin
set @mydate = dateadd( day ,-1, @mydate)

end

Declare @Reel nvarchar(20)
Declare @Prefix nvarchar(10)
Set @Reel= (select distinct R_ROLLID from TBL_REELS where R_REELID = @REELID)
SET @Prefix=(SELECT distinct PO_LOTPREFIX from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel )
Declare @Qual nvarchar(20)
Set @Qual =(select distinct PO_QUALITY from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel)

Declare @PrintLot nvarchar(10)

if(@Qual='WESCO MICR' and @Prefix='')
begin
Set @PrintLot='W'
END

ELSE 
begin
set @PrintLot=(select distinct PO_LOTPREFIX from TBL_PRODUCTIONORDER where PO_ROLLID=@Reel)
end


	DECLARE @SIZE VARCHAR(50)
SET @SIZE=(SELECT top 1 R_ACTUALSIZE FROM TBL_REELS WHERE R_REELID=@REELID)

	select TR.R_REELID AS [REELID],TS.PO_ROLLID AS [LOT NO],TS.PO_QUALITY AS[QUALITY],TS.PO_SIZE AS [SIZE] ,@PrintLot as [Prefix],
	TS.PO_GSM AS [GSM], @mydate AS [MFG],TR.R_SHIFT AS [SHIFT] from TBL_REELS TR inner join TBL_PRODUCTIONORDER TS  
ON tr.R_ROLLID=TS.PO_ROLLID AND TR.R_REELID=@REELID AND PO_SIZE=@SIZE ORDER BY R_ID ASC


UPDATE  TBL_REELS  SET R_STATUS='PRINTED' WHERE  R_REELID=@REELID
	
	END
	
GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateFormSizeWeight]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateFormSizeWeight]

@Size nvarchar(20),
@Weight numeric(18,1),
@ReelID nvarchar(20)


As
declare @Sno nvarchar(20)
Set @Sno = (Select max(R_REELSNOFORPRINT) from TBL_REELS where R_REELID=@ReelID )


declare @Tare numeric(18,1)
set @Tare = (Select R_TAREWEIGHT from TBL_REELS where R_REELID=@ReelID and R_REELSNOFORPRINT=@Sno)


declare @FinalWeight numeric(18,1)
set @FinalWeight = @Weight - @Tare




begin
----------------------------------------------------
if(@Size <>'' and @Weight is not null)
begin
Update TBL_REELS
set R_SIZE=@Size ,R_WEIGHT=@Weight ,R_NETWEIGHT=@FinalWeight
where R_REELID=@ReelID and R_REELSNOFORPRINT=@Sno
end

-------------------------------------------------
ELSE if(@Size ='' and @Weight is not null)
begin
Update TBL_REELS
set R_WEIGHT=@Weight , R_NETWEIGHT=@FinalWeight
where R_REELID=@ReelID and R_REELSNOFORPRINT=@Sno
end

-------------------------------------------------
ELSE if(@Size <>'' and @Weight is null)
begin
Update TBL_REELS
set R_SIZE=@Size
where R_REELID=@ReelID and R_REELSNOFORPRINT=@Sno
end


end


GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATELASTLOGEEDINTIME]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATELINEDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATELOGINSTATUS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UPDATEPRINTCOUNT]    Script Date: 28-01-2020 14:36:30 ******/
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

	SELECT @CURRENTCOUNT=R_NOOFPRINTS FROM TBL_REELS WHERE R_REELID=@REELNUMBER and R_WEIGHT is null			--weight is null
	IF @CURRENTCOUNT=NULL
	BEGIN
SET 	@CURRENTCOUNT=0;
	END
	SET @CURRENTCOUNT=@CURRENTCOUNT+1;
	UPDATE TBL_REELS SET R_NOOFPRINTS=@CURRENTCOUNT WHERE R_REELID=@REELNUMBER
	UPDATE TBL_REELS SET R_DATETIME=GETDATE(), R_USERNAME=@USER
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATEREELWEIGHT]    Script Date: 28-01-2020 14:36:30 ******/
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
	@LINENO VARCHAR(50),
	@LineWeight int
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
DECLARE @REELSIZE VARCHAR(50)
SET @REELSIZE=(SELECT TOP 1  R_SIZE FROM TBL_REELS WHERE R_REELID=@REELID)
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
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='MICR')
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
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='BC')
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
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='DC')
	 	  END
-----------------------------------------------------------------------------------------------------------
	   ELSE  IF (@TYPE='MARKET')	  BEGIN
	  
	     IF (@LINENUMBER='1') BEGIN
		  IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE ) 
		  BEGIN
	  	   SET @SN= 200000
		  END
		  ELSE 
		  BEGIN
			 SET @SN=(SELECT MAX(ISNULL(R_REELSNO,200000)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE)
		   END
		   END
	
	 ELSE  IF (@LINENUMBER='2') 
BEGIN
	  IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE AND (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ))
	  BEGIN
	   SET @SN= 0 
	   END
ELSE 
BEGIN
  SET @SN=(SELECT MAX(ISNULL(R_REELSNO,0)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX AND R_TYPE=@TYPE AND  (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ))END
END
   SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='MARKET')
END
  -------------------------------------------------------------------------------------------------------------
	
	 SET @SN=@SN+1;
	 DECLARE @PINTSN VARCHAR(50)
	SET @PINTSN =CONCAT(@PREFIX,'',@SN)
	DECLARE @NETWEIGHT NUMERIC(18,3)
	SET @NETWEIGHT=@WEIGHT-@TAREWEIGHT;
	   UPDATE dbo.TBL_REELS SET R_REELSNO = @SN, R_REELSNOFORPRINT=@PINTSN,R_WEIGHT = @WEIGHT,R_TAREWEIGHT=@TAREWEIGHT,R_NETWEIGHT=@NETWEIGHT, R_WEIGHTCAPUREDTIME=GETDATE() , R_DATETIME=dbo.GETPRODUCTIONDATE() ,R_LINE=@LineWeight WHERE R_REELID = @REELID;
	    
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
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='MICR')
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
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='BC')
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
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='DC')
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
	   END
	   
	 ELSE  IF (@LINENUMBER='2')
	 BEGIN
	 
	   IF NOT EXISTS(SELECT R_REELSNO FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1 AND (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ))
       BEGIN
  SET @SN1= 0
 END
   ELSE
       BEGIN
   SET @SN1=(SELECT MAX(ISNULL(R_REELSNO,0)) FROM TBL_REELS WHERE  R_PREFIX=@PREFIX1 AND R_TYPE=@TYPE1  AND  (R_MACHINENUMBER=4 OR R_MACHINENUMBER=5 ))
   
       END
       END

 
	   SET @TAREWEIGHT=( SELECT MASTERTWEIGHT_TAREWEIGHT FROM TBL_TAREWEIGHTMASTER 
WHERE MASTERTWEIGHT_REELSIZEFROM<=@REELSIZE AND MASTERTWEIGHT_REELSIZETO>=@REELSIZE AND MASTERTWEIGHT_TYPE='MARKET')
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

  UPDATE dbo.TBL_REELS SET R_REELSNO = @SN1, R_REELSNOFORPRINT=@PINTSN1,R_REPROCESS='REPROCESSED',R_WEIGHT=@WEIGHT,R_TAREWEIGHT=@TAREWEIGHT,R_NETWEIGHT=@NETWEIGHT1,R_WEIGHTCAPUREDTIME=GETDATE(), R_DATETIME=dbo.GETPRODUCTIONDATE() ,R_LINE=@LineWeight WHERE R_ID = @MAXID;
	  END
	  	  INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'WEIGHT CAPTURED',@USER,@LINENO)
	    INSERT INTO TBL_REELHISTORY (RH_REELID,RH_ACTION,RH_USER,RH_LINE) VALUES (@REELID,'FINAL LABEL PRINTED',@USER,@LINENO)
END
    

GO
/****** Object:  StoredProcedure [dbo].[SP_UpdateSelectReelDetail]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SP_UpdateSelectReelDetail]

@Reelid nvarchar(20)

As

if exists(Select * from TBL_REELS where R_REELID=@Reelid and R_WEIGHT  is not null and R_REELSNOFORPRINT<>'' )

declare @Sno nvarchar(20)
Set @Sno = (Select max(R_REELSNOFORPRINT) from TBL_REELS where R_REELID=@Reelid ) 
begin

Select  R_REELSNOFORPRINT , R_SIZE ,CONVERT (NUMERIC(18,0), R_WEIGHT) as [R_WEIGHT] from TBL_REELS where R_REELID=@Reelid and R_REELSNOFORPRINT=@Sno

end




GO
/****** Object:  StoredProcedure [dbo].[Sp_UpdateSerialNoTestApplication]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Sp_UpdateSerialNoTestApplication]

@OldSn int,
@OldPre nvarchar(20),
@NewSn int,
@newPre nvarchar(20)


as
begin

 set nocount on
update TBL_REELS
set R_REELSNO =@NewSn , R_REELSNOFORPRINT=@newPre


where R_REELSNO =@OldSn and R_REELSNOFORPRINT=@OldPre


end
GO
/****** Object:  StoredProcedure [dbo].[SP_UPDATEUSERDETAILS]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SP_UpdateWeightReprocess]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[SP_UpdateWeightReprocess]

(@WEIGHT AS NUMERIC(9,3), @REELID AS VARCHAR(50)
)


as
begin 

set nocount on


end
GO
/****** Object:  StoredProcedure [dbo].[SP_VALIDATEGSM]    Script Date: 28-01-2020 14:36:30 ******/
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
/****** Object:  StoredProcedure [dbo].[SpClearBLPrintnull]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[SpClearBLPrintnull]

as
begin

delete from BL_PRINT where P_REELID='' or P_SERAILNUMBER='' 




set nocount on
 end
GO
/****** Object:  StoredProcedure [dbo].[SPUPDATEAFTERLABELPRINTING]    Script Date: 28-01-2020 14:36:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE     PROCEDURE [dbo].[SPUPDATEAFTERLABELPRINTING] 
	@REELID VARCHAR(50)
	
 AS
BEGIN
	
	SET NOCOUNT ON;

	UPDATE tblPrintLabel SET P_FLAG=0 WHERE P_REELID=@REELID

	DECLARE @PRINTCOUNT INT;
	SET @PRINTCOUNT =(SELECT R_NOOFPRINTS FROM TBL_REELS WHERE R_REELID=@REELID)
SET @PRINTCOUNT =@PRINTCOUNT +1;


	UPDATE TBL_REELS SET R_NOOFPRINTS=@PRINTCOUNT WHERE R_REELID=@REELID
	
	END
	






GO
/****** Object:  StoredProcedure [dbo].[SPUPDATEAFTERPRINTING]    Script Date: 28-01-2020 14:36:30 ******/
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
USE [master]
GO
ALTER DATABASE [dbWCPM] SET  READ_WRITE 
GO
