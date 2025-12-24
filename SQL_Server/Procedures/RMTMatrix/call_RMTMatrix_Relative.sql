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

/******************************************************************************************************************************/

CREATE PROCEDURE dbo.call_RMTMatrix_Relative
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

       DECLARE @d00 FLOAT (53), @d01 FLOAT (53), @d02 FLOAT (53), @d03 FLOAT (53),
               @d10 FLOAT (53), @d11 FLOAT (53), @d12 FLOAT (53), @d13 FLOAT (53),
               @d20 FLOAT (53), @d21 FLOAT (53), @d22 FLOAT (53), @d23 FLOAT (53),
               @d30 FLOAT (53), @d31 FLOAT (53), @d32 FLOAT (53), @d33 FLOAT (53)

       DECLARE @dTX FLOAT (53), @dTY FLOAT (53), @dTZ FLOAT (53),
               @dRX FLOAT (53), @dRY FLOAT (53), @dRZ FLOAT (53), @dRW FLOAT (53),
               @dSX FLOAT (53), @dSY FLOAT (53), @dSZ FLOAT (53)

            IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMTOBJECT AND @ObjectHead_Parent_twObjectIx <> 0
         BEGIN
                     -- perform a mult into local variables

                 SELECT @d00 = (ml.d00 * mr.d00) + (ml.d01 * mr.d10) + (ml.d02 * mr.d20) + (ml.d03 * mr.d30),
                        @d01 = (ml.d00 * mr.d01) + (ml.d01 * mr.d11) + (ml.d02 * mr.d21) + (ml.d03 * mr.d31),
                        @d02 = (ml.d00 * mr.d02) + (ml.d01 * mr.d12) + (ml.d02 * mr.d22) + (ml.d03 * mr.d32),
                        @d03 = (ml.d00 * mr.d03) + (ml.d01 * mr.d13) + (ml.d02 * mr.d23) + (ml.d03 * mr.d33),

                        @d10 = (ml.d10 * mr.d00) + (ml.d11 * mr.d10) + (ml.d12 * mr.d20) + (ml.d13 * mr.d30),
                        @d11 = (ml.d10 * mr.d01) + (ml.d11 * mr.d11) + (ml.d12 * mr.d21) + (ml.d13 * mr.d31),
                        @d12 = (ml.d10 * mr.d02) + (ml.d11 * mr.d12) + (ml.d12 * mr.d22) + (ml.d13 * mr.d32),
                        @d13 = (ml.d10 * mr.d03) + (ml.d11 * mr.d13) + (ml.d12 * mr.d23) + (ml.d13 * mr.d33),

                        @d20 = (ml.d20 * mr.d00) + (ml.d21 * mr.d10) + (ml.d22 * mr.d20) + (ml.d23 * mr.d30),
                        @d21 = (ml.d20 * mr.d01) + (ml.d21 * mr.d11) + (ml.d22 * mr.d21) + (ml.d23 * mr.d31),
                        @d22 = (ml.d20 * mr.d02) + (ml.d21 * mr.d12) + (ml.d22 * mr.d22) + (ml.d23 * mr.d32),
                        @d23 = (ml.d20 * mr.d03) + (ml.d21 * mr.d13) + (ml.d22 * mr.d23) + (ml.d23 * mr.d33),

                        @d30 = (ml.d30 * mr.d00) + (ml.d31 * mr.d10) + (ml.d32 * mr.d20) + (ml.d33 * mr.d30),
                        @d31 = (ml.d30 * mr.d01) + (ml.d31 * mr.d11) + (ml.d32 * mr.d21) + (ml.d33 * mr.d31),
                        @d32 = (ml.d30 * mr.d02) + (ml.d31 * mr.d12) + (ml.d32 * mr.d22) + (ml.d33 * mr.d32),
                        @d33 = (ml.d30 * mr.d03) + (ml.d31 * mr.d13) + (ml.d32 * mr.d23) + (ml.d33 * mr.d33)

                   FROM dbo.RMTMatrix AS ml
                   JOIN dbo.RMTMatrix AS mr ON mr.bnMatrix = @twRMTObjectIx
                  WHERE ml.bnMatrix = 0 - @ObjectHead_Parent_twObjectIx                 -- parent's inverse matrix
           END
          ELSE
         BEGIN
                     -- copy matrix to local variables

                 SELECT @d00 = mr.d00,
                        @d01 = mr.d01,
                        @d02 = mr.d02,
                        @d03 = mr.d03,

                        @d10 = mr.d10,
                        @d11 = mr.d11,
                        @d12 = mr.d12,
                        @d13 = mr.d13,

                        @d20 = mr.d20,
                        @d21 = mr.d21,
                        @d23 = mr.d23,
                        @d22 = mr.d22,

                        @d30 = mr.d30,
                        @d31 = mr.d31,
                        @d32 = mr.d32,
                        @d33 = mr.d33

                   FROM dbo.RMTMatrix AS mr
                  WHERE mr.bnMatrix = @twRMTObjectIx
           END

            -- Extract the translation from the matrix

        SELECT @dTX = @d03,
               @dTY = @d13,
               @dTZ = @d23

