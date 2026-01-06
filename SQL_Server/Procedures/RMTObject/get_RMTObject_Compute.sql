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

-- These tables need to be empty for object 999999999 when executing this stored procedure

-- SELECT * FROM dbo.RMTMatrix     WHERE bnMatrix      = 999999999
-- SELECT * FROM dbo.RMTSubsurface WHERE twRMTObjectIx = 999999999
-- GO

-- This temporary table must exist when executing this stored procedure
-- Populate this table with all nodes that fall within the geographic region of the subsurface being created 
-- prior to executing this stored procedure

-- CREATE TABLE #Node
-- (
--    dLatitude                     FLOAT (53),
--    dLongitude                    FLOAT (53)
-- )
-- GO

/******************************************************************************************************************************/

DROP PROCEDURE IF EXISTS dbo.get_RMTObject_Compute
GO

CREATE PROCEDURE dbo.get_RMTObject_Compute
(
-- @twRMTParentIx             BIGINT,
   @dRad                      FLOAT (53),
   @dHeight                   FLOAT (53),
   @dDepth                    FLOAT (53)
)
AS
BEGIN
        DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

        DECLARE @nResult INT = 0,
                @bDone   INT = 0,
                @bIter   INT = 0

        DECLARE @twRMTObjectIx  BIGINT = 999999999,
                @twRMTObjectIx_ BIGINT = 0 - @twRMTObjectIx

        DECLARE @Node TABLE
                (
                   dLatitude  FLOAT (53),
                   dLongitude FLOAT (53),
                
                   dX         FLOAT (53),
                   dY         FLOAT (53),
                   dZ         FLOAT (53),
                
                   dX_        FLOAT (53),
                   dY_        FLOAT (53),
                   dZ_        FLOAT (53)
                )
         
        DECLARE @dLat_Min FLOAT (53), @dLat_Max FLOAT (53), @dLat_Mid FLOAT (53),
                @dLon_Min FLOAT (53), @dLon_Max FLOAT (53), @dLon_Mid FLOAT (53)
         
        DECLARE @dX_Min   FLOAT (53), @dX_Max   FLOAT (53), @dX_Mid   FLOAT (53),
                @dY_Min   FLOAT (53), @dY_Max   FLOAT (53), @dY_Mid   FLOAT (53),
                @dZ_Min   FLOAT (53), @dZ_Max   FLOAT (53), @dZ_Mid   FLOAT (53)
                  
        DECLARE @dX       FLOAT (53), @dY       FLOAT (53), @dZ       FLOAT (53)

        DECLARE @dX_Bound FLOAT (53), @dY_Bound FLOAT (53), @dZ_Bound FLOAT (53)

             -- Add all boundary nodes into the @Node table, and convert to cartesian coordinates (relative to the surface)

         INSERT @Node
                ( dLatitude, dLongitude, dX, dY, dZ )
         SELECT dLatitude, 
                dLongitude,
                @dRad * COS (RADIANS (dLatitude)) * SIN (RADIANS (dLongitude)),
                @dRad * SIN (RADIANS (dLatitude)),
                @dRad * COS (RADIANS (dLatitude)) * COS (RADIANS (dLongitude))
           FROM #Node

             -- Choose an origin based on the middle of the latitude and longitude (will need to be corrected in a second round)

         SELECT @dLat_Min = MIN (dLatitude), 
                @dLat_Max = MAX (dLatitude)
           FROM @Node
         
         SELECT @dLon_Min = MIN (dLongitude), 
                @dLon_Max = MAX (dLongitude)
           FROM @Node
         
             SET @dLat_Mid = (@dLat_Min + @dLat_Max) / 2
         
          -- IF (@dLon_Min = -180  AND  @dLon_Max = 180)
             IF (@dLon_Max - @dLon_Min > 270)
          BEGIN
                  SELECT @dLon_Min = MIN (dLongitude) 
                    FROM @Node
                   WHERE dLongitude >= 0
                  
                  SELECT @dLon_Max = MAX (dLongitude)
                    FROM @Node
                   WHERE dLongitude < 0
         
                     SET @dLon_Mid = (@dLon_Min + @dLon_Max + 360) / 2
         
                      IF @dLon_Mid > 180
                              SET @dLon_Mid -= 360
            END
           ELSE      SET @dLon_Mid = (@dLon_Min + @dLon_Max) / 2
         
