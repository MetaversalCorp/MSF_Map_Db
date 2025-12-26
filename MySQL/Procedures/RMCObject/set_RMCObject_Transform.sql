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

DROP PROCEDURE IF EXISTS set_RMCObject_Transform;

DELIMITER $$

CREATE PROCEDURE set_RMCObject_Transform
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
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
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMCOBJECT_OP_TRANSFORM                     INT DEFAULT 5;

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
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

         START TRANSACTION;

          CALL call_RMCObject_Validate (twRPersonaIx, twRMCObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);
            IF nError = 0
          THEN
                   CALL call_RMCObject_Validate_Transform (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMCObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMCObject_Event_Transform (twRMCObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMCObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMCObject_Log (RMCOBJECT_OP_TRANSFORM, sIPAddress, twRPersonaIx, twRMCObjectIx, bError);
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
