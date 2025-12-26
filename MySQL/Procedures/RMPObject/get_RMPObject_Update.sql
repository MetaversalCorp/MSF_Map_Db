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

DROP PROCEDURE IF EXISTS get_RMPObject_Update;

DELIMITER $$

CREATE PROCEDURE get_RMPObject_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE bCommit INT DEFAULT 0;
       DECLARE nError  INT DEFAULT 0;

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
           SET twRMPObjectIx = IFNULL (twRMPObjectIx, 0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMPObjectIx <= 0
          THEN
               CALL call_Error (2, 'PObject is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 INSERT INTO Results
                 SELECT 0,
                        p.ObjectHead_Self_twObjectIx
                   FROM RMPObject AS p
                  WHERE p.ObjectHead_Self_twObjectIx = twRMPObjectIx;

                     IF ROW_COUNT () = 1
                   THEN
                          INSERT INTO Results
                          SELECT 1,
                                 x.ObjectHead_Self_twObjectIx
                            FROM RMPObject AS p
                            JOIN RMPObject AS x ON x.ObjectHead_Parent_wClass     = p.ObjectHead_Self_wClass
                                               AND x.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
                           WHERE p.ObjectHead_Self_twObjectIx = twRMPObjectIx
                        ORDER BY x.ObjectHead_Self_twObjectIx ASC;
             
                            CALL call_RMPObject_Select(0);
                            CALL call_RMPObject_Select(1);
             
                             SET bCommit = 1;
                   ELSE 
                            CALL call_Error (3, 'PObject does not exist', nError);
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
