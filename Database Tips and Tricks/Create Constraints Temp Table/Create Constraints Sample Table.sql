/*********************************************************************
Scott Peters
Create Constraints On A Temp Table

https://advancedsqlpuzzles.com
Last Updated: 01/11/2023

This script is written in Microsoft SQL Server's T-SQL

This script creates two tables called EmployeePayRecords and Employees.

It then sets various constraints on the EmployeePayRecords table:
*  All columns are set to be NOT NULL
*  EmployeeID_Unique_NotNull and (EmployeeID,FiscalYear) are set to be UNIQUE
*  (EmployeeID,FiscalYear) is set to be a primary key
*  There are several check constraints to ensure the FiscalYear is the same as the year of the StartDate and EndDate, StartDate and EndDate must be 
   January 1 and December 31 respectively, and the pay rate must be greater than 0.
*  A foreign key constraint is added between EmployeePayRecords.EmployeeID and Employees.EmployeeID to maintain referential intgrity.

**********************************************************************/
DROP TABLE IF EXISTS EmployeePayRecords;
DROP TABLE IF EXISTS Employees;
GO

CREATE TABLE EmployeePayRecords
(

EmployeeID                 INTEGER IDENTITY(1,1),
EmployeeID_Unique_NotNull  UNIQUEIDENTIFIER DEFAULT NEWID(),
FiscalYear                 INTEGER,
StartDate                  DATE,
EndDate                    DATE,
PayRate                    MONEY
);
GO

CREATE TABLE Employees
(
EmployeeID  INTEGER PRIMARY KEY
);
GO

--NOT NULL
ALTER TABLE EmployeePayRecords ALTER COLUMN EmployeeID INTEGER NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN EmployeeID_Unique_NotNull UNIQUEIDENTIFIER NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN FiscalYear INTEGER NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN StartDate DATE NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN EndDate DATE NOT NULL;
ALTER TABLE EmployeePayRecords ALTER COLUMN PayRate MONEY NOT NULL;
GO

--UNIQUE
ALTER TABLE EmployeePayRecords ADD CONSTRAINT U_EmployeePayRecords_EmployeeID_Unique_NotNull
                                    UNIQUE (EmployeeID_Unique_NotNull);
--PRIMARY KEY
ALTER TABLE EmployeePayRecords ADD CONSTRAINT PK_EmployeePayRecords_EmployeeIDFiscalYear
                                    PRIMARY KEY (EmployeeID,FiscalYear);
--CHECK CONSTRAINTS
ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Year_StartDate
                                    CHECK (FiscalYear = DATEPART(YYYY,StartDate));

ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Month_StartDate 
                                    CHECK (DATEPART(MM,StartDate) = 01);

ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Day_StartDate
                                    CHECK (DATEPART(DD,StartDate) = 01);

ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Year_EndDate
                                    CHECK (FiscalYear = DATEPART(YYYY,EndDate));

ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Month_EndDate
                                    CHECK (DATEPART(MM,EndDate) = 12);

ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Day_EndDate
                                    CHECK (DATEPART(DD,EndDate) = 31);

ALTER TABLE EmployeePayRecords ADD CONSTRAINT Check_EmployeePayRecords_Payrate
                                    CHECK (PayRate > 0);

ALTER TABLE EmployeePayRecords
ADD CONSTRAINT FK_EmployeePayRecords_EmployeeID
FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
GO
