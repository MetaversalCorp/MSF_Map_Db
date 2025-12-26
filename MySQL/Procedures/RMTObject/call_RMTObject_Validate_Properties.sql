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

DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Properties;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Properties
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Properties_bLockToGround      TINYINT UNSIGNED,
   IN    Properties_bYouth             TINYINT UNSIGNED,
   IN    Properties_bAdult             TINYINT UNSIGNED,
   IN    Properties_bAvatar            TINYINT UNSIGNED,
   INOUT nError                        INT
)
BEGIN
            IF Properties_bLockToGround IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bLockToGround is NULL',    nError);
        ELSEIF Properties_bLockToGround NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bLockToGround is invalid', nError);
        END IF ;

            IF Properties_bYouth IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bYouth is NULL',           nError);
        ELSEIF Properties_bYouth NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bYouth is invalid',        nError);
        END IF ;

            IF Properties_bAdult IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bAdult is NULL',           nError);
        ELSEIF Properties_bAdult NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bAdult is invalid',        nError);
        END IF ;

            IF Properties_bAvatar IS NULL
          THEN
                   CALL call_Error (21, 'Properties_bAvatar is NULL',          nError);
        ELSEIF Properties_bAvatar NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Properties_bAvatar is invalid',       nError);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
