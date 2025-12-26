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

DROP FUNCTION IF EXISTS Format_Transform;

DELIMITER $$

CREATE FUNCTION Format_Transform
(
   Position_dX               DOUBLE,
   Position_dY               DOUBLE,
   Position_dZ               DOUBLE,
   Rotation_dX               DOUBLE,
   Rotation_dY               DOUBLE,
   Rotation_dZ               DOUBLE,
   Rotation_dW               DOUBLE,
   Scale_dX                  DOUBLE,
   Scale_dY                  DOUBLE,
   Scale_dZ                  DOUBLE
)
RETURNS VARCHAR (512)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "Position": ', Format_Double3 (Position_dX, Position_dY, Position_dZ), ', "Rotation": ', Format_Double4(Rotation_dX, Rotation_dY, Rotation_dZ, Rotation_dW), ', "Scale": ', Format_Double3 (Scale_dX, Scale_dY, Scale_dZ), ' }');
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
