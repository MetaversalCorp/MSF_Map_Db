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

DROP PROCEDURE IF EXISTS call_RMTObject_Event_RMTObject_Close;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_RMTObject_Close
(
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

       DECLARE nCount    INT DEFAULT 0;

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);
            IF bError = 0
          THEN
                 DELETE FROM RMTMatrix                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE bnMatrix =     twRMTObjectIx_Close
                     OR bnMatrix = 0 - twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT (); -- 2

                 DELETE FROM RMTSubsurface                                    -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE twRMTObjectIx = twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT (); -- 1

                 DELETE FROM RMTObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                  WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx_Close;

                    SET nCount = nCount + ROW_COUNT (); -- 1

                    SET bError = IF (nCount = 4, 0, 1); -- this will only return the error of the last delete statement

                     IF bError = 0
                   THEN
                          INSERT INTO Event
                                 (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                          SELECT 'RMTOBJECT_CLOSE',

                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx,
                                 SBO_CLASS_RMTOBJECT,
                                 twRMTObjectIx_Close,
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
