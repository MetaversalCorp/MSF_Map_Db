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

DROP PROCEDURE IF EXISTS dbo.set_RMTObject_Fabric_Configure
GO

CREATE PROCEDURE dbo.set_RMTObject_Fabric_Configure
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
-- @twRMTObjectIx                BIGINT,
   @twRMPObjectIx_Configure      BIGINT,
   @Name_wsRMTObjectId           NVARCHAR (48),
   @Type_bType                   TINYINT,
-- @Type_bSubtype                TINYINT,
-- @Type_bFiction                TINYINT,
   @Owner_twRPersonaIx           BIGINT,
   @Resource_qwResource          BIGINT,
   @Resource_sName               NVARCHAR (48),
   @Resource_sReference          NVARCHAR (128)
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
        -- SET @twRMTObjectIx = ISNULL (@twRMTObjectIx, 0)

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73
       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11
       DECLARE @RMTOBJECT_OP_FABRIC_CONFIGURE             INT = 20

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
               @Parent_Type_bType            TINYINT,
               @Self_Type_bSubtype           TINYINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

        SELECT @ObjectHead_Grand_wClass      = t.ObjectHead_Parent_wClass,
               @ObjectHead_Grand_twObjectIx  = t.ObjectHead_Parent_twObjectIx,
               @ObjectHead_Parent_wClass     = t.ObjectHead_Self_wClass,
               @ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx,
               @Parent_Type_bType            = t.Type_bType,
               @ObjectHead_Self_wClass       = p.ObjectHead_Self_wClass,
               @ObjectHead_Self_twObjectIx   = p.ObjectHead_Self_twObjectIx,
               @Self_Type_bSubtype           = p.Type_bSubtype
          FROM dbo.RMPObject AS p
          JOIN dbo.RMTObject AS t  ON t.ObjectHead_Self_wClass     = p.ObjectHead_Parent_wClass
                                  AND t.ObjectHead_Self_twObjectIx = p.ObjectHead_Parent_twObjectIx
         WHERE p.ObjectHead_Self_wClass     = @SBO_CLASS_RMPOBJECT
           AND p.ObjectHead_Self_twObjectIx = @twRMPObjectIx_Configure

            IF @ObjectHead_Grand_wClass IS NULL
               EXEC dbo.call_Error 1, 'Unknown Object', @nError OUTPUT
       ELSE IF @ObjectHead_Grand_wClass <> @SBO_CLASS_RMTOBJECT  OR  @ObjectHead_Parent_wClass <> @SBO_CLASS_RMTOBJECT  OR  @Parent_Type_bType <> @MVO_RMTOBJECT_TYPE_PARCEL
               EXEC dbo.call_Error 2, 'Invalid Object', @nError OUTPUT
       ELSE IF @Self_Type_bSubtype <> 255
               EXEC dbo.call_Error 3, 'Invalid Object', @nError OUTPUT

      -- EXEC dbo.call_RMTObject_Validate @twRPersonaIx, @twRMTObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC dbo.call_RMTObject_Validate_Name       @SBO_CLASS_RMTOBJECT, @ObjectHead_Parent_twObjectIx, 0, @Name_wsRMTObjectId, @nError OUTPUT
                -- EXEC dbo.call_RMPObject_Validate_Type       @SBO_CLASS_RMPOBJECT, @ObjectHead_Self_twObjectIx,   0, @Type_bType, @Type_bSubtype, @Type_bFiction, @nError OUTPUT
                   EXEC dbo.call_RMPObject_Validate_Owner      @SBO_CLASS_RMPOBJECT, @ObjectHead_Self_twObjectIx,   0, @Owner_twRPersonaIx, @nError OUTPUT
                   EXEC dbo.call_RMPObject_Validate_Resource   @SBO_CLASS_RMPOBJECT, @ObjectHead_Self_twObjectIx,   0, @Resource_qwResource, @Resource_sName, @Resource_sReference, @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Event_Name @ObjectHead_Parent_twObjectIx, @Name_wsRMTObjectId
                     IF @bError = 0
                  BEGIN
                            EXEC @bError = dbo.call_RMPObject_Event_Type @ObjectHead_Self_twObjectIx, @Type_bType, 255, 0, 0
                              IF @bError = 0
                           BEGIN
                                     EXEC @bError = dbo.call_RMPObject_Event_Owner @ObjectHead_Self_twObjectIx, @Owner_twRPersonaIx
                                       IF @bError = 0
                                    BEGIN
                                              EXEC @bError = dbo.call_RMPObject_Event_Resource @ObjectHead_Self_twObjectIx, @Resource_qwResource, @Resource_sName, @Resource_sReference
                                                IF @bError = 0
                                             BEGIN
                                                        SET @bCommit = 1
                                               END
                                              ELSE EXEC dbo.call_Error -4, 'Failed to update RMPObject'
                                      END
                                     ELSE EXEC dbo.call_Error -3, 'Failed to update RMPObject'
                             END
                            ELSE EXEC dbo.call_Error -2, 'Failed to update RMPObject'
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to update RMTObject'
           END

            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMTObject_Log @RMTOBJECT_OP_FABRIC_CONFIGURE, @sIPAddress, @twRPersonaIx, @ObjectHead_Grand_twObjectIx
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

GRANT EXECUTE ON dbo.set_RMTObject_Fabric_Configure TO WebService
GO

/******************************************************************************************************************************/
