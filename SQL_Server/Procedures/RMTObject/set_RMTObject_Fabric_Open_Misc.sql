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

CREATE PROCEDURE dbo.set_RMTObject_Fabric_Open
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMTObjectIx_Root           BIGINT,
   @Name_wsRMTObjectId           NVARCHAR (48),
   @Type_bType                   TINYINT,
-- @Type_bSubtype                TINYINT,
-- @Type_bFiction                TINYINT,
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
-- @Properties_bLockToGround     TINYINT,
-- @Properties_bYouth            TINYINT,
-- @Properties_bAdult            TINYINT,
-- @Properties_bAvatar           TINYINT,
   @Transform_Rotate             FLOAT (53),
   @bCoord                       TINYINT,
   @dA                           FLOAT (53),
   @dB                           FLOAT (53),
   @dC                           FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
        -- SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73
       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11
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

    -- DECLARE @ObjectHead_Parent_wClass     SMALLINT,
    --         @ObjectHead_Parent_twObjectIx BIGINT

       DECLARE @twRMTObjectIx        BIGINT = 0,
               @twRMTObjectIx_Open   BIGINT,
               @twRMPObjectIx_Open   BIGINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

/*
   validate the input
   find a parcel parent
      determine which bounding box(es) contain that coordinate (with type < parcel)
      pick the one with the largest type
      select the closest
   create a parcel (TObject)
   create an attachment point (PObject)
   return the attachment point object index

*/
       -- EXEC dbo.call_RMTObject_Validate @twRPersonaIx, @twRMTObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

           SET @Bound_dY         = (@Bound_dX + @Bound_dZ) / 4.0

