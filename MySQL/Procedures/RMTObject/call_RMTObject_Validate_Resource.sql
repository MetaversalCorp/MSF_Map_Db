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

DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Resource;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Resource
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Resource_qwResource           BIGINT,
   IN    Resource_sName                VARCHAR (48),
   IN    Resource_sReference           VARCHAR (128),
   INOUT nError                        INT
)
BEGIN
            IF Resource_qwResource IS NULL
          THEN
                   CALL call_Error (21, 'Resource_qwResource is NULL', nError);
        END IF ;
            IF Resource_sName IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sName is NULL',      nError);
        END IF ;
            IF Resource_sReference IS NULL
          THEN
                   CALL call_Error (21, 'Resource_sReference is NULL', nError);
        END IF ;

            -- do we want to check sName and sReference for length or invalid characters
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
