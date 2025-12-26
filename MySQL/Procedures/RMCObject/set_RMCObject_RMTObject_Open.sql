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

DROP PROCEDURE IF EXISTS set_RMCObject_RMTObject_Open;

DELIMITER $$

CREATE PROCEDURE set_RMCObject_RMTObject_Open
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMTObjectId            VARCHAR (48),
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
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   IN    bCoord                        TINYINT UNSIGNED,
   IN    dA                            DOUBLE,
   IN    dB                            DOUBLE,
   IN    dC                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE RMCOBJECT_OP_RMTOBJECT_OPEN                INT DEFAULT 13;
       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

       DECLARE twRMTObjectIx_Open           BIGINT;

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
                   CALL call_RMTObject_Validate_Name       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Name_wsRMTObjectId, nError);
                   CALL call_RMTObject_Validate_Type       (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Type_bType, Type_bSubtype, Type_bFiction, nError);
                   CALL call_RMTObject_Validate_Owner      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Owner_twRPersonaIx, nError);
                   CALL call_RMTObject_Validate_Resource   (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Resource_qwResource, Resource_sName, Resource_sReference, nError);
                -- CALL call_RMTObject_Validate_Transform  (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                   CALL call_RMTObject_Validate_Bound      (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Bound_dX, Bound_dY, Bound_dZ, nError);
                   CALL call_RMTObject_Validate_Properties (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, nError);

                     IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Nul (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                 ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                   THEN
                        CALL call_RMTObject_Validate_Coord_Car (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Cyl (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, dA, dB, dC, nError);
                 ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                   THEN
                        CALL call_RMTObject_Validate_Coord_Geo (SBO_CLASS_RMCOBJECT, twRMCObjectIx, 0, dA, dB, dC, nError);
                   ELSE 
                        CALL call_Error (99, 'bCoord is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_RMTObject_Open (twRMCObjectIx, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar, twRMTObjectIx_Open, bError);
                     IF bError = 0
                   THEN
                              IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                            THEN
                                 CALL call_RMTMatrix_Nul (SBO_CLASS_RMCOBJECT, twRMCObjectIx, twRMTObjectIx_Open, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);
                          ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                            THEN
                                 CALL call_RMTMatrix_Car (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                            THEN
                                 CALL call_RMTMatrix_Cyl (twRMTObjectIx_Open, dA, dB, dC);
                          ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                            THEN
                                 CALL call_RMTMatrix_Geo (twRMTObjectIx_Open, dA, dB, dC);
                          END IF ;

                            CALL call_RMTMatrix_Relative (SBO_CLASS_RMCOBJECT, twRMCObjectIx, twRMTObjectIx_Open);

                          SELECT twRMTObjectIx_Open AS twRMTObjectIx;
   
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to insert RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_RMTOBJECT_OPEN, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
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
