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

DROP FUNCTION IF EXISTS Format_Control;

DELIMITER $$

CREATE FUNCTION Format_Control
(
   Self_wClass             SMALLINT,
   Self_twObjectIx         BIGINT,
   Child_wClass            SMALLINT,
   Child_twObjectIx        BIGINT,
   wFlags                  SMALLINT,
   twEventIz               BIGINT
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT
             (
                '{ "wClass_Object": ', CAST(Self_wClass AS CHAR), 
                ', "twObjectIx": ',    CAST(Self_twObjectIx AS CHAR), 
                ', "wClass_Child": ',  CAST(Child_wClass AS CHAR), 
                ', "twChildIx": ',     CAST(Child_twObjectIx AS CHAR), 
                ', "wFlags": ',        CAST(wFlags AS CHAR), 
                ', "twEventIz": ',     CAST(twEventIz AS CHAR), 
                ' }'
             );
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
