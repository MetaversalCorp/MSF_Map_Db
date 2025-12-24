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

CREATE PROCEDURE dbo.call_RMTObject_Parent_Geo
(
   @twRMTObjectIx_Root           BIGINT,
   @bType_Min                    TINYINT,         -- least acceptable type for a parent subsurface (typically 6 = STATE)
   @dLatitude                    FLOAT (53),
   @dLongitude                   FLOAT (53),
   @dRadius                      FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @dLat       FLOAT (53) = RADIANS (@dLatitude),
               @dLon       FLOAT (53) = RADIANS (@dLongitude)
      
       DECLARE @dX         FLOAT (53) = @dRadius * COS (@dLat) * SIN (@dLon),
               @dY         FLOAT (53) = @dRadius * SIN (@dLat),
               @dZ         FLOAT (53) = @dRadius * COS (@dLat) * COS (@dLon)
      
       DECLARE @nCount        INT,
               @bType         TINYINT,
               @bSubtype      TINYINT,
               @twRMTObjectIx BIGINT = 0
      
-- SELECT @dX, @dY, @dZ
      
       DECLARE @Match TABLE
               (
                  nStep         INT,
                  twRMTObjectIx BIGINT
               )
      
       DECLARE @Child TABLE
               (
                  twRMTObjectIx BIGINT,
                  dX            FLOAT (53),
                  dY            FLOAT (53),
                  dZ            FLOAT (53)
               )
      
       DECLARE @Bound TABLE
               (
                  twRMTObjectIx BIGINT,
                  dX            FLOAT (53),
                  dY            FLOAT (53),
                  dZ            FLOAT (53)
               )
      
        INSERT @Match
             ( nStep,  twRMTObjectIx      )
        SELECT 0,     @twRMTObjectIx_Root
      
           SET @nCount = @@ROWCOUNT
      
         WHILE @nCount > 0
         BEGIN
                 DELETE @Child
      
                 INSERT @Child
                      ( twRMTObjectIx, dX, dY, dZ )
                 SELECT o.ObjectHead_Self_twObjectIx, o.Bound_dX / 2, o.Bound_dY, o.Bound_dZ / 2
                   FROM @Match        AS m
                   JOIN dbo.RMTObject AS o  ON m.nStep                        = 0
                                           AND o.ObjectHead_Parent_wClass     = 72
                                           AND o.ObjectHead_Parent_twObjectIx = m.twRMTObjectIx
                                           AND o.Type_bType                   < 11 -- PARCEL
      
                    SET @nCount = @@ROWCOUNT
      
                 DELETE @Bound
      
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx,  dX,   0,  dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx,  dX,   0, -dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx, -dX,   0,  dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx, -dX,   0, -dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx,  dX,  dY,  dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx,  dX,  dY, -dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx, -dX,  dY,  dZ FROM @Child
                 INSERT @Bound (twRMTObjectIx, dX, dY, dZ) SELECT twRMTObjectIx, -dX,  dY, -dZ FROM @Child
      
                 UPDATE b
                    SET b.dX = (m.d00 * b.dX) + (m.d01 * b.dY) + (m.d02 * b.dZ) + (m.d03 * 1),
                        b.dY = (m.d10 * b.dX) + (m.d11 * b.dY) + (m.d12 * b.dZ) + (m.d13 * 1),
                        b.dZ = (m.d20 * b.dX) + (m.d21 * b.dY) + (m.d22 * b.dZ) + (m.d23 * 1)
                   FROM @Bound        AS b
                   JOIN dbo.RMTMatrix AS m ON m.bnMatrix = b.twRMTObjectIx
      
                 UPDATE @Match
                    SET nStep = 1
      
                 INSERT @Match
                      ( nStep, twRMTObjectIx)
                 SELECT 0,     twRMTObjectIx
                   FROM
                      (
                          SELECT twRMTObjectIx, MIN (dX) AS dX_Min, MAX (dX) AS dX_Max, MIN (dY) AS dY_Min, MAX (dY) AS dY_Max, MIN (dZ) AS dZ_Min, MAX (dZ) AS dZ_Max
                            FROM @Bound
                        GROUP BY twRMTObjectIx
                      ) AS b
                  WHERE @dX BETWEEN b.dX_Min AND b.dX_Max
                    AND @dY BETWEEN b.dY_Min AND b.dY_Max
                    AND @dZ BETWEEN b.dZ_Min AND b.dZ_Max
      
/*
SELECT COUNT (*) FROM @Match
      
SELECT * 
  FROM @Match        AS m
  JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = m.twRMTObjectIx
*/
           END
      
/*
SELECT * 
  FROM @Match        AS m
  JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = m.twRMTObjectIx
*/
      
        SELECT @bType    = MAX (o.Type_bType)
          FROM @Match        AS m
          JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = m.twRMTObjectIx
        
        SELECT @bSubtype = MAX (o.Type_bSubtype)
          FROM @Match        AS m
          JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = m.twRMTObjectIx AND o.Type_bType = @bType
      
/*
SELECT *
  FROM @Match        AS m
  JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = m.twRMTObjectIx AND o.Type_bType = @bType AND o.Type_bSubtype = @bSubtype
*/
      
            IF @bType >= @bType_Min
        SELECT @twRMTObjectIx = twRMTObjectIx
          FROM
             (
                 SELECT TOP 1
                        twRMTObjectIx, ((@dX - dX) * (@dX - dX)) + ((@dY - dY) * (@dY - dY)) + ((@dZ - dZ) * (@dZ - dZ)) AS dDistance_2
                   FROM
                      (
                          SELECT m.twRMTObjectIx,
                                 x.d03           AS dX,
                                 x.d13           AS dY,
                                 x.d23           AS dZ
                            FROM @Match        AS m
                            JOIN dbo.RMTMatrix AS x ON x.bnMatrix                   = m.twRMTObjectIx
                            JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = m.twRMTObjectIx
                                                   AND o.Type_bType                 = @bType
                                                   AND o.Type_bSubtype              = @bSubtype
                      ) AS a
               ORDER BY 2
             ) AS b
      
        RETURN @twRMTObjectIx
  END
GO

/******************************************************************************************************************************/
