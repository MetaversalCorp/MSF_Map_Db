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

DROP PROCEDURE IF EXISTS call_RMTObject_Validate_Coord_Car;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Validate_Coord_Car
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    dX                            DOUBLE,
   IN    dY                            DOUBLE,
   IN    dZ                            DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF dX IS NULL OR dX <> dX
          THEN
                   CALL call_Error (21, 'dX is NULL or NaN', nError);
        END IF ;

            IF dY IS NULL OR dY <> dY
          THEN
                   CALL call_Error (21, 'dY is NULL or NaN', nError);
        END IF ;

            IF dZ IS NULL OR dZ <> dZ
          THEN
                   CALL call_Error (21, 'dZ is NULL or NaN', nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
