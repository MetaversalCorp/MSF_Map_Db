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

DROP PROCEDURE IF EXISTS call_RMTMatrix_Car;

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Car
(
   IN    twRMTObjectIx                 BIGINT,
   IN    dX                            DOUBLE,
   IN    dY                            DOUBLE,
   IN    dZ                            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTMATRIX_COORD_CAR                       INT DEFAULT 1;

        INSERT INTO RMTSubsurface
               ( twRMTObjectIx, tnGeometry,          dA, dB, dC )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_CAR, dX, dY, dZ );

        INSERT INTO RMTMatrix
               (  bnMatrix,

                  d00, d01, d02, d03,
                  d10, d11, d12, d13,
                  d20, d21, d22, d23,
                  d30, d31, d32, d33
               )
        VALUES ( twRMTObjectIx,

                  1 ,  0 ,  0 ,  dX ,
                  0 ,  1 ,  0 ,  dY ,
                  0 ,  0 ,  1 ,  dZ ,
                  0 ,  0 ,  0 ,  1
               );

        INSERT INTO RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse (twRMTObjectIx, nResult);
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
