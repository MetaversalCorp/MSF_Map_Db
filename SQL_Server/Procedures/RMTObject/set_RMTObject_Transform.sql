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

CREATE PROCEDURE dbo.set_RMTObject_Transform
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
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
   @Transform_Scale_dZ           FLOAT (53),
   @bCoord                       TINYINT,
   @dA                           FLOAT (53),
   @dB                           FLOAT (53),
   @dC                           FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

       DECLARE @RMTOBJECT_OP_TRANSFORM                    INT = 5
       DECLARE @RMTMATRIX_COORD_NUL                       INT = 0
       DECLARE @RMTMATRIX_COORD_CAR                       INT = 1
       DECLARE @RMTMATRIX_COORD_CYL                       INT = 2
       DECLARE @RMTMATRIX_COORD_GEO                       INT = 3

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0,
               @bError  INT

       DECLARE @ObjectHead_Parent_wClass     SMALLINT,
               @ObjectHead_Parent_twObjectIx BIGINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

          EXEC dbo.call_RMTObject_Validate @twRPersonaIx, @twRMTObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                -- EXEC dbo.call_RMTObject_Validate_Transform @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT

                     IF @bCoord = 3 -- @RMTMATRIX_COORD_NUL
                        EXEC dbo.call_RMTObject_Validate_Coord_Nul @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT
                ELSE IF @bCoord = 2 -- @RMTMATRIX_COORD_CAR
                        EXEC dbo.call_RMTObject_Validate_Coord_Car @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx, @dA, @dB, @dC, @nError OUTPUT
                ELSE IF @bCoord = 1 -- @RMTMATRIX_COORD_CYL
                        EXEC dbo.call_RMTObject_Validate_Coord_Cyl @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx, @dA, @dB, @dC, @nError OUTPUT
                ELSE IF @bCoord = 0 -- @RMTMATRIX_COORD_GEO
                        EXEC dbo.call_RMTObject_Validate_Coord_Geo @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx, @dA, @dB, @dC, @nError OUTPUT
                   ELSE EXEC dbo.call_Error 99, 'bCoord is invalid', @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Event_Transform @twRMTObjectIx, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ
                     IF @bError = 0
                  BEGIN
                          DELETE dbo.RMTMatrix
                           WHERE bnMatrix =     @twRMTObjectIx
                              OR bnMatrix = 0 - @twRMTObjectIx

                          -- SET @nCount += @@ROWCOUNT -- 2

                          DELETE dbo.RMTSubsurface
                           WHERE twRMTObjectIx = @twRMTObjectIx

                          -- SET @nCount += @@ROWCOUNT -- 1

                          -- assume these succeeded for now

                              IF @bCoord = 3 -- @RMTMATRIX_COORD_NUL
                                 EXEC dbo.call_RMTMatrix_Nul @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ
                         ELSE IF @bCoord = 2 -- @RMTMATRIX_COORD_CAR
                                 EXEC dbo.call_RMTMatrix_Car                                                           @twRMTObjectIx, @dA, @dB, @dC
                         ELSE IF @bCoord = 1 -- @RMTMATRIX_COORD_CYL
                                 EXEC dbo.call_RMTMatrix_Cyl                                                           @twRMTObjectIx, @dA, @dB, @dC
                         ELSE IF @bCoord = 0 -- @RMTMATRIX_COORD_GEO
                                 EXEC dbo.call_RMTMatrix_Geo                                                           @twRMTObjectIx, @dA, @dB, @dC

                            EXEC dbo.call_RMTMatrix_Relative @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMTObjectIx

                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to update RMTObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMTObject_Log @RMTOBJECT_OP_TRANSFORM, @sIPAddress, @twRPersonaIx, @twRMTObjectIx
                     IF @bError = 0
                  BEGIN
                         EXEC @bError = dbo.call_Event_Push
                           IF @bError = 0
                        BEGIN
                              SET @bCommit = 1
                          END
                         ELSE EXEC dbo.call_Error -9, 'Failed to push events'
                    END
                   ELSE EXEC dbo.call_Error -8, 'Failed to log action'
           END
       
            IF @bCommit = 0
         BEGIN
                 SELECT dwError, sError FROM #Error

               ROLLBACK TRANSACTION
           END
          ELSE COMMIT TRANSACTION

        RETURN @bCommit - 1 - @nError
  END
GO

GRANT EXECUTE ON dbo.set_RMTObject_Transform TO WebService
GO

/******************************************************************************************************************************/
