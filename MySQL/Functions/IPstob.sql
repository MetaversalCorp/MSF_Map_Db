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

DROP FUNCTION IF EXISTS IPstob;

DELIMITER $$

CREATE FUNCTION IPstob
(
   sIPAddress     VARCHAR (16)
)
RETURNS BINARY(4)
DETERMINISTIC
BEGIN
       RETURN UNHEX (HEX (INET_ATON (sIPAddress)));
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */

DROP FUNCTION IF EXISTS IPbtos;

DELIMITER $$

CREATE FUNCTION IPbtos
(
   dwIPAddress    BINARY(4)
)
RETURNS VARCHAR (16)
DETERMINISTIC
BEGIN
      RETURN CONCAT
      (
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 1, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 2, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 3, 1)), 16, 10) AS CHAR), '.',
          CAST(CONV (HEX (SUBSTRING(dwIPAddress, 4, 1)), 16, 10) AS CHAR)
      );
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
