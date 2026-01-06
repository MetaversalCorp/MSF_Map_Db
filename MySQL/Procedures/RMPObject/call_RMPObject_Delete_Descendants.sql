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

DROP PROCEDURE IF EXISTS call_RMPObject_Delete_Descendants;

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Delete_Descendants
(
   IN    twRMPObjectIx                 BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE nCount INT;

            IF twRMPObjectIx IS NULL
          THEN
                INSERT INTO PObject
                       ( ObjectHead_Self_twObjectIx )
                  WITH RECURSIVE Tree AS
                       (
                         SELECT oa.ObjectHead_Self_twObjectIx
                           FROM TObject   AS p
                           JOIN RMPObject AS oa ON oa.ObjectHead_Parent_wClass     = SBO_CLASS_RMTOBJECT
                                               AND oa.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
                                
                          UNION ALL
               
                         SELECT ob.ObjectHead_Self_twObjectIx
                           FROM Tree      AS t
                           JOIN RMPObject AS ob ON ob.ObjectHead_Parent_wClass     = SBO_CLASS_RMPOBJECT
                                               AND ob.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                       )
                SELECT ObjectHead_Self_twObjectIx
                  FROM Tree;

                   SET bError = 0;

                   SET nCount = 0;
          ELSE
                INSERT INTO PObject
                       ( ObjectHead_Self_twObjectIx )
                  WITH RECURSIVE Tree AS
                       (
                         SELECT oa.ObjectHead_Self_twObjectIx
                           FROM RMPObject AS oa
                          WHERE oa.ObjectHead_Self_wClass     = SBO_CLASS_RMPOBJECT
                            AND oa.ObjectHead_Self_twObjectIx = twRMPObjectIx
                                
                          UNION ALL
               
                         SELECT ob.ObjectHead_Self_twObjectIx
                           FROM Tree      AS t
                           JOIN RMPObject AS ob ON ob.ObjectHead_Parent_wClass     = SBO_CLASS_RMPOBJECT
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
                   FROM PObject   AS p
                   JOIN RMPObject AS o ON o.ObjectHead_Self_twObjectIx = p.ObjectHead_Self_twObjectIx;
           
                    SET bError = IF (ROW_COUNT () >= nCount, 0, 1);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
