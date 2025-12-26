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

DROP FUNCTION IF EXISTS Format_Double;

DELIMITER $$

CREATE FUNCTION Format_Double
(
   d   DOUBLE
)
RETURNS VARCHAR (32)
DETERMINISTIC
BEGIN

      DECLARE dA      DOUBLE DEFAULT ABS (d);
      DECLARE e       INT DEFAULT 0;
      DECLARE sSign   VARCHAR (1) DEFAULT '';
      DECLARE sExp    VARCHAR (8) DEFAULT '';
      DECLARE sNum    VARCHAR (20) DEFAULT '';

           IF (dA <> d)
         THEN
              SET sSign = '-';
       END IF ;

           IF dA <> 0 AND dA <> 1
         THEN
                    IF dA < 1.0
                  THEN
                          WHILE (dA < POW (10, -e) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, e);
                            SET sExp = CONCAT ('e-', e);
                ELSEIF dA >= 10.0
                  THEN
                          WHILE (dA >= POW (10, e + 1) AND e < 310)
                             DO
                                     SET e = e + 1;
                      END WHILE ;

                            SET dA = dA * POW (10, -e);
                            SET sExp = CONCAT ('e+', e);
                END IF ;
       END IF ;

           IF (FLOOR (dA) = CEILING (dA))
         THEN
              SET sNum = CAST(dA AS CHAR);
         ELSE 
              SET sNum = FORMAT (dA, 16);
       END IF ;

       RETURN CONCAT (sSign, sNum, sExp);
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
