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

CREATE PROCEDURE dbo.call_RMTMatrix_Cyl
(
   @twRMTObjectIx                BIGINT,
   @dTheta                       FLOAT (53),
   @dY                           FLOAT (53),
   @dRadius                      FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @RMTMATRIX_COORD_CYL                       INT = 2

       DECLARE @nResult INT = 0

            -- right handed (counter-clockwise rotation), Y up, negative Z forward
            -- theta == 0 degrees aligns with the +z axis
         
            -- this is a special case of the geographic coordiate system with latitude = 0

       DECLARE @dThe    FLOAT (53) = RADIANS (@dTheta),
            -- @dY      FLOAT (53) =          @dY,
               @dRad    FLOAT (53) =          @dRadius,
               @dOI     FLOAT (53) = 1

       DECLARE @dCThe FLOAT (53) = COS (@dThe),
               @dSThe FLOAT (53) = SIN (@dThe)

            IF @dRad < 0
         BEGIN
               SET @dRad *= -1
               SET @dOI  *= -1
           END

            -- MXform_Identity     (MXform);
            -- MXform_Translate    (MXform, dRad * dCLat * dSThe, dRad * dSLat, dRad * dCLat * dCThe);
            -- MXform_Rotate_Y     (MXform, dThe);                                                              -- +z axis aligns with theta
            -- MXform_Rotate_X     (MXform, 90);                                                                -- +y axis aligns with latitude = 0
            -- MXform_Rotate_Z     (MXform, 90 +/- 90);                                                         -- +y axis aligns with latitude = 0 (direction depends on dOI)
         
            -- Matrix multiplication progresses left to right
         
            -- [ 1   0   0   0 ]     [ 1   0   0   X ]     [  dCThe   0   dSThe   0 ]     [ 1   0    0   0 ]     [ dOI   0     0   0 ]
            -- [ 0   1   0   0 ]  X  [ 0   1   0   Y ]  X  [  0       1   0       0 ]  X  [ 0   0   -1   0 ]  X  [ 0     dOI   0   0 ]
            -- [ 0   0   1   0 ]     [ 0   0   1   Z ]     [ -dSThe   0   dCThe   0 ]     [ 0   1    0   0 ]     [ 0     0     1   0 ]
            -- [ 0   0   0   1 ]     [ 0   0   0   1 ]     [  0       0   0       1 ]     [ 0   0    0   1 ]     [ 0     0     0   1 ]

        INSERT dbo.RMTSubsurface
               (  twRMTObjectIx, tnGeometry,            dA,      dB,  dC      )
        VALUES ( @twRMTObjectIx, @RMTMATRIX_COORD_CYL, @dTheta, @dY, @dRadius )

        INSERT dbo.RMTMatrix
               ( bnMatrix,

                 d00,                 d01,                d02,     d03,
                 d10,                 d11,                d12,     d13,
                 d20,                 d21,                d22,     d23,
                 d30,                 d31,                d32,     d33
               )
        VALUES ( @twRMTObjectIx,

                 @dOI *  @dCThe ,     @dOI * @dSThe ,      0 ,     @dRad * @dSThe ,
                         0      ,            0      ,     -1 ,     @dY            ,
                 @dOI * -@dSThe ,     @dOI * @dCThe ,      0 ,     @dRad * @dCThe ,
                         0      ,            0      ,      0 ,     1             
               )

        INSERT dbo.RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - @twRMTObjectIx )

          EXEC @nResult = dbo.call_RMTMatrix_Inverse @twRMTObjectIx

        RETURN @nResult
  END
GO

/******************************************************************************************************************************/
