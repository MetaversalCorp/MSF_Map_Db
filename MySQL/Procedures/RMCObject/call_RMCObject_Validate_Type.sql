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

DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Type;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Type
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Type_bType                    TINYINT UNSIGNED,
   IN    Type_bSubtype                 TINYINT UNSIGNED,
   IN    Type_bFiction                 TINYINT UNSIGNED,
   INOUT nError                        INT
)
BEGIN
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

       DECLARE Parent_bType    TINYINT UNSIGNED;
       DECLARE Parent_bSubtype TINYINT UNSIGNED;
       DECLARE Self_bType      TINYINT UNSIGNED;
       DECLARE Self_bSubtype   TINYINT UNSIGNED;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO Parent_bType, Parent_bSubtype
                   FROM RMCObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = ObjectHead_Parent_twObjectIx;
        END IF ;

            IF twRMCObjectIx > 0
          THEN
                 SELECT o.Type_bType, o.Type_bSubtype
                   INTO   Self_bType,   Self_bSubtype
                   FROM RMCObject AS o
                  WHERE o.ObjectHead_Self_twObjectIx = twRMCObjectIx;
-- get max children's type and subtype

        END IF ;

-- attachment points can't have cildren

            IF Type_bType IS NULL
          THEN
                   CALL call_Error (21, 'Type_bType is NULL',       nError);
        END IF ;

            IF Type_bSubtype IS NULL
          THEN
                   CALL call_Error (21, 'Type_bSubtype is NULL',    nError);
        END IF ;

            IF Type_bFiction IS NULL
          THEN
                   CALL call_Error (21, 'Type_bFiction is NULL',    nError);
        ELSEIF Type_bFiction NOT BETWEEN 0 AND 1
          THEN
                   CALL call_Error (21, 'Type_bFiction is invalid', nError);
        END IF ;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT AND Type_bType < Parent_bType
          THEN
                   CALL call_Error (21, 'Type_bType must be greater than or equal to its parent\'s Type_bType', nError);
        ELSEIF ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT AND Type_bType = Parent_bType AND Type_bSubtype <= Parent_bSubtype
          THEN
                   CALL call_Error (21, 'Type_bSubtype must be greater than its parent\'s Type_bType', nError);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
