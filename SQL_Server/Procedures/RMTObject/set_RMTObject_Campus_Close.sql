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

DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Campus_Close
GO

CREATE PROCEDURE dbo.set_RMTObject_Campus_Close
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
-- @twRMTObjectIx                BIGINT,
   @twRMTObjectIx_Close          BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
        -- SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11
       DECLARE @RMTOBJECT_OP_CAMPUS_CLOSE                 INT = 22

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0,
               @bError  INT

       DECLARE @ObjectHead_Parent_wClass     SMALLINT,
               @ObjectHead_Parent_twObjectIx BIGINT,
               @Self_Type_bSubtype           TINYINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

        SELECT @ObjectHead_Parent_wClass     = t.ObjectHead_Parent_wClass,
               @ObjectHead_Parent_twObjectIx = t.ObjectHead_Parent_twObjectIx,
               @Self_Type_bSubtype           = t.Type_bSubtype
          FROM dbo.RMTObject AS t
         WHERE t.ObjectHead_Self_wClass     = @SBO_CLASS_RMTOBJECT
           AND t.ObjectHead_Self_twObjectIx = @twRMTObjectIx_Close

            IF @ObjectHead_Parent_wClass IS NULL
               EXEC dbo.call_Error 1, 'Unknown Object', @nError OUTPUT
       ELSE IF @ObjectHead_Parent_wClass <> @SBO_CLASS_RMTOBJECT
               EXEC dbo.call_Error 2, 'Invalid Object', @nError OUTPUT
       ELSE IF @Self_Type_bSubtype <> 255
               EXEC dbo.call_Error 3, 'Invalid Object', @nError OUTPUT

      -- EXEC dbo.call_RMTObject_Validate @twRPersonaIx, @twRMTObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Event_RMTObject_Close @ObjectHead_Parent_twObjectIx, @twRMTObjectIx_Close
                     IF @bError = 0
                  BEGIN
                             SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to delete RMTObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMTObject_Log @RMTOBJECT_OP_CAMPUS_CLOSE, @sIPAddress, @twRPersonaIx, @ObjectHead_Parent_twObjectIx
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

GRANT EXECUTE ON dbo.set_RMTObject_Campus_Close TO WebService
GO

/******************************************************************************************************************************/
