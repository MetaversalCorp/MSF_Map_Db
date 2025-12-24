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

CREATE PROCEDURE dbo.call_RMTMatrix_Scale
(
   @bnMatrix_L                   BIGINT,
   @dX                           FLOAT (53),
   @dY                           FLOAT (53),
   @dZ                           FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @nResult INT = 0

       DECLARE @d00 FLOAT (53) = @dX,
               @d01 FLOAT (53) = 0,
               @d02 FLOAT (53) = 0,
               @d03 FLOAT (53) = 0,

               @d10 FLOAT (53) = 0,
               @d11 FLOAT (53) = @dY,
               @d12 FLOAT (53) = 0,
               @d13 FLOAT (53) = 0,

               @d20 FLOAT (53) = 0,
               @d21 FLOAT (53) = 0,
               @d22 FLOAT (53) = @dZ,
               @d23 FLOAT (53) = 0,

               @d30 FLOAT (53) = 0,
               @d31 FLOAT (53) = 0,
               @d32 FLOAT (53) = 0,
               @d33 FLOAT (53) = 1

        UPDATE ml
           SET ml.d00 = (ml.d00 * @d00) + (ml.d01 * @d10) + (ml.d02 * @d20) + (ml.d03 * @d30),
               ml.d01 = (ml.d00 * @d01) + (ml.d01 * @d11) + (ml.d02 * @d21) + (ml.d03 * @d31),
               ml.d02 = (ml.d00 * @d02) + (ml.d01 * @d12) + (ml.d02 * @d22) + (ml.d03 * @d32),
               ml.d03 = (ml.d00 * @d03) + (ml.d01 * @d13) + (ml.d02 * @d23) + (ml.d03 * @d33),

               ml.d10 = (ml.d10 * @d00) + (ml.d11 * @d10) + (ml.d12 * @d20) + (ml.d13 * @d30),
               ml.d11 = (ml.d10 * @d01) + (ml.d11 * @d11) + (ml.d12 * @d21) + (ml.d13 * @d31),
               ml.d12 = (ml.d10 * @d02) + (ml.d11 * @d12) + (ml.d12 * @d22) + (ml.d13 * @d32),
               ml.d13 = (ml.d10 * @d03) + (ml.d11 * @d13) + (ml.d12 * @d23) + (ml.d13 * @d33),

               ml.d20 = (ml.d20 * @d00) + (ml.d21 * @d10) + (ml.d22 * @d20) + (ml.d23 * @d30),
               ml.d21 = (ml.d20 * @d01) + (ml.d21 * @d11) + (ml.d22 * @d21) + (ml.d23 * @d31),
               ml.d22 = (ml.d20 * @d02) + (ml.d21 * @d12) + (ml.d22 * @d22) + (ml.d23 * @d32),
               ml.d23 = (ml.d20 * @d03) + (ml.d21 * @d13) + (ml.d22 * @d23) + (ml.d23 * @d33),

               ml.d30 = (ml.d30 * @d00) + (ml.d31 * @d10) + (ml.d32 * @d20) + (ml.d33 * @d30),
               ml.d31 = (ml.d30 * @d01) + (ml.d31 * @d11) + (ml.d32 * @d21) + (ml.d33 * @d31),
               ml.d32 = (ml.d30 * @d02) + (ml.d31 * @d12) + (ml.d32 * @d22) + (ml.d33 * @d32),
               ml.d33 = (ml.d30 * @d03) + (ml.d31 * @d13) + (ml.d32 * @d23) + (ml.d33 * @d33)

          FROM dbo.RMTMatrix AS ml
         WHERE ml.bnMatrix = @bnMatrix_L
  END
GO

/******************************************************************************************************************************/
