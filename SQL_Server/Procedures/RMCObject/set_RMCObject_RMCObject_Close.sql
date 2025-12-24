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

CREATE PROCEDURE dbo.set_RMCObject_RMCObject_Close
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMCObjectIx                BIGINT,
   @twRMCObjectIx_Close          BIGINT,
   @bDeleteAll                   TINYINT
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx        = ISNULL (@twRPersonaIx,        0)
           SET @twRMCObjectIx       = ISNULL (@twRMCObjectIx,       0)
           SET @twRMCObjectIx_Close = ISNULL (@twRMCObjectIx_Close, 0)

       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @RMCOBJECT_OP_RMCOBJECT_CLOSE              INT = 12

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0,
               @bError  INT

       DECLARE @ObjectHead_Parent_wClass     SMALLINT,
               @ObjectHead_Parent_twObjectIx BIGINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

          EXEC dbo.call_RMCObject_Validate @twRPersonaIx, @twRMCObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                DECLARE @nCount INT

                 SELECT @nCount = COUNT (*)
                   FROM dbo.RMCObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = @SBO_CLASS_RMCOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = @twRMCObjectIx_Close

                 SELECT @nCount += COUNT (*)
                   FROM dbo.RMTObject AS o
                  WHERE o.ObjectHead_Parent_wClass     = @SBO_CLASS_RMCOBJECT
                    AND o.ObjectHead_Parent_twObjectIx = @twRMCObjectIx_Close

                     IF @twRMCObjectIx_Close <= 0
                        EXEC dbo.call_Error 5,  'twRMCObjectIx_Close is invalid',   @nError OUTPUT
                ELSE IF @bDeleteAll = 0  AND  @nCount > 0
                        EXEC dbo.call_Error 6,  'twRMCObjectIx_Close is not empty', @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMCObject_Event_RMCObject_Close @twRMCObjectIx, @twRMCObjectIx_Close
                     IF @bError = 0
                  BEGIN
                        SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to delete RMCObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMCObject_Log @RMCOBJECT_OP_RMCOBJECT_CLOSE, @sIPAddress, @twRPersonaIx, @twRMCObjectIx
                     IF @bError = 0
                  BEGIN
                         EXEC @bError = dbo.call_Event_Push
                           IF @bError = 0
                        BEGIN
                              SET @bCommit = 1
                          END
                         ELSE EXEC dbo.call_Error -9, 'Failed to push events'
                    END
                   ELSE EXEC dbo.call_Error -8, 'Failed to log action'
           END
       
            IF @bCommit = 0
         BEGIN
                 SELECT dwError, sError FROM #Error

               ROLLBACK TRANSACTION
           END
          ELSE COMMIT TRANSACTION

        RETURN @bCommit - 1 - @nError
  END
GO

GRANT EXECUTE ON dbo.set_RMCObject_RMCObject_Close TO WebService
GO

/******************************************************************************************************************************/
