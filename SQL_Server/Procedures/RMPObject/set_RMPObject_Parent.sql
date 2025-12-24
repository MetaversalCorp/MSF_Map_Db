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

-- Note that this is not a function of the RMPObject itself, but rather a function of the two parents involved.

CREATE PROCEDURE dbo.set_RMPObject_Parent
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMPObjectIx                BIGINT,
   @wClass                       SMALLINT,
   @twObjectIx                   BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMPObjectIx = ISNULL (@twRMPObjectIx, 0)

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73
       DECLARE @RMPOBJECT_OP_PARENT                       INT = 18

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0,
               @bError  INT

       DECLARE @ObjectHead_Parent_wClass     SMALLINT,
               @ObjectHead_Parent_twObjectIx BIGINT,
               @nCount                       INT

       DECLARE @Name_wsRMPObjectId           NVARCHAR (48),
               @Type_bType                   TINYINT,
               @Type_bSubtype                TINYINT,
               @Type_bFiction                TINYINT,
               @Type_bMovable                TINYINT,
               @Owner_twRPersonaIx           BIGINT,
               @Resource_qwResource          BIGINT,
               @Resource_sName               NVARCHAR (48),
               @Resource_sReference          NVARCHAR (128),
               @Transform_Position_dX        FLOAT (53),
               @Transform_Position_dY        FLOAT (53),
               @Transform_Position_dZ        FLOAT (53),
               @Transform_Rotation_dX        FLOAT (53),
               @Transform_Rotation_dY        FLOAT (53),
               @Transform_Rotation_dZ        FLOAT (53),
               @Transform_Rotation_dW        FLOAT (53),
               @Transform_Scale_dX           FLOAT (53),
               @Transform_Scale_dY           FLOAT (53),
               @Transform_Scale_dZ           FLOAT (53),
               @Bound_dX                     FLOAT (53),
               @Bound_dY                     FLOAT (53),
               @Bound_dZ                     FLOAT (53)

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

          EXEC dbo.call_RMPObject_Validate @twRPersonaIx, @twRMPObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                     IF @wClass = @ObjectHead_Parent_wClass  AND  @twObjectIx = @ObjectHead_Parent_twObjectIx
                        EXEC dbo.call_Error 99, 'The new parent is the same as the current parent', @nError OUTPUT
                ELSE IF @wClass = @SBO_CLASS_RMROOT
                  BEGIN
                              IF NOT EXISTS (SELECT 1 FROM dbo.RMRoot    WHERE ObjectHead_Self_twObjectIx = @twObjectIx)
                                 EXEC dbo.call_Error 99, 'twObjectIx is invalid', @nError OUTPUT
                    END
                ELSE IF @wClass = @SBO_CLASS_RMTOBJECT
                  BEGIN
                              IF NOT EXISTS (SELECT 1 FROM dbo.RMTObject WHERE ObjectHead_Self_twObjectIx = @twObjectIx)
                                 EXEC dbo.call_Error 99, 'twObjectIx is invalid', @nError OUTPUT
                    END
                ELSE IF @wClass = @SBO_CLASS_RMPOBJECT
                  BEGIN
                              IF NOT EXISTS (SELECT 1 FROM dbo.RMPObject WHERE ObjectHead_Self_twObjectIx = @twObjectIx)
                                 EXEC dbo.call_Error 99, 'twObjectIx is invalid', @nError OUTPUT
                    END
                   ELSE EXEC dbo.call_Error 99, 'wClass is invalid', @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                 SELECT @Name_wsRMPObjectId    = Name_wsRMPObjectId,
                        @Type_bType            = Type_bType,
                        @Type_bSubtype         = Type_bSubtype,
                        @Type_bFiction         = Type_bFiction,
                        @Type_bMovable         = Type_bMovable,
                        @Owner_twRPersonaIx    = Owner_twRPersonaIx,
                        @Resource_qwResource   = Resource_qwResource,
                        @Resource_sName        = Resource_sName,
                        @Resource_sReference   = Resource_sReference,
                        @Transform_Position_dX = Transform_Position_dX,
                        @Transform_Position_dY = Transform_Position_dY,
                        @Transform_Position_dZ = Transform_Position_dZ,
                        @Transform_Rotation_dX = Transform_Rotation_dX,
                        @Transform_Rotation_dY = Transform_Rotation_dY,
                        @Transform_Rotation_dZ = Transform_Rotation_dZ,
                        @Transform_Rotation_dW = Transform_Rotation_dW,
                        @Transform_Scale_dX    = Transform_Scale_dX,
                        @Transform_Scale_dY    = Transform_Scale_dY,
                        @Transform_Scale_dZ    = Transform_Scale_dZ,
                        @Bound_dX              = Bound_dX,
                        @Bound_dY              = Bound_dY,
                        @Bound_dZ              = Bound_dZ
                   FROM dbo.RMPObject AS o
                  WHERE ObjectHead_Self_twObjectIx = @twRMPObjectIx

                   EXEC dbo.call_RMPObject_Validate_Type @wClass, @twObjectIx, @twRMPObjectIx, @Type_bType, @Type_bSubtype, @Type_bFiction, @Type_bMovable, @nError OUTPUT
           END

            IF @nError = 0
         BEGIN

                     IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMROOT
                        EXEC @bError = dbo.call_RMRoot_Event_RMPObject_Close    @ObjectHead_Parent_twObjectIx, @twRMPObjectIx, 1
                ELSE IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMTOBJECT
                        EXEC @bError = dbo.call_RMTObject_Event_RMPObject_Close @ObjectHead_Parent_twObjectIx, @twRMPObjectIx, 1
                ELSE IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMPOBJECT
                        EXEC @bError = dbo.call_RMPObject_Event_RMPObject_Close @ObjectHead_Parent_twObjectIx, @twRMPObjectIx, 1
                   ELSE EXEC dbo.call_Error 99, 'Internal error', @nError OUTPUT

                     IF @bError = 0
                  BEGIN
                          UPDATE dbo.RMPObject
                             SET ObjectHead_Parent_wClass     = @wClass,
                                 ObjectHead_Parent_twObjectIx = @twObjectIx
                           WHERE ObjectHead_Self_twObjectIx = @twRMPObjectIx

                             SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

                              IF @bError = 0
                           BEGIN
                                       IF @wClass = @SBO_CLASS_RMROOT
                                          EXEC @bError = dbo.call_RMRoot_Event_RMPObject_Open    @twObjectIx, @Name_wsRMPObjectId, @Type_bType, @Type_bSubtype, @Type_bFiction, @Type_bMovable, @Owner_twRPersonaIx, @Resource_qwResource, @Resource_sName, @Resource_sReference, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @Bound_dX, @Bound_dY, @Bound_dZ, @twRMPObjectIx OUTPUT, 1
                                  ELSE IF @wClass = @SBO_CLASS_RMTOBJECT
                                          EXEC @bError = dbo.call_RMTObject_Event_RMPObject_Open @twObjectIx, @Name_wsRMPObjectId, @Type_bType, @Type_bSubtype, @Type_bFiction, @Type_bMovable, @Owner_twRPersonaIx, @Resource_qwResource, @Resource_sName, @Resource_sReference, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @Bound_dX, @Bound_dY, @Bound_dZ, @twRMPObjectIx OUTPUT, 1
                                  ELSE IF @wClass = @SBO_CLASS_RMPOBJECT
                                          EXEC @bError = dbo.call_RMPObject_Event_RMPObject_Open @twObjectIx, @Name_wsRMPObjectId, @Type_bType, @Type_bSubtype, @Type_bFiction, @Type_bMovable, @Owner_twRPersonaIx, @Resource_qwResource, @Resource_sName, @Resource_sReference, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @Bound_dX, @Bound_dY, @Bound_dZ, @twRMPObjectIx OUTPUT, 1
                                     ELSE EXEC dbo.call_Error 99, 'Internal error', @nError OUTPUT
                  
                                       IF @bError = 0
                                    BEGIN
                                          SET @bCommit = 1
                                      END
                                     ELSE EXEC dbo.call_Error -3, 'Failed to update new parent'
                             END
                            ELSE EXEC dbo.call_Error -2, 'Failed to update RMPObject'
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to delete from old parent'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMPObject_Log @RMPOBJECT_OP_PARENT, @sIPAddress, @twRPersonaIx, @twRMPObjectIx
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

GRANT EXECUTE ON dbo.set_RMPObject_Parent TO WebService
GO

/******************************************************************************************************************************/
