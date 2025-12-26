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

DROP PROCEDURE IF EXISTS call_RMRoot_Event_RMPObject_Close;

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Event_RMPObject_Close
(
   IN    twRMRootIx                    BIGINT,
   IN    twRMPObjectIx_Close           BIGINT,
   OUT   bError                        INT,
   IN    bReparent                     TINYINT UNSIGNED
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

          CALL call_RMRoot_Event (twRMRootIx, twEventIz, bError);
            IF bError = 0
          THEN
                     IF bReparent = 0
                   THEN
                          DELETE FROM RMPObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                           WHERE ObjectHead_Self_twObjectIx = twRMPObjectIx_Close;
         
                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMPOBJECT_CLOSE',

                                 SBO_CLASS_RMROOT,
                                 twRMRootIx,
                                 SBO_CLASS_RMPOBJECT,
                                 twRMPObjectIx_Close,
                                 SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                                 twEventIz,

                                 '{ }',

                                 '{ }',

                                 '{ }';

                             SET bError = IF (ROW_COUNT () = 1, 0, 1);
                 END IF ;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
