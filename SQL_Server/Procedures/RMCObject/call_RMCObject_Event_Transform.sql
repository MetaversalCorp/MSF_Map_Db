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

CREATE PROCEDURE dbo.call_RMCObject_Event_Transform
(
   @twRMCObjectIx                BIGINT,
   @Transform_Position_dX        FLOAT (53),
   @Transform_Position_dY        FLOAT (53),
   @Transform_Position_dZ        FLOAT (53),
   @Transform_Rotation_dX        FLOAT (53),
   @Transform_Rotation_dY        FLOAT (53),
   @Transform_Rotation_dZ        FLOAT (53),
   @Transform_Rotation_dW        FLOAT (53),
   @Transform_Scale_dX           FLOAT (53),
   @Transform_Scale_dY           FLOAT (53),
   @Transform_Scale_dZ           FLOAT (53)
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_NULL                            INT = 0
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71

       DECLARE @bError    INT,
               @twEventIz BIGINT

          EXEC @bError = dbo.call_RMCObject_Event @twRMCObjectIx, @twEventIz OUTPUT

            IF @bError = 0
         BEGIN
               UPDATE dbo.RMCObject
                  SET Transform_Position_dX = @Transform_Position_dX,
                      Transform_Position_dY = @Transform_Position_dY,
                      Transform_Position_dZ = @Transform_Position_dZ,
                      Transform_Rotation_dX = @Transform_Rotation_dX,
                      Transform_Rotation_dY = @Transform_Rotation_dY,
                      Transform_Rotation_dZ = @Transform_Rotation_dZ,
                      Transform_Rotation_dW = @Transform_Rotation_dW,
                      Transform_Scale_dX    = @Transform_Scale_dX,
                      Transform_Scale_dY    = @Transform_Scale_dY,
                      Transform_Scale_dZ    = @Transform_Scale_dZ
                WHERE ObjectHead_Self_twObjectIx = @twRMCObjectIx

                  SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

                   IF @bError = 0
                BEGIN
                      INSERT #Event
                             (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                      SELECT 'TRANSFORM',

                             @SBO_CLASS_RMCOBJECT,
                             @twRMCObjectIx,
                             @SBO_CLASS_NULL,
                             0,
                             0,
                             @twEventIz,

                             CONCAT
                             (
                               '{ ',
                                 '"pTransform": ',    dbo.Format_Transform
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
                              ' }'
                             ),

                             '{ }',

                             '{ }'

                         SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)
                  END
           END

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
