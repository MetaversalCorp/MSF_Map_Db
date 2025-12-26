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

DROP FUNCTION IF EXISTS Format_Orbit_Spin;

DELIMITER $$

CREATE FUNCTION Format_Orbit_Spin
(
   tmPeriod                 BIGINT,
   tmStart                  BIGINT,
   dA                       DOUBLE,
   dB                       DOUBLE
)
RETURNS VARCHAR (256)
DETERMINISTIC
BEGIN
      RETURN CONCAT ('{ "tmPeriod": ', CAST(tmPeriod AS CHAR), ', "tmStart": ', CAST(tmStart AS CHAR), ', "dA": ', Format_Double(dA), ', "dB": ', Format_Double(dB), ' }');
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
