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

DROP PROCEDURE IF EXISTS call_RMPObject_Event_Type;

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Event_Type
(
   IN    twRMPObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   IN    Type_bMovable                 TINYINT UNSIGNED,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE twEventIz BIGINT;

          CALL call_RMPObject_Event (twRMPObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMPObject AS o
                    SET o.Type_bType    = Type_bType,
                        o.Type_bSubtype = Type_bSubtype,
                        o.Type_bFiction = Type_bFiction,
                        o.Type_bMovable = Type_bMovable
                  WHERE o.ObjectHead_Self_twObjectIx = twRMPObjectIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'TYPE',

                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pType": ',         Format_Type_P
                                                          (
                                                             Type_bType,
                                                             Type_bSubtype,
                                                             Type_bFiction,
                                                             Type_bMovable
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
