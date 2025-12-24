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

CREATE PROCEDURE dbo.search_RMTObject
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMTObjectIx                BIGINT,
   @dX                           FLOAT (53),
   @dY                           FLOAT (53),
   @dZ                           FLOAT (53),
   @sText                        NVARCHAR (48)
)
AS
BEGIN
            SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @MVO_RMTOBJECT_TYPE_COMMUNITY              INT = 9
       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @bError  INT = 0,
               @bCommit INT = 0,
               @nError  INT

        DECLARE @bType   TINYINT,
                @dRange  FLOAT (53),
                @nCount  INT = 0

         SELECT @bType = Type_bType
           FROM dbo.RMTObject
          WHERE ObjectHead_Self_twObjectIx = @twRMTObjectIx

             IF @bType IS NULL
                SET @bError = 1

             IF @bError = 0
          BEGIN
                  SET @sText = RTRIM (LTRIM (ISNULL (@sText, '')))

                   IF @sText <> ''
                BEGIN
                            -- positions must be normalized to the surface

                       DECLARE @dRadius FLOAT (53) = 6371000 -- where do we get this?
                       DECLARE @dNormal FLOAT (53) = @dRadius / SQRT ((@dX * @dX) + (@dY * @dY) + (@dZ * @dZ))

                           SET @dX *= @dNormal
                           SET @dY *= @dNormal
                           SET @dZ *= @dNormal

                       DECLARE @Result TABLE
                                       (
                                          nOrder                          INT         IDENTITY (0, 1),
                                          ObjectHead_Self_twObjectIx      BIGINT,
                                          dFactor                         FLOAT (53),
                                          dDistance                       FLOAT (53)
                                       )

                        INSERT @Result
                             (
                               ObjectHead_Self_twObjectIx, 
                               dFactor,
                               dDistance
                             )
                        SELECT TOP 10
                               o.ObjectHead_Self_twObjectIx, 
                               f.dFactor, 
                               d.dDistance
                          FROM dbo.RMTObject AS o
                          JOIN dbo.RMTMatrix AS m ON m.bnMatrix = o.ObjectHead_Self_twObjectIx
                   CROSS APPLY (SELECT POWER (CAST (4.0 AS FLOAT (53)), o.Type_bType - 7)                                                              AS dFactor    ) AS f
                   CROSS APPLY (SELECT dbo.ArcLength (@dRadius, @dX, @dY, @dZ, m.d03, m.d13, m.d23)                                                    AS dDistance  ) AS d
                   CROSS APPLY (SELECT dbo.Descendant_T (@SBO_CLASS_RMTOBJECT, @twRMTObjectIx, o.ObjectHead_Self_wClass, o.ObjectHead_Self_twObjectIx) AS bDescendant) AS i
                         WHERE o.Name_wsRMTObjectId LIKE @sText + '%'
                           AND    (o.Type_bType  BETWEEN @bType + 1 AND @MVO_RMTOBJECT_TYPE_COMMUNITY
                               OR  o.Type_bType        =                @MVO_RMTOBJECT_TYPE_PARCEL)
                           AND i.bDescendant           = 1
                      ORDER BY f.dFactor * d.dDistance, o.Name_wsRMTObjectId

                        SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,  -- change client to new names
                               o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,     -- change client to new names
                               o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,  -- change client to new names
                               o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,     -- change client to new names
                               o.ObjectHead_wFlags,
                               o.ObjectHead_twEventIz,
                               o.Name_wsRMTObjectId,
                               o.Type_bType,
                               o.Type_bSubtype,
                               o.Type_bFiction,
                               r.nOrder,
                               r.dFactor,
                               r.dDistance
                          FROM dbo.RMTObject AS o
                          JOIN @Result       AS r ON r.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                      ORDER BY r.nOrder

                            -- select also all of the ancestors of the result set

                        ; WITH Tree AS
                               (
                                 SELECT oa.ObjectHead_Parent_wClass,
                                        oa.ObjectHead_Parent_twObjectIx,
                                        oa.ObjectHead_Self_wClass,
                                        oa.ObjectHead_Self_twObjectIx,
                                        r.nOrder,
                                        0                               AS nAncestor
                                   FROM dbo.RMTObject AS oa
                                   JOIN @Result       AS r  ON r.ObjectHead_Self_twObjectIx = oa.ObjectHead_Self_twObjectIx
 
                                  UNION ALL
 
                                 SELECT ob.ObjectHead_Parent_wClass,
                                        ob.ObjectHead_Parent_twObjectIx,
                                        ob.ObjectHead_Self_wClass,
                                        ob.ObjectHead_Self_twObjectIx,
                                        x.nOrder,
                                        x.nAncestor + 1                 AS nAncestor
                                   FROM dbo.RMTObject AS ob
                                   JOIN Tree          AS x  ON x.ObjectHead_Parent_twObjectIx = ob.ObjectHead_Self_twObjectIx
                                                           AND x.ObjectHead_Parent_wClass     = ob.ObjectHead_Self_wClass
                               )
                        SELECT o.ObjectHead_Parent_wClass     AS ObjectHead_wClass_Parent,  -- change client to new names
                               o.ObjectHead_Parent_twObjectIx AS ObjectHead_twParentIx,     -- change client to new names
                               o.ObjectHead_Self_wClass       AS ObjectHead_wClass_Object,  -- change client to new names
                               o.ObjectHead_Self_twObjectIx   AS ObjectHead_twObjectIx,     -- change client to new names
                               o.ObjectHead_wFlags,
                               o.ObjectHead_twEventIz,
                               o.Name_wsRMTObjectId,
                               o.Type_bType,
                               o.Type_bSubtype,
                               o.Type_bFiction,
                               x.nOrder,
                               x.nAncestor
                          FROM dbo.RMTObject AS o
                          JOIN Tree          AS x ON x.ObjectHead_Self_twObjectIx = o.ObjectHead_Self_twObjectIx
                         WHERE x.nAncestor > 0
                      ORDER BY x.nOrder,
                               x.nAncestor

                  END
                 ELSE
                BEGIN
                        SELECT TOP 0 NULL AS Unused
                        SELECT TOP 0 NULL AS Unused
                  END

                  SET @bCommit = 1
            END
           ELSE EXEC dbo.call_Error 1, 'twRMTObjectIx is invalid'

             IF @bCommit = 0
                  SELECT dwError, sError FROM #Error

         RETURN @bCommit - @bError - 1
  END
GO

GRANT EXECUTE ON dbo.search_RMTObject TO WebService
GO

/******************************************************************************************************************************/
