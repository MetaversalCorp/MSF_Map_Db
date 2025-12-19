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

CREATE TABLE IF NOT EXISTS RMPType
(
   bType                               TINYINT UNSIGNED  NOT NULL,
   sType                               VARCHAR (31)      NOT NULL,

   CONSTRAINT PK_RMPType PRIMARY KEY
   (
      bType ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */

CREATE TABLE IF NOT EXISTS RMPObject
(
   ObjectHead_Parent_wClass            SMALLINT          NOT NULL,
   ObjectHead_Parent_twObjectIx        BIGINT            NOT NULL,
   ObjectHead_Self_wClass              SMALLINT          NOT NULL,
   ObjectHead_Self_twObjectIx          BIGINT            NOT NULL AUTO_INCREMENT,
   ObjectHead_twEventIz                BIGINT            NOT NULL,
   ObjectHead_wFlags                   SMALLINT          NOT NULL,

   Name_wsRMPObjectId                  VARCHAR (48)      NOT NULL DEFAULT '',
   Type_bType                          TINYINT UNSIGNED  NOT NULL,
   Type_bSubtype                       TINYINT UNSIGNED  NOT NULL,
   Type_bFiction                       TINYINT UNSIGNED  NOT NULL,
   Type_bMovable                       TINYINT UNSIGNED  NOT NULL,
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

   CONSTRAINT PK_RMPObject PRIMARY KEY
   (
      ObjectHead_Self_twObjectIx       ASC
   ),

   INDEX IX_RMPObject_ObjectHead_Parent_twObjectIx
   (
      ObjectHead_Parent_twObjectIx     ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */

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

CREATE TABLE IF NOT EXISTS RMPObjectLog
(
   dtCreated                           DATETIME          NOT NULL    DEFAULT CURRENT_TIMESTAMP,
   twLogIx                             BIGINT            NOT NULL    AUTO_INCREMENT,
                                                         
   bOp                                 TINYINT UNSIGNED  NOT NULL,
   dwIPAddress                         BINARY(4)         NOT NULL,
   twRPersonaIx                        BIGINT            NOT NULL,
   twRMPObjectIx                       BIGINT            NOT NULL,

   CONSTRAINT PK_RMPObjectLog PRIMARY KEY
   (
      twLogIx                          ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */
