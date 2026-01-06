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

DROP PROCEDURE IF EXISTS call_RMTMatrix_Inverse;

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Inverse
(
   IN    bnMatrix                      BIGINT,
   OUT   nResult                       INT
)
BEGIN
       DECLARE d00 DOUBLE; DECLARE d01 DOUBLE; DECLARE d02 DOUBLE; DECLARE d03 DOUBLE;
       DECLARE d10 DOUBLE; DECLARE d11 DOUBLE; DECLARE d12 DOUBLE; DECLARE d13 DOUBLE;
       DECLARE d20 DOUBLE; DECLARE d21 DOUBLE; DECLARE d22 DOUBLE; DECLARE d23 DOUBLE;
       DECLARE d30 DOUBLE; DECLARE d31 DOUBLE; DECLARE d32 DOUBLE; DECLARE d33 DOUBLE;

       DECLARE s0 DOUBLE; DECLARE s1 DOUBLE; DECLARE s2 DOUBLE; DECLARE s3 DOUBLE;
       DECLARE s4 DOUBLE; DECLARE s5 DOUBLE;
       DECLARE c0 DOUBLE; DECLARE c1 DOUBLE; DECLARE c2 DOUBLE; DECLARE c3 DOUBLE;
       DECLARE c4 DOUBLE; DECLARE c5 DOUBLE;
       DECLARE dDeterminant DOUBLE; DECLARE dDeterminant_ DOUBLE;

           SET nResult = 0;

        SELECT m.d00, m.d01, m.d02, m.d03,
               m.d10, m.d11, m.d12, m.d13,
               m.d20, m.d21, m.d22, m.d23,
               m.d30, m.d31, m.d32, m.d33
          INTO d00,   d01,   d02,   d03,
               d10,   d11,   d12,   d13,
               d20,   d21,   d22,   d23,
               d30,   d31,   d32,   d33
          FROM RMTMatrix AS m
         WHERE m.bnMatrix = bnMatrix;

           SET s0 = d00 * d11 - d10 * d01;
           SET s1 = d00 * d12 - d10 * d02;
           SET s2 = d00 * d13 - d10 * d03;
           SET s3 = d01 * d12 - d11 * d02;
           SET s4 = d01 * d13 - d11 * d03;
           SET s5 = d02 * d13 - d12 * d03;

           SET c5 = d22 * d33 - d32 * d23;
           SET c4 = d21 * d33 - d31 * d23;
           SET c3 = d21 * d32 - d31 * d22;
           SET c2 = d20 * d33 - d30 * d23;
           SET c1 = d20 * d32 - d30 * d22;
           SET c0 = d20 * d31 - d30 * d21;

           SET dDeterminant = s0 * c5 - s1 * c4 + s2 * c3 + s3 * c2 - s4 * c1 + s5 * c0;

            IF dDeterminant <> 0
          THEN
                    SET dDeterminant_ = 1 / dDeterminant;
           
                 UPDATE RMTMatrix AS m
                    SET m.d00 = ( d11 * c5 - d12 * c4 + d13 * c3) * dDeterminant_,
                        m.d01 = (-d01 * c5 + d02 * c4 - d03 * c3) * dDeterminant_,
                        m.d02 = ( d31 * s5 - d32 * s4 + d33 * s3) * dDeterminant_,
                        m.d03 = (-d21 * s5 + d22 * s4 - d23 * s3) * dDeterminant_,
           
                        m.d10 = (-d10 * c5 + d12 * c2 - d13 * c1) * dDeterminant_,
                        m.d11 = ( d00 * c5 - d02 * c2 + d03 * c1) * dDeterminant_,
                        m.d12 = (-d30 * s5 + d32 * s2 - d33 * s1) * dDeterminant_,
                        m.d13 = ( d20 * s5 - d22 * s2 + d23 * s1) * dDeterminant_,
           
                        m.d20 = ( d10 * c4 - d11 * c2 + d13 * c0) * dDeterminant_,
                        m.d21 = (-d00 * c4 + d01 * c2 - d03 * c0) * dDeterminant_,
                        m.d22 = ( d30 * s4 - d31 * s2 + d33 * s0) * dDeterminant_,
                        m.d23 = (-d20 * s4 + d21 * s2 - d23 * s0) * dDeterminant_,
           
                        m.d30 = (-d10 * c3 + d11 * c1 - d12 * c0) * dDeterminant_,
                        m.d31 = ( d00 * c3 - d01 * c1 + d02 * c0) * dDeterminant_,
                        m.d32 = (-d30 * s3 + d31 * s1 - d32 * s0) * dDeterminant_,
                        m.d33 = ( d20 * s3 - d21 * s1 + d22 * s0) * dDeterminant_
                  WHERE m.bnMatrix = 0 - bnMatrix;

                    SET nResult = 1;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
