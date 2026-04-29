# AUCA Certificate Generator

An ASP.NET WebForms application that generates official **Certificates of Good Standing** for students of the Adventist University of Central Africa (AUCA).

## Features

- Search students by name or Student ID
- Auto-fills certificate from SQL Server database
- Print-ready A4 certificate layout matching the official AUCA format
- QR code support for certificate verification
- Signature image support
- Save as PDF via browser print dialog

## Tech Stack

- **Frontend:** ASP.NET WebForms (ASPX), HTML, CSS
- **Backend:** C# (.NET Framework 4.8)
- **Database:** SQL Server (T-SQL)

## Database Table

```sql
CREATE TABLE [dbo].[CertificateOfAttendance] (
    [StudentName]  NVARCHAR(255),
    [BornDate]     DATETIME,
    [StudentID]    NVARCHAR(100),
    [StudiedFrom]  NVARCHAR(100),
    [StudiedTo]    NVARCHAR(100),
    [Year]         NVARCHAR(50),
    [Faculty]      NVARCHAR(255),
    [Major]        NVARCHAR(255),
    [AcademicYear] NVARCHAR(100),
    [ApprovedBy]   NVARCHAR(255),
    [Comment]      NVARCHAR(MAX),
    [Status]       NVARCHAR(100)
)
```

## Setup

1. Clone the repository
2. Open in Visual Studio
3. Update the connection string in `Web.config`
4. Run the SQL script to create the database and table
5. Place `Letterhead.jpg` and `signature.png` in the `Images/` folder
6. Build and run

## Project Structure
