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

CREATE PROCEDURE dbo.set_RMCObject_RMCObject_Open
(
   @sIPAddress                   NVARCHAR (16),
   @twRPersonaIx                 BIGINT,
   @twRMCObjectIx                BIGINT,
   @Name_wsRMCObjectId           NVARCHAR (48),
   @Type_bType                   TINYINT,
   @Type_bSubtype                TINYINT,
   @Type_bFiction                TINYINT,
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
   @Orbit_Spin_tmPeriod          BIGINT,
   @Orbit_Spin_tmStart           BIGINT,
   @Orbit_Spin_dA                FLOAT (53),
   @Orbit_Spin_dB                FLOAT (53),
   @Bound_dX                     FLOAT (53),
   @Bound_dY                     FLOAT (53),
   @Bound_dZ                     FLOAT (53),
   @Properties_fMass             FLOAT (24),
   @Properties_fGravity          FLOAT (24),
   @Properties_fColor            FLOAT (24),
   @Properties_fBrightness       FLOAT (24),
   @Properties_fReflectivity     FLOAT (24)
)
AS
BEGIN
           SET NOCOUNT ON

           SET @twRPersonaIx  = ISNULL (@twRPersonaIx,  0)
           SET @twRMCObjectIx = ISNULL (@twRMCObjectIx, 0)

       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @RMCOBJECT_OP_RMCOBJECT_OPEN               INT = 11

            -- Create the temp Error table
        SELECT * INTO #Error FROM dbo.Table_Error ()

       DECLARE @nError  INT = 0,
               @bCommit INT = 0,
               @bError  INT

       DECLARE @ObjectHead_Parent_wClass     SMALLINT,
               @ObjectHead_Parent_twObjectIx BIGINT

       DECLARE @twRMCObjectIx_Open   BIGINT

            -- Create the temp Event table
        SELECT * INTO #Event FROM dbo.Table_Event ()

         BEGIN TRANSACTION

          EXEC dbo.call_RMCObject_Validate @twRPersonaIx, @twRMCObjectIx, @ObjectHead_Parent_wClass OUTPUT, @ObjectHead_Parent_twObjectIx OUTPUT, @nError OUTPUT

            IF @nError = 0
         BEGIN
                   EXEC dbo.call_RMCObject_Validate_Name       @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Name_wsRMCObjectId, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Type       @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Type_bType, @Type_bSubtype, @Type_bFiction, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Owner      @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Owner_twRPersonaIx, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Resource   @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Resource_qwResource, @Resource_sName, @Resource_sReference, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Transform  @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Orbit_Spin @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Orbit_Spin_tmPeriod, @Orbit_Spin_tmStart, @Orbit_Spin_dA, @Orbit_Spin_dB, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Bound      @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Bound_dX, @Bound_dY, @Bound_dZ, @nError OUTPUT
                   EXEC dbo.call_RMCObject_Validate_Properties @SBO_CLASS_RMCOBJECT, @twRMCObjectIx, 0, @Properties_fMass, @Properties_fGravity, @Properties_fColor, @Properties_fBrightness, @Properties_fReflectivity, @nError OUTPUT
           END

            IF @nError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMCObject_Event_RMCObject_Open @twRMCObjectIx, @Name_wsRMCObjectId, @Type_bType, @Type_bSubtype, @Type_bFiction, @Owner_twRPersonaIx, @Resource_qwResource, @Resource_sName, @Resource_sReference, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @Orbit_Spin_tmPeriod, @Orbit_Spin_tmStart, @Orbit_Spin_dA, @Orbit_Spin_dB, @Bound_dX, @Bound_dY, @Bound_dZ, @Properties_fMass, @Properties_fGravity, @Properties_fColor, @Properties_fBrightness, @Properties_fReflectivity, @twRMCObjectIx_Open OUTPUT
                     IF @bError = 0
                  BEGIN
                        SELECT @twRMCObjectIx_Open AS twRMCObjectIx
   
                           SET @bCommit = 1
                    END
                   ELSE EXEC dbo.call_Error -1, 'Failed to insert RMCObject'
           END
       
            IF @bCommit = 1
         BEGIN
                    SET @bCommit = 0
                 
                   EXEC @bError = dbo.call_RMCObject_Log @RMCOBJECT_OP_RMCOBJECT_OPEN, @sIPAddress, @twRPersonaIx, @twRMCObjectIx
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

GRANT EXECUTE ON dbo.set_RMCObject_RMCObject_Open TO WebService
GO

/******************************************************************************************************************************/
