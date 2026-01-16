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

DROP PROCEDURE IF EXISTS call_RMRoot_Event_Owner;

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_Owner
(
   IN    twRMRootIx                    BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                 UPDATE RMRoot AS o
                    SET o.Owner_twRPersonaIx = Owner_twRPersonaIx
                  WHERE o.ObjectHead_Self_twObjectIx = twRMRootIx;

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'OWNER',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_NULL,
                                 0,
                                 0,
                                 twEventIz,

                                 CONCAT
                                 (
                                   '{ ',
                                     '"pOwner": ',        Format_Owner
                                                          (
                                                             Owner_twRPersonaIx
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
