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

CREATE PROCEDURE dbo.get_RMRoot_Update
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMRootIx                   BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0

            -- Create the temp Results table
        SELECT * INTO #Results FROM dbo.Table_Results ()

           SET @twRPersonaIx = ISNULL (@twRPersonaIx, 0)
           SET @twRMRootIx   = ISNULL (@twRMRootIx,   0)

            IF @twRPersonaIx < 0
               EXEC dbo.call_Error 1,  'Session is invalid', @nError OUTPUT

            IF @twRMRootIx <= 0
               EXEC dbo.call_Error 2,  'Root is invalid',    @nError OUTPUT

            IF @nError = 0
         BEGIN
                 INSERT #Results
                 SELECT 0,
                        r.ObjectHead_Self_twObjectIx
                   FROM dbo.RMRoot    AS r
                  WHERE r.ObjectHead_Self_twObjectIx = @twRMRootIx

                     IF @@ROWCOUNT = 1
                  BEGIN
                          INSERT #Results
                          SELECT 1,
                                 c.ObjectHead_Self_twObjectIx
                            FROM dbo.RMRoot    AS r
                            JOIN dbo.RMCObject AS c ON c.ObjectHead_Parent_wClass     = r.ObjectHead_Self_wClass
                                                   AND c.ObjectHead_Parent_twObjectIx = r.ObjectHead_Self_twObjectIx
                           WHERE r.ObjectHead_Self_twObjectIx = @twRMRootIx
                        ORDER BY c.ObjectHead_Self_twObjectIx ASC
          
                          INSERT #Results
                          SELECT 2,
                                 t.ObjectHead_Self_twObjectIx
                            FROM dbo.RMRoot    AS r
                            JOIN dbo.RMTObject AS t ON t.ObjectHead_Parent_wClass     = r.ObjectHead_Self_wClass
                                                   AND t.ObjectHead_Parent_twObjectIx = r.ObjectHead_Self_twObjectIx
                           WHERE r.ObjectHead_Self_twObjectIx = @twRMRootIx
                        ORDER BY t.ObjectHead_Self_twObjectIx ASC
          
                          INSERT #Results
                          SELECT 3,
                                 p.ObjectHead_Self_twObjectIx
                            FROM dbo.RMRoot    AS r
                            JOIN dbo.RMPObject AS p ON p.ObjectHead_Parent_wClass     = r.ObjectHead_Self_wClass
                                                   AND p.ObjectHead_Parent_twObjectIx = r.ObjectHead_Self_twObjectIx
                           WHERE r.ObjectHead_Self_twObjectIx = @twRMRootIx
                        ORDER BY p.ObjectHead_Self_twObjectIx ASC
          
                            EXEC dbo.call_RMRoot_Select    0
                            EXEC dbo.call_RMCObject_Select 1
                            EXEC dbo.call_RMTObject_Select 2
                            EXEC dbo.call_RMPObject_Select 3
          
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error 3,  'Root does not exist', @nError OUTPUT
           END

            IF @bCommit = 0
               SELECT dwError, sError FROM #Error

        RETURN @bCommit - 1 - @nError
  END
GO

GRANT EXECUTE ON dbo.get_RMRoot_Update TO WebService
GO

/******************************************************************************************************************************/
