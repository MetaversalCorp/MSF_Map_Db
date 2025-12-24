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

CREATE PROCEDURE dbo.get_RMPObject
(
   @sIPAddress                   NVARCHAR (16),
   @twRMPObjectIx                BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @bError  INT = 0,
               @bCommit INT = 0,
               @nError  INT

            -- Create the temp Results table
        SELECT * INTO #Results FROM dbo.Table_Results ()

         BEGIN TRANSACTION

--        EXEC @nError = dbo.call_
           SET @nError = 0
            IF @nError = 0
         BEGIN
                  -- validate input

               DECLARE @bType TINYINT

               SELECT @bType = Type_bType
                 FROM dbo.RMPObject
                WHERE ObjectHead_Self_twObjectIx = @twRMPObjectIx

                   IF @bType IS NULL
                      SET @bError = 1

                  IF (@bError = 0)
               BEGIN
                     INSERT #Results
                     SELECT 0,
                            ObjectHead_Self_twObjectIx
                       FROM dbo.RMPObject
                      WHERE ObjectHead_Self_twObjectIx = @twRMPObjectIx

                     INSERT #Results
                     SELECT 1,
                            ObjectHead_Self_twObjectIx
                       FROM dbo.RMPObject
                      WHERE ObjectHead_Parent_wClass     = @SBO_CLASS_RMPOBJECT
                        AND ObjectHead_Parent_twObjectIx = @twRMPObjectIx

                      EXEC dbo.call_RMPObject_Select 0
                      EXEC dbo.call_RMPObject_Select 1

                       SET @bCommit = 1
                 END
           END

            IF (@bCommit = 0)
         BEGIN
                 SELECT dwError, sError FROM #Error

               ROLLBACK TRANSACTION
           END
          ELSE COMMIT TRANSACTION

        RETURN @bCommit - @bError - 1
  END
GO

GRANT EXECUTE ON dbo.get_RMPObject TO WebService
GO

/******************************************************************************************************************************/
