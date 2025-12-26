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

DROP PROCEDURE IF EXISTS call_RMTObject_Log;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Log
(
   IN    bOp                           TINYINT UNSIGNED,
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE dwIPAddress BINARY (4) DEFAULT IPstob (sIPAddress);

        INSERT INTO RMTObjectLog
               (bOp, dwIPAddress, twRPersonaIx, twRMTObjectIx)
        VALUES (bOp, dwIPAddress, twRPersonaIx, twRMTObjectIx);
 
           SET bError = IF (ROW_COUNT () = 1, 0, 1);
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
