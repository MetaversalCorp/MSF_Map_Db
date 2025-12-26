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

DROP PROCEDURE IF EXISTS set_RMCObject_RMCObject_Open;

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMCObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Owner_twRPersonaIx            BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMCOBJECT_OP_RMCOBJECT_OPEN                INT DEFAULT 11;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMCObjectIx_Open           BIGINT;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Event table
        CREATE TEMPORARY TABLE Event
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  sType                         VARCHAR (50)    NOT NULL,
                  Self_wClass                   SMALLINT        NOT NULL,
                  Self_twObjectIx               BIGINT          NOT NULL,
                  Child_wClass                  SMALLINT        NOT NULL,
                  Child_twObjectIx              BIGINT          NOT NULL,
                  wFlags                        SMALLINT        NOT NULL,
                  twEventIz                     BIGINT          NOT NULL,
                  sJSON_Object                  TEXT            NOT NULL,
                  sJSON_Child                   TEXT            NOT NULL,
                  sJSON_Change                  TEXT            NOT NULL
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Name       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Name_wsRMCObjectId, nError);
                   CALL call_RMCObject_Validate_Type       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMCObject_Validate_Owner      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMCObject_Validate_Resource   (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                   CALL call_RMCObject_Validate_Transform  (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMCObject_Validate_Orbit_Spin (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, nError);
                   CALL call_RMCObject_Validate_Bound      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMCObject_Validate_Properties (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMCObject_Open (twRMCObjectIx, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity, twRMCObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                          SELECT twRMCObjectIx_Open AS twRMCObjectIx;
   
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to insert RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMCOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
                     IF bError = 0
                   THEN
                            CALL call_Event_Push (bError);
                              IF bError = 0
                            THEN
                                      SET bCommit = 1;
                            ELSE
                                     CALL call_Error (-9, 'Failed to push events', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (-8, 'Failed to log action', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
                 SELECT dwError, sError FROM Error;

               ROLLBACK ;
          ELSE
                 COMMIT ;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
