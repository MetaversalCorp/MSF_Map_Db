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

DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Owner;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Owner
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Owner_twRPersonaIx            BIGINT,
   INOUT nError                        INT
)
BEGIN
            IF Owner_twRPersonaIx IS NULL
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is NULL',    nError);
        ELSEIF Owner_twRPersonaIx NOT BETWEEN 1 AND 0x0000FFFFFFFFFFFC
          THEN
                   CALL call_Error (21, 'Owner_twRPersonaIx is invalid', nError);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
