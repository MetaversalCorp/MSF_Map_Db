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

-- Note that this is not a function of the RMPObject itself, but rather a function of the two parents involved.

DROP PROCEDURE IF EXISTS set_RMPObject_Parent;

DELIMITER $$

CREATE PROCEDURE set_RMPObject_Parent
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    wClass                        SMALLINT,
   IN    twObjectIx                    BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE RMPOBJECT_OP_PARENT                        INT DEFAULT 18;

       DECLARE nError  INT DEFAULT 0;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE bError  INT;

       DECLARE ObjectHead_Parent_wClass     SMALLINT;
       DECLARE ObjectHead_Parent_twObjectIx BIGINT;
       DECLARE nCount                       INT;
       DECLARE nLock                        INT;

       DECLARE Name_wsRMPObjectId            VARCHAR (48);
       DECLARE Type_bType                    TINYINT UNSIGNED;
       DECLARE Type_bSubtype                 TINYINT UNSIGNED;
       DECLARE Type_bFiction                 TINYINT UNSIGNED;
       DECLARE Type_bMovable                 TINYINT UNSIGNED;
       DECLARE Owner_twRPersonaIx            BIGINT;
       DECLARE Resource_qwResource           BIGINT;
       DECLARE Resource_sName                VARCHAR (48);
       DECLARE Resource_sReference           VARCHAR (128);
       DECLARE Transform_Position_dX         DOUBLE;
       DECLARE Transform_Position_dY         DOUBLE;
       DECLARE Transform_Position_dZ         DOUBLE;
       DECLARE Transform_Rotation_dX         DOUBLE;
       DECLARE Transform_Rotation_dY         DOUBLE;
       DECLARE Transform_Rotation_dZ         DOUBLE;
       DECLARE Transform_Rotation_dW         DOUBLE;
       DECLARE Transform_Scale_dX            DOUBLE;
       DECLARE Transform_Scale_dY            DOUBLE;
       DECLARE Transform_Scale_dZ            DOUBLE;
       DECLARE Bound_dX                      DOUBLE;
       DECLARE Bound_dY                      DOUBLE;
       DECLARE Bound_dZ                      DOUBLE;

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
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

