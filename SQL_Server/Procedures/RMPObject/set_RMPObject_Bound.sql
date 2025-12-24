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

CREATE PROCEDURE dbo.set_RMPObject_Bound
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMPObjectIx                BIGINT,
   @Bound_dX                     FLOAT (53),
   @Bound_dY                     FLOAT (53),
   @Bound_dZ                     FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMPObjectIx = ISNULL (@twRMPObjectIx, 0)

       DECLARE @RMPOBJECT_OP_BOUND                        INT = 8

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

          EXEC dbo.call_RMPObject_Validate @twRPersonaIx, @twRMPObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC dbo.call_RMPObject_Validate_Bound @ObjectHead_Parent_wClass, @ObjectHead_Parent_twObjectIx, @twRMPObjectIx, @Bound_dX, @Bound_dY, @Bound_dZ, @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMPObject_Event_Bound @twRMPObjectIx, @Bound_dX, @Bound_dY, @Bound_dZ
                     IF @bError = 0
                  BEGIN
                        SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to update RMPObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMPObject_Log @RMPOBJECT_OP_BOUND, @sIPAddress, @twRPersonaIx, @twRMPObjectIx
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

GRANT EXECUTE ON dbo.set_RMPObject_Bound TO WebService
GO

/******************************************************************************************************************************/
