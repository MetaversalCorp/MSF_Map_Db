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

CREATE PROCEDURE dbo.get_RMPObject_Update
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMPObjectIx                BIGINT
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

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMPObjectIx = ISNULL (@twRMPObjectIx, 0)

            IF @twRPersonaIx < 0
               EXEC dbo.call_Error 1,  'Session is invalid', @nError OUTPUT

            IF @twRMPObjectIx <= 0
               EXEC dbo.call_Error 2,  'PObject is invalid', @nError OUTPUT

            IF @nError = 0
         BEGIN
                 INSERT #Results
                 SELECT 0,
                        p.ObjectHead_Self_twObjectIx
                   FROM dbo.RMPObject AS p
                  WHERE p.ObjectHead_Self_twObjectIx = @twRMPObjectIx

                     IF @@ROWCOUNT = 1
                  BEGIN
                          INSERT #Results
                          SELECT 1,
                                 x.ObjectHead_Self_twObjectIx
                            FROM dbo.RMPObject AS p
                            JOIN dbo.RMPObject AS x ON x.ObjectHead_Parent_wClass     = p.ObjectHead_Self_wClass
                                                   AND x.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
                           WHERE p.ObjectHead_Self_twObjectIx = @twRMPObjectIx
                        ORDER BY x.ObjectHead_Self_twObjectIx ASC
             
                            EXEC dbo.call_RMPObject_Select 0
                            EXEC dbo.call_RMPObject_Select 1
             
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error 3,  'PObject does not exist', @nError OUTPUT
           END

            IF @bCommit = 0
               SELECT dwError, sError FROM #Error

        RETURN @bCommit - 1 - @nError
  END
GO

GRANT EXECUTE ON dbo.get_RMPObject_Update TO WebService
GO

/******************************************************************************************************************************/
