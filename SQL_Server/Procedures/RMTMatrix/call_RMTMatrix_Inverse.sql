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

CREATE PROCEDURE dbo.call_RMTMatrix_Inverse
(
   @bnMatrix                     BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @nResult INT = 0

       DECLARE @d00 FLOAT (53), @d01 FLOAT (53), @d02 FLOAT (53), @d03 FLOAT (53),
               @d10 FLOAT (53), @d11 FLOAT (53), @d12 FLOAT (53), @d13 FLOAT (53),
               @d20 FLOAT (53), @d21 FLOAT (53), @d22 FLOAT (53), @d23 FLOAT (53),
               @d30 FLOAT (53), @d31 FLOAT (53), @d32 FLOAT (53), @d33 FLOAT (53)

        SELECT @d00 = d00, @d01 = d01, @d02 = d02, @d03 = d03,
               @d10 = d10, @d11 = d11, @d12 = d12, @d13 = d13,
               @d20 = d20, @d21 = d21, @d22 = d22, @d23 = d23,
               @d30 = d30, @d31 = d31, @d32 = d32, @d33 = d33
          FROM dbo.RMTMatrix
         WHERE bnMatrix = @bnMatrix

       DECLARE @s0 FLOAT (53) = @d00 * @d11 - @d10 * @d01,
               @s1 FLOAT (53) = @d00 * @d12 - @d10 * @d02,
               @s2 FLOAT (53) = @d00 * @d13 - @d10 * @d03,
               @s3 FLOAT (53) = @d01 * @d12 - @d11 * @d02,
               @s4 FLOAT (53) = @d01 * @d13 - @d11 * @d03,
               @s5 FLOAT (53) = @d02 * @d13 - @d12 * @d03,

               @c5 FLOAT (53) = @d22 * @d33 - @d32 * @d23,
               @c4 FLOAT (53) = @d21 * @d33 - @d31 * @d23,
               @c3 FLOAT (53) = @d21 * @d32 - @d31 * @d22,
               @c2 FLOAT (53) = @d20 * @d33 - @d30 * @d23,
               @c1 FLOAT (53) = @d20 * @d32 - @d30 * @d22,
               @c0 FLOAT (53) = @d20 * @d31 - @d30 * @d21

       DECLARE @dDeterminant FLOAT (53) = @s0 * @c5 - @s1 * @c4 + @s2 * @c3 + @s3 * @c2 - @s4 * @c1 + @s5 * @c0

            IF @dDeterminant <> 0
         BEGIN
                DECLARE @dDeterminant_ FLOAT (53) = 1 / @dDeterminant
           
                 UPDATE dbo.RMTMatrix
                    SET d00 = ( @d11 * @c5 - @d12 * @c4 + @d13 * @c3) * @dDeterminant_,
                        d01 = (-@d01 * @c5 + @d02 * @c4 - @d03 * @c3) * @dDeterminant_,
                        d02 = ( @d31 * @s5 - @d32 * @s4 + @d33 * @s3) * @dDeterminant_,
                        d03 = (-@d21 * @s5 + @d22 * @s4 - @d23 * @s3) * @dDeterminant_,
           
                        d10 = (-@d10 * @c5 + @d12 * @c2 - @d13 * @c1) * @dDeterminant_,
                        d11 = ( @d00 * @c5 - @d02 * @c2 + @d03 * @c1) * @dDeterminant_,
                        d12 = (-@d30 * @s5 + @d32 * @s2 - @d33 * @s1) * @dDeterminant_,
                        d13 = ( @d20 * @s5 - @d22 * @s2 + @d23 * @s1) * @dDeterminant_,
           
                        d20 = ( @d10 * @c4 - @d11 * @c2 + @d13 * @c0) * @dDeterminant_,
                        d21 = (-@d00 * @c4 + @d01 * @c2 - @d03 * @c0) * @dDeterminant_,
                        d22 = ( @d30 * @s4 - @d31 * @s2 + @d33 * @s0) * @dDeterminant_,
                        d23 = (-@d20 * @s4 + @d21 * @s2 - @d23 * @s0) * @dDeterminant_,
           
                        d30 = (-@d10 * @c3 + @d11 * @c1 - @d12 * @c0) * @dDeterminant_,
                        d31 = ( @d00 * @c3 - @d01 * @c1 + @d02 * @c0) * @dDeterminant_,
                        d32 = (-@d30 * @s3 + @d31 * @s1 - @d32 * @s0) * @dDeterminant_,
                        d33 = ( @d20 * @s3 - @d21 * @s1 + @d22 * @s0) * @dDeterminant_
                  WHERE bnMatrix = 0 - @bnMatrix

                    SET @nResult = 1
           END

        RETURN @nResult
  END
GO

/******************************************************************************************************************************/