SET nLock = GET_LOCK ('parent', 10);

         START TRANSACTION;

          CALL call_RMPObject_Validate (twRPersonaIx, twRMPObjectIx, ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, nError);

            IF nError = 0
          THEN
                     IF wClass = ObjectHead_Parent_wClass  AND  twObjectIx = ObjectHead_Parent_twObjectIx
                   THEN
                            CALL call_Error (99, 'The new parent is the same as the current parent', nError);
                 ELSEIF wClass = SBO_CLASS_RMROOT
                   THEN
                              IF NOT EXISTS (SELECT 1 FROM RMRoot    WHERE ObjectHead_Self_twObjectIx = twObjectIx)
                            THEN
                                     CALL call_Error (99, 'twObjectIx is invalid', nError);
                          END IF ;
                 ELSEIF wClass = SBO_CLASS_RMTOBJECT
                   THEN
                              IF NOT EXISTS (SELECT 1 FROM RMTObject WHERE ObjectHead_Self_twObjectIx = twObjectIx)
                            THEN
                                     CALL call_Error (99, 'twObjectIx is invalid', nError);
                          END IF ;
                 ELSEIF wClass = SBO_CLASS_RMPOBJECT
                   THEN
                              IF NOT EXISTS (SELECT 1 FROM RMPObject WHERE ObjectHead_Self_twObjectIx = twObjectIx)
                            THEN
                                     CALL call_Error (99, 'twObjectIx is invalid', nError);
                          END IF ;
                   ELSE
                            CALL call_Error (99, 'wClass is invalid', nError);
                 END IF ;
        END IF ;

            IF nError = 0
          THEN
                 SELECT o.Name_wsRMPObjectId,
                        o.Type_bType,
                        o.Type_bSubtype,
                        o.Type_bFiction,
                        o.Type_bMovable,
                        o.Owner_twRPersonaIx,
                        o.Resource_qwResource,
                        o.Resource_sName,
                        o.Resource_sReference,
                        o.Transform_Position_dX,
                        o.Transform_Position_dY,
                        o.Transform_Position_dZ,
                        o.Transform_Rotation_dX,
                        o.Transform_Rotation_dY,
                        o.Transform_Rotation_dZ,
                        o.Transform_Rotation_dW,
                        o.Transform_Scale_dX,
                        o.Transform_Scale_dY,
                        o.Transform_Scale_dZ,
                        o.Bound_dX,
                        o.Bound_dY,
                        o.Bound_dZ
                   INTO Name_wsRMPObjectId,
                        Type_bType,
                        Type_bSubtype,
                        Type_bFiction,
                        Type_bMovable,
                        Owner_twRPersonaIx,
                        Resource_qwResource,
                        Resource_sName,
                        Resource_sReference,
                        Transform_Position_dX,
                        Transform_Position_dY,
                        Transform_Position_dZ,
                        Transform_Rotation_dX,
                        Transform_Rotation_dY,
                        Transform_Rotation_dZ,
                        Transform_Rotation_dW,
                        Transform_Scale_dX,
                        Transform_Scale_dY,
                        Transform_Scale_dZ,
                        Bound_dX,
                        Bound_dY,
                        Bound_dZ
                   FROM RMPObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = twRMPObjectIx;

                   CALL call_RMPObject_Validate_Type (wClass, twObjectIx, twRMPObjectIx, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, nError);
        END IF ;

            IF nError = 0
          THEN
                     IF ObjectHead_Parent_wClass = SBO_CLASS_RMROOT
                   THEN
                            CALL call_RMRoot_Event_RMPObject_Close    (ObjectHead_Parent_twObjectIx, twRMPObjectIx, bError, 1);
                 ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT
                   THEN
                            CALL call_RMTObject_Event_RMPObject_Close (ObjectHead_Parent_twObjectIx, twRMPObjectIx, bError, 1);
                 ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT
                   THEN
                            CALL call_RMPObject_Event_RMPObject_Close (ObjectHead_Parent_twObjectIx, twRMPObjectIx, bError, 1);
                   ELSE
                            CALL call_Error (99, 'Internal error', nError);
                 END IF ;

                     IF bError = 0
                   THEN
                          UPDATE RMPObject AS o
                             SET o.ObjectHead_Parent_wClass     = wClass,
                                 o.ObjectHead_Parent_twObjectIx = twObjectIx
                           WHERE o.ObjectHead_Self_twObjectIx = twRMPObjectIx;

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);

                              IF bError = 0
                            THEN
                                       IF wClass = SBO_CLASS_RMROOT
                                     THEN
                                              CALL call_RMRoot_Event_RMPObject_Open    (twObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx, bError, 1);
                                   ELSEIF wClass = SBO_CLASS_RMTOBJECT
                                     THEN
                                              CALL call_RMTObject_Event_RMPObject_Open (twObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx, bError, 1);
                                   ELSEIF wClass = SBO_CLASS_RMPOBJECT
                                     THEN
                                              CALL call_RMPObject_Event_RMPObject_Open (twObjectIx, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, twRMPObjectIx, bError, 1);
                                     ELSE
                                              CALL call_Error (99, 'Internal error', nError);
                                   END IF ;
                  
                                       IF bError = 0
                                     THEN
                                               SET bCommit = 1;
                                     ELSE
                                              CALL call_Error (-3, 'Failed to update new parent');
                                   END IF ;
                            ELSE
                                     CALL call_Error (-2, 'Failed to update RMPObject');
                          END IF ;
                   ELSE
                            CALL call_Error (-1, 'Failed to update old parent');
                 END IF ;
        END IF ;

            IF bCommit = 1
          THEN
                    SET bCommit = 0;
                 
                   CALL call_RMPObject_Log (RMPOBJECT_OP_PARENT, sIPAddress, twRPersonaIx, twRMPObjectIx, bError);
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

SET nLock = RELEASE_LOCK ('parent');

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Event;

           SET nResult = bCommit - 1 - nError;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
