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

CREATE PROCEDURE dbo.call_RMRoot_Event_RMPObject_Open
(
   @twRMRootIx                   BIGINT,
   @Name_wsRMPObjectId           NVARCHAR (48),
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
   @Bound_dZ                     FLOAT (53),
   @twRMPObjectIx_Open           BIGINT OUTPUT,
   @bReparent                    TINYINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73
       DECLARE @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN  INT = 0x01

       DECLARE @bError    INT,
               @twEventIz BIGINT

          EXEC @bError = dbo.call_RMRoot_Event @twRMRootIx, @twEventIz OUTPUT

            IF @bError = 0
         BEGIN
                   IF @bReparent = 0
                BEGIN
                        INSERT dbo.RMPObject
                               ( ObjectHead_Parent_wClass,  ObjectHead_Parent_twObjectIx,  ObjectHead_Self_wClass,  ObjectHead_twEventIz,  ObjectHead_wFlags,  Name_wsRMPObjectId,  Type_bType,  Type_bSubtype,  Type_bFiction,  Type_bMovable,  Owner_twRPersonaIx,  Resource_qwResource,  Resource_sName,  Resource_sReference,  Transform_Position_dX,  Transform_Position_dY,  Transform_Position_dZ,  Transform_Rotation_dX,  Transform_Rotation_dY,  Transform_Rotation_dZ,  Transform_Rotation_dW,  Transform_Scale_dX,  Transform_Scale_dY,  Transform_Scale_dZ,  Bound_dX,  Bound_dY,  Bound_dZ)
                        VALUES (@SBO_CLASS_RMROOT,         @twRMRootIx,                   @SBO_CLASS_RMPOBJECT,     0,                     32,                @Name_wsRMPObjectId, @Type_bType, @Type_bSubtype, @Type_bFiction, @Type_bMovable, @Owner_twRPersonaIx, @Resource_qwResource, @Resource_sName, @Resource_sReference, @Transform_Position_dX, @Transform_Position_dY, @Transform_Position_dZ, @Transform_Rotation_dX, @Transform_Rotation_dY, @Transform_Rotation_dZ, @Transform_Rotation_dW, @Transform_Scale_dX, @Transform_Scale_dY, @Transform_Scale_dZ, @Bound_dX, @Bound_dY, @Bound_dZ)

                           SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

                           SET @twRMPObjectIx_Open = SCOPE_IDENTITY ()
                  END

                   IF @bError = 0
                BEGIN
                        INSERT #Event
                               (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                        SELECT 'RMPOBJECT_OPEN',
  
                               @SBO_CLASS_RMROOT,
                               @twRMRootIx,
                               @SBO_CLASS_RMPOBJECT,
                               @twRMPObjectIx_Open,
                               @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN,
                               @twEventIz,
  
                               '{ }',
  
                               CONCAT
                               (
                                 '{ ',
                                   '"pName": ',         dbo.Format_Name_P
                                                        (
                                                           @Name_wsRMPObjectId
                                                        ),
                                 ', "pType": ',         dbo.Format_Type_P
                                                        (
                                                           @Type_bType,
                                                           @Type_bSubtype,
                                                           @Type_bFiction,
                                                           @Type_bMovable
                                                        ),
                                 ', "pOwner": ',        dbo.Format_Owner
                                                        (
                                                           @Owner_twRPersonaIx
                                                        ),
                                 ', "pResource": ',     dbo.Format_Resource
                                                        (
                                                           @Resource_qwResource,
                                                           @Resource_sName,
                                                           @Resource_sReference
                                                        ),
                                 ', "pTransform": ',    dbo.Format_Transform
                                                        (
                                                           @Transform_Position_dX,
                                                           @Transform_Position_dY,
                                                           @Transform_Position_dZ,
                                                           @Transform_Rotation_dX,
                                                           @Transform_Rotation_dY,
                                                           @Transform_Rotation_dZ,
                                                           @Transform_Rotation_dW,
                                                           @Transform_Scale_dX,
                                                           @Transform_Scale_dY,
                                                           @Transform_Scale_dZ
                                                        ),
                                 ', "pBound": ',        dbo.Format_Bound
                                                        (
                                                           @Bound_dX,
                                                           @Bound_dY,
                                                           @Bound_dZ
                                                        ),
                                ' }'
                               ),
  
                               '{ }'
  
                           SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)
                  END
           END

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
