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

DROP PROCEDURE IF EXISTS get_RMCObject_Update;

DELIMITER $$

CREATE PROCEDURE get_RMCObject_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE MVO_RMCOBJECT_TYPE_SURFACE                 INT DEFAULT 17;

       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;

       DECLARE bType TINYINT UNSIGNED;

            -- Create the temp Error table
        CREATE TEMPORARY TABLE Error
               (
                  nOrder                        INT             NOT NULL AUTO_INCREMENT PRIMARY KEY,
                  dwError                       INT             NOT NULL,
                  sError                        VARCHAR (255)   NOT NULL
               );

            -- Create the temp Results table
        CREATE TEMPORARY TABLE Results
               (
                  nResultSet                    INT,
                  ObjectHead_Self_twObjectIx    BIGINT
               );

           SET twRPersonaIx  = IFNULL (twRPersonaIx,  0);
           SET twRMCObjectIx = IFNULL (twRMCObjectIx, 0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMCObjectIx <= 0
          THEN
               CALL call_Error (2, 'CObject is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 SELECT c.Type_bType INTO bType
                   FROM RMCObject AS c
                  WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx;

                 INSERT INTO Results
                 SELECT 0,
                        c.ObjectHead_Self_twObjectIx
                   FROM RMCObject AS c
                  WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx;

                     IF ROW_COUNT () = 1  AND  bType IS NOT NULL
                   THEN
                              IF bType <> MVO_RMCOBJECT_TYPE_SURFACE
                            THEN
                                   INSERT INTO Results
                                   SELECT 1,
                                          x.ObjectHead_Self_twObjectIx
                                     FROM RMCObject AS c
                                     JOIN RMCObject AS x ON x.ObjectHead_Parent_wClass     = c.ObjectHead_Self_wClass
                                                        AND x.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
                                    WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx
                                 ORDER BY x.ObjectHead_Self_twObjectIx ASC;
                            ELSE
                                   INSERT INTO Results
                                   SELECT 1,
                                          t.ObjectHead_Self_twObjectIx
                                     FROM RMCObject AS c
                                     JOIN RMTObject AS t ON t.ObjectHead_Parent_wClass     = c.ObjectHead_Self_wClass
                                                        AND t.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
                                    WHERE c.ObjectHead_Self_twObjectIx = twRMCObjectIx
                                 ORDER BY t.ObjectHead_Self_twObjectIx ASC;
                          END IF ;
             
                            CALL call_RMCObject_Select(0);
                              IF bType <> MVO_RMCOBJECT_TYPE_SURFACE
                            THEN
                                     CALL call_RMCObject_Select (1);
                            ELSE
                                     CALL call_RMTObject_Select (1);
                          END IF ;
             
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (3, 'CObject does not exist', nError);
                 END IF ;
        END IF ;

            IF bCommit = 0
          THEN
               SELECT dwError, sError FROM Error;
        END IF ;

          DROP TEMPORARY TABLE Error;
          DROP TEMPORARY TABLE Results;

           SET nResult = bCommit - 1 - nError;

END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
