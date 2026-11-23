--DROP/CREATE Database
USE [master]
GO
/****** Object:  Database [LRCH]    Script Date: 2023-12-08 11:55:44 AM ******/
-- Make sure to set the database to single user mode to drop existing connections
ALTER DATABASE [LRCH] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Drop the database
DROP DATABASE IF EXISTS [LRCH];
GO

/****** Object:  Database [LRCH]    Script Date: 2023-12-08 11:55:44 AM ******/
CREATE DATABASE [LRCH]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LRCH', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LRCH.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'LRCH_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\LRCH_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LRCH].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [LRCH] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [LRCH] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [LRCH] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [LRCH] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [LRCH] SET ARITHABORT OFF 
GO

ALTER DATABASE [LRCH] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [LRCH] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [LRCH] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [LRCH] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [LRCH] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [LRCH] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [LRCH] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [LRCH] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [LRCH] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [LRCH] SET  DISABLE_BROKER 
GO

ALTER DATABASE [LRCH] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [LRCH] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [LRCH] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [LRCH] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [LRCH] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [LRCH] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [LRCH] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [LRCH] SET RECOVERY FULL 
GO

ALTER DATABASE [LRCH] SET  MULTI_USER 
GO

ALTER DATABASE [LRCH] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [LRCH] SET DB_CHAINING OFF 
GO

ALTER DATABASE [LRCH] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [LRCH] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO

ALTER DATABASE [LRCH] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [LRCH] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO

ALTER DATABASE [LRCH] SET QUERY_STORE = OFF
GO

ALTER DATABASE [LRCH] SET  READ_WRITE 
GO



-- ADD TABLES TO DATABASE(Without FK restraints)

-- Create Hospital stay fact table 

USE [LRCH]
GO

