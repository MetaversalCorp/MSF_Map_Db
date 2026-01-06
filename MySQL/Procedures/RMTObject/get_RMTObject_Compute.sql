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

/* ************************************************************************************************************************** */

-- These tables need to be empty for object 999999999 when executing this stored procedure

-- SELECT * FROM RMTMatrix     WHERE bnMatrix      = 999999999
-- SELECT * FROM RMTSubsurface WHERE twRMTObjectIx = 999999999
-- GO

-- This temporary table must exist when executing this stored procedure
-- Populate this table with all nodes that fall within the geographic region of the subsurface being created 
-- prior to executing this stored procedure

-- CREATE TEMPORARY TABLE Node
-- (
--    dLatitude                     DOUBLE,
--    dLongitude                    DOUBLE
-- )
-- GO

/* ************************************************************************************************************************** */

DROP PROCEDURE IF EXISTS get_RMTObject_Compute;

DELIMITER $$

CREATE PROCEDURE get_RMTObject_Compute
(
-- IN    twRMTParentIx                 BIGINT,
   IN    dRad                          DOUBLE,
   IN    dHeight                       DOUBLE,
   IN    dDepth                        DOUBLE
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

       DECLARE nResult INT DEFAULT 0;
       DECLARE bDone   INT DEFAULT 0;
       DECLARE bIter   INT DEFAULT 0;
       DECLARE bSafe   INT;

       DECLARE twRMTObjectIx  BIGINT DEFAULT 999999999;
       DECLARE twRMTObjectIx_ BIGINT DEFAULT 0 - twRMTObjectIx;

       DECLARE dLat_Min, dLat_Max, dLat_Mid DOUBLE;
       DECLARE dLon_Min, dLon_Max, dLon_Mid DOUBLE;
        
       DECLARE dX_Min,   dX_Max,   dX_Mid   DOUBLE;
       DECLARE dY_Min,   dY_Max,   dY_Mid   DOUBLE;
       DECLARE dZ_Min,   dZ_Max,   dZ_Mid   DOUBLE;
                 
       DECLARE dX,       dY,       dZ       DOUBLE;

       DECLARE dX_Bound, dY_Bound, dZ_Bound DOUBLE;

        CREATE TEMPORARY TABLE Node
               (
                  dLatitude  DOUBLE NOT NULL,
                  dLongitude DOUBLE NOT NULL,
               
                  dX         DOUBLE,
                  dY         DOUBLE,
                  dZ         DOUBLE,
               
                  dX_        DOUBLE,
                  dY_        DOUBLE,
                  dZ_        DOUBLE
               );
        
SET bSafe = @@SQL_SAFE_UPDATES;  -- this is necessary to prevent error 1175 in the UPDATE Node statement
SET SQL_SAFE_UPDATES = 0;        -- this is necessary to prevent error 1175 in the UPDATE Node statement

            -- Add all boundary nodes into the Node table, and convert to cartesian coordinates (relative to the surface)

        INSERT INTO Node
               ( dLatitude, dLongitude, dX, dY, dZ )
        SELECT dLatitude, 
               dLongitude,
               dRad * COS(RADIANS(dLatitude)) * SIN(RADIANS(dLongitude)),
               dRad * SIN(RADIANS(dLatitude)),
               dRad * COS(RADIANS(dLatitude)) * COS(RADIANS(dLongitude))
          FROM _Node;

            -- Choose an origin based on the middle of the latitude and longitude (will need to be corrected in a second round)

        SELECT MIN(dLatitude), MAX(dLatitude)
          INTO dLat_Min,       dLat_Max
          FROM Node;
        
        SELECT MIN(dLongitude), MAX(dLongitude)
          INTO dLon_Min,        dLon_Max
          FROM Node;
        
            SET dLat_Mid = (dLat_Min + dLat_Max) / 2;
        
         -- IF (dLon_Min = -180  AND  dLon_Max = 180)
            IF (dLon_Max - dLon_Min > 270)
          THEN
                 SELECT MIN(dLongitude) 
                   INTO dLon_Min
                   FROM Node
                  WHERE dLongitude >= 0;
                 
                 SELECT MAX(dLongitude)
                   INTO dLon_Max
                   FROM Node
                  WHERE dLongitude < 0;
        
                    SET dLon_Mid = (dLon_Min + dLon_Max + 360) / 2;
        
                     IF dLon_Mid > 180
                   THEN
                             SET dLon_Mid = dLon_Mid - 360;
                 END IF ;
          ELSE
                    SET dLon_Mid = (dLon_Min + dLon_Max) / 2;
        END IF ;
        
-- SELECT 0, dLat_Mid AS dLat_Mid, dLon_Mid AS dLon_Mid

         WHILE bDone = 0  AND  bIter < 10
            DO
                     -- Delete any past attempts

                 DELETE FROM RMTMatrix     WHERE bnMatrix      IN (twRMTObjectIx, twRMTObjectIx_);
                 DELETE FROM RMTSubsurface WHERE twRMTObjectIx IN (twRMTObjectIx);
        
                     -- Compute the subsurface matrix for the origin of the relation

                   CALL call_RMTMatrix_Geo (twRMTObjectIx, dLat_Mid, dLon_Mid, dRad, nResult);
                
                     -- Convert all of the nodes from surface relative to local relative

                 UPDATE Node      AS n
                   JOIN RMTMatrix AS m ON m.bnMatrix = twRMTObjectIx_
                    SET n.dX_ = (m.d00 * n.dX) + (m.d01 * n.dY) + (m.d02 * n.dZ) + (m.d03 * 1),
                        n.dY_ = (m.d10 * n.dX) + (m.d11 * n.dY) + (m.d12 * n.dZ) + (m.d13 * 1),
                        n.dZ_ = (m.d20 * n.dX) + (m.d21 * n.dY) + (m.d22 * n.dZ) + (m.d23 * 1);

                     -- Compute the bounding box values

                 SELECT MIN(dX_), MAX(dX_), MIN(dY_), MAX(dY_), MIN(dZ_), MAX(dZ_)  -- MAX(_dY) should be 0
                   INTO dX_Min,   dX_Max,   dY_Min,   dY_Max,   dZ_Min,   dZ_Max
                   FROM Node;
                 
                    SET dX_Mid = (dX_Min + dX_Max) / 2,
                     -- dY_Mid = (dY_Min + dX_Max) / 2,
                        dZ_Mid = (dZ_Min + dZ_Max) / 2;

-- SELECT 1, bIter, dX_Mid AS dX_Mid, dZ_Mid AS dZ_Mid
                  
                     IF dY_Min < 0 - dRad
                   THEN
                             SET dY_Min = dY_Min;
                 END IF ;

                     -- Check to see if the origin is close to the middle of the bounding box

                     IF ABS(dX_Mid) > 0.000001  OR  ABS(dZ_Mid) > 0.000001
                   THEN
                         -- Convert the midpoint back to a surface relative coordinate

                             SET dX_Mid = dX_Mid * 0.97,
                                 dZ_Mid = dZ_Mid * 0.97;

                             SET dY_Mid = 0;

-- SELECT 2, dX_Mid AS dX_Mid, dZ_Mid AS dZ_Mid, dY_Mid AS dY_Mid
                  
                          SELECT (m.d00 * dX_Mid) + (m.d01 * dY_Mid) + (m.d02 * dZ_Mid) + (m.d03 * 1),
                                 (m.d10 * dX_Mid) + (m.d11 * dY_Mid) + (m.d12 * dZ_Mid) + (m.d13 * 1),
                                 (m.d20 * dX_Mid) + (m.d21 * dY_Mid) + (m.d22 * dZ_Mid) + (m.d23 * 1)
                            INTO dX, dY, dZ
                            FROM RMTMatrix AS m
                           WHERE m.bnMatrix = twRMTObjectIx;

-- SELECT 3, dX AS dX, dZ AS dZ, dY AS dY

                             SET dY = SQRT((dRad * dRad) - (dX * dX) - (dZ * dZ)) * (CASE WHEN dY < 0 THEN -1 ELSE 1 END);
                  
-- SELECT 4, dX AS dX, dZ AS dZ, dY AS dY

                              -- Convert the midpoint back to latitude and longitude

                             SET dLat_Mid = DEGREES(ASIN(dY / dRad)),
                                 dLon_Mid = DEGREES(ATAN2(dX, dZ));

-- SELECT 5, dLat_Mid AS dLat_Mid, dLon_Mid AS dLon_Mid

                             SET bIter = bIter + 1;
                   ELSE
                             SET bDone = 1;
                 END IF ;
     END WHILE ;

            -- Calculate the bounding box dimensions

           SET dX = (dX_Max - dX_Min) / 2,
               dZ = (dZ_Max - dZ_Min) / 2;

           SET dX_Bound = dX * (dRad + dHeight) / dRad,
               dZ_Bound = dZ * (dRad + dHeight) / dRad;

           SET dY = IF (dX > dZ, dX, dZ);

           SET dY = dY * (dRad - dDepth) / dRad;

           SET dY = SQRT(((dRad - dDepth) * (dRad - dDepth)) - (dY * dY));

           SET dY_Bound = dRad + dHeight - dY;

-- SELECT 6, dX AS dX, dY AS dY, dZ AS dZ, dX_Bound AS dX_Bound, dY_Bound AS dY_Bound, dZ_Bound AS dZ_Bound

            -- Now that we have the coordinates of the origin, we need to call call_RMTMatrix_Geo one last time

        DELETE FROM RMTMatrix     WHERE bnMatrix      IN (twRMTObjectIx, twRMTObjectIx_);
        DELETE FROM RMTSubsurface WHERE twRMTObjectIx IN (twRMTObjectIx);
        
            -- Note that dY sits at the bottom of the bounding box and acts as the effective radius
            -- All nodes should be above dY (positive) after this call

/*
        INSERT RMTObject
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
             ( SBO_CLASS_RMTOBJECT, twRMTParentIx, 
               SBO_CLASS_RMTOBJECT, -- twRMTObjectIx, 
               0, 32, 
               '', 
               0, 0, 0,
               1,
               0, '', '', 
               0, 0, 0, 
               0, 0, 0, 1, 
               1, 1, 1, 
               0, 0, 0, 
               dX_Bound * 2, dY_Bound, dZ_Bound * 2, 
               0, 0, 0, 0
             );

           SET twRMTObjectIx = SCOPE_IDENTITY ();

          CALL call_RMTMatrix_Geo (twRMTObjectIx, dLat_Mid, dLon_Mid, dY);

          CALL call_RMTMatrix_Relative (SBO_CLASS_RMTOBJECT, twRMTParentIx, twRMTObjectIx);
*/
        SELECT dLat_Mid     AS dLatitude, 
               dLon_Mid     AS dLongitude,
               dY           AS dRadius, 
               dX_Bound * 2 AS Bound_dX, 
               dY_Bound     AS Bound_dY, 
               dZ_Bound * 2 AS Bound_dZ;

SET SQL_SAFE_UPDATES = bSafe;    -- this is necessary to prevent error 1175 in the UPDATE Node statement

          DROP TEMPORARY TABLE Node;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