-- SELECT 0, @dLat_Mid AS dLat_Mid, @dLon_Mid AS dLon_Mid

          WHILE @bDone = 0  AND  @bIter < 10
          BEGIN
                      -- Delete any past attempts

                  DELETE dbo.RMTMatrix     WHERE bnMatrix      IN (@twRMTObjectIx, @twRMTObjectIx_)
                  DELETE dbo.RMTSubsurface WHERE twRMTObjectIx IN (@twRMTObjectIx)
         
                      -- Compute the subsurface matrix for the origin of the relation

                    EXEC dbo.call_RMTMatrix_Geo @twRMTObjectIx, @dLat_Mid, @dLon_Mid, @dRad
                 
                      -- Convert all of the nodes from surface relative to local relative

                  UPDATE n
                     SET n.dX_ = (m.d00 * n.dX) + (m.d01 * n.dY) + (m.d02 * n.dZ) + (m.d03 * 1),
                         n.dY_ = (m.d10 * n.dX) + (m.d11 * n.dY) + (m.d12 * n.dZ) + (m.d13 * 1),
                         n.dZ_ = (m.d20 * n.dX) + (m.d21 * n.dY) + (m.d22 * n.dZ) + (m.d23 * 1)
                    FROM @Node      AS n
                    JOIN dbo.RMTMatrix AS m on m.bnMatrix = @twRMTObjectIx_
                  
                      -- Compute the bounding box values

                  SELECT @dX_Min = MIN (dX_), 
                         @dX_Max = MAX (dX_),
                         @dY_Min = MIN (dY_), 
                         @dY_Max = MAX (dY_),   -- should be 0
                         @dZ_Min = MIN (dZ_), 
                         @dZ_Max = MAX (dZ_)
                    FROM @Node
                  
                     SET @dX_Mid = (@dX_Min + @dX_Max) / 2,
                      -- @dY_Mid = (@dY_Min + @dX_Max) / 2,
                         @dZ_Mid = (@dZ_Min + @dZ_Max) / 2

-- SELECT 1, @bIter, @dX_Mid AS dX_Mid, @dZ_Mid AS dZ_Mid
                  
                      IF @dY_Min < 0 - @dRad
                   BEGIN
                              SET @dY_Min = @dY_Min
                     END

                      -- Check to see if the origin is close to the middle of the bounding box

                      IF ABS (@dX_Mid) > 0.000001  OR ABS (@dZ_Mid) > 0.000001
                   BEGIN
                          -- Convert the midpoint back to a surface relative coordinate

                              SET @dX_Mid *= 0.97,
                                  @dZ_Mid *= 0.97

                              SET @dY_Mid = 0

-- SELECT 2, @dX_Mid AS dX_Mid, @dZ_Mid AS dZ_Mid, @dY_Mid AS dY_Mid
                  
                           SELECT @dX = (m.d00 * @dX_Mid) + (m.d01 * @dY_Mid) + (m.d02 * @dZ_Mid) + (m.d03 * 1),
                                  @dY = (m.d10 * @dX_Mid) + (m.d11 * @dY_Mid) + (m.d12 * @dZ_Mid) + (m.d13 * 1),
                                  @dZ = (m.d20 * @dX_Mid) + (m.d21 * @dY_Mid) + (m.d22 * @dZ_Mid) + (m.d23 * 1)
                             FROM dbo.RMTMatrix AS m
                            WHERE m.bnMatrix = @twRMTObjectIx