/****** Object:  Table [dbo].[FCT_Stay]    Script Date: 2023-12-08 11:58:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FCT_Stay](
	[StayID] [int] NOT NULL,
	[Bed] [int] NOT NULL,
	[CostCentreID] [int] NOT NULL,
	[PhysicianID] [int] NOT NULL,
	[PatientID] [int] NOT NULL,
	[ItemCode] [int] NOT NULL,
 CONSTRAINT [PK_FCT_Stay] PRIMARY KEY CLUSTERED 
(
	[StayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Details of the Patients Stay' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FCT_Stay'
GO



-- Create DIM Address
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Address]    Script Date: 2023-12-08 11:58:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Address](
	[AddressID] [int] NOT NULL,
	[Number] [int] NULL,
	[Street] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[Province] [varchar](50) NULL,
	[PostalCode] [varchar](50) NULL,
	[FullAddress] [varchar](500) NOT NULL,
 CONSTRAINT [PK_DIM_Address] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Trigger to combine address parts into full address when its added 
CREATE TRIGGER tr_DIM_Address_SplitAddress
ON [dbo].[DIM_Address]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE da
    SET 
      Number = CASE WHEN CHARINDEX(' ', i.FullAddress) > 0 THEN CAST(SUBSTRING(i.FullAddress, 1, CHARINDEX(' ', i.FullAddress) - 1) AS int) END,
      Street = CASE WHEN CHARINDEX(' ', i.FullAddress) > 0 AND CHARINDEX(',', i.FullAddress) > 0 THEN SUBSTRING(i.FullAddress, CHARINDEX(' ', i.FullAddress) + 1, CHARINDEX(',', i.FullAddress) - CHARINDEX(' ', i.FullAddress) - 1) END,
      City = CASE WHEN CHARINDEX(',', i.FullAddress) + 1 > 0 AND CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) > 0 THEN SUBSTRING(i.FullAddress, CHARINDEX(',', i.FullAddress) + 2, CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) - CHARINDEX(',', i.FullAddress) - 2) END,
      Province = CASE WHEN CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) + 2 > 0 AND CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) + 1) > 0 THEN SUBSTRING(i.FullAddress, CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) + 2, CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) + 1) - CHARINDEX(',', i.FullAddress, CHARINDEX(',', i.FullAddress) + 1) - 2) END,
      PostalCode = CASE WHEN LEN(i.FullAddress) >= 6 THEN SUBSTRING(i.FullAddress, LEN(i.FullAddress) - 6 + 1, 6) END
    FROM [DIM_Address] da
    INNER JOIN inserted i ON da.AddressID = i.AddressID;
END;
GO



-- Create DIM Admission
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Admission]    Script Date: 2023-12-08 11:59:18 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Admission](
	[AdmissionDate] [int] NOT NULL,
	[DateID] [int] NOT NULL,
 CONSTRAINT [PK_DIM_Admission] PRIMARY KEY CLUSTERED 
(
	[AdmissionDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- Create DIM Bed
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Bed]    Script Date: 2023-12-08 11:59:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Bed](
	[Bed] [int] NOT NULL,
	[Occupied] [bit] NOT NULL,
	[PatientID] [int] NULL,
	[BedLetter] [varchar](1) NULL
 CONSTRAINT [PK_DIM_Bed] PRIMARY KEY CLUSTERED 
(
	[Bed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- Create DIM Cost Centre

USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_CostCentre]    Script Date: 2023-12-08 12:00:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_CostCentre](
	[CostCentreID] [int] NOT NULL,
	[Department] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DIM_CostCentre] PRIMARY KEY CLUSTERED 
(
	[CostCentreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- Create DIM Date
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Date]    Script Date: 2023-12-08 12:00:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Date](
	[DateID] [int] NOT NULL,
	[_Day] [int] NULL,
	[_Month] [varchar](50) NULL,
	[_Year] [int] NULL,
	[FullDate] [Date] NOT NULL
 CONSTRAINT [PK_DIM_Date_1] PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] 
GO

USE [LRCH]
GO

CREATE TRIGGER tr_DIM_Date_FullDate
ON [dbo].[DIM_Date]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE d
    SET
        [_Day] = DAY(i.[FullDate]),
        [_Month] = DATENAME(MONTH, i.[FullDate]),
        [_Year] = YEAR(i.[FullDate])
    FROM [dbo].[DIM_Date] d
    INNER JOIN inserted i ON d.[DateID] = i.[DateID];
END;
GO


-- CREATE DIM Department
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Department]    Script Date: 2023-12-08 12:00:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Department](
	[Department] [varchar](50) NOT NULL,
	[Description] [varchar](255) NULL,
 CONSTRAINT [PK_DIM_Department] PRIMARY KEY CLUSTERED 
(
	[Department] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- CREATE DIM DISCHARGE

USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Discharge]    Script Date: 2023-12-08 12:01:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Discharge](
	[DischargeDate] [int] NOT NULL,
	[DateID] [int] NOT NULL,
 CONSTRAINT [PK_DIM_Discharge] PRIMARY KEY CLUSTERED 
(
	[DischargeDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- CREATE DIM ITEM
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Item]    Script Date: 2023-12-08 12:01:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Item](
	[ItemCode] [int] NOT NULL,
	[Description] [varchar](50) NULL,
	[Price] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_DIM_Item] PRIMARY KEY CLUSTERED 
(
	[ItemCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- CREATE DIM PATIENT
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Patient]    Script Date: 2023-12-08 12:02:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Patient](
	[PatientID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[HCN] [varchar](50) NULL,
	[AdmissionDate] [int] NOT NULL,
	[DischargeDate] [int] NULL,
	[FinancialStatus] [varchar](50) NOT NULL,
	[Note] [varchar](1000) NULL,
 CONSTRAINT [PK_DIM_Patient] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- CREATE DIM PERSON
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Person]    Script Date: 2023-12-08 12:02:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Person](
	[PersonID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[Telephone] [varchar](50) NULL,
	[Sex] [varchar](50) NULL,
	[AddressID] [int] NULL,
 CONSTRAINT [PK_DIM_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- CREATE DIM PHYSICIAN
USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Physician]    Script Date: 2023-12-08 12:02:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Physician](
	[PhysicianID] [int] NOT NULL,
	[Specialty] [varchar](50) NULL,
	[PersonID] [int] NOT NULL,
 CONSTRAINT [PK_DIM_Physician] PRIMARY KEY CLUSTERED 
(
	[PhysicianID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- CREATE DIM ROOM

USE [LRCH]
GO

/****** Object:  Table [dbo].[DIM_Room]    Script Date: 2023-12-08 12:03:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DIM_Room](
	[RoomID] [int] NOT NULL,
	[RoomNumber] [int] NOT NULL,
	[Floor] [int] NOT NULL,
	[Wing] [varchar](50) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Bed] [int] NOT NULL,
 CONSTRAINT [PK_DIM_Room] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- ADD FOREIGN KEY RESTRAINS 

-- FCT Stay Forign keys
use LRCH;
ALTER TABLE [dbo].[FCT_Stay]
ADD CONSTRAINT FK_Stay_Bed
FOREIGN KEY (Bed)
REFERENCES DIM_Bed (Bed);

use LRCH;
ALTER TABLE [dbo].[FCT_Stay]
ADD CONSTRAINT FK_Stay_PhysicianID
FOREIGN KEY (PhysicianID)
REFERENCES DIM_Physician (PhysicianID);

use LRCH;
ALTER TABLE [dbo].[FCT_Stay]
ADD CONSTRAINT FK_Stay_CostCentre
FOREIGN KEY (CostCentreID)
REFERENCES DIM_CostCentre (CostCentreID);

use LRCH;
ALTER TABLE [dbo].[FCT_Stay]
ADD CONSTRAINT FK_Stay_PatientID
FOREIGN KEY (PatientID)
REFERENCES DIM_Patient (PatientID);

ALTER TABLE [dbo].[FCT_Stay]
ADD CONSTRAINT FK_STAY_ItemCode
FOREIGN KEY (ItemCode)
REFERENCES DIM_ITEM (ItemCode);


-- DIM_Physician FK
use LRCH;
ALTER TABLE [dbo].[DIM_Physician]
ADD CONSTRAINT FK_Physician_PersonID
FOREIGN KEY (PersonID)
REFERENCES DIM_Person (PersonID);

-- DIM_Person FK
use LRCH;
ALTER TABLE [dbo].[DIM_Person]
ADD CONSTRAINT FK_Person_AddressID
FOREIGN KEY (AddressID)
REFERENCES DIM_Address (AddressID);

--DIM PATIENT FKs
use LRCH;
ALTER TABLE [dbo].[DIM_Patient]
ADD CONSTRAINT FK_Patient_PersonID
FOREIGN KEY (PersonID)
REFERENCES DIM_Person (PersonID);


use LRCH;
ALTER TABLE [dbo].[DIM_Patient]
ADD CONSTRAINT FK_Patient_AdmissionDate
FOREIGN KEY (AdmissionDate)
REFERENCES DIM_Admission (AdmissionDate);

use LRCH;
ALTER TABLE [dbo].[DIM_Patient]
ADD CONSTRAINT FK_Patient_DischargeDate
FOREIGN KEY (DischargeDate)
REFERENCES DIM_Discharge (DischargeDate);

-- DIM DischargeDate FK
use LRCH;
ALTER TABLE [dbo].[DIM_Discharge]
ADD CONSTRAINT FK_Discharage_DateID
FOREIGN KEY (DateID)
REFERENCES DIM_Date (DateID);

-- DIM AdmissionDate FK
use LRCH;
ALTER TABLE [dbo].[DIM_Admission]
ADD CONSTRAINT FK_Admission_DateID
FOREIGN KEY (DateID)
REFERENCES DIM_Date (DateID);

-- DIM Room FK
use LRCH;
ALTER TABLE [dbo].[DIM_Room]
ADD CONSTRAINT FK_Room_Bed
FOREIGN KEY (Bed)
REFERENCES DIM_Bed (Bed);

-- CostCentre FK
use LRCH;
ALTER TABLE [dbo].[DIM_CostCentre]
ADD CONSTRAINT FK_CostCentre_Department
FOREIGN KEY (Department)
REFERENCES DIM_Department (Department);


-- DATA INSERTS


USE LRCH;

INSERT INTO [DIM_Date] (DateID, FullDate)
VALUES
  (1, '2024-06-05'),
  (2, '2022-11-22'),
  (3, '2023-01-07'),
  (4, '2024-11-02'),
  (5, '2024-11-14'),
  (6, '2024-12-01'),
  (7, '2021-05-13'),
  (8, '2022-07-22'),
  (9, '2023-12-22'),
  (10, '2022-10-20'),
  (11, '2022-08-19'),
  (12, '2021-09-18'),
  (13, '2021-09-27'),
  (14, '2021-11-11'),
  (15, '2022-11-30'),
  (16, '2020-11-19'),
  (17, '2021-03-23'),
  (18, '2022-02-09'),
  (19, '2022-11-23'),
  (20, '2023-05-13'),
  (21, '2021-07-07'),
  (22, '2021-05-29'),
  (23, '2021-09-30'),
  (24, '2021-05-08'),
  (25, '2023-09-30'),
  (26, '2022-11-11'),
  (27, '2022-07-31'),
  (28, '2023-11-28'),
  (29, '2024-01-13'),
  (30, '2021-11-19'),
  (31, '2022-01-14'),
  (32, '2024-02-14'),
  (33, '2023-08-29'),
  (34, '2023-09-21'),
  (35, '2021-02-01'),
  (36, '2022-11-22'),
  (37, '2023-02-07'),
  (38, '2021-04-15'),
  (39, '2021-04-29'),
  (40, '2024-06-30'),
  (41, '2024-07-06'),
  (42, '2023-11-17'),
  (43, '2023-10-17'),
  (44, '2022-05-27'),
  (45, '2023-12-31'),
  (46, '2021-10-26'),
  (47, '2023-07-02'),
  (48, '2021-02-14'),
  (49, '2023-11-24'),
  (50, '2022-08-05'),
  (51, '2023-11-22'),
  (52, '2022-05-28'),
  (53, '2023-02-25'),
  (54, '2023-01-26'),
  (55, '2021-06-30'),
  (56, '2023-05-12'),
  (57, '2021-09-22'),
  (58, '2022-11-18'),
  (59, '2023-05-29'),
  (60, '2024-06-19');



INSERT INTO [DIM_Discharge] (DischargeDate, DateID)
VALUES
  (1,1),
  (2,2),
  (3,3),
  (4,4),
  (5,5),
  (6,6),
  (7,7),
  (8,8),
  (9,9),
  (10,10),
  (11,11),
  (12,12),
  (13,13),
  (14,14),
  (15,15),
  (16,16),
  (17,17),
  (18,18),
  (19,19),
  (20,20),
  (21,21),
  (22,22),
  (23,23),
  (24,24),
  (25,25),
  (26,26),
  (27,27),
  (28,28),
  (29,29),
  (30,30);


  INSERT INTO [DIM_Admission] (AdmissionDate,DateID)
VALUES
  (31,31),
  (32,32),
  (33,33),
  (34,34),
  (35,35),
  (36,36),
  (37,37),
  (38,38),
  (39,39),
  (40,40),
  (41,41),
  (42,42),
  (43,43),
  (44,44),
  (45,45),
  (46,46),
  (47,47),
  (48,48),
  (49,49),
  (50,50),
  (51,51),
  (52,52),
  (53,53),
  (54,54),
  (55,55),
  (56,56),
  (57,57),
  (58,58),
  (59,59),
  (60,60);

  use LRCH;



  INSERT INTO [DIM_Address] (AddressID, FullAddress)
VALUES
  (1, '123 Main St, Toronto, Ontario, A1B 2C3'),
  (2, '456 Oak St, Vancouver, British Columbia, I0Y 1Z2'),
  (3, '789 Maple St, Montreal, Quebec, H3K 4L5'),
  (4, '321 Pine St, Calgary, Alberta, M5N 6P7'),
  (5, '654 Cedar St, Ottawa, Ontario, J8R 9T1'),
  (6, '987 Elm St, Edmonton, Alberta, V2W 3X4'),
  (7, '135 Birch St, Halifax, Nova Scotia, B5E 6F7'),
  (8, '246 Willow St, Winnipeg, Manitoba, U9I 1O2'),
  (9, '579 Spruce St, Quebec City, Quebec, Q3S 4D5'),
  (10, '753 Fir St, Regina, Saskatchewan, G6H 7J8'),
  (11, '864 Pine St, St. Johns, Newfoundland and Labrador, K9L 1M2'),
  (12, '159 Cedar St, Victoria, British Columbia, Y3Z 4A5'),
  (13, '264 Maple St, Charlottetown, PEI, 6C4 7V8'),
  (14, '837 Oak St, Yellowknife, Northwest, L0K 1R0'),
  (15, '459 Elm St, Whitehorse, Yukon, R3I 4O5'),
  (16, '623 Birch St, Iqaluit, Nunavut, Q7W 8E9'),
  (17, '951 Willow St, Saskatoon, Saskatchewan, P1A 2S3'),
  (18, '357 Spruce St, Fredericton, New Brunswick, N4D 5F6'),
  (19, '682 Fir St, Moncton, New Brunswick, B7G 8H9'),
  (20, '174 Pine St, Thunder Bay, Ontario, J1K 2L3'),
  (21, '836 Cedar St, Sudbury, Ontario, M4N 5P6'),
  (22, '249 Oak St, London, Ontario, Q7R 8S9'),
  (23, '573 Maple St, Halifax, Nova Scotia, T1U 2V3'),
  (24, '791 Elm St, Winnipeg, Manitoba, W4X 5Y6'),
  (25, '682 Birch St, Quebec City, Quebec, Z7A 8B9'),
  (26, '324 Willow St, Regina, Saskatchewan, C1D 2E3'),
  (27, '975 Spruce St, St. John\s, Newfoundland and Labrador, F4G 5H6'),
  (28, '136 Fir St, Victoria, British Columbia, I7J 8K9'),
  (29, '487 Pine St, Charlottetown, PEI L1M 2N3'),
  (30, '615 Cedar St, Yellowknife, NWT, O4P 5Q6'),
  (31, '123 Main St, Toronto, Ontario, M1A 1A1'),
  (32, '456 Oak St, Vancouver, British Columbia, V1B 2B2'),
  (33, '789 Maple St, Montreal, Quebec, H3C 3C3'),
  (34, '321 Pine St, Calgary, Alberta, T2E 4E4'),
  (35, '654 Cedar St, Ottawa, Ontario, K1G 5G5'),
  (36, '987 Elm St, Edmonton, Alberta, T5J 6J6'),
  (37, '135 Birch St, Halifax, Nova Scotia, B3K 7K7'),
  (38, '246 Willow St, Winnipeg, Manitoba, R2M 8M8'),
  (39, '579 Spruce St, Quebec City, Quebec, G1N 9N9'),
  (40, '753 Fir St, Regina, Saskatchewan, S4S 1S1'),
  (41, '864 Pine St, St. Johns, Newfoundland and Labrador, A1A 2A2'),
  (42, '159 Cedar St, Victoria, British Columbia, V8W 3W3'),
  (43, '264 Maple St, Charlottetown, PEI, C1A 4A4'),
  (44, '837 Oak St, Yellowknife, Northwest, L0K 1R0'),
  (45, '459 Elm St, Whitehorse, Yukon, Y1A 6A6'),
  (46, '623 Birch St, Iqaluit, Nunavut, P0A 7A7'),
  (47, '951 Willow St, Saskatoon, Saskatchewan, S7H 8H8'),
  (48, '357 Spruce St, Fredericton, New Brunswick, E3B 9B9'),
  (49, '682 Fir St, Moncton, New Brunswick, E1C 1C1'),
  (50, '174 Pine St, Thunder Bay, Ontario, P7A 2A2'),
  (51, '836 Cedar St, Sudbury, Ontario, P3E 3E3'),
  (52, '249 Oak St, London, Ontario, N6A 4A4'),
  (53, '573 Maple St, Windsor, Ontario, N9A 5A5'),
  (54, '791 Elm St, Barrie, Ontario, L4M 6M6'),
  (55, '682 Birch St, Oshawa, Ontario, L1G 7G7'),
  (56, '324 Willow St, Hamilton, Ontario, L8N 8N8'),
  (57, '975 Spruce St, Kitchener, Ontario, N2G 9G9'),
  (58, '136 Fir St, Guelph, Ontario, N1H 1H1'),
  (59, '487 Pine St, Waterloo, Ontario, N2L 2L2'),
  (60, '615 Cedar St, Cambridge, Ontario, N1R 3R3');






INSERT INTO [DIM_Person] (PersonID,FirstName,LastName,Telephone,Sex,AddressID,MiddleName)
VALUES
  (1,'Harrison','Talley','(196) 355-5385','Other',1,'Zachary'),
  (2,'Jocelyn','Cherry','1-750-363-2719','Other',2,'Odette'),
  (3,'Connor','Adkins','1-335-578-1836','Other',3,'Marvin'),
  (4,'Merritt','Moreno','1-565-281-0778','Female',4,'Bell'),
  (5,'Jenette','Hobbs','1-217-844-6455','Male',5,'Caleb'),
  (6,'Madeline','Glass','(960) 802-3225','Male',6,'Lisandra'),
  (7,'Medge','Bender','(522) 798-5356','Male',7,'Hanae'),
  (8,'Kiona','Fletcher','1-698-642-3413','Male',8,'Clinton'),
  (9,'Nolan','Coleman','1-316-857-4419','Non-Binary',9,'Roth'),
  (10,'Louis','Leach','(664) 987-4367','Non-Binary',10,'Emerson'),
  (11,'Nadine','Morris','1-878-598-7488','Non-Binary',11,'Jared'),
  (12,'Lesley','Mccarthy','1-332-614-5456','Female',12,'Jacqueline'),
  (13,'Yael','Zimmerman','(645) 575-8567','Male',13,'Alma'),
  (14,'Lucius','Freeman','(686) 325-1144','Non-Binary',14,'Aphrodite'),
  (15,'Randall','Hayes','(182) 606-6439','Other',15,'Hayley'),
  (16,'Aurelia','Martinez','(623) 456-3545','Male',16,'Fatima'),
  (17,'Calvin','Barker','1-220-772-8287','Female',17,'Margaret'),
  (18,'Christen','Romero','1-835-277-7917','Male',18,'Kristen'),
  (19,'Andrew','Vega','1-482-344-0344','Non-Binary',19,'Eugenia'),
  (20,'Jonah','Mccarthy','1-458-413-0338','Other',20,'Gretchen'),
  (21,'Yael','Kane','1-418-507-7826','Non-Binary',21,'Dolan'),
  (22,'Jamalia','Guy','(367) 772-5150','Non-Binary',22,'Signe'),
  (23,'Dahlia','Webster','(525) 706-9853','Non-Binary',23,'Knox'),
  (24,'Keegan','Mccray','1-289-742-6382','Non-Binary',24,'Caesar'),
  (25,'Dominique','Fowler','1-333-226-7188','Female',25,'Fatima'),
  (26,'Dante','Aguirre','1-196-382-1542','Female',26,'Meredith'),
  (27,'Vera','Wilkins','(162) 513-4210','Non-Binary',27,'Ima'),
  (28,'Channing','Kidd','(252) 431-4432','Non-Binary',28,'Jacqueline'),
  (29,'Isabelle','David','(214) 791-1042','Female',29,'Gannon'),
  (30,'Debra','Kim','(768) 814-1404','Female',30,'Colin'),
  (31,'Amy','Burnett','1-706-531-3212','Male',31,'Lara'),
  (32,'Mollie','Pearson','1-256-431-2302','Non-Binary',32,'Brynne'),
  (33,'Rhonda','Sampson','(553) 325-6342','Non-Binary',33,'Hanna'),
  (34,'Harper','Gibson','(953) 293-5316','Other',34,'Deborah'),
  (35,'Jelani','Richardson','1-736-552-2267','Female',35,'Lael'),
  (36,'Shellie','Huber','1-237-638-8186','Non-Binary',36,'Harriet'),
  (37,'Cathleen','Mejia','1-823-472-0305','Male',37,'Rhona'),
  (38,'Hedda','Wall','(441) 385-7468','Male',38,'Elmo'),
  (39,'Shaine','Duffy','(514) 716-5141','Other',39,'Stephen'),
  (40,'Chester','King','1-303-830-2824','Other',40,'Faith'),
  (41,'Carlos','Singleton','(540) 625-9758','Male',41,'Julie'),
  (42,'Raymond','Hoffman','1-116-492-6232','Other',42,'Tamara'),
  (43,'Anika','Fernandez','(858) 837-5104','Female',43,'Benjamin'),
  (44,'Timothy','Craft','(802) 730-5287','Non-Binary',44,'Curran'),
  (45,'Rigel','Hardy','1-837-216-6324','Other',45,'Talon'),
  (46,'Dara','Garner','(395) 522-2575','Other',46,'Ian'),
  (47,'Louis','Luna','1-804-505-5083','Non-Binary',47,'Quynn'),
  (48,'Shafira','Stevens','(662) 431-5230','Non-Binary',48,'Keelie'),
  (49,'Hiroko','Walton','1-809-431-5265','Other',49,'Kimberley'),
  (50,'Hasad','Shelton','(173) 326-6657','Female',50,'Justin'),
  (51,'Zeph','Bean','(237) 405-6384','Other',51,'Zenaida'),
  (52,'Hilel','Ochoa','(291) 693-4423','Male',52,'Venus'),
  (53,'Jolene','Gonzales','1-749-870-2562','Male',53,'Laurel'),
  (54,'Ima','Chandler','1-460-536-1397','Other',54,'Abraham'),
  (55,'Jolie','Christian','(584) 592-6788','Male',55,'Noelle'),
  (56,'Willow','Sheppard','1-648-673-4334','Male',56,'Chester'),
  (57,'Ariana','Mcmillan','1-848-486-5714','Female',57,'Gwendolyn'),
  (58,'Illiana','Estes','1-769-715-5462','Non-Binary',58,'Zane'),
  (59,'Camille','Stephens','1-721-372-3762','Other',59,'Ashton'),
  (60,'Timothy','Sanford','(706) 337-2453','Male',60,'Keiko');





INSERT INTO [DIM_Patient] (PatientID,PersonID,HCN,AdmissionDate,FinancialStatus,DischargeDate,Note)
VALUES
  (1,1,'MKN80TUO0PR',31,'SELF',1,'Curabitur egestas'),
  (2,2,'BXR13HQV4KY',32,'ASSURE',2,'ac mattis velit justo nec'),
  (3,3,'BUY85SVJ4MY',33,'ASSURE',3,'nulla. Integer'),
  (4,4,'BUQ19GSX7NF',34,'ESI',4,'tellus. Phasellus elit pede, malesuada vel, venenatis vel, faucibus'),
  (5,5,'BPM49EPM2QJ',35,'ASSURE',5,'vel sapien imperdiet ornare. In'),
  (6,6,'PUE57MSS2DQ',36,'SELF',6,'urna. Nullam lobortis quam a felis'),
  (7,7,'KOP27LUG2YS',37,'SELF',7,'risus. Duis a'),
  (8,8,'VQU63KJU0TL',38,'ESI',8,'diam vel arcu. Curabitur'),
  (9,9,'YNY01UAX8JU',39,'SELF',9,'ipsum primis in faucibus orci luctus et ultrices posuere'),
  (10,10,'RWO40NWD2GO',40,'SELF',10,'pulvinar arcu et'),
  (11,11,'BIN24XLA3HW',41,'ASSURE',11,'quis, pede. Suspendisse'),
  (12,12,'YMC62QIS8GB',42,'ASSURE',12,'molestie tortor nibh'),
  (13,13,'VVM37UWN5RK',43,'ESI',13,'senectus et netus et malesuada fames ac turpis'),
  (14,14,'AKE83YPD2QO',44,'ASSURE',14,'In lorem. Donec elementum, lorem'),
  (15,15,'QRF15EBD7FF',45,'ESI',15,'imperdiet nec, leo. Morbi neque tellus, imperdiet non, vestibulum nec,'),
  (16,16,'NFY85BKX7VQ',46,'ASSURE',16,'tempor augue ac ipsum. Phasellus vitae mauris sit amet'),
  (17,17,'QWN33TOO6OD',47,'SELF',17,'augue porttitor interdum. Sed auctor odio a purus.'),
  (18,18,'KOV34CBM4GG',48,'ESI',18,'ligula elit, pretium et, rutrum non, hendrerit id, ante.'),
  (19,19,'SJJ73JJK8WZ',49,'SELF',19,'interdum ligula eu enim. Etiam imperdiet dictum magna.'),
  (20,20,'IFI76KGQ2YS',50,'ESI',20,'neque venenatis lacus. Etiam bibendum fermentum metus.'),
  (21,21,'IMK50FMV4LF',51,'ASSURE',21,'erat neque'),
  (22,22,'UOW24BSG4HV',52,'ESI',22,'massa. Suspendisse eleifend. Cras sed'),
  (23,23,'CXQ80YOI4VX',53,'ASSURE',23,'Integer urna. Vivamus molestie dapibus ligula. Aliquam'),
  (24,24,'TBM16CCD7VG',54,'ASSURE',24,'ultricies sem magna nec'),
  (25,25,'PMY52AVG4BE',55,'ESI',25,'Quisque tincidunt pede ac urna. Ut tincidunt vehicula risus.'),
  (26,26,'SIC50WWU7ON',56,'SELF',26,'dui, in sodales elit erat vitae risus. Duis'),
  (27,27,'LMA15EZG5FS',57,'ASSURE',27,'orci quis lectus. Nullam suscipit,'),
  (28,28,'SLV75GZP0HC',58,'ASSURE',28,'eget, dictum placerat, augue.'),
  (29,29,'GMR38ITP2BN',59,'ESI',29,'semper auctor. Mauris vel'),
  (30,30,'LFK56PUY3JE',60,'ASSURE',30,'amet luctus vulputate, nisi sem semper erat, in consectetuer ipsum');



  INSERT INTO [DIM_Physician] (PhysicianID,PersonID,Specialty)
VALUES
  (1,31,'Oncology'),
  (2,32,'Family medicine'),
  (3,33,'Surgery'),
  (4,34,'Surgery'),
  (5,35,'Family medicine'),
  (6,36,'Pediatrics'),
  (7,37,'Diagnostic Radiology'),
  (8,38,'Family medicine'),
  (9,39,'Surgery'),
  (10,40,'Obstetrics and gynaecology'),
  (11,41,'Surgery'),
  (12,42,'Obstetrics and gynaecology'),
  (13,43,'Surgery'),
  (14,44,'Diagnostic Radiology'),
  (15,45,'Surgery'),
  (16,46,'Pediatrics'),
  (17,47,'Family medicine'),
  (18,48,'Obstetrics and gynaecology'),
  (19,49,'Oncology'),
  (20,50,'Obstetrics and gynaecology'),
  (21,51,'Obstetrics and gynaecology'),
  (22,52,'Family medicine'),
  (23,53,'Pediatrics'),
  (24,54,'Diagnostic Radiology'),
  (25,55,'Oncology'),
  (26,56,'Family medicine'),
  (27,57,'Family medicine'),
  (28,58,' Oncology'),
  (29,59,'Obstetrics and gynaecology'),
  (30,60,'Obstetrics and gynaecology');



INSERT INTO [DIM_Bed] (Bed,Occupied,PatientID,BedLetter)
VALUES
  (1,'1',1,'B'),
  (2,'1',2,'C'),
  (3,'0',3,'C'),
  (4,'0',4,'A'),
  (5,'0',5,'D'),
  (6,'0',6,'D'),
  (7,'1',7,'D'),
  (8,'0',8,'E'),
  (9,'1',9,'B'),
  (10,'0',10,'C'),
  (11,'1',11,'D'),
  (12,'1',12,'C'),
  (13,'1',13,'C'),
  (14,'1',14,'C'),
  (15,'0',15,'E'),
  (16,'0',16,'D'),
  (17,'1',17,'A'),
  (18,'1',18,'D'),
  (19,'0',19,'A'),
  (20,'0',20,'A'),
  (21,'0',21,'E'),
  (22,'1',22,'E'),
  (23,'1',23,'C'),
  (24,'0',24,'B'),
  (25,'0',25,'A'),
  (26,'1',26,'E'),
  (27,'1',27,'E'),
  (28,'1',28,'C'),
  (29,'1',29,'A'),
  (30,'0',30,'B');


  INSERT INTO [DIM_Room] (RoomID,RoomNumber,Floor,Wing,Type,Bed)
VALUES
  (1,290,2,'A','Private',1),
  (2,485,4,'E','Four-Bed',2),
  (3,492,4,'F','Three-Bed',3),
  (4,537,5,'A','Semi-Private',4),
  (5,319,3,'G','Semi-Private',5),
  (6,144,1,'A','Four-Bed',6),
  (7,246,2,'F','Semi-Private',7),
  (8,552,5,'C','Semi-Private',8),
  (9,240,2,'F','Private',9),
  (10,308,3,'F','Private',10),
  (11,511,5,'E','Four-Bed',11),
  (12,441,4,'A','Three-Bed',12),
  (13,405,4,'C','Three-Bed',13),
  (14,184,1,'B','Semi-Private',14),
  (15,305,3,'F','Three-Bed',15),
  (16,494,4,'E','Three-Bed',16),
  (17,453,4,'B','Four-Bed',17),
  (18,396,3,'G','Three-Bed',18),
  (19,211,2,'G','Three-Bed',19),
  (20,137,1,'A','Private',20),
  (21,251,2,'G','Semi-Private',21),
  (22,389,3,'C','Four-Bed',22),
  (23,148,1,'F','Three-Bed',23),
  (24,568,5,'F','Three-Bed',24),
  (25,427,4,'F','Private',25),
  (26,128,1,'F','Semi-Private',26),
  (27,430,4,'D','Three-Bed',27),
  (28,390,3,'C','Three-Bed',28),
  (29,513,5,'G','Private',29),
  (30,483,4,'F','Semi-Private',30);


   INSERT INTO [DIM_Item] (ItemCode,Description,Price)
VALUES
  (1000,'Chest X-Ray',3085),
  (1001,'Foot X-Ray',6888),
  (1002,'Arm X-Ray',2767),
  (1003,'Head X-Ray',6486),
  (1004,'Leg X-Ray',9073),
  (1005,'Foot X-Ray',4869),
  (1006,'Head MRI',1579),
  (1007,'Chest MRI',6831),
  (1008,'Arm/Hand MRI',172),
  (1009,'Leg/Foot MRI',133),
  (1010,'MRI with contrast',1531),
  (1011,'Head CT',8170),
  (1012,'Chest CT',895),
  (1013,'Arm/Hand CT',3516),
  (1014,'Leg/Foot CT',7011),
  (1015,'Full body X-Ray',3950),
  (1016,'Full body MRI',7504),
  (1017,'Full body CT',1960),
  (1018,'CT scan with contrast',5517),
  (1019,'Minor surgery',9068),
  (1020,'Major surgery',867),
  (1021,'Spinal tap',4558),
  (1022,'Bloodwork',2661),
  (1023,'ECG',1284),
  (1024,'EKG',1433),
  (1025,'Oxygen treatment',1401),
  (1026,'Antibiotics',7373),
  (1027,'Painkillers',9087),
  (1028,'Colonoscopy',5205),
  (1029,'Upper GI scope',1290);




    INSERT INTO DIM_Department (Department, Description)
VALUES
  ('Infectious Diseases', 'The Infectious Diseases department addresses the prevention and treatment of illnesses caused by pathogens.'),
  ('Emergency Medicine', 'Department providing immediate medical care for acute illnesses or injuries.'),
  ('Cardiology', 'Department focusing on the diagnosis and treatment of heart diseases.'),
  ('Radiology', 'Department specializing in medical imaging and diagnostic procedures.'),
  ('Pediatrics', 'Department dedicated to the healthcare of infants, children, and adolescents.'),
  ('Obstetrics and Gynecology', 'Department dealing with women’s health, pregnancy, and childbirth.'),
  ('Surgery', 'Department performing surgical procedures for various medical conditions.'),
  ('Internal Medicine', 'Department providing comprehensive care for adults and managing chronic illnesses.'),
  ('Neurology', 'Department specializing in disorders of the nervous system.'),
  ('Orthopedics', 'Department focusing on the musculoskeletal system and related conditions.'),
  ('Dermatology', 'Department dealing with skin-related conditions and diseases.'),
  ('Ophthalmology', 'Department specializing in eye care and vision-related disorders.'),
  ('Urology', 'Department addressing diseases and conditions of the urinary tract and male reproductive system.'),
  ('Oncology', 'Department specializing in the diagnosis and treatment of cancer.'),
  ('Psychiatry', 'Department dealing with mental health, behavioral, and emotional disorders.'),
  ('Anesthesiology', 'Department responsible for providing anesthesia and perioperative care.'),
  ('Gastroenterology', 'Department focusing on the digestive system and related disorders.'),
  ('Nephrology', 'Department specializing in kidney function and related conditions.'),
  ('Pulmonology', 'Department dealing with diseases of the respiratory system.'),
  ('Hematology', 'Department specializing in the study and treatment of blood disorders.'),
  ('Endocrinology', 'Department addressing disorders of the endocrine system and hormones.'),
  ('Physical Therapy', 'Department providing rehabilitation services to improve physical function.'),
  ('Occupational Therapy', 'Department focusing on improving daily living skills and independence.'),
  ('Nutrition Services', 'Department offering dietary guidance and nutritional support.'),
  ('Pathology', 'Department responsible for studying diseases and diagnosing through laboratory tests.'),
  ('Cardiac Rehabilitation', 'Department assisting patients in recovering from heart-related conditions.'),
  ('Speech-Language Pathology', 'Department addressing speech and language disorders.'),
  ('Sleep Medicine', 'Department specializing in the diagnosis and treatment of sleep disorders.'),
  ('Allergy', 'Department dealing with allergies and immune system disorders.'),
  ('Immunology', 'Department focusing on the study of the immune system.');




  INSERT INTO DIM_CostCentre(CostCentreID, Department)
VALUES
  (1000,'Infectious Diseases'),
  (1001,'Emergency Medicine'),
  (1002,'Cardiology'),
  (1003,'Radiology'),
  (1004,'Pediatrics'),
  (1005,'Obstetrics and Gynecology'),
  (1006,'Surgery'),
  (1007,'Internal Medicine'),
  (1008,'Neurology'),
  (1009,'Orthopedics'),
  (1010,'Dermatology'),
  (1011,'Ophthalmology'),
  (1012,'Urology'),
  (1013,'Oncology'),
  (1014,'Psychiatry'),
  (1015,'Anesthesiology'),
  (1016,'Gastroenterology'),
  (1017,'Nephrology'),
  (1018,'Pulmonology'),
  (1019,'Hematology'),
  (1020,'Endocrinology'),
  (1021,'Physical Therapy'),
  (1022,'Occupational Therapy'),
  (1023,'Nutrition Services'),
  (1024,'Pathology'),
  (1025,'Cardiac Rehabilitation'),
  (1026,'Speech-Language Pathology'),
  (1027,'Sleep Medicine'),
  (1028,'Allergy'),
  (1029,'Immunology');



  INSERT INTO [FCT_Stay] (StayID, Bed, CostCentreID, PhysicianID, PatientID, ItemCode)
VALUES
  (1, 1, 1000, 1, 1, 1001),
  (2, 2, 1025, 2, 2, 1004),
  (3, 3, 1019, 3, 3, 1013),
  (4, 4, 1012, 4, 4, 1018),
  (5, 5, 1026, 5, 5, 1007),
  (6, 6, 1017, 6, 6, 1015),
  (7, 7, 1013, 7, 7, 1022),
  (8, 8, 1006, 8, 8, 1027),
  (9, 9, 1022, 9, 9, 1025),
  (10, 10, 1005, 10, 10, 1011),
  (11, 11, 1027, 11, 11, 1029),
  (12, 12, 1016, 12, 12, 1017),
  (13, 13, 1015, 13, 13, 1024),
  (14, 14, 1009, 14, 14, 1016),
  (15, 15, 1028, 15, 15, 1020),
  (16, 16, 1011, 16, 16, 1006),
  (17, 17, 1020, 17, 17, 1019),
  (18, 18, 1021, 18, 18, 1008),
  (19, 19, 1004, 19, 19, 1014),
  (20, 20, 1023, 20, 20, 1028),
  (21, 21, 1010, 21, 21, 1000),
  (22, 22, 1003, 22, 22, 1009),
  (23, 23, 1007, 23, 23, 1026),
  (24, 24, 1002, 24, 24, 1021),
  (25, 25, 1001, 25, 25, 1002),
  (26, 26, 1008, 26, 26, 1010),
  (27, 27, 1029, 27, 27, 1023),
  (28, 28, 1024, 28, 28, 1003),
  (29, 29, 1018, 29, 29, 1012),
  (30, 30, 1024, 30, 30, 1012);

