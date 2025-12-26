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

DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMTObject_Open;

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMTObject_Open
(
   IN    twRMRootIx                    BIGINT,
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
   OUT   twRMTObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 INSERT INTO RMTObject
                        (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar)
                 VALUES (SBO_CLASS_RMROOT,         twRMRootIx,                   SBO_CLASS_RMTOBJECT,    0,                    32,                Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar);

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                             SET twRMTObjectIx = LAST_INSERT_ID ();

                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_OPEN',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_T
                                                          (
                                                             Name_wsRMTObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_T
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction
                                                          ),
                                   ', "pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
                                                          ),
                                   ', "pResource": ',     Format_Resource
                                                          (
                                                             Resource_qwResource,
                                                             Resource_sName,
                                                             Resource_sReference
                                                          ),
                                   ', "pTransform": ',    Format_Transform
                                                          (
                                                             Transform_Position_dX,
                                                             Transform_Position_dY,
                                                             Transform_Position_dZ,
                                                             Transform_Rotation_dX,
                                                             Transform_Rotation_dY,
                                                             Transform_Rotation_dZ,
                                                             Transform_Rotation_dW,
                                                             Transform_Scale_dX,
                                                             Transform_Scale_dY,
                                                             Transform_Scale_dZ
                                                          ),
                                   ', "pBound": ',        Format_Bound
                                                          (
                                                             Bound_dX,
                                                             Bound_dY,
                                                             Bound_dZ
                                                          ),
                                   ', "pProperties": ',   Format_Properties_T
                                                          (
                                                             Properties_bLockToGround,
                                                             Properties_bYouth,
                                                             Properties_bAdult,
                                                             Properties_bAvatar
                                                          ),
                                  ' }'
                                 ),

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
