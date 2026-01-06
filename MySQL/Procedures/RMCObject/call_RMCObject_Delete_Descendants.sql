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

DROP PROCEDURE IF EXISTS call_RMCObject_Delete_Descendants;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Delete_Descendants
(
   IN    twRMCObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE nCount INT;

            IF twRMCObjectIx IS NULL
          THEN
                INSERT INTO CObject
                       ( ObjectHead_Self_twObjectIx )
                  WITH RECURSIVE Tree AS
                       (
                         SELECT oa.ObjectHead_Self_twObjectIx
                           FROM Root      AS p
                           JOIN RMCObject AS oa ON oa.ObjectHead_Parent_wClass     = SBO_CLASS_RMROOT
                                               AND oa.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
                                
                          UNION ALL
               
                         SELECT ob.ObjectHead_Self_twObjectIx
                           FROM Tree      AS t
                           JOIN RMCObject AS ob ON ob.ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                                               AND ob.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                       )
                SELECT ObjectHead_Self_twObjectIx
                  FROM Tree;

                   SET bError = 0;

                   SET nCount = 0;
          ELSE
                INSERT INTO CObject
                       ( ObjectHead_Self_twObjectIx )
                  WITH RECURSIVE Tree AS
                       (
                         SELECT oa.ObjectHead_Self_twObjectIx
                           FROM RMCObject AS oa
                          WHERE oa.ObjectHead_Self_wClass     = SBO_CLASS_RMCOBJECT
                            AND oa.ObjectHead_Self_twObjectIx = twRMCObjectIx
                                
                          UNION ALL
               
                         SELECT ob.ObjectHead_Self_twObjectIx
                           FROM Tree      AS t
                           JOIN RMCObject AS ob ON ob.ObjectHead_Parent_wClass     = SBO_CLASS_RMCOBJECT
                                               AND ob.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                       )
                SELECT ObjectHead_Self_twObjectIx
                  FROM Tree;

                   SET bError = 0;

                   SET nCount = 1;
        END IF ;

            IF bError = 0
          THEN
                 DELETE o
                   FROM CObject   AS p
                   JOIN RMCObject AS o ON o.ObjectHead_Self_twObjectIx = p.ObjectHead_Self_twObjectIx;
         
                    SET bError = IF (ROW_COUNT () >= nCount, 0, 1);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
