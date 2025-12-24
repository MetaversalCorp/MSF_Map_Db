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

CREATE PROCEDURE dbo.set_RMTObject_RMTObject_Open
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMTObjectIx                BIGINT,
   @Name_wsRMTObjectId           NVARCHAR (48),
   @Type_bType                   TINYINT,
   @Type_bSubtype                TINYINT,
   @Type_bFiction                TINYINT,
   @Owner_twRPersonaIx           BIGINT,
   @Resource_qwResource          BIGINT,
   @Resource_sName               NVARCHAR (48),
   @Resource_sReference          NVARCHAR (128),
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
   @Bound_dX                     FLOAT (53),
   @Bound_dY                     FLOAT (53),
   @Bound_dZ                     FLOAT (53),
   @Properties_bLockToGround     TINYINT,
   @Properties_bYouth            TINYINT,
   @Properties_bAdult            TINYINT,
   @Properties_bAvatar           TINYINT,
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

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @RMTOBJECT_OP_RMTOBJECT_OPEN               INT = 14
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

       DECLARE @twRMTObjectIx_Open   BIGINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

          EXEC dbo.call_RMTObject_Validate @twRPersonaIx, @twRMTObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC dbo.call_RMTObject_Validate_Name       @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Name_wsRMTObjectId, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Type       @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Type_bType, @Type_bSubtype, @Type_bFiction, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Owner      @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Owner_twRPersonaIx, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Resource   @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Resource_qwResource, @Resource_sName, @Resource_sReference, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Transform  @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Bound      @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Bound_dX, @Bound_dY, @Bound_dZ, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Properties @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Properties_bLockToGround, @Properties_bYouth, @Properties_bAdult, @Properties_bAvatar, @nError OUTPUT

                     IF @bCoord = 3 -- @RMTMATRIX_COORD_NUL
                        EXEC dbo.call_RMTObject_Validate_Coord_Nul @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT
                ELSE IF @bCoord = 2 -- @RMTMATRIX_COORD_CAR
                        EXEC dbo.call_RMTObject_Validate_Coord_Car @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @dA, @dB, @dC, @nError OUTPUT
                ELSE IF @bCoord = 1 -- @RMTMATRIX_COORD_CYL
                        EXEC dbo.call_RMTObject_Validate_Coord_Cyl @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @dA, @dB, @dC, @nError OUTPUT
                ELSE IF @bCoord = 0 -- @RMTMATRIX_COORD_GEO
                        EXEC dbo.call_RMTObject_Validate_Coord_Geo @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @dA, @dB, @dC, @nError OUTPUT
                   ELSE EXEC dbo.call_Error 99, 'bCoord is invalid', @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Event_RMTObject_Open @twRMTObjectIx, @Name_wsRMTObjectId, @Type_bType, @Type_bSubtype, @Type_bFiction, @Owner_twRPersonaIx, @Resource_qwResource, @Resource_sName, @Resource_sReference, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @Bound_dX, @Bound_dY, @Bound_dZ, @Properties_bLockToGround, @Properties_bYouth, @Properties_bAdult, @Properties_bAvatar, @twRMTObjectIx_Open OUTPUT
                     IF @bError = 0
                  BEGIN
                              IF @bCoord = 3 -- @RMTMATRIX_COORD_NUL
                                 EXEC dbo.call_RMTMatrix_Nul @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, @twRMTObjectIx_Open, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ
                         ELSE IF @bCoord = 2 -- @RMTMATRIX_COORD_CAR
                                 EXEC dbo.call_RMTMatrix_Car                                       @twRMTObjectIx_Open, @dA, @dB, @dC
                         ELSE IF @bCoord = 1 -- @RMTMATRIX_COORD_CYL
                                 EXEC dbo.call_RMTMatrix_Cyl                                       @twRMTObjectIx_Open, @dA, @dB, @dC
                         ELSE IF @bCoord = 0 -- @RMTMATRIX_COORD_GEO
                                 EXEC dbo.call_RMTMatrix_Geo                                       @twRMTObjectIx_Open, @dA, @dB, @dC

                            EXEC dbo.call_RMTMatrix_Relative @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, @twRMTObjectIx_Open

                          SELECT @twRMTObjectIx_Open AS twRMTObjectIx
   
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to insert RMTObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMTObject_Log @RMTOBJECT_OP_RMTOBJECT_OPEN, @sIPAddress, @twRPersonaIx, @twRMTObjectIx
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

GRANT EXECUTE ON dbo.set_RMTObject_RMTObject_Open TO WebService
GO

/******************************************************************************************************************************/
