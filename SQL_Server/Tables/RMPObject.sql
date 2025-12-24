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

IF OBJECT_ID (N'dbo.RMPType', 'U') IS NULL
CREATE TABLE dbo.RMPType
(
   bType                     TINYINT         NOT NULL,
   sType                     NVARCHAR (31)   NOT NULL,

   CONSTRAINT PK_RMPType PRIMARY KEY CLUSTERED
   (
      bType ASC
   )
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

IF OBJECT_ID (N'dbo.RMPObject', 'U') IS NULL
CREATE TABLE dbo.RMPObject
(
   ObjectHead_Parent_wClass            SMALLINT        NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT          NOT NULL,
   ObjectHead_Self_wClass              SMALLINT        NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT          NOT NULL IDENTITY (1, 1),
   ObjectHead_twEventIz                BIGINT          NOT NULL,
   ObjectHead_wFlags                   SMALLINT        NOT NULL,

   Name_wsRMPObjectId                  NVARCHAR (48)   NOT NULL,
   Type_bType                          TINYINT         NOT NULL,
   Type_bSubtype                       TINYINT         NOT NULL,
   Type_bFiction                       TINYINT         NOT NULL,
   Type_bMovable                       TINYINT         NOT NULL,
   Owner_twRPersonaIx                  BIGINT          NOT NULL,
   Resource_qwResource                 BIGINT          NOT NULL,
   Resource_sName                      NVARCHAR (48)   NOT NULL DEFAULT (''),
   Resource_sReference                 NVARCHAR (128)  NOT NULL DEFAULT (''),
   Transform_Position_dX               FLOAT (53)      NOT NULL,
   Transform_Position_dY               FLOAT (53)      NOT NULL,
   Transform_Position_dZ               FLOAT (53)      NOT NULL,
   Transform_Rotation_dX               FLOAT (53)      NOT NULL,
   Transform_Rotation_dY               FLOAT (53)      NOT NULL,
   Transform_Rotation_dZ               FLOAT (53)      NOT NULL,
   Transform_Rotation_dW               FLOAT (53)      NOT NULL,
   Transform_Scale_dX                  FLOAT (53)      NOT NULL,
   Transform_Scale_dY                  FLOAT (53)      NOT NULL,
   Transform_Scale_dZ                  FLOAT (53)      NOT NULL,
   Bound_dX                            FLOAT (53)      NOT NULL,
   Bound_dY                            FLOAT (53)      NOT NULL,
   Bound_dZ                            FLOAT (53)      NOT NULL,

   CONSTRAINT PK_RMPObject           PRIMARY KEY CLUSTERED
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX      IX_RMPObject_ObjectHead_Parent_twObjectIx NONCLUSTERED
   (
      ObjectHead_Parent_twObjectIx     ASC
   )
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

-- bOp     Meaning
-- 0       NULL
-- 1       RMPObject_Open
-- 2       RMPObject_Close
-- 3    -- RMPObject_Name
-- 4       RMPObject_Type
-- 5       RMPObject_Owner
-- 6       RMPObject_Resource
-- 7       RMPObject_Transform
-- 8    -- RMPObject_Orbit
-- 9    -- RMPObject_Spin
-- 10      RMPObject_Bound
-- 11   -- RMPObject_Properties

IF OBJECT_ID (N'dbo.RMPObjectLog', 'U') IS NULL
CREATE TABLE dbo.RMPObjectLog
(
   dtCreated                    DATETIME2       NOT NULL    CONSTRAINT DF_RMPObjectLog_dtCreated     DEFAULT SYSUTCDATETIME (),
   twLogIx                      BIGINT          NOT NULL    IDENTITY (1, 1),

   bOp                          TINYINT         NOT NULL,
   dwIPAddress                  BINARY (4)      NOT NULL,
   twRPersonaIx                 BIGINT          NOT NULL,
   twRMPObjectIx                BIGINT          NOT NULL

   CONSTRAINT PK_RMPObjectLog PRIMARY KEY CLUSTERED
   (
      twLogIx                   ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/
