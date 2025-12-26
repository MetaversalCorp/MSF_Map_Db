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

DROP PROCEDURE IF EXISTS set_RMTObject_Transform;

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Transform
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
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
   IN    bCoord                        TINYINT UNSIGNED,
   IN    dA                            DOUBLE,
   IN    dB                            DOUBLE,
   IN    dC                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_TRANSFORM                     INT DEFAULT 5;
       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;

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
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

         START TRANSACTION;

          CALL call_RMTObject_Validate (twRPersonaIx, twRMTObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                     IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Nul (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
                 ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                   THEN
                        CALL call_RMTObject_Validate_Coord_Car (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, dA, dB, dC, nError);
                 ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                   THEN
                        CALL call_RMTObject_Validate_Coord_Cyl (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, dA, dB, dC, nError);
                 ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                   THEN
                        CALL call_RMTObject_Validate_Coord_Geo (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, dA, dB, dC, nError);
                   ELSE 
                        CALL call_Error (99, 'bCoord is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Transform(twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, bError);
                     IF bError = 0
                   THEN
                          DELETE FROM RMTMatrix
                           WHERE bnMatrix = twRMTObjectIx
                              OR bnMatrix = 0 - twRMTObjectIx;

                          -- SET nCount += @@ROWCOUNT -- 2

                          DELETE FROM RMTSubsurface
                           WHERE twRMTObjectIx = twRMTObjectIx;

                          -- SET nCount += @@ROWCOUNT -- 1

                          -- assume these succeeded for now

                              IF bCoord = 3 -- RMTMATRIX_COORD_NUL
                            THEN
                                 CALL call_RMTMatrix_Nul(ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);
                          ELSEIF bCoord = 2 -- RMTMATRIX_COORD_CAR
                            THEN
                                 CALL call_RMTMatrix_Car(twRMTObjectIx, dA, dB, dC);
                          ELSEIF bCoord = 1 -- RMTMATRIX_COORD_CYL
                            THEN
                                 CALL call_RMTMatrix_Cyl(twRMTObjectIx, dA, dB, dC);
                          ELSEIF bCoord = 0 -- RMTMATRIX_COORD_GEO
                            THEN
                                 CALL call_RMTMatrix_Geo(twRMTObjectIx, dA, dB, dC);
                          END IF ;

                            CALL call_RMTMatrix_Relative(ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx);

                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_TRANSFORM, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
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
