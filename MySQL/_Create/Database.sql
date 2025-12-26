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

-- PREREQUISITE --

-- TBD :
-- Login similar to SQL Server

/* ************************************************************************************************************************** */

-- REQUIRED BEFORE RUNNING THIS SCRIPT --

-- 1. Rename [{MSF_Map}]    to your new database name

-- TBD :
-- 2. Rename [{Login_Name}] to your server's login (see above) that will be granted execute access to this database

/* ************************************************************************************************************************** */

/*
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
*/

CREATE DATABASE IF NOT EXISTS [{MSF_Map}];

USE [{MSF_Map}];

/* ************************************************************************************************************************** */
