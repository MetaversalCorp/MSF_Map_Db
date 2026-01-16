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

DROP PROCEDURE IF EXISTS call_RMTMatrix_Relative;

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Relative
(
   IN ObjectHead_Parent_wClass     SMALLINT,
   IN ObjectHead_Parent_twObjectIx BIGINT,
   IN twRMTObjectIx                BIGINT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                       INT DEFAULT 72;

       DECLARE d00 DOUBLE; DECLARE d01 DOUBLE; DECLARE d02 DOUBLE; DECLARE d03 DOUBLE;
       DECLARE d10 DOUBLE; DECLARE d11 DOUBLE; DECLARE d12 DOUBLE; DECLARE d13 DOUBLE;
       DECLARE d20 DOUBLE; DECLARE d21 DOUBLE; DECLARE d22 DOUBLE; DECLARE d23 DOUBLE;
       DECLARE d30 DOUBLE; DECLARE d31 DOUBLE; DECLARE d32 DOUBLE; DECLARE d33 DOUBLE;

       DECLARE dTX DOUBLE; DECLARE dTY DOUBLE; DECLARE dTZ DOUBLE;
       DECLARE dRX DOUBLE; DECLARE dRY DOUBLE; DECLARE dRZ DOUBLE; DECLARE dRW DOUBLE;
       DECLARE dSX DOUBLE; DECLARE dSY DOUBLE; DECLARE dSZ DOUBLE;

       DECLARE dTrace DOUBLE;
       DECLARE dS     DOUBLE;
       DECLARE dN     DOUBLE;

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT AND ObjectHead_Parent_twObjectIx <> 0
          THEN
                     -- perform a mult into local variables

                 SELECT (ml.d00 * mr.d00) + (ml.d01 * mr.d10) + (ml.d02 * mr.d20) + (ml.d03 * mr.d30),
                        (ml.d00 * mr.d01) + (ml.d01 * mr.d11) + (ml.d02 * mr.d21) + (ml.d03 * mr.d31),
                        (ml.d00 * mr.d02) + (ml.d01 * mr.d12) + (ml.d02 * mr.d22) + (ml.d03 * mr.d32),
                        (ml.d00 * mr.d03) + (ml.d01 * mr.d13) + (ml.d02 * mr.d23) + (ml.d03 * mr.d33),

                        (ml.d10 * mr.d00) + (ml.d11 * mr.d10) + (ml.d12 * mr.d20) + (ml.d13 * mr.d30),
                        (ml.d10 * mr.d01) + (ml.d11 * mr.d11) + (ml.d12 * mr.d21) + (ml.d13 * mr.d31),
                        (ml.d10 * mr.d02) + (ml.d11 * mr.d12) + (ml.d12 * mr.d22) + (ml.d13 * mr.d32),
                        (ml.d10 * mr.d03) + (ml.d11 * mr.d13) + (ml.d12 * mr.d23) + (ml.d13 * mr.d33),

                        (ml.d20 * mr.d00) + (ml.d21 * mr.d10) + (ml.d22 * mr.d20) + (ml.d23 * mr.d30),
                        (ml.d20 * mr.d01) + (ml.d21 * mr.d11) + (ml.d22 * mr.d21) + (ml.d23 * mr.d31),
                        (ml.d20 * mr.d02) + (ml.d21 * mr.d12) + (ml.d22 * mr.d22) + (ml.d23 * mr.d32),
                        (ml.d20 * mr.d03) + (ml.d21 * mr.d13) + (ml.d22 * mr.d23) + (ml.d23 * mr.d33),

                        (ml.d30 * mr.d00) + (ml.d31 * mr.d10) + (ml.d32 * mr.d20) + (ml.d33 * mr.d30),
                        (ml.d30 * mr.d01) + (ml.d31 * mr.d11) + (ml.d32 * mr.d21) + (ml.d33 * mr.d31),
                        (ml.d30 * mr.d02) + (ml.d31 * mr.d12) + (ml.d32 * mr.d22) + (ml.d33 * mr.d32),
                        (ml.d30 * mr.d03) + (ml.d31 * mr.d13) + (ml.d32 * mr.d23) + (ml.d33 * mr.d33)

                   INTO d00, d01, d02, d03, 
                        d10, d11, d12, d13,
                        d20, d21, d22, d23,
                        d30, d31, d32, d33

                   FROM RMTMatrix AS ml
                   JOIN RMTMatrix AS mr ON mr.bnMatrix = twRMTObjectIx
                  WHERE ml.bnMatrix = 0 - ObjectHead_Parent_twObjectIx;                 -- parent's inverse matrix
          ELSE
                     -- copy matrix to local variables

                 SELECT mr.d00,
                        mr.d01,
                        mr.d02,
                        mr.d03,

                        mr.d10,
                        mr.d11,
                        mr.d12,
                        mr.d13,

                        mr.d20,
                        mr.d21,
                        mr.d23,
                        mr.d22,

                        mr.d30,
                        mr.d31,
                        mr.d32,
                        mr.d33

                   INTO d00, d01, d02, d03, 
                        d10, d11, d12, d13,
                        d20, d21, d22, d23,
                        d30, d31, d32, d33

                   FROM RMTMatrix AS mr
                  WHERE mr.bnMatrix = twRMTObjectIx;
        END IF ;

            -- Extract the translation from the matrix

           SET dTX = d03;
           SET dTY = d13;
           SET dTZ = d23;

-- SELECT 'T', dTX, dTY, dTZ

            -- Extract the rotation (quaternion) from the matrix

           SET dTrace = d00 + d11 + d22;

            IF dTrace > 0
          THEN
                  SET dS = 1 / (SQRT(dTrace + 1) * 2);

                  SET dRX = (d21 - d12) * dS;
                  SET dRY = (d02 - d20) * dS;
                  SET dRZ = (d10 - d01) * dS;
                  SET dRW = 1 / (dS * 4);
        ELSEIF d00 > d11 AND d00 > d22
          THEN
                  SET dS = 2 * SQRT(1 + d00 - d11 - d22);

                  SET dRX = dS / 4;
                  SET dRY = (d01 + d10) / dS;
                  SET dRZ = (d02 + d20) / dS;
                  SET dRW = (d21 - d12) / dS;
        ELSEIF d11 > d22
          THEN
                  SET dS = 2 * SQRT(1 + d11 - d00 - d22);

                  SET dRX = (d01 + d10) / dS;
                  SET dRY = dS / 4;
                  SET dRZ = (d12 + d21) / dS;
                  SET dRW = (d02 - d20) / dS;
          ELSE
                  SET dS = 2 * SQRT(1 + d22 - d00 - d11);

                  SET dRX = (d02 + d20) / dS;
                  SET dRY = (d12 + d21) / dS;
                  SET dRZ = dS / 4;
                  SET dRW = (d10 - d01) / dS;
        END IF ;

           SET dN = SQRT((dRX * dRX) + (dRY * dRY) + (dRZ * dRZ) + (dRW * dRW));

           SET dRX = dRX / dN;
           SET dRY = dRY / dN;
           SET dRZ = dRZ / dN;
           SET dRW = dRW / dN;

-- SELECT 'R', dRX, dRY, dRZ, dRW

            -- Extract the scale from the matrix

           SET dSX = SQRT((d00 * d00) + (d10 * d10) + (d20 * d20));
           SET dSY = SQRT((d01 * d01) + (d11 * d11) + (d21 * d21));
           SET dSZ = SQRT((d02 * d02) + (d12 * d12) + (d22 * d22));

            -- Update the relative transform in the object

        UPDATE RMTObject AS o
           SET o.Transform_Position_dX = dTX,
               o.Transform_Position_dY = dTY,
               o.Transform_Position_dZ = dTZ,
               o.Transform_Rotation_dX = dRX,
               o.Transform_Rotation_dY = dRY,
               o.Transform_Rotation_dZ = dRZ,
               o.Transform_Rotation_dW = dRW,
               o.Transform_Scale_dX    = dSX,
               o.Transform_Scale_dY    = dSY,
               o.Transform_Scale_dZ    = dSZ
         WHERE o.ObjectHead_Self_twObjectIx = twRMTObjectIx;
END$$

DELIMITER ;

/* ************************************************************************************************************************** */