DECLARE @nTry   INT = 10,
        @nRetry INT = 1
  WHILE @nTry > 0  AND  @nRetry > 0
  BEGIN
        SET @nTry  -= 1
        SET @nRetry = 0

           SET @Transform_Rotate = RAND () * 360.0           --   0.0 -> 360.0
           SET @dA               = RAND () * 120.0 - 60.0    -- -60.0 ->  60.0
           SET @dB               = RAND () * 340.0 + 10.0    --  10.0 -> 350.0
            IF @db > 180.0
               SET @dB -= 360.0

            IF @twRMTObjectIx_Root = 5 -- Elysium (ROOT)
         BEGIN
                   EXEC dbo.call_Error 99, 'twRMTObjectIx_Root = 5 is not yet supported', @nError OUTPUT
           END
       ELSE IF @twRMTObjectIx_Root = 6 -- Karona  (ROOT)
         BEGIN
                    SET @dC = 6371000.0
           END
       ELSE IF @twRMTObjectIx_Root = 7 -- Simetra (ROOT)
         BEGIN
                    SET @dC = 3469400.0
           END
          ELSE EXEC dbo.call_Error 99, 'twRMTObjectIx_Root is invalid', @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC dbo.call_RMTObject_Validate_Name       @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Name_wsRMTObjectId, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Type       @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Type_bType, @Type_bSubtype, @Type_bFiction, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Owner      @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Owner_twRPersonaIx, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Resource   @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Resource_qwResource, @Resource_sName, @Resource_sReference, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Transform  @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Bound      @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Bound_dX, @Bound_dY, @Bound_dZ, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Properties @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, 0, @Properties_bLockToGround, @Properties_bYouth, @Properties_bAdult, @Properties_bAvatar, @nError OUTPUT

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

            IF @nError = 0  AND  @bCoord = 0 -- @RMTMATRIX_COORD_GEO
         BEGIN
                DECLARE @nCount INT

                 SELECT @nCount = COUNT (*)
                   FROM dbo.RMTSubsurface AS s
                   JOIN dbo.RMTObject     AS o ON o.ObjectHead_Self_twObjectIx = s.twRMTObjectIx
                  WHERE o.Type_bType = 11
                    AND 2 * @dC * ASIN (SQRT (SQUARE (SIN ((RADIANS (s.dA) - RADIANS (@dA)) / 2)) + (COS (RADIANS (s.dA)) * COS (RADIANS (@dA)) * SQUARE (SIN ((RADIANS (s.dB) - RADIANS (@dB)) / 2))))) < 2500 -- IIF (o.Bound_dX > o.Bound_dZ, o.Bound_dX, o.Bound_dZ) + IIF (@Bound_dX > @Bound_dZ, @Bound_dX, @Bound_dZ)

                     IF @nCount > 0
  BEGIN
                        EXEC dbo.call_Error 97, 'Parcel overlaps with another parcel', @nError OUTPUT
        SET @nRetry = 1
    END
           END

            IF @nError = 0
         BEGIN
                     IF @bCoord = 3 -- @RMTMATRIX_COORD_NUL
                        EXEC dbo.call_Error 99, 'bCoord is invalid', @nError OUTPUT
                ELSE IF @bCoord = 2 -- @RMTMATRIX_COORD_CAR
                        EXEC dbo.call_Error 99, 'bCoord is invalid', @nError OUTPUT
                ELSE IF @bCoord = 1 -- @RMTMATRIX_COORD_CYL
                        EXEC dbo.call_Error 99, 'bCoord is invalid', @nError OUTPUT
                ELSE IF @bCoord = 0 -- @RMTMATRIX_COORD_GEO
                        EXEC @twRMTObjectIx = dbo.call_RMTObject_Parent_Geo @twRMTObjectIx_Root, 3, @dA, @dB, @dC -- LAND
                   ELSE EXEC dbo.call_Error 99, 'bCoord is invalid', @nError OUTPUT

                     IF @twRMTObjectIx = 0
                        EXEC dbo.call_Error 98, 'Coordinate is not within a mapped land area', @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Event_RMTObject_Open @twRMTObjectIx, @Name_wsRMTObjectId, @MVO_RMTOBJECT_TYPE_PARCEL, 0, 0,  1,  0, '', '',  0, 0, 0,  0, 0, 0, 1,  1, 1, 1,  @Bound_dX, @Bound_dY, @Bound_dZ,  0, 0, 0, 0,  @twRMTObjectIx_Open OUTPUT
                     IF @bError = 0
                  BEGIN
                              IF @bCoord = 3 -- @RMTMATRIX_COORD_NUL
                                 EXEC dbo.call_RMTMatrix_Nul @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, @twRMTObjectIx_Open,  @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ
                         ELSE IF @bCoord = 2 -- @RMTMATRIX_COORD_CAR
                                 EXEC dbo.call_RMTMatrix_Car                                       @twRMTObjectIx_Open, @dA, @dB, @dC
                         ELSE IF @bCoord = 1 -- @RMTMATRIX_COORD_CYL
                                 EXEC dbo.call_RMTMatrix_Cyl                                       @twRMTObjectIx_Open, @dA, @dB, @dC
                         ELSE IF @bCoord = 0 -- @RMTMATRIX_COORD_GEO
                                 EXEC dbo.call_RMTMatrix_Geo                                       @twRMTObjectIx_Open, @dA, @dB, @dC

                            EXEC dbo.call_RMTMatrix_Relative @SBO_CLASS_RMTOBJECT, @twRMTObjectIx, @twRMTObjectIx_Open

                          SELECT @Transform_Rotation_dX = 0,
                                 @Transform_Rotation_dY = SIN (RADIANS (@Transform_Rotate) * 0.5),
                                 @Transform_Rotation_dZ = 0,
                                 @Transform_Rotation_dW = COS (RADIANS (@Transform_Rotate) * 0.5)

                            EXEC @bError = dbo.call_RMTObject_Event_RMPObject_Open @twRMTObjectIx_Open, 'Attachment Point', @Type_bType, 255, 0, 0,  @Owner_twRPersonaIx,  @Resource_qwResource, @Resource_sName, @Resource_sReference,  0, 0, 0,  @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW,  1, 1, 1,  @Bound_dX, @Bound_dY, @Bound_dZ,  @twRMPObjectIx_Open OUTPUT, 0
                              IF @bError = 0
                           BEGIN
                                   SELECT @SBO_CLASS_RMPOBJECT AS wClass,
                                          @twRMPObjectIx_Open  AS twRMPObjectIx
   
                                      SET @bCommit = 1
                             END
                            ELSE EXEC dbo.call_Error -1, 'Failed to insert RMPObject'
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to insert RMTObject'
           END

    END -- retry
       
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

GRANT EXECUTE ON dbo.set_RMTObject_Fabric_Open TO WebService
GO

/******************************************************************************************************************************/
