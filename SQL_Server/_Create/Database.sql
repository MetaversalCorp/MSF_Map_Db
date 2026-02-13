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

-- 1. Rename [{Pathname}]   to the full pathname (without the trailing backslash) of your new database's data and log files.
-- 2. Rename [{MSF_Map}]    to your new database name.
-- 3. Rename [{Login_Name}] to your server's login (see above) that will be granted execute access to this database.

/******************************************************************************************************************************/

USE master
GO

   IF DB_ID (N'[{MSF_Map}]') IS NULL
BEGIN
         CREATE DATABASE [{MSF_Map}]
  END
GO

USE [{MSF_Map}]
GO

   IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'WebService')
BEGIN
        CREATE USER WebService FOR LOGIN [{Login_Name}] WITH DEFAULT_SCHEMA = dbo
  END
GO

/******************************************************************************************************************************/
