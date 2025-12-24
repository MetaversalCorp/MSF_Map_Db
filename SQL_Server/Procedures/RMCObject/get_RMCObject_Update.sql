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

CREATE PROCEDURE dbo.get_RMCObject_Update
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMCObjectIx                BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @MVO_RMCOBJECT_TYPE_SURFACE                INT = 17

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0

            -- Create the temp Results table
        SELECT * INTO #Results FROM dbo.Table_Results ()

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMCObjectIx = ISNULL (@twRMCObjectIx, 0)

            IF @twRPersonaIx < 0
               EXEC dbo.call_Error 1,  'Session is invalid', @nError OUTPUT

            IF @twRMCObjectIx <= 0
               EXEC dbo.call_Error 2,  'CObject is invalid', @nError OUTPUT

            IF @nError = 0
         BEGIN
                DECLARE @bType TINYINT

                 SELECT @bType = c.Type_bType
                   FROM dbo.RMCObject AS c
                  WHERE c.ObjectHead_Self_twObjectIx = @twRMCObjectIx

                 INSERT #Results
                 SELECT 0,
                        c.ObjectHead_Self_twObjectIx
                   FROM dbo.RMCObject AS c
                  WHERE c.ObjectHead_Self_twObjectIx = @twRMCObjectIx

                     IF @@ROWCOUNT = 1  AND  @bType IS NOT NULL
                  BEGIN
                              IF @bType <> @MVO_RMCOBJECT_TYPE_SURFACE
                           BEGIN
                                   INSERT #Results
                                   SELECT 1,
                                          x.ObjectHead_Self_twObjectIx
                                     FROM dbo.RMCObject AS c
                                     JOIN dbo.RMCObject AS x ON x.ObjectHead_Parent_wClass     = c.ObjectHead_Self_wClass
                                                            AND x.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
                                    WHERE c.ObjectHead_Self_twObjectIx = @twRMCObjectIx
                                 ORDER BY x.ObjectHead_Self_twObjectIx ASC
                             END
                            ELSE
                           BEGIN
                                   INSERT #Results
                                   SELECT 1,
                                          t.ObjectHead_Self_twObjectIx
                                     FROM dbo.RMCObject AS c
                                     JOIN dbo.RMTObject AS t ON t.ObjectHead_Parent_wClass     = c.ObjectHead_Self_wClass
                                                            AND t.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
                                    WHERE c.ObjectHead_Self_twObjectIx = @twRMCObjectIx
                                 ORDER BY t.ObjectHead_Self_twObjectIx ASC
                             END
             
                            EXEC dbo.call_RMCObject_Select 0
                              IF @bType <> @MVO_RMCOBJECT_TYPE_SURFACE
                                 EXEC dbo.call_RMCObject_Select 1
                            ELSE EXEC dbo.call_RMTObject_Select 1
             
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error 3,  'CObject does not exist', @nError OUTPUT
           END

            IF @bCommit = 0
               SELECT dwError, sError FROM #Error

        RETURN @bCommit - 1 - @nError
  END
GO

GRANT EXECUTE ON dbo.get_RMCObject_Update TO WebService
GO

/******************************************************************************************************************************/
