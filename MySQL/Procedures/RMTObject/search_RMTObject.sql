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

DROP PROCEDURE IF EXISTS search_RMTObject;

DELIMITER $$

CREATE PROCEDURE search_RMTObject
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dX                            DOUBLE,
   IN    dY                            DOUBLE,
   IN    dZ                            DOUBLE,
   IN    sText                         VARCHAR (48)
)
BEGIN
       DECLARE MVO_RMTOBJECT_TYPE_COMMUNITY              INT DEFAULT 9;

       DECLARE bError  INT;
       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT;

       DECLARE bType   TINYINT UNSIGNED;
       DECLARE dRange  DOUBLE;
       DECLARE nCount  INT DEFAULT 0;

       DECLARE dRadius DOUBLE DEFAULT 6371000; -- where do we get this?
       DECLARE dHeight DOUBLE DEFAULT SQRT ((dX * dX) + (dY * dY) + (dZ * dZ));
       DECLARE dNormal DOUBLE DEFAULT IF (dHeight > 0, dRadius / dHeight, 1.0);

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Result table
        CREATE TEMPORARY TABLE Result
               (
                  nOrder                        INT                      AUTO_INCREMENT PRIMARY KEY,
                  ObjectHead_Self_twObjectIx    BIGINT,
                  dFactor                       DOUBLE,
                  dDistance                     DOUBLE
               );

        SELECT Type_bType INTO bType
          FROM RMTObject
         WHERE ObjectHead_Self_twObjectIx = twRMTObjectIx;

            IF bType IS NULL
          THEN
                SET bError = 1;
        END IF ;

            IF bError = 0
          THEN
                    SET sText = TRIM (IFNULL (sText, ''));

                     IF sText <> ''
                   THEN
                              -- positions must be normalized to the surface

                             SET dX = dX * dNormal;
                             SET dY = dY * dNormal;
                             SET dZ = dZ * dNormal;

                          INSERT INTO Result
                               (
                                 ObjectHead_Self_twObjectIx, 
                                 dFactor,
                                 dDistance
                               )
                          SELECT 
                                 o.ObjectHead_Self_twObjectIx, 
                                 POW (4.0, o.Type_bType - 7) AS dFactor, 
                                 IF (dHeight > 0, dRadius, ArcLength (dRadius, dX, dY, dZ, m.d03, m.d13, m.d23)) AS dDistance
                            FROM RMTObject AS o
                            JOIN RMTMatrix AS m ON m.bnMatrix = o.ObjectHead_Self_twObjectIx

                           WHERE o.Name_wsRMTObjectId LIKE CONCAT(sText, '%')
                             AND o.Type_bType BETWEEN bType + 1 AND MVO_RMTOBJECT_TYPE_COMMUNITY
                        ORDER BY POW (4.0, o.Type_bType - 7) * ArcLength (dRadius, dX, dY, dZ, m.d03, m.d13, m.d23), o.Name_wsRMTObjectId
                           LIMIT 10;

                          SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,  -- change client to new names
                                 o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,     -- change client to new names
                                 o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,  -- change client to new names
                                 o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,     -- change client to new names
                                 o.ObjectHead_wFlags,
                                 o.ObjectHead_twEventIz,
                                 o.Name_wsRMTObjectId,
                                 o.Type_bType,
                                 o.Type_bSubtype,
                                 o.Type_bFiction,
                                 r.nOrder,
                                 r.dFactor,
                                 r.dDistance
                            FROM RMTObject AS o
                            JOIN Result    AS r ON r.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                        ORDER BY r.nOrder;

                              -- select also all of the ancestors of the result set

                            WITH RECURSIVE Tree AS
                                 (
                                   SELECT oa.ObjectHead_Parent_wClass,
                                          oa.ObjectHead_Parent_twObjectIx,
                                          oa.ObjectHead_Self_wClass,
                                          oa.ObjectHead_Self_twObjectIx,
                                          r.nOrder,
                                          0                               AS nAncestor
                                     FROM RMTObject AS oa
                                     JOIN Result    AS r  ON r.ObjectHead_Self_twObjectIx = oa.ObjectHead_Self_twObjectIx
 
                                    UNION ALL
 
                                   SELECT ob.ObjectHead_Parent_wClass,
                                          ob.ObjectHead_Parent_twObjectIx,
                                          ob.ObjectHead_Self_wClass,
                                          ob.ObjectHead_Self_twObjectIx,
                                          x.nOrder,
                                          x.nAncestor + 1                 AS nAncestor
                                     FROM RMTObject AS ob
                                     JOIN Tree      AS x  ON x.ObjectHead_Parent_twObjectIx = ob.ObjectHead_Self_twObjectIx
                                                         AND x.ObjectHead_Parent_wClass     = ob.ObjectHead_Self_wClass
                                 )
                          SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,  -- change client to new names
                                 o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,     -- change client to new names
                                 o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,  -- change client to new names
                                 o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,     -- change client to new names
                                 o.ObjectHead_wFlags,
                                 o.ObjectHead_twEventIz,
                                 o.Name_wsRMTObjectId,
                                 o.Type_bType,
                                 o.Type_bSubtype,
                                 o.Type_bFiction,
                                 x.nOrder,
                                 x.nAncestor
                            FROM RMTObject AS o
                            JOIN Tree      AS x ON x.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                           WHERE x.nAncestor > 0
                        ORDER BY x.nOrder,
                                 x.nAncestor;
                   ELSE
                          SELECT NULL AS Unused LIMIT 0;
                          SELECT NULL AS Unused LIMIT 0;
                 END IF ;

                    SET bCommit = 1;
          ELSE
                   CALL call_Error (1, 'twRMTObjectIx is invalid', nError);
        END IF ;

            IF bCommit = 0
          THEN
                  SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Result;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