-- SELECT 3, @dX AS dX, @dZ AS dZ, @dY AS dY

                              SET @dY = SQRT ((@dRad * @dRad) - (@dX * @dX) - (@dZ * @dZ)) * (CASE WHEN @dY < 0 THEN -1 ELSE 1 END)
                  
-- SELECT 4, @dX AS dX, @dZ AS dZ, @dY AS dY

                               -- Convert the midpoint back to latitude and longitude

                              SET @dLat_Mid = DEGREES (ASIN (@dY / @dRad)),
                                  @dLon_Mid = DEGREES (ATN2 (@dX, @dZ))

-- SELECT 5, @dLat_Mid AS dLat_Mid, @dLon_Mid AS dLon_Mid

                              SET @bIter += 1
                     END
                    ELSE      SET @bDone = 1
            END

             -- Calculate the bounding box dimensions

            SET @dX = (@dX_Max - @dX_Min) / 2,
                @dZ = (@dZ_Max - @dZ_Min) / 2

            SET @dX_Bound = @dX * (@dRad + @dHeight) / @dRad,
                @dZ_Bound = @dZ * (@dRad + @dHeight) / @dRad

            SET @dY = IIF (@dX > @dZ, @dX, @dZ)

            SET @dY = @dY * (@dRad - @dDepth) / @dRad

            SET @dY = SQRT (((@dRad - @dDepth) * (@dRad - @dDepth)) - (@dY * @dY))

            SET @dY_Bound = @dRad + @dHeight - @dY

--  SELECT 6, @dX AS dX, @dY AS dY, @dZ AS dZ, @dX_Bound AS dX_Bound, @dY_Bound AS dY_Bound, @dZ_Bound AS dZ_Bound

             -- Now that we have the coordinates of the origin, we need to call call_RMTMatrix_Geo one last time

         DELETE dbo.RMTMatrix     WHERE bnMatrix      IN (@twRMTObjectIx, @twRMTObjectIx_)
         DELETE dbo.RMTSubsurface WHERE twRMTObjectIx IN (@twRMTObjectIx)
         
             -- Note that dY sits at the bottom of the bounding box and acts as the effective radius
             -- All nodes should be above dY (positive) after this call

/*
         INSERT dbo.RMTObject
              (
                ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx,
                ObjectHead_Self_wClass, -- ObjectHead_Self_twObjectIx,
                ObjectHead_twEventIz, ObjectHead_wFlags, 
                Name_wsRMTObjectId, 
                Type_bType, Type_bSubtype, Type_bFiction,
                Owner_twRPersonaIx, 
                Resource_qwResource, Resource_sName, Resource_sReference, 
                Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, 
                Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, 
                Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, 
                Bound_dX, Bound_dY, Bound_dZ, 
                Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar
              )
         VALUES
              ( @SBO_CLASS_RMTOBJECT, @twRMTParentIx, 
                @SBO_CLASS_RMTOBJECT, -- @twRMTObjectIx, 
                0, 32, 
                '', 
                0, 0, 0,
                1,
                0, '', '', 
                0, 0, 0, 
                0, 0, 0, 1, 
                1, 1, 1, 
                0, 0, 0, 
                @dX_Bound * 2, @dY_Bound, @dZ_Bound * 2, 
                0, 0, 0, 0
              )

            SET @twRMTObjectIx = SCOPE_IDENTITY ()

           EXEC dbo.call_RMTMatrix_Geo @twRMTObjectIx, @dLat_Mid, @dLon_Mid, @dY

           EXEC dbo.call_RMTMatrix_Relative @SBO_CLASS_RMTOBJECT, @twRMTParentIx, @twRMTObjectIx
*/
         SELECT @dLat_Mid     AS dLatitude, 
                @dLon_Mid     AS dLongitude,
                @dY           AS dRadius, 
                @dX_Bound * 2 AS Bound_dX, 
                @dY_Bound     AS Bound_dY, 
                @dZ_Bound * 2 AS Bound_dZ
  END
GO

GRANT EXECUTE ON dbo.get_RMTObject_Compute TO WebService
GO

/******************************************************************************************************************************/
