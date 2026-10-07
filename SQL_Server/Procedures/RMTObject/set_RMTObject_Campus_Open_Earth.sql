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

DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Campus_Open
GO

CREATE PROCEDURE dbo.set_RMTObject_Campus_Open
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMTObjectIx_Root           BIGINT,
   @Name_wsRMTObjectId           NVARCHAR (48),
   @Owner_twRPersonaIx           BIGINT,
   @Resource_qwResource          BIGINT,
   @Resource_sName               NVARCHAR (48),
   @Resource_sReference          NVARCHAR (128),
   @dLatitude_Min                FLOAT (53),
   @dLatitude_Max                FLOAT (53),
   @dLongitude_Min               FLOAT (53),
   @dLongitude_Max               FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
        -- SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73
       DECLARE @MVO_RMTOBJECT_TYPE_SECTOR                 INT = 10
       DECLARE @RMTOBJECT_OP_CAMPUS_OPEN                  INT = 19
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

       DECLARE @twRMTParentIx        BIGINT,
               @twRMTObjectIx_Open   BIGINT

       DECLARE @nCount   INT     = 0,
               @bSubtype TINYINT = 2

       DECLARE @dRadius_Planet FLOAT (53)

       DECLARE @dLatitude      FLOAT (53),
               @dLongitude     FLOAT (53),
               @dRadius        FLOAT (53),
               @Bound_dX       FLOAT (53),
               @Bound_dY       FLOAT (53),
               @Bound_dZ       FLOAT (53)

       DECLARE @dHeight        FLOAT (53),
               @dDepth         FLOAT (53)

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

            IF @twRMTObjectIx_Root = 1 -- Earth   (ROOT)
         BEGIN
                    SET @dRadius_Planet = 6371000.0
           END
          ELSE EXEC dbo.call_Error 99, 'twRMTObjectIx_Root is invalid', @nError OUTPUT

            IF @nError = 0
         BEGIN
                    SET @ObjectHead_Parent_wClass     = @SBO_CLASS_RMTOBJECT
                    SET @ObjectHead_Parent_twObjectIx = 0

                   EXEC dbo.call_RMTObject_Validate_Name       @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Name_wsRMTObjectId, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Type       @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Type_bType, @Type_bSubtype, @Type_bFiction, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Owner      @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Owner_twRPersonaIx, @nError OUTPUT
                   EXEC dbo.call_RMTObject_Validate_Resource   @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Resource_qwResource, @Resource_sName, @Resource_sReference, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Transform  @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Bound      @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Bound_dX, @Bound_dY, @Bound_dZ, @nError OUTPUT
                -- EXEC dbo.call_RMTObject_Validate_Properties @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @Properties_bLockToGround, @Properties_bYouth, @Properties_bAdult, @Properties_bAvatar, @nError OUTPUT

                   EXEC dbo.call_RMTObject_Validate_Campus     @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, 0, @dLatitude_Min, @dLatitude_Max, @dLongitude_Min, @dLongitude_Max, @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                     -- Make sure these queries return no results:

                 SELECT @nCount += COUNT (*) FROM dbo.RMTMatrix     WHERE bnMatrix      = 999999999
                 SELECT @nCount += COUNT (*) FROM dbo.RMTSubsurface WHERE twRMTObjectIx = 999999999

                     IF @nCount = 0
                  BEGIN
                             SET @nError = 0
                    END
                   ELSE EXEC dbo.call_Error -1, 'RMTMatrix or RMTSubsurface scratch rows are not empty', @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 1
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                     -- Create a temporary table to hold the campus nodes:

                 CREATE TABLE #Node
                        (
                           dLatitude             FLOAT (53),
                           dLongitude            FLOAT (53)
                        )

               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 2
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                 INSERT #Node
                        ( dLatitude,      dLongitude    )
                 VALUES (@dLatitude_Min, @dLongitude_Min),
                        (@dLatitude_Min, @dLongitude_Max),
                        (@dLatitude_Max, @dLongitude_Min),
                        (@dLatitude_Max, @dLongitude_Max)

               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 3
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                   EXEC dbo.call_RMTObject_Compute

                                    @dRadius_Planet, 
                                    0.0, 
                                    0.0, 

                                    @dLatitude  OUTPUT, 
                                    @dLongitude OUTPUT, 
                                    @dRadius    OUTPUT, 
                                    
                                    @Bound_dX   OUTPUT, 
                                    @Bound_dY   OUTPUT, 
                                    @Bound_dZ   OUTPUT

                     -- Make note of the center point of the campus (@dLatitude, @dLongitude)

               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 4
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                   EXEC @twRMTParentIx = dbo.call_RMTObject_Parent_Geo 1, 6, @dLatitude, @dLongitude, @dRadius_Planet

              -- SELECT @twRMTParentIx
              -- SELECT * FROM dbo.RMTObject WHERE ObjectHead_Self_twObjectIx = @twRMTParentIx

                     -- Make note of the parent object (@twRMTParentIx)
           END

            IF @nError = 0
         BEGIN
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 5
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                    -- Sectors with bSubtype = 0 use 1000 m for depth and height, and are roughly 50 - 100 km in diameter
                    -- Sectors with bSubtype = 1 use  750 m for depth and height, and are roughly 10 -  50 km in diameter
                    -- Sectors with bSubtype = 2 use  500 m for depth and height, and are roughly  1 -   5 km in diameter
                    -- Sectors with bSubtype = 3 use  250 m for depth and height, and are roughly .1 -  .5 km in diameter

                   SET @bSubtype = CASE
                                   WHEN @Bound_dX * @Bound_dX <     250000 THEN 3
                                   WHEN @Bound_dX * @Bound_dX <   25000000 THEN 2
                                   WHEN @Bound_dX * @Bound_dX < 2500000000 THEN 1
                                   ELSE                                         0
                                    END

                   SET @dHeight  = CASE @bSubtype
                                   WHEN 0 THEN 1000.0
                                   WHEN 1 THEN  750.0
                                   WHEN 2 THEN  500.0
                                   WHEN 3 THEN  250.0
                                    END

                   SET @dDepth   = @dHeight

                   -- find the appropriate parent
                   -- WHILE
                   -- @twRMTParentIx 
           END

            IF @nError = 0
         BEGIN
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 6
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                  EXEC dbo.call_RMTObject_Compute

                                    @dRadius_Planet, 
                                    @dHeight, 
                                    @dDepth, 
                                    
                                    @dLatitude  OUTPUT, 
                                    @dLongitude OUTPUT, 
                                    @dRadius    OUTPUT, 
                                    
                                    @Bound_dX   OUTPUT, 
                                    @Bound_dY   OUTPUT, 
                                    @Bound_dZ   OUTPUT

               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 7
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                   EXEC @bError = dbo.call_RMTObject_Event_RMTObject_Open 
                                    @twRMTParentIx,                      -- twRMTObjectIx                    -- from step 4
                                    @Name_wsRMTObjectId,                 -- Name_wsRMTObjectId
                                    @MVO_RMTOBJECT_TYPE_SECTOR,          -- Type_bType
                                    255,                                 -- Type_bSubtype
                                    0,                                   -- Type_bFiction
                                    @Owner_twRPersonaIx,                 -- Owner_twRPersonaIx
                                    0,                                   -- Resource_qwResource
                                    @Resource_sName,                     -- Resource_sName                   -- <company>
                                    @Resource_sReference,                -- Resource_sReference              -- <campus.msf>
                                    0,                                   -- Transform_Position_dX
                                    0,                                   -- Transform_Position_dY
                                    0,                                   -- Transform_Position_dZ
                                    0,                                   -- Transform_Rotation_dX
                                    0,                                   -- Transform_Rotation_dY
                                    0,                                   -- Transform_Rotation_dZ
                                    1,                                   -- Transform_Rotation_dW
                                    1,                                   -- Transform_Scale_dX
                                    1,                                   -- Transform_Scale_dY
                                    1,                                   -- Transform_Scale_dZ
                                    @Bound_dX,                           -- Bound_dX                         -- from step 6
                                    @Bound_dY,                           -- Bound_dY                         -- from step 6
                                    @Bound_dZ,                           -- Bound_dZ                         -- from step 6
                                    0,                                   -- Properties_bLockToGround
                                    0,                                   -- Properties_bYouth
                                    0,                                   -- Properties_bAdult
                                    0,                                   -- Properties_bAvatar
                                    @twRMTObjectIx_Open OUTPUT           -- twRMTObjectIx_Open

                     IF @bError = 0
                  BEGIN
                            EXEC dbo.call_RMTMatrix_Geo @twRMTObjectIx_Open, @dLatitude, @dLongitude, @dRadius -- from step 6

                            EXEC dbo.call_RMTMatrix_Relative @SBO_CLASS_RMTOBJECT, @twRMTParentIx, @twRMTObjectIx_Open

                          SELECT @SBO_CLASS_RMTOBJECT AS wClass,
                                 @twRMTObjectIx_Open  AS twRMPObjectIx
   
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to insert RMTObject'
           END

            IF @bCommit = 1
         BEGIN
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
               -- Step 8
               --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                   SELECT CONCAT
                          (
                            '{ "parent":{ "class":', t.ObjectHead_Parent_wClass, ', "object":', t.ObjectHead_Parent_twObjectIx, ' }, ',
                              '"object":{ "class":', t.ObjectHead_Self_wClass, ', "object":', t.ObjectHead_Self_twObjectIx, ' }, ',
                              '"campus":{ "bounds":{ "x":"', dbo.Format_Double (t.Bound_dX), '", "y":"', dbo.Format_Double (t.Bound_dY), '", "z":"', dbo.Format_Double (t.Bound_dZ), '" }, ',
                                         '"subtype":"', t.Type_bType, '" }, ',
                              '"planet":{ "matrix":{ "d00":"', dbo.Format_Double (mp.d00), '", "d01":"', dbo.Format_Double (mp.d01), '", "d02":"', dbo.Format_Double (mp.d02), '", "d03":"', dbo.Format_Double (mp.d03), '", ',
                                                    '"d10":"', dbo.Format_Double (mp.d10), '", "d11":"', dbo.Format_Double (mp.d11), '", "d12":"', dbo.Format_Double (mp.d12), '", "d13":"', dbo.Format_Double (mp.d13), '", ',
                                                    '"d20":"', dbo.Format_Double (mp.d20), '", "d21":"', dbo.Format_Double (mp.d21), '", "d22":"', dbo.Format_Double (mp.d22), '", "d23":"', dbo.Format_Double (mp.d23), '", ',
                                                    '"d30":"', dbo.Format_Double (mp.d30), '", "d31":"', dbo.Format_Double (mp.d31), '", "d32":"', dbo.Format_Double (mp.d32), '", "d33":"', dbo.Format_Double (mp.d33), '" }, ',
                                         '"radius":"', dbo.Format_Double (s.dC), '", ',
                                         '"subsurface":{ "dA":', dbo.Format_Double (s.dA), ', "dB":', dbo.Format_Double (s.dB), ', "dC":', dbo.Format_Double (s.dC), ', "tnGeometry":', s.tnGeometry, ' }, ',
                                         '"matrixInverse":{ "d00":"', dbo.Format_Double (mn.d00), '", "d01":"', dbo.Format_Double (mn.d01), '", "d02":"', dbo.Format_Double (mn.d02), '", "d03":"', dbo.Format_Double (mn.d03), '", ',
                                                           '"d10":"', dbo.Format_Double (mn.d10), '", "d11":"', dbo.Format_Double (mn.d11), '", "d12":"', dbo.Format_Double (mn.d12), '", "d13":"', dbo.Format_Double (mn.d13), '", ',
                                                           '"d20":"', dbo.Format_Double (mn.d20), '", "d21":"', dbo.Format_Double (mn.d21), '", "d22":"', dbo.Format_Double (mn.d22), '", "d23":"', dbo.Format_Double (mn.d23), '", ',
                                                           '"d30":"', dbo.Format_Double (mn.d30), '", "d31":"', dbo.Format_Double (mn.d31), '", "d32":"', dbo.Format_Double (mn.d32), '", "d33":"', dbo.Format_Double (mn.d33), '" }',
                               ' } }'
                          ) AS Response
                     FROM dbo.RMTMatrix     AS mp
                     JOIN dbo.RMTMatrix     AS mn ON mn.bnMatrix = 0 - mp.bnMatrix
                     JOIN dbo.RMTSubsurface AS s  ON s.twRMTObjectIx = mp.bnMatrix
                     JOIN dbo.RMTObject     AS t  ON t.ObjectHead_Self_twObjectIx = mp.bnMatrix
                    WHERE mp.bnMatrix = @twRMTObjectIx_Open -- from step 7
           END

            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMTObject_Log @RMTOBJECT_OP_CAMPUS_OPEN, @sIPAddress, @twRPersonaIx, @twRMTParentIx
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

GRANT EXECUTE ON dbo.set_RMTObject_Campus_Open TO WebService
GO


-- this procedure shouldn't always be added tothe database, but there's no way to only add it based on a condition
DROP PROCEDURE dbo.set_RMTObject_Campus_Open
GO

/******************************************************************************************************************************/
