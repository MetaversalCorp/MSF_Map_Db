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

/*
   The NodeJS server calls this function periodically to retrieve events from the queue.
*/

DROP PROCEDURE IF EXISTS etl_Events;

DELIMITER $$

CREATE PROCEDURE etl_Events
(
   OUT   bError                        INT
)
BEGIN
        CREATE TEMPORARY TABLE Events
               (
                  twEventIx      BIGINT
               );

         START TRANSACTION;

        INSERT INTO Events
             ( twEventIx )
        SELECT twEventIx
          FROM RMEvent
      ORDER BY twEventIx ASC
         LIMIT 100;

        SELECT CONCAT
               (
                 '{ ',
                   '"sType": ',     '"', e.sType, '"',
                 ', "pControl": ',  Format_Control (e.Self_wClass, e.Self_twObjectIx, e.Child_wClass, e.Child_twObjectIx, e.wFlags, e.twEventIz),
                 ', "pObject": ',   e.sJSON_Object,
                 ', "pChild": ',    e.sJSON_Child,
                 ', "pChange": ',   e.sJSON_Change,
                ' }'
               )
               AS `Object`
          FROM RMEvent AS e
          JOIN Events AS t ON t.twEventIx = e.twEventIx
      ORDER BY e.twEventIx;
       
        DELETE e
          FROM RMEvent AS e
          JOIN Events AS t ON t.twEventIx = e.twEventIx;

        SELECT COUNT(*) AS nCount
          FROM RMEvent;
       
        COMMIT ;

          DROP TEMPORARY TABLE Events;

           SET bError = 0;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
