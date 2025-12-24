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

IF OBJECT_ID (N'dbo.RMTType', 'U') IS NULL
CREATE TABLE dbo.RMTType
(
   bType                     TINYINT         NOT NULL,
   sType                     NVARCHAR (31)   NOT NULL,

   CONSTRAINT PK_RMTType PRIMARY KEY CLUSTERED
   (
      bType ASC
   )
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

IF OBJECT_ID (N'dbo.RMTObject', 'U') IS NULL
CREATE TABLE dbo.RMTObject
(
   ObjectHead_Parent_wClass            SMALLINT        NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT          NOT NULL,
   ObjectHead_Self_wClass              SMALLINT        NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT          NOT NULL IDENTITY (1, 1),
   ObjectHead_twEventIz                BIGINT          NOT NULL,
   ObjectHead_wFlags                   SMALLINT        NOT NULL,

   Name_wsRMTObjectId                  NVARCHAR (48)   NOT NULL,
   Type_bType                          TINYINT         NOT NULL,
   Type_bSubtype                       TINYINT         NOT NULL,
   Type_bFiction                       TINYINT         NOT NULL,
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
   Properties_bLockToGround            TINYINT         NOT NULL,
   Properties_bYouth                   TINYINT         NOT NULL,
   Properties_bAdult                   TINYINT         NOT NULL,
   Properties_bAvatar                  TINYINT         NOT NULL,

   CONSTRAINT PK_RMTObject           PRIMARY KEY CLUSTERED
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX      IX_RMTObject_ObjectHead_Parent_twObjectIx NONCLUSTERED
   (
      ObjectHead_Parent_twObjectIx     ASC
   ),

   INDEX      IX_RMTObject_Name_wsRMTObjectId    NONCLUSTERED
   (
      Name_wsRMTObjectId               ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

-- bOp     Meaning
-- 0       NULL
-- 1       RMTObject_Open
-- 2       RMTObject_Close
-- 3       RMTObject_Name
-- 4       RMTObject_Type
-- 5       RMTObject_Owner
-- 6       RMTObject_Resource
-- 7       RMTObject_Transform
-- 8    -- RMTObject_Orbit
-- 9    -- RMTObject_Spin
-- 10      RMTObject_Bound
-- 11      RMTObject_Properties

IF OBJECT_ID (N'dbo.RMTObjectLog', 'U') IS NULL
CREATE TABLE dbo.RMTObjectLog
(
   dtCreated                    DATETIME2       NOT NULL    CONSTRAINT DF_RMTObjectLog_dtCreated     DEFAULT SYSUTCDATETIME (),
   twLogIx                      BIGINT          NOT NULL    IDENTITY (1, 1),

   bOp                          TINYINT         NOT NULL,
   dwIPAddress                  BINARY (4)      NOT NULL,
   twRPersonaIx                 BIGINT          NOT NULL,
   twRMTObjectIx                BIGINT          NOT NULL

   CONSTRAINT PK_RMTObjectLog PRIMARY KEY CLUSTERED
   (
      twLogIx                   ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/
