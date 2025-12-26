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

DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Bound;

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Bound
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
   IN    Bound_dX                      DOUBLE,
   IN    Bound_dY                      DOUBLE,
   IN    Bound_dZ                      DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Bound_dX IS NULL OR Bound_dX <> Bound_dX
          THEN
                   CALL call_Error (21, 'Bound_dX is NULL or NaN', nError);
        ELSEIF Bound_dX < 0
          THEN
                   CALL call_Error (21, 'Bound_dX is invalid',     nError);
        END IF ;

            IF Bound_dY IS NULL OR Bound_dY <> Bound_dY
          THEN
                   CALL call_Error (21, 'Bound_dY is NULL or NaN', nError);
        ELSEIF Bound_dY < 0
          THEN
                   CALL call_Error (21, 'Bound_dY is invalid',     nError);
        END IF ;

            IF Bound_dZ IS NULL OR Bound_dZ <> Bound_dZ
          THEN
                   CALL call_Error (21, 'Bound_dZ is NULL or NaN', nError);
        ELSEIF Bound_dZ < 0
          THEN
                   CALL call_Error (21, 'Bound_dZ is invalid',     nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate bound is inside  parent's   bound
                     -- validate bound is outside children's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
