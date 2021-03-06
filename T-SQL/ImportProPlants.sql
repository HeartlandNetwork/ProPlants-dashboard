

-- 1. Connect to your SQL Server instance, master database

-- 2. Run the following code to create an empty database called TSQLV4
USE master;

-- Drop database
IF DB_ID(N'HTLN_ProPlants') IS NOT NULL DROP DATABASE HTLN_ProPlants;

-- If database could not be created due to open connections, abort
IF @@ERROR = 3702 
   RAISERROR(N'Database cannot be dropped because there are still open connections.', 127, 127) WITH NOWAIT, LOG;



-- Create database
CREATE DATABASE HTLN_ProPlants;
GO

USE HTLN_ProPlants;
GO

CREATE SCHEMA lut AUTHORIZATION dbo;
GO

-- Create tables
CREATE TABLE dbo.ClipStatus
(
  park        NVARCHAR(4)  NOT NULL,
  locationid  NVARCHAR(20) NOT NULL,
  clipstatus  NVARCHAR(20) NOT NULL,
  CONSTRAINT PK_ClipStatus PRIMARY KEY(locationid)
);
GO

CREATE TABLE dbo.FieldData
(
  id          INT             NOT NULL IDENTITY,
  locationid  NVARCHAR(20)    NOT NULL,
  periodid    NVARCHAR(20)    NOT NULL,
  species     NVARCHAR(50)    NOT NULL,
  coverclass  INT             NOT NULL,
  comments    NVARCHAR(256)   NOT NULL,
  CONSTRAINT PK_FieldData PRIMARY KEY(locationid)
);
GO

CREATE TABLE dbo.Location
(
  id              INT             NOT NULL IDENTITY,
  locationid      NVARCHAR(20)    NOT NULL,
  parkcode        NVARCHAR(4)     NOT NULL,
  latitude        DECIMAL(10,6)   NOT NULL,
  longitude       DECIMAL(10,6)   NOT NULL,   
  firstsampled    NVARCHAR(20)    NOT NULL,
  searchunittype  NVARCHAR(20)    NOT NULL,
  CONSTRAINT PK_Location PRIMARY KEY(locationid)
);
GO


CREATE TABLE lut.taxareference
(
  id                INT             NOT NULL IDENTITY,
  acceptedsymbol    NVARCHAR(20)    NOT NULL,
  commonname        NVARCHAR(100)   NOT NULL, 
  scientificname    NVARCHAR(256)   NOT NULL,
  family            NVARCHAR(40)    NOT NULL,
  iranksum          NVARCHAR(5)     NOT NULL,
  irankimpact       NVARCHAR(5)     NOT NULL,
  irankcurrent      NVARCHAR(5)     NOT NULL,
  iranktrend        NVARCHAR(5)     NOT NULL,
  irankmgmt         NVARCHAR(5)     NOT NULL,
  irankcomment      NVARCHAR(256)   NOT NULL,
  CONSTRAINT PK_Taxareference PRIMARY KEY(acceptedsymbol)
);
GO


CREATE TABLE lut.coverclass
(
  id          INT             NOT NULL IDENTITY,
  coverclass  INT             NOT NULL,
  lowrange    INT             NOT NULL, 
  midrange    INT             NOT NULL, 
  highrange   INT             NOT NULL, 
  CONSTRAINT PK_Coverclass PRIMARY KEY(coverclass)
);
GO

CREATE TABLE dbo.SamplingPeriod
(
  id          INT            NOT NULL IDENTITY,
  periodid    NVARCHAR(20)  NOT NULL,
  parkcode    NVARCHAR(4)   NOT NULL,
  startdate   DATE          NOT NULL,
  enddate     DATE          NOT NULL,
  CONSTRAINT PK_SamplingPeriod PRIMARY KEY(periodid)
);
GO

BULK INSERT
dbo.clipstatus
FROM 'C:\users\growell\work\PowerBI\ProPlants\tbl_ClipStatus.csv'
