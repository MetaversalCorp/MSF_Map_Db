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

DROP PROCEDURE IF EXISTS call_RMPObject_Event_RMPObject_Open;

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_RMPObject_Open
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Name_wsRMPObjectId            VARCHAR (48),
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
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
   INOUT twRMPObjectIx_Open            BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN

       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN   INT DEFAULT 0x01;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          INSERT INTO RMPObject
                                 (ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ)
                          VALUES (SBO_CLASS_RMPOBJECT,      twRMPObjectIx,                SBO_CLASS_RMPOBJECT,    0,                    32,                Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ);
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);

                             SET twRMPObjectIx_Open = LAST_INSERT_ID ();
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_OPEN',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Open,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                                 twEventIz,

                                 '{ }',

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pName": ',         Format_Name_P
                                                          (
                                                             Name_wsRMPObjectId
                                                          ),
                                   ', "pType": ',         Format_Type_P
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction,
                                                             Type_bMovable
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
                                  ' }'
                                 ),

                                 '{ }';

                               SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
