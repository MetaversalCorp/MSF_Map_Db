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

/* ************************************************************************************************************************** */

-- Rename [{MSF_Map}] to your desired database name
-- This script creates a MySQL database with UTF-8 support and appropriate settings

-- Drop database (optional - remove if you want to preserve existing data)
-- DROP DATABASE [{MSF_Map}];

CREATE DATABASE IF NOT EXISTS MSF_Map;

USE MSF_Map;

/*
**
** MySQL Database Creation Notes:
**
** 1. File Management: MySQL handles data files automatically. No need to specify file paths.
** 2. Character Set: utf8mb4 is recommended for full UTF-8 support including emojis.
** 3. Storage Engine: InnoDB is recommended for ACID compliance and foreign key support.
** 4. User Management: Create dedicated users instead of using root for applications.
** 5. Configuration: Many SQL Server database settings are handled in MySQL's my.cnf file.
**
** Recommended my.cnf settings for this database:
** [mysqld]
** default-storage-engine=innodb
** innodb_file_per_table=1
** innodb_buffer_pool_size=1G  # Adjust based on available RAM
** max_connections=200
** query_cache_size=32M
** log-bin=mysql-bin
** binlog_format=ROW
**
*/

/* ************************************************************************************************************************** */

DROP FUNCTION IF EXISTS ArcLength;
DROP FUNCTION IF EXISTS DateTime2_Time;
DROP FUNCTION IF EXISTS Date_DateTime2;
DROP FUNCTION IF EXISTS Format_Bound;
DROP FUNCTION IF EXISTS Format_Control;
DROP FUNCTION IF EXISTS Format_Double;
DROP FUNCTION IF EXISTS Format_Double3;
DROP FUNCTION IF EXISTS Format_Double4;
DROP FUNCTION IF EXISTS Format_Float;
DROP FUNCTION IF EXISTS Format_Name_C;
DROP FUNCTION IF EXISTS Format_Name_P;
DROP FUNCTION IF EXISTS Format_Name_R;
DROP FUNCTION IF EXISTS Format_Name_T;
DROP FUNCTION IF EXISTS Format_ObjectHead;
DROP FUNCTION IF EXISTS Format_Orbit_Spin;
DROP FUNCTION IF EXISTS Format_Owner;
DROP FUNCTION IF EXISTS Format_Properties_C;
DROP FUNCTION IF EXISTS Format_Properties_T;
DROP FUNCTION IF EXISTS Format_Resource;
DROP FUNCTION IF EXISTS Format_Transform;
DROP FUNCTION IF EXISTS Format_Type_C;
DROP FUNCTION IF EXISTS Format_Type_P;
DROP FUNCTION IF EXISTS Format_Type_T;
DROP FUNCTION IF EXISTS IPstob;
DROP FUNCTION IF EXISTS IPbtos;
DROP FUNCTION IF EXISTS Time_Current;
DROP FUNCTION IF EXISTS Time_DateTime2;

/* ************************************************************************************************************************** */

