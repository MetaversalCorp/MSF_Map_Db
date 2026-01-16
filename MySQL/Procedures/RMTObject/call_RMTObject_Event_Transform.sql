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

DROP PROCEDURE IF EXISTS call_RMTObject_Event_Transform;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_Transform
(
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
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE twEventIz BIGINT;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMTObject AS o
                    SET o.Transform_Position_dX = Transform_Position_dX,
                        o.Transform_Position_dY = Transform_Position_dY,
                        o.Transform_Position_dZ = Transform_Position_dZ,
                        o.Transform_Rotation_dX = Transform_Rotation_dX,
                        o.Transform_Rotation_dY = Transform_Rotation_dY,
                        o.Transform_Rotation_dZ = Transform_Rotation_dZ,
                        o.Transform_Rotation_dW = Transform_Rotation_dW,
                        o.Transform_Scale_dX    = Transform_Scale_dX,
                        o.Transform_Scale_dY    = Transform_Scale_dY,
                        o.Transform_Scale_dZ    = Transform_Scale_dZ
                  WHERE o.ObjectHead_Self_twObjectIx = twRMTObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TRANSFORM',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pTransform": ',    Format_Transform
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
                                  ' }'
                                 ),

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
