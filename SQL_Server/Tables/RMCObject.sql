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

IF OBJECT_ID (N'dbo.RMCType', 'U') IS NULL
CREATE TABLE dbo.RMCType
(
   bType                     TINYINT         NOT NULL,
   sType                     NVARCHAR (31)   NOT NULL,

   CONSTRAINT PK_RMCType PRIMARY KEY CLUSTERED
   (
      bType ASC
   )
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

IF OBJECT_ID (N'dbo.RMCObject', 'U') IS NULL
CREATE TABLE dbo.RMCObject
(
   ObjectHead_Parent_wClass            SMALLINT        NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT          NOT NULL,
   ObjectHead_Self_wClass              SMALLINT        NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT          NOT NULL IDENTITY (1, 1),
   ObjectHead_twEventIz                BIGINT          NOT NULL,
   ObjectHead_wFlags                   SMALLINT        NOT NULL,

   Name_wsRMCObjectId                  NVARCHAR (48)   NOT NULL,
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
   Orbit_Spin_tmPeriod                 BIGINT          NOT NULL,
   Orbit_Spin_tmStart                  BIGINT          NOT NULL,
   Orbit_Spin_dA                       FLOAT (53)      NOT NULL,
   Orbit_Spin_dB                       FLOAT (53)      NOT NULL,
   Bound_dX                            FLOAT (53)      NOT NULL,
   Bound_dY                            FLOAT (53)      NOT NULL,
   Bound_dZ                            FLOAT (53)      NOT NULL,
   Properties_fMass                    FLOAT (24)      NOT NULL,                        
   Properties_fGravity                 FLOAT (24)      NOT NULL,                        
   Properties_fColor                   FLOAT (24)      NOT NULL,                        
   Properties_fBrightness              FLOAT (24)      NOT NULL,                        
   Properties_fReflectivity            FLOAT (24)      NOT NULL                        

   CONSTRAINT PK_RMCObject PRIMARY KEY CLUSTERED
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX      IX_RMCObject_ObjectHead_Parent_twObjectIx NONCLUSTERED
   (
      ObjectHead_Parent_twObjectIx     ASC
   ),

   INDEX      IX_RMCObject_Name_wsRMCObjectId    NONCLUSTERED
   (
      Name_wsRMCObjectId               ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/

-- bOp     Meaning
-- 0       NULL
-- 1       RMCObject_Open
-- 2       RMCObject_Close
-- 3       RMCObject_Name
-- 4       RMCObject_Type
-- 5       RMCObject_Owner
-- 6       RMCObject_Resource
-- 7       RMCObject_Transform
-- 8       RMCObject_Orbit
-- 9       RMCObject_Spin
-- 10      RMCObject_Bound
-- 11      RMCObject_Properties

IF OBJECT_ID (N'dbo.RMCObjectLog', 'U') IS NULL
CREATE TABLE dbo.RMCObjectLog
(
   dtCreated                    DATETIME2       NOT NULL    CONSTRAINT DF_RMCObjectLog_dtCreated     DEFAULT SYSUTCDATETIME (),
   twLogIx                      BIGINT          NOT NULL    IDENTITY (1, 1),

   bOp                          TINYINT         NOT NULL,
   dwIPAddress                  BINARY (4)      NOT NULL,
   twRPersonaIx                 BIGINT          NOT NULL,
   twRMCObjectIx                BIGINT          NOT NULL

   CONSTRAINT PK_RMCObjectLog PRIMARY KEY CLUSTERED
   (
      twLogIx                   ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/
