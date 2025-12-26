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

DROP PROCEDURE IF EXISTS get_RMTObject_Update;

DELIMITER $$

CREATE PROCEDURE get_RMTObject_Update
(
   IN    sIPAddress                    VARCHAR (16),
   IN    twRPersonaIx                  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   OUT   nResult                       BIGINT
)
BEGIN
       DECLARE MVO_RMTOBJECT_TYPE_PARCEL                  INT DEFAULT 11;

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
           SET twRMTObjectIx = IFNULL (twRMTObjectIx, 0);

            IF twRPersonaIx < 0
          THEN
               CALL call_Error (1, 'Session is invalid', nError);
        END IF ;

            IF twRMTObjectIx <= 0
          THEN
               CALL call_Error (2, 'TObject is invalid', nError);
        END IF ;

            IF nError = 0
          THEN
                 SELECT t.Type_bType INTO bType
                   FROM RMTObject AS t
                  WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx;

                 INSERT INTO Results
                 SELECT 0,
                        t.ObjectHead_Self_twObjectIx
                   FROM RMTObject AS t
                  WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx;

                     IF ROW_COUNT () = 1  AND  bType IS NOT NULL
                   THEN
                              IF bType <> MVO_RMTOBJECT_TYPE_PARCEL
                            THEN
                                   INSERT INTO Results
                                   SELECT 1,
                                          x.ObjectHead_Self_twObjectIx
                                     FROM RMTObject AS t
                                     JOIN RMTObject AS x ON x.ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass
                                                        AND x.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                                    WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx
                                 ORDER BY x.ObjectHead_Self_twObjectIx ASC;
                            ELSE
                                   INSERT INTO Results
                                   SELECT 1,
                                          p.ObjectHead_Self_twObjectIx
                                     FROM RMTObject AS t
                                     JOIN RMPObject AS p ON p.ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass
                                                        AND p.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                                    WHERE t.ObjectHead_Self_twObjectIx = twRMTObjectIx
                                 ORDER BY p.ObjectHead_Self_twObjectIx ASC;
                          END IF ;
             
                            CALL call_RMTObject_Select(0);
                              IF bType <> MVO_RMTOBJECT_TYPE_PARCEL
                            THEN
                                     CALL call_RMTObject_Select (1);
                            ELSE
                                     CALL call_RMPObject_Select (1);
                          END IF ;
             
                             SET bCommit = 1;
                   ELSE
                            CALL call_Error (3, 'TObject does not exist', nError);
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
