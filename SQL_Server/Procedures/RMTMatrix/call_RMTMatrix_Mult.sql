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

CREATE PROCEDURE dbo.call_RMTMatrix_Mult
(
   @bnMatrix_R                   BIGINT,
   @bnMatrix_L                   BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @nResult INT = 0

        UPDATE mr
           SET mr.d00 = (ml.d00 * mr.d00) + (ml.d01 * mr.d10) + (ml.d02 * mr.d20) + (ml.d03 * mr.d30),
               mr.d01 = (ml.d00 * mr.d01) + (ml.d01 * mr.d11) + (ml.d02 * mr.d21) + (ml.d03 * mr.d31),
               mr.d02 = (ml.d00 * mr.d02) + (ml.d01 * mr.d12) + (ml.d02 * mr.d22) + (ml.d03 * mr.d32),
               mr.d03 = (ml.d00 * mr.d03) + (ml.d01 * mr.d13) + (ml.d02 * mr.d23) + (ml.d03 * mr.d33),

               mr.d10 = (ml.d10 * mr.d00) + (ml.d11 * mr.d10) + (ml.d12 * mr.d20) + (ml.d13 * mr.d30),
               mr.d11 = (ml.d10 * mr.d01) + (ml.d11 * mr.d11) + (ml.d12 * mr.d21) + (ml.d13 * mr.d31),
               mr.d12 = (ml.d10 * mr.d02) + (ml.d11 * mr.d12) + (ml.d12 * mr.d22) + (ml.d13 * mr.d32),
               mr.d13 = (ml.d10 * mr.d03) + (ml.d11 * mr.d13) + (ml.d12 * mr.d23) + (ml.d13 * mr.d33),

               mr.d20 = (ml.d20 * mr.d00) + (ml.d21 * mr.d10) + (ml.d22 * mr.d20) + (ml.d23 * mr.d30),
               mr.d21 = (ml.d20 * mr.d01) + (ml.d21 * mr.d11) + (ml.d22 * mr.d21) + (ml.d23 * mr.d31),
               mr.d22 = (ml.d20 * mr.d02) + (ml.d21 * mr.d12) + (ml.d22 * mr.d22) + (ml.d23 * mr.d32),
               mr.d23 = (ml.d20 * mr.d03) + (ml.d21 * mr.d13) + (ml.d22 * mr.d23) + (ml.d23 * mr.d33),

               mr.d30 = (ml.d30 * mr.d00) + (ml.d31 * mr.d10) + (ml.d32 * mr.d20) + (ml.d33 * mr.d30),
               mr.d31 = (ml.d30 * mr.d01) + (ml.d31 * mr.d11) + (ml.d32 * mr.d21) + (ml.d33 * mr.d31),
               mr.d32 = (ml.d30 * mr.d02) + (ml.d31 * mr.d12) + (ml.d32 * mr.d22) + (ml.d33 * mr.d32),
               mr.d33 = (ml.d30 * mr.d03) + (ml.d31 * mr.d13) + (ml.d32 * mr.d23) + (ml.d33 * mr.d33)

          FROM dbo.RMTMatrix AS ml
          JOIN dbo.RMTMatrix AS mr ON mr.bnMatrix = @bnMatrix_R
         WHERE ml.bnMatrix = @bnMatrix_L
  END
GO

/******************************************************************************************************************************/
