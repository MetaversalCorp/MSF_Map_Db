/*
** Copyright 2025 Metaversal Corporation.
** 
** Licensed under the Apache License, Version 2.0 (the "License"); 
** you may not use this file except in compliance with the License. 
** You may obtain a copy of the License at 
** 
**    https://www.apache.org/licenses/LICENSE-2.0
** 
** Unless required by applicable law or agreed to in writing, software 
** distributed under the License is distributed on an "AS IS" BASIS, 
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
** See the License for the specific language governing permissions and 
** limitations under the License.
** 
** SPDX-License-Identifier: Apache-2.0
*/

/******************************************************************************************************************************/

-- PREREQUISITE --

-- If you don't already have a login on your server that you want to use for this database, you can create one
--    using one of these methods:

--    CREATE LOGIN [{Login_Name}] WITH PASSWORD = '[{Login_Password}]'
--    CREATE LOGIN [{Login_Name}] FROM WINDOWS

-- When you're creating logins that are mapped from a Windows domain account, you must use the logon name in the 
-- format [<domainName>\<login_name>]. Therefore, you would rename as follows, retaining the square brackets:
--
--    [{Login_Name}] -> [<domainName>\<login_name>]

-- For more information on creating logins:
--
--    https://learn.microsoft.com/en-us/sql/t-sql/statements/create-login-transact-sql?view=sql-server-ver17

/******************************************************************************************************************************/

-- REQUIRED BEFORE RUNNING THIS SCRIPT --

-- 1. Rename [{MSF_Map}]    to your new database name
-- 2. Rename [{Login_Name}] to your server's login (see above) that will be granted execute access to this database

/******************************************************************************************************************************/

USE master
GO

   IF DB_ID (N'[{MSF_Map}]') IS NULL
BEGIN
         CREATE DATABASE [{MSF_Map}] ON PRIMARY
         (
            NAME       = N'[{MSF_Map}]',
            FILENAME   = N'D:\MSSQL\Data\[{MSF_Map}].mdf',
            SIZE       = 4096KB,
            MAXSIZE    = UNLIMITED,
            FILEGROWTH = 10%
         )
         LOG ON
         (
            NAME       = N'[{MSF_Map}]_log',
            FILENAME   = N'D:\MSSQL\Data\[{MSF_Map}]_log.ldf',
            SIZE       = 4096KB,
            MAXSIZE    = 2048GB,
            FILEGROWTH = 10%
         )
         
         ALTER DATABASE [{MSF_Map}] SET ANSI_NULL_DEFAULT             OFF
         ALTER DATABASE [{MSF_Map}] SET ANSI_NULLS                    ON
         ALTER DATABASE [{MSF_Map}] SET ANSI_PADDING                  ON
         ALTER DATABASE [{MSF_Map}] SET ANSI_WARNINGS                 OFF
         ALTER DATABASE [{MSF_Map}] SET ARITHABORT                    OFF
         ALTER DATABASE [{MSF_Map}] SET AUTO_CLOSE                    OFF
         ALTER DATABASE [{MSF_Map}] SET AUTO_CREATE_STATISTICS        ON
         ALTER DATABASE [{MSF_Map}] SET AUTO_SHRINK                   OFF
         ALTER DATABASE [{MSF_Map}] SET AUTO_UPDATE_STATISTICS        ON
         ALTER DATABASE [{MSF_Map}] SET CURSOR_CLOSE_ON_COMMIT        OFF
         ALTER DATABASE [{MSF_Map}] SET CURSOR_DEFAULT                GLOBAL
         ALTER DATABASE [{MSF_Map}] SET CONCAT_NULL_YIELDS_NULL       OFF
         ALTER DATABASE [{MSF_Map}] SET NUMERIC_ROUNDABORT            OFF
         ALTER DATABASE [{MSF_Map}] SET QUOTED_IDENTIFIER             OFF
         ALTER DATABASE [{MSF_Map}] SET RECURSIVE_TRIGGERS            OFF
         ALTER DATABASE [{MSF_Map}] SET DISABLE_BROKER
         ALTER DATABASE [{MSF_Map}] SET AUTO_UPDATE_STATISTICS_ASYNC  OFF
         ALTER DATABASE [{MSF_Map}] SET DATE_CORRELATION_OPTIMIZATION OFF
         ALTER DATABASE [{MSF_Map}] SET TRUSTWORTHY                   OFF
         ALTER DATABASE [{MSF_Map}] SET ALLOW_SNAPSHOT_ISOLATION      OFF
         ALTER DATABASE [{MSF_Map}] SET PARAMETERIZATION              SIMPLE
         ALTER DATABASE [{MSF_Map}] SET READ_COMMITTED_SNAPSHOT       OFF
         ALTER DATABASE [{MSF_Map}] SET HONOR_BROKER_PRIORITY         OFF
         ALTER DATABASE [{MSF_Map}] SET READ_WRITE
         ALTER DATABASE [{MSF_Map}] SET RECOVERY                      FULL
         ALTER DATABASE [{MSF_Map}] SET MULTI_USER
         ALTER DATABASE [{MSF_Map}] SET PAGE_VERIFY                   CHECKSUM
         ALTER DATABASE [{MSF_Map}] SET DB_CHAINING                   ON
         
         ALTER AUTHORIZATION ON DATABASE::[{MSF_Map}] TO sa
  END
GO

USE [{MSF_Map}]
GO

CREATE USER WebService FOR LOGIN [{Login_Name}] WITH DEFAULT_SCHEMA = dbo
GO

/******************************************************************************************************************************/
