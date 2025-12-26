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

DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Coord_Geo;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Coord_Geo
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dLatitude                     DOUBLE,
   IN    dLongitude                    DOUBLE,
   IN    dRadius                       DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF dLatitude IS NULL OR dLatitude <> dLatitude
          THEN
                   CALL call_Error (21, 'dLatitude is NULL or NaN',  nError);
        ELSEIF dLatitude NOT BETWEEN -180 AND 180
          THEN
                   CALL call_Error (21, 'dLatitude is invalid',      nError);
        END IF ;

            IF dLongitude IS NULL OR dLongitude <> dLongitude
          THEN
                   CALL call_Error (21, 'dLongitude is NULL or NaN', nError);
        ELSEIF dLongitude NOT BETWEEN -180 AND 180
          THEN
                   CALL call_Error (21, 'dLongitude is invalid',     nError);
        END IF ;

            IF dRadius IS NULL OR dRadius <> dRadius
          THEN
                   CALL call_Error (21, 'dRadius is NULL or NaN',    nError);
        ELSEIF dRadius = 0
          THEN
                   CALL call_Error (21, 'dRadius is invalid',        nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