DROP PROCEDURE IF EXISTS call_RMRoot_Event_Owner;
DROP PROCEDURE IF EXISTS call_Error;
DROP PROCEDURE IF EXISTS call_Event_Push;
DROP PROCEDURE IF EXISTS etl_Events;
DROP PROCEDURE IF EXISTS call_RMCObject_Event;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Bound;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Name;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Orbit_Spin;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Owner;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Properties;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Resource;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_RMCObject_Close;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_RMCObject_Open;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_RMTObject_Close;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_RMTObject_Open;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Transform;
DROP PROCEDURE IF EXISTS call_RMCObject_Event_Type;
DROP PROCEDURE IF EXISTS call_RMCObject_Log;
DROP PROCEDURE IF EXISTS call_RMCObject_Select;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Bound;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Name;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Orbit_Spin;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Owner;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Properties;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Resource;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Transform;
DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Type;
DROP PROCEDURE IF EXISTS get_RMCObject_Update;
DROP PROCEDURE IF EXISTS search_RMCObject;
DROP PROCEDURE IF EXISTS set_RMCObject_Bound;
DROP PROCEDURE IF EXISTS set_RMCObject_Name;
DROP PROCEDURE IF EXISTS set_RMCObject_Orbit_Spin;
DROP PROCEDURE IF EXISTS set_RMCObject_Owner;
DROP PROCEDURE IF EXISTS set_RMCObject_Properties;
DROP PROCEDURE IF EXISTS set_RMCObject_Resource;
DROP PROCEDURE IF EXISTS set_RMCObject_RMCObject_Close;
DROP PROCEDURE IF EXISTS set_RMCObject_RMCObject_Open;
DROP PROCEDURE IF EXISTS set_RMCObject_RMTObject_Close;
DROP PROCEDURE IF EXISTS set_RMCObject_RMTObject_Open;
DROP PROCEDURE IF EXISTS set_RMCObject_Transform;
DROP PROCEDURE IF EXISTS set_RMCObject_Type;
DROP PROCEDURE IF EXISTS call_RMPObject_Event;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_Bound;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_Name;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_Owner;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_Resource;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_RMPObject_Close;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_RMPObject_Open;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_Transform;
DROP PROCEDURE IF EXISTS call_RMPObject_Event_Type;
DROP PROCEDURE IF EXISTS call_RMPObject_Log;
DROP PROCEDURE IF EXISTS call_RMPObject_Select;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Bound;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Name;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Owner;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Resource;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Transform;
DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Type;
DROP PROCEDURE IF EXISTS get_RMPObject_Update;
DROP PROCEDURE IF EXISTS set_RMPObject_Bound;
DROP PROCEDURE IF EXISTS set_RMPObject_Name;
DROP PROCEDURE IF EXISTS set_RMPObject_Owner;
DROP PROCEDURE IF EXISTS set_RMPObject_Parent;
DROP PROCEDURE IF EXISTS set_RMPObject_Resource;
DROP PROCEDURE IF EXISTS set_RMPObject_RMPObject_Close;
DROP PROCEDURE IF EXISTS set_RMPObject_RMPObject_Open;
DROP PROCEDURE IF EXISTS set_RMPObject_Transform;
DROP PROCEDURE IF EXISTS set_RMPObject_Type;
DROP PROCEDURE IF EXISTS call_RMRoot_Event;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_Name;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMCObject_Close;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMCObject_Open;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMPObject_Close;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMPObject_Open;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMTObject_Close;
DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMTObject_Open;
DROP PROCEDURE IF EXISTS call_RMRoot_Log;
DROP PROCEDURE IF EXISTS call_RMRoot_Select;
DROP PROCEDURE IF EXISTS call_RMRoot_Validate;
DROP PROCEDURE IF EXISTS call_RMRoot_Validate_Name;
DROP PROCEDURE IF EXISTS call_RMRoot_Validate_Owner;
DROP PROCEDURE IF EXISTS get_RMRoot_Update;
DROP PROCEDURE IF EXISTS set_RMRoot_Name;
DROP PROCEDURE IF EXISTS set_RMRoot_Owner;
DROP PROCEDURE IF EXISTS set_RMRoot_RMCObject_Close;
DROP PROCEDURE IF EXISTS set_RMRoot_RMCObject_Open;
DROP PROCEDURE IF EXISTS set_RMRoot_RMPObject_Close;
DROP PROCEDURE IF EXISTS set_RMRoot_RMPObject_Open;
DROP PROCEDURE IF EXISTS set_RMRoot_RMTObject_Close;
DROP PROCEDURE IF EXISTS set_RMRoot_RMTObject_Open;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Car;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Cyl;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Geo;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Inverse;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Mult;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Nul;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Relative;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Rotate;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Scale;
DROP PROCEDURE IF EXISTS call_RMTMatrix_Translate;
DROP PROCEDURE IF EXISTS call_RMTObject_Event;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Bound;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Name;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Owner;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Properties;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Resource;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_RMPObject_Close;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_RMPObject_Open;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_RMTObject_Close;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_RMTObject_Open;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Transform;
DROP PROCEDURE IF EXISTS call_RMTObject_Event_Type;
DROP PROCEDURE IF EXISTS call_RMTObject_Log;
DROP PROCEDURE IF EXISTS call_RMTObject_Select;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Bound;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Coord_Car;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Coord_Cyl;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Coord_Geo;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Coord_Nul;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Name;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Owner;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Properties;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Resource;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Transform;
DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Type;
DROP PROCEDURE IF EXISTS get_RMTObject_Update;
DROP PROCEDURE IF EXISTS search_RMTObject;
DROP PROCEDURE IF EXISTS set_RMTObject_Bound;
DROP PROCEDURE IF EXISTS set_RMTObject_Name;
DROP PROCEDURE IF EXISTS set_RMTObject_Owner;
DROP PROCEDURE IF EXISTS set_RMTObject_Properties;
DROP PROCEDURE IF EXISTS set_RMTObject_Resource;
DROP PROCEDURE IF EXISTS set_RMTObject_RMPObject_Close;
DROP PROCEDURE IF EXISTS set_RMTObject_RMPObject_Open;
DROP PROCEDURE IF EXISTS set_RMTObject_RMTObject_Close;
DROP PROCEDURE IF EXISTS set_RMTObject_RMTObject_Open;
DROP PROCEDURE IF EXISTS set_RMTObject_Transform;
DROP PROCEDURE IF EXISTS set_RMTObject_Type;

/* ************************************************************************************************************************** */
