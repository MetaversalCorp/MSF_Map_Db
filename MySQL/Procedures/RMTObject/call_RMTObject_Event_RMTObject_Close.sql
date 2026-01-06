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

DROP PROCEDURE IF EXISTS call_RMTObject_Event_RMTObject_Close;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Event_RMTObject_Close
(
   IN    twRMTObjectIx                 BIGINT,
   IN    twRMTObjectIx_Close           BIGINT,
   OUT   bError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE  INT DEFAULT 0x02;

       DECLARE twEventIz BIGINT;

       DECLARE nCount    INT DEFAULT 0;

            -- Create the temp TObject table
        CREATE TEMPORARY TABLE TObject
               (
                  ObjectHead_Self_twObjectIx    BIGINT          NOT NULL
               );

            -- Create the temp PObject table
        CREATE TEMPORARY TABLE PObject
               (
                  ObjectHead_Self_twObjectIx    BIGINT          NOT NULL
               );

          CALL call_RMTObject_Event (twRMTObjectIx, twEventIz, bError);

            IF bError = 0
          THEN
                   CALL call_RMTObject_Delete_Descendants (twRMTObjectIx_Close, bError);
        END IF ;

            IF bError = 0
          THEN
                   CALL call_RMPObject_Delete_Descendants (NULL, bError);
        END IF ;

            IF bError = 0
          THEN
                 INSERT INTO Event
                        (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                 SELECT 'RMTOBJECT_CLOSE',

                        SBO_CLASS_RMTOBJECT,
                        twRMTObjectIx,
                        SBO_CLASS_RMTOBJECT,
                        twRMTObjectIx_Close,
                        SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                        twEventIz,

                        '{ }',

                        '{ }',

                        '{ }';

                    SET bError = IF (ROW_COUNT () = 1, 0, 1);
        END IF ;

          DROP TEMPORARY TABLE TObject;
          DROP TEMPORARY TABLE PObject;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
