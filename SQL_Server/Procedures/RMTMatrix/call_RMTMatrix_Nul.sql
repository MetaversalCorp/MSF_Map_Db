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

CREATE PROCEDURE dbo.call_RMTMatrix_Nul
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
   @Transform_Position_dX        FLOAT (53),
   @Transform_Position_dY        FLOAT (53),
   @Transform_Position_dZ        FLOAT (53),
   @Transform_Rotation_dX        FLOAT (53),
   @Transform_Rotation_dY        FLOAT (53),
   @Transform_Rotation_dZ        FLOAT (53),
   @Transform_Rotation_dW        FLOAT (53),
   @Transform_Scale_dX           FLOAT (53),
   @Transform_Scale_dY           FLOAT (53),
   @Transform_Scale_dZ           FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @RMTMATRIX_COORD_NUL                       INT = 0

       DECLARE @nResult INT = 0

        INSERT dbo.RMTSubsurface
               (  twRMTObjectIx, tnGeometry,            dA,  dB,  dC )
        VALUES ( @twRMTObjectIx, @RMTMATRIX_COORD_NUL,   0,   0,   0 )

        INSERT dbo.RMTMatrix
               ( bnMatrix       )
        VALUES ( @twRMTObjectIx )

            IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMTOBJECT AND @ObjectHead_Parent_twObjectIx <> 0
               EXEC dbo.call_RMTMatrix_Mult @twRMTObjectIx, @ObjectHead_Parent_twObjectIx

          EXEC dbo.call_RMTMatrix_Translate @twRMTObjectIx, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ

          EXEC dbo.call_RMTMatrix_Rotate    @twRMTObjectIx, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW

          EXEC dbo.call_RMTMatrix_Scale     @twRMTObjectIx, @Transform_Scale_dX,     @Transform_Scale_dY,    @Transform_Scale_dZ

        INSERT dbo.RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - @twRMTObjectIx )

          EXEC @nResult = dbo.call_RMTMatrix_Inverse @twRMTObjectIx

        RETURN @nResult
  END
GO

/******************************************************************************************************************************/
