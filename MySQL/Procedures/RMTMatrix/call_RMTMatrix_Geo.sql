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

DROP PROCEDURE IF EXISTS call_RMTMatrix_Geo;

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Geo
(
   IN    twRMTObjectIx                 BIGINT,
   IN    dLatitude                     DOUBLE,
   IN    dLongitude                    DOUBLE,
   IN    dRadius                       DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE RMTMATRIX_COORD_GEO                       INT DEFAULT 3;

       DECLARE nResult INT DEFAULT 0;

            -- right handed (counter-clockwise rotation), Y up, negative Z forward
            -- longitude == 0 degrees (the prime meridian) aligns with the +z axis

       DECLARE dLatX   DOUBLE DEFAULT RADIANS (90.0 - dLatitude);
       DECLARE dLat    DOUBLE DEFAULT RADIANS (dLatitude);
       DECLARE dLon    DOUBLE DEFAULT RADIANS (dLongitude);
       DECLARE dRad    DOUBLE DEFAULT dRadius;
       DECLARE dOI     DOUBLE DEFAULT 1;

       DECLARE dCLatX  DOUBLE DEFAULT COS (dLatX);
       DECLARE dSLatX  DOUBLE DEFAULT SIN (dLatX);
       DECLARE dCLat   DOUBLE DEFAULT COS (dLat);
       DECLARE dSLat   DOUBLE DEFAULT SIN (dLat);
       DECLARE dCLon   DOUBLE DEFAULT COS (dLon);
       DECLARE dSLon   DOUBLE DEFAULT SIN (dLon);

            IF dRad < 0
          THEN
                    SET dRad = dRad * -1;
                    SET dOI  = dOI  * -1;
        END IF ; 

            -- MXform_Identity     (MXform);
            -- MXform_Translate    (MXform, dRad * dCLat * dSLon, dRad * dSLat, dRad * dCLat * dCLon);
            -- MXform_Rotate_Y     (MXform, dLon);                                                              -- +z axis aligns with longitude
            -- MXform_Rotate_X     (MXform, dLatX);                                                             -- +y axis aligns with latitude
            -- MXform_Rotate_Z     (MXform, 90 +/- 90);                                                         -- +y axis aligns with latitude (direction depends on dOI)

            -- Matrix multiplication progresses left to right

            -- [ 1   0   0   0 ]     [ 1   0   0   X ]     [  dCLon   0   dSLon   0 ]     [ 1   0         0        0 ]     [ dOI   0     0   0 ]
            -- [ 0   1   0   0 ]  X  [ 0   1   0   Y ]  X  [  0       1   0       0 ]  X  [ 0   dCLatX   -dSLatX   0 ]  X  [ 0     dOI   0   0 ]
            -- [ 0   0   1   0 ]     [ 0   0   1   Z ]     [ -dSLon   0   dCLon   0 ]     [ 0   dSLatX    dCLatX   0 ]     [ 0     0     1   0 ]
            -- [ 0   0   0   1 ]     [ 0   0   0   1 ]     [  0       0   0       1 ]     [ 0   0         0        1 ]     [ 0     0     0   1 ]

        INSERT INTO RMTSubsurface
               ( twRMTObjectIx, tnGeometry,          dA,        dB,         dC      )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_GEO, dLatitude, dLongitude, dRadius );

        INSERT INTO RMTMatrix
               ( bnMatrix,

                 d00,                 d01,                           d02,                   d03,
                 d10,                 d11,                           d12,                   d13,
                 d20,                 d21,                           d22,                   d23,
                 d30,                 d31,                           d32,                   d33
               )
        VALUES ( twRMTObjectIx,

                 dOI *  dCLon ,     dOI * dSLon * dSLatX ,      dSLon * dCLatX ,     dRad * dCLat * dSLon ,
                        0     ,     dOI * dCLatX         ,     -dSLatX         ,     dRad * dSLat         ,
                 dOI * -dSLon ,     dOI * dCLon * dSLatX ,      dCLon * dCLatX ,     dRad * dCLat * dCLon ,
                        0     ,           0              ,      0              ,     1
               );

        INSERT INTO RMTMatrix
               ( bnMatrix          )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse (twRMTObjectIx, nResult);
END$$

DELIMITER ;

/* ************************************************************************************************************************** */
