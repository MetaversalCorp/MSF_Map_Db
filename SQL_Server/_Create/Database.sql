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

-- Rename [{MSF_Map}] to new database name

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

/*
CREATE USER MapService FOR LOGIN [<your_domain>\MapService] WITH DEFAULT_SCHEMA = dbo
GO

GRANT EXECUTE TO [<your_domain>\MapService];
GO
*/

/******************************************************************************************************************************/

DROP FUNCTION IF EXISTS dbo.ArcLength
DROP FUNCTION IF EXISTS dbo.DateTime2_Time
DROP FUNCTION IF EXISTS dbo.Date_DateTime2
DROP FUNCTION IF EXISTS dbo.Descendant_C
DROP FUNCTION IF EXISTS dbo.Descendant_T
DROP FUNCTION IF EXISTS dbo.Format_Bound
DROP FUNCTION IF EXISTS dbo.Format_Control
DROP FUNCTION IF EXISTS dbo.Format_Double
DROP FUNCTION IF EXISTS dbo.Format_Double3
DROP FUNCTION IF EXISTS dbo.Format_Double4
DROP FUNCTION IF EXISTS dbo.Format_Float
DROP FUNCTION IF EXISTS dbo.Format_Name_C
DROP FUNCTION IF EXISTS dbo.Format_Name_P
DROP FUNCTION IF EXISTS dbo.Format_Name_R
DROP FUNCTION IF EXISTS dbo.Format_Name_T
DROP FUNCTION IF EXISTS dbo.Format_ObjectHead
DROP FUNCTION IF EXISTS dbo.Format_Orbit_Spin
DROP FUNCTION IF EXISTS dbo.Format_Owner
DROP FUNCTION IF EXISTS dbo.Format_Properties_C
DROP FUNCTION IF EXISTS dbo.Format_Properties_T
DROP FUNCTION IF EXISTS dbo.Format_Resource
DROP FUNCTION IF EXISTS dbo.Format_Transform
DROP FUNCTION IF EXISTS dbo.Format_Type_C
DROP FUNCTION IF EXISTS dbo.Format_Type_P
DROP FUNCTION IF EXISTS dbo.Format_Type_T
DROP FUNCTION IF EXISTS dbo.IPstob
DROP FUNCTION IF EXISTS dbo.IPbtos
DROP FUNCTION IF EXISTS dbo.Table_Error
DROP FUNCTION IF EXISTS dbo.Table_Event
DROP FUNCTION IF EXISTS dbo.Table_Results
DROP FUNCTION IF EXISTS dbo.Time_Current
DROP FUNCTION IF EXISTS dbo.Time_DateTime2
GO

/******************************************************************************************************************************/

DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event
DROP PROCEDURE IF EXISTS dbo.call_Error
DROP PROCEDURE IF EXISTS dbo.call_Event_Push
DROP PROCEDURE IF EXISTS dbo.etl_Events
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Bound
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Name
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Orbit_Spin
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Properties
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Resource
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_RMCObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_RMCObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_RMTObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_RMTObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Transform
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Event_Type
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Log
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Select
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Bound
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Name
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Orbit_Spin
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Properties
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Resource
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Transform
DROP PROCEDURE IF EXISTS dbo.call_RMCObject_Validate_Type
DROP PROCEDURE IF EXISTS dbo.get_RMCObject
DROP PROCEDURE IF EXISTS dbo.get_RMCObject_Update
DROP PROCEDURE IF EXISTS dbo.search_RMCObject
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Bound
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Name
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Orbit_Spin
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Owner
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Properties
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Resource
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_RMCObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_RMCObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_RMTObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_RMTObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Transform
DROP PROCEDURE IF EXISTS dbo.set_RMCObject_Type
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_Bound
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_Name
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_Resource
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_RMPObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_RMPObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_Transform
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Event_Type
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Log
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Select
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate_Bound
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate_Name
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate_Resource
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate_Transform
DROP PROCEDURE IF EXISTS dbo.call_RMPObject_Validate_Type
DROP PROCEDURE IF EXISTS dbo.get_RMPObject
DROP PROCEDURE IF EXISTS dbo.get_RMPObject_Update
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Bound
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Name
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Owner
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Parent
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Resource
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_RMPObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_RMPObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Transform
DROP PROCEDURE IF EXISTS dbo.set_RMPObject_Type
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_Name
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMCObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMCObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMPObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMPObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMTObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMTObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Log
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Select
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Validate
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Validate_Name
DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Validate_Owner
DROP PROCEDURE IF EXISTS dbo.get_RMRoot
DROP PROCEDURE IF EXISTS dbo.get_RMRoot_Update
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_Name
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_Owner
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_RMCObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_RMCObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_RMPObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_RMPObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_RMTObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMRoot_RMTObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Car
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Cyl
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Geo
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Inverse
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Mult
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Nul
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Relative
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Rotate
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Scale
DROP PROCEDURE IF EXISTS dbo.call_RMTMatrix_Translate
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Bound
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Name
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Properties
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Resource
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_RMPObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_RMPObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_RMTObject_Close
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_RMTObject_Open
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Transform
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Event_Type
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Log
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Parent_Geo
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Select
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Bound
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Coord_Car
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Coord_Cyl
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Coord_Geo
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Coord_Nul
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Name
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Owner
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Properties
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Resource
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Transform
DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Type
DROP PROCEDURE IF EXISTS dbo.get_RMTObject
DROP PROCEDURE IF EXISTS dbo.get_RMTObject_Update
DROP PROCEDURE IF EXISTS dbo.search_RMTObject
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Bound
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Fabric_Close
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Fabric_Configure
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Fabric_Open
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Fabric_Open
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Name
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Owner
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Properties
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Resource
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_RMPObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_RMPObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_RMTObject_Close
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_RMTObject_Open
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Transform
DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Type
GO

/******************************************************************************************************************************/
