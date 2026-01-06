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

DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Delete_Descendants
GO

CREATE PROCEDURE dbo.call_RMTObject_Delete_Descendants
(
   @twRMTObjectIx                BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

       DECLARE @nCount    INT,
               @bError    INT

            IF @twRMTObjectIx IS NULL
         BEGIN
                ; WITH Tree AS
                       (
                         SELECT oa.ObjectHead_Self_twObjectIx
                           FROM #CObject      AS p
                           JOIN dbo.RMTObject AS oa ON oa.ObjectHead_Parent_wClass     = @SBO_CLASS_RMCOBJECT
                                                   AND oa.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
                                
                          UNION ALL
               
                         SELECT ob.ObjectHead_Self_twObjectIx
                           FROM Tree          AS t
                           JOIN dbo.RMTObject AS ob ON ob.ObjectHead_Parent_wClass     = @SBO_CLASS_RMTOBJECT
                                                   AND ob.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                       )
                INSERT #TObject
                     ( ObjectHead_Self_twObjectIx )
                SELECT ObjectHead_Self_twObjectIx
                  FROM Tree

                   SET @bError = @@ERROR

                   SET @nCount = 0
           END
          ELSE
         BEGIN
                ; WITH Tree AS
                       (
                         SELECT oa.ObjectHead_Self_twObjectIx
                           FROM dbo.RMTObject AS oa
                          WHERE oa.ObjectHead_Self_wClass     = @SBO_CLASS_RMTOBJECT
                            AND oa.ObjectHead_Self_twObjectIx = @twRMTObjectIx
                                
                          UNION ALL
               
                         SELECT ob.ObjectHead_Self_twObjectIx
                           FROM Tree          AS t
                           JOIN dbo.RMTObject AS ob ON ob.ObjectHead_Parent_wClass     = @SBO_CLASS_RMTOBJECT
                                                   AND ob.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                       )
                INSERT #TObject
                     ( ObjectHead_Self_twObjectIx )
                SELECT ObjectHead_Self_twObjectIx
                  FROM Tree

                   SET @bError = @@ERROR

                   SET @nCount = 1
           END

            IF @bError = 0
         BEGIN
                 DELETE o
                   FROM #TObject      AS p
                   JOIN dbo.RMTMatrix AS m ON m.bnMatrix =     p.ObjectHead_Self_twObjectIx
                                           OR m.bnMatrix = 0 - p.ObjectHead_Self_twObjectIx
         
                    SET @bError = IIF (@@ROWCOUNT >= @nCount, @@ERROR, 1)
         
                     IF @bError = 0
                  BEGIN
                          DELETE o
                            FROM #TObject          AS p
                            JOIN dbo.RMTSubsurface AS s ON s.twRMTObjectIx = p.ObjectHead_Self_twObjectIx
         
                             SET @bError = IIF (@@ROWCOUNT >= @nCount, @@ERROR, 1)
         
                              IF @bError = 0
                           BEGIN
                                   DELETE o
                                     FROM #TObject      AS p
                                     JOIN dbo.RMTObject AS o ON o.ObjectHead_Self_twObjectIx = p.ObjectHead_Self_twObjectIx
         
                                      SET @bError = IIF (@@ROWCOUNT >= @nCount, @@ERROR, 1)
                             END
                    END
           END

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
