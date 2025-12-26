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

DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Name;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Name
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Name_wsRMCObjectId            VARCHAR (48),
   INOUT nError                        INT
)
BEGIN
            IF Name_wsRMCObjectId IS NULL
          THEN
                   CALL call_Error (21, 'Name_wsRMCObjectId is NULL', nError);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
