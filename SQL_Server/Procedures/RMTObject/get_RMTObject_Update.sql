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

CREATE PROCEDURE dbo.get_RMTObject_Update
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMTObjectIx                BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0

            -- Create the temp Results table
        SELECT * INTO #Results FROM dbo.Table_Results ()

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

            IF @twRPersonaIx < 0
               EXEC dbo.call_Error 1,  'Session is invalid', @nError OUTPUT

            IF @twRMTObjectIx <= 0
               EXEC dbo.call_Error 2,  'TObject is invalid', @nError OUTPUT

            IF @nError = 0
         BEGIN
                DECLARE @bType TINYINT

                 SELECT @bType = t.Type_bType
                   FROM dbo.RMTObject AS t
                  WHERE t.ObjectHead_Self_twObjectIx = @twRMTObjectIx

                 INSERT #Results
                 SELECT 0,
                        t.ObjectHead_Self_twObjectIx
                   FROM dbo.RMTObject AS t
                  WHERE t.ObjectHead_Self_twObjectIx = @twRMTObjectIx

                     IF @@ROWCOUNT = 1  AND  @bType IS NOT NULL
                  BEGIN
                              IF @bType <> @MVO_RMTOBJECT_TYPE_PARCEL
                           BEGIN
                                   INSERT #Results
                                   SELECT 1,
                                          x.ObjectHead_Self_twObjectIx
                                     FROM dbo.RMTObject AS t
                                     JOIN dbo.RMTObject AS x ON x.ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass
                                                            AND x.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                                    WHERE t.ObjectHead_Self_twObjectIx = @twRMTObjectIx
                                 ORDER BY x.ObjectHead_Self_twObjectIx ASC
                             END
                            ELSE
                           BEGIN
                                   INSERT #Results
                                   SELECT 1,
                                          p.ObjectHead_Self_twObjectIx
                                     FROM dbo.RMTObject AS t
                                     JOIN dbo.RMPObject AS p ON p.ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass
                                                            AND p.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
                                    WHERE t.ObjectHead_Self_twObjectIx = @twRMTObjectIx
                                 ORDER BY p.ObjectHead_Self_twObjectIx ASC
                             END
             
                            EXEC dbo.call_RMTObject_Select 0
                              IF @bType <> @MVO_RMTOBJECT_TYPE_PARCEL
                                 EXEC dbo.call_RMTObject_Select 1
                            ELSE EXEC dbo.call_RMPObject_Select 1
             
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error 3,  'TObject does not exist', @nError OUTPUT
           END

            IF @bCommit = 0
               SELECT dwError, sError FROM #Error

        RETURN @bCommit - 1 - @nError
  END
GO

GRANT EXECUTE ON dbo.get_RMTObject_Update TO WebService
GO

/******************************************************************************************************************************/
