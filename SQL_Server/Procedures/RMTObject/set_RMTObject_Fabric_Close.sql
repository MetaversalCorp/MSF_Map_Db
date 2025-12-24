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

CREATE PROCEDURE dbo.set_RMTObject_Fabric_Close
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
-- @twRMTObjectIx                BIGINT,
   @twRMPObjectIx_Close          BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
        -- SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73
       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11
       DECLARE @RMTOBJECT_OP_RMTOBJECT_CLOSE              INT = 15

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0,
               @bError  INT

       DECLARE @ObjectHead_Grand_wClass      SMALLINT,
               @ObjectHead_Grand_twObjectIx  BIGINT,
               @ObjectHead_Parent_wClass     SMALLINT,
               @ObjectHead_Parent_twObjectIx BIGINT,
               @ObjectHead_Self_wClass       SMALLINT,
               @ObjectHead_Self_twObjectIx   BIGINT,
               @Type_bType                   TINYINT,
               @Type_bSubtype                TINYINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

        SELECT @ObjectHead_Grand_wClass      = t.ObjectHead_Parent_wClass,
               @ObjectHead_Grand_twObjectIx  = t.ObjectHead_Parent_twObjectIx,
               @ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass,
               @ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx,
               @Type_bType                   = t.Type_bType,
               @ObjectHead_Self_wClass       = p.ObjectHead_Self_wClass,
               @ObjectHead_Self_twObjectIx   = p.ObjectHead_Self_twObjectIx,
               @Type_bSubtype                = p.Type_bSubtype
          FROM dbo.RMPObject AS p
          JOIN dbo.RMTObject AS t  ON t.ObjectHead_Self_wClass     = p.ObjectHead_Parent_wClass
                                  AND t.ObjectHead_Self_twObjectIx = p.ObjectHead_Parent_twObjectIx
         WHERE p.ObjectHead_Self_wClass     = @SBO_CLASS_RMPOBJECT
           AND p.ObjectHead_Self_twObjectIx = @twRMPObjectIx_Close

            IF @ObjectHead_Grand_wClass IS NULL
               EXEC dbo.call_Error 1, 'Unknown Object', @nError OUTPUT
       ELSE IF @ObjectHead_Grand_wClass <> @SBO_CLASS_RMTOBJECT  OR  @ObjectHead_Parent_wClass <> @SBO_CLASS_RMTOBJECT  OR  @Type_bType <> @MVO_RMTOBJECT_TYPE_PARCEL
               EXEC dbo.call_Error 2, 'Invalid Object', @nError OUTPUT
       ELSE IF @Type_bSubtype <> 255
               EXEC dbo.call_Error 3, 'Invalid Object', @nError OUTPUT

      -- EXEC dbo.call_RMTObject_Validate @twRPersonaIx, @twRMTObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Event_RMPObject_Close @ObjectHead_Parent_twObjectIx, @twRMPObjectIx_Close, 0
                     IF @bError = 0
                  BEGIN
                            EXEC @bError = dbo.call_RMTObject_Event_RMTObject_Close @ObjectHead_Grand_twObjectIx, @ObjectHead_Parent_twObjectIx
                              IF @bError = 0
                           BEGIN
                                      SET @bCommit = 1
                             END
                            ELSE EXEC dbo.call_Error -1, 'Failed to delete RMTObject'
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to delete RMPObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMTObject_Log @RMTOBJECT_OP_RMTOBJECT_CLOSE, @sIPAddress, @twRPersonaIx, @ObjectHead_Grand_twObjectIx
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

GRANT EXECUTE ON dbo.set_RMTObject_Fabric_Close TO WebService
GO

/******************************************************************************************************************************/