--SELECT 'T', @dTX, @dTY, @dTZ

            -- Extract the rotation (quaternion) from the matrix

       DECLARE @dTrace FLOAT (53),
               @dS     FLOAT (53),
               @dN     FLOAT (53)

           SET @dTrace = @d00 + @d11 + @d22

            IF @dTrace > 0
         BEGIN
                  SET @dS = 1 / (SQRT (@dTrace + 1) * 2)

               SELECT @dRX = (@d21 - @d12) * @dS,
                      @dRY = (@d02 - @d20) * @dS,
                      @dRZ = (@d10 - @d01) * @dS,
                      @dRW = 1 / (@dS * 4)
           END
       ELSE IF @d00 > @d11  AND  @d00 > @d22
         BEGIN
                  SET @dS = 2 * SQRT (1 + @d00 - @d11 - @d22)

               SELECT @dRX = @dS / 4,
                      @dRY = (@d01 + @d10) / @dS,
                      @dRZ = (@d02 + @d20) / @dS,
                      @dRW = (@d21 - @d12) / @dS
           END
       ELSE IF @d11 > @d22
         BEGIN
                  SET @dS = 2 * SQRT (1 + @d11 - @d00 - @d22)

               SELECT @dRX = (@d01 + @d10) / @dS,
                      @dRY = @dS / 4,
                      @dRZ = (@d12 + @d21) / @dS,
                      @dRW = (@d02 - @d20) / @dS
           END
          ELSE
         BEGIN
                  SET @dS = 2 * SQRT (1 + @d22 - @d00 - @d11)

               SELECT @dRX = (@d02 + @d20) / @dS,
                      @dRY = (@d12 + @d21) / @dS,
                      @dRZ = @dS / 4,
                      @dRW = (@d10 - @d01) / @dS
           END

        SELECT @dN = SQRT ((@dRX * @dRX) + (@dRY * @dRY) + (@dRZ * @dRZ) + (@dRW * @dRW))

        SELECT @dRX /= @dN,
               @dRY /= @dN,
               @dRZ /= @dN,
               @dRW /= @dN

--SELECT 'R', @dRX, @dRY, @dRZ, @dRW

            -- Extract the scale from the matrix

        SELECT @dSX = SQRT ((@d00 * @d00) + (@d10 * @d10) + (@d20 * @d20)),
               @dSY = SQRT ((@d01 * @d01) + (@d11 * @d11) + (@d21 * @d21)),
               @dSZ = SQRT ((@d02 * @d02) + (@d12 * @d12) + (@d22 * @d22))

            -- Update the relative transform in the object

        UPDATE dbo.RMTObject
           SET Transform_Position_dX = @dTX,
               Transform_Position_dY = @dTY,
               Transform_Position_dZ = @dTZ,
               Transform_Rotation_dX = @dRX,
               Transform_Rotation_dY = @dRY,
               Transform_Rotation_dZ = @dRZ,
               Transform_Rotation_dW = @dRW,
               Transform_Scale_dX    = @dSX,
               Transform_Scale_dY    = @dSY,
               Transform_Scale_dZ    = @dSZ
         WHERE ObjectHead_Self_twObjectIx = @twRMTObjectIx

        RETURN
  END
GO

/******************************************************************************************************************************/
