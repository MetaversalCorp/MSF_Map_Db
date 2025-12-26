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

DROP PROCEDURE IF EXISTS set_RMTObject_Resource;

DELIMITER $$

CREATE PROCEDURE set_RMTObject_Resource
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTOBJECT_OP_RESOURCE                      INT DEFAULT 4;

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
                   CALL call_RMTObject_Validate_Resource (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, twRMTObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, nError);
        END IF ;

            IF nError = 0
          THEN
                   CALL call_RMTObject_Event_Resource (twRMTObjectIx, Resource_qwResource, Resource_sName, Resource_sReference, bError);
                     IF bError = 0
                   THEN
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (-1, 'Failed to update RMTObject', nError);
                 END IF ;
        END IF ;
       
            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMTObject_Log (RMTOBJECT_OP_RESOURCE, sIPAddress, twRPersonaIx, twRMTObjectIx, bError);
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
