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

CREATE TABLE IF NOT EXISTS RMTType
(
   bType                               TINYINT UNSIGNED  NOT NULL,
   sType                               VARCHAR (31)      NOT NULL,

   CONSTRAINT PK_RMTType PRIMARY KEY
   (
      bType ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */

CREATE TABLE IF NOT EXISTS RMTObject
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Name_wsRMTObjectId                  VARCHAR (48)      NOT NULL,
   Type_bType                          TINYINT UNSIGNED  NOT NULL,
   Type_bSubtype                       TINYINT UNSIGNED  NOT NULL,
   Type_bFiction                       TINYINT UNSIGNED  NOT NULL,
   Owner_twRPersonaIx                  BIGINT            NOT NULL,
   Resource_qwResource                 BIGINT            NOT NULL,
   Resource_sName                      VARCHAR (48)      NOT NULL DEFAULT '',
   Resource_sReference                 VARCHAR (128)     NOT NULL DEFAULT '',
   Transform_Position_dX               DOUBLE            NOT NULL,
   Transform_Position_dY               DOUBLE            NOT NULL,
   Transform_Position_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dX               DOUBLE            NOT NULL,
   Transform_Rotation_dY               DOUBLE            NOT NULL,
   Transform_Rotation_dZ               DOUBLE            NOT NULL,
   Transform_Rotation_dW               DOUBLE            NOT NULL,
   Transform_Scale_dX                  DOUBLE            NOT NULL,
   Transform_Scale_dY                  DOUBLE            NOT NULL,
   Transform_Scale_dZ                  DOUBLE            NOT NULL,
   Bound_dX                            DOUBLE            NOT NULL,
   Bound_dY                            DOUBLE            NOT NULL,
   Bound_dZ                            DOUBLE            NOT NULL,
   Properties_bLockToGround            TINYINT UNSIGNED  NOT NULL,
   Properties_bYouth                   TINYINT UNSIGNED  NOT NULL,
   Properties_bAdult                   TINYINT UNSIGNED  NOT NULL,
   Properties_bAvatar                  TINYINT UNSIGNED  NOT NULL,

   CONSTRAINT PK_RMTObject PRIMARY KEY
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX IX_RMTObject_ObjectHead_Parent_twObjectIx
   (
      ObjectHead_Parent_twObjectIx     ASC
   ),

   INDEX IX_RMTObject_Name_wsRMTObjectId
   (
      Name_wsRMTObjectId               ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */

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

CREATE TABLE IF NOT EXISTS RMTObjectLog
(
   dtCreated                           DATETIME          NOT NULL    DEFAULT CURRENT_TIMESTAMP,
   twLogIx                             BIGINT            NOT NULL    AUTO_INCREMENT,
                                                         
   bOp                                 TINYINT UNSIGNED  NOT NULL,
   dwIPAddress                         BINARY(4)         NOT NULL,
   twRPersonaIx                        BIGINT            NOT NULL,
   twRMTObjectIx                       BIGINT            NOT NULL,

   CONSTRAINT PK_RMTObjectLog PRIMARY KEY
   (
      twLogIx                          ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */
