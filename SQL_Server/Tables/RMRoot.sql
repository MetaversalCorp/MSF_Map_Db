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

IF OBJECT_ID (N'dbo.RMRoot', 'U') IS NULL
CREATE TABLE dbo.RMRoot
(
   ObjectHead_Parent_wClass            SMALLINT        NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT          NOT NULL,
   ObjectHead_Self_wClass              SMALLINT        NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT          NOT NULL IDENTITY (1, 1),
   ObjectHead_twEventIz                BIGINT          NOT NULL,
   ObjectHead_wFlags                   SMALLINT        NOT NULL,

   Name_wsRMRootId                     NVARCHAR (48)   NOT NULL,
   Owner_twRPersonaIx                  BIGINT          NOT NULL,

   CONSTRAINT PK_RMRoot PRIMARY KEY CLUSTERED
   (
      ObjectHead_Self_twObjectIx       ASC
   )
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

-- bOp     Meaning
-- 0       NULL
-- 1    -- RMRoot_Open
-- 2    -- RMRoot_Close
-- 3       RMRoot_Name
-- 4    -- RMRoot_Type
-- 5       RMRoot_Owner
-- 6    -- RMRoot_Resource
-- 7    -- RMRoot_Transform
-- 8    -- RMRoot_Orbit
-- 9    -- RMRoot_Spin
-- 10   -- RMRoot_Bound
-- 11   -- RMRoot_Properties
-- 12   -- RMRoot_RMRoot_Open
-- 13   -- RMRoot_RMRoot_Close
-- 14      RMRoot_RMCObject_Open
-- 15      RMRoot_RMCObject_Close
-- 16      RMRoot_RMTObject_Open
-- 17      RMRoot_RMTObject_Close
-- 18      RMRoot_RMPObject_Open
-- 19      RMRoot_RMPObject_Close

IF OBJECT_ID (N'dbo.RMRootLog', 'U') IS NULL
CREATE TABLE dbo.RMRootLog
(
   dtCreated                    DATETIME2       NOT NULL    CONSTRAINT DF_RMRootLog_dtCreated     DEFAULT SYSUTCDATETIME (),
   twLogIx                      BIGINT          NOT NULL    IDENTITY (1, 1),

   bOp                          TINYINT         NOT NULL,
   dwIPAddress                  BINARY (4)      NOT NULL,
   twRPersonaIx                 BIGINT          NOT NULL,
   twRMRootIx                   BIGINT          NOT NULL

   CONSTRAINT PK_RMRootLog PRIMARY KEY CLUSTERED
   (
      twLogIx                   ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/
