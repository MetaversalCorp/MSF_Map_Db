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

DROP PROCEDURE IF EXISTS call_RMCObject_Event;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Event
(
   IN    twRMCObjectIx                 BIGINT,
   OUT   twEventIz                     BIGINT,
   OUT   bError                        INT
)
BEGIN
        SELECT ObjectHead_twEventIz
          INTO twEventIz
          FROM RMCObject
         WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

            -- Success will be tested on the update below

        UPDATE RMCObject
           SET ObjectHead_twEventIz = ObjectHead_twEventIz + 1
         WHERE ObjectHead_Self_twObjectIx = twRMCObjectIx;

           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
