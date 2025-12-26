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

DROP PROCEDURE IF EXISTS call_RMRoot_Validate;

DELIMITER $$

CREATE PROCEDURE call_RMRoot_Validate
(
   IN    twRPersonaIx                  BIGINT,
   IN    twRMRootIx                    BIGINT,
   OUT   ObjectHead_Parent_wClass      SMALLINT,
   OUT   ObjectHead_Parent_twObjectIx  BIGINT,
   INOUT nError                        INT
)
BEGIN
       DECLARE bAdmin INT DEFAULT 0;
       DECLARE nCount INT;

            IF EXISTS (SELECT 1 FROM Admin AS a WHERE a.twRPersonaIx = twRPersonaIx)
          THEN
                    SET bAdmin = 1;
        END IF ;

        SELECT o.ObjectHead_Parent_wClass, o.ObjectHead_Parent_twObjectIx
          INTO   ObjectHead_Parent_wClass,   ObjectHead_Parent_twObjectIx
          FROM RMRoot AS o
         WHERE o.ObjectHead_Self_twObjectIx = twRMRootIx;

           SET nCount = ROW_COUNT ();

            IF twRPersonaIx <= 0
          THEN
                   CALL call_Error (1, 'twRPersonaIx is invalid', nError);
        ELSEIF twRMRootIx <= 0
          THEN
                   CALL call_Error (2, 'twRMRootIx is invalid',   nError);
        ELSEIF nCount <> 1
          THEN
                   CALL call_Error (3, 'twRMRootIx is unknown',   nError);
        ELSEIF bAdmin = 0
          THEN
                   CALL call_Error (4, 'Invalid rights',          nError);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
