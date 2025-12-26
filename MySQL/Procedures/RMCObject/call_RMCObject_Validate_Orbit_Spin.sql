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

DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Orbit_Spin;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Orbit_Spin
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Orbit_Spin_tmPeriod           BIGINT,
   IN    Orbit_Spin_tmStart            BIGINT,
   IN    Orbit_Spin_dA                 DOUBLE,
   IN    Orbit_Spin_dB                 DOUBLE,
   INOUT nError                        INT
)
BEGIN
            IF Orbit_Spin_tmPeriod IS NULL
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmPeriod is NULL',    nError);
        ELSEIF Orbit_Spin_tmPeriod < 0
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmPeriod is invalid', nError);
        END IF ;

            IF Orbit_Spin_tmStart IS NULL
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmStart is NULL',     nError);
        ELSEIF Orbit_Spin_tmStart NOT BETWEEN 0 AND Orbit_Spin_tmPeriod
          THEN
                   CALL call_Error (21, 'Orbit_Spin_tmStart is invalid',  nError);
        END IF ;

            IF Orbit_Spin_dA IS NULL OR Orbit_Spin_dA <> Orbit_Spin_dA
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dA is NULL or NaN',   nError);
        ELSEIF Orbit_Spin_dA < 0
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dA is invalid',       nError);
        END IF ;

            IF Orbit_Spin_dB IS NULL OR Orbit_Spin_dB <> Orbit_Spin_dB
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dB is NULL or NaN',   nError);
        ELSEIF Orbit_Spin_dB < 0
          THEN
                   CALL call_Error (21, 'Orbit_Spin_dB is invalid',       nError);
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
