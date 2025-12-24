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

CREATE PROCEDURE dbo.call_RMTObject_Validate_Transform
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
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
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

            IF @Transform_Position_dX IS NULL OR @Transform_Position_dX <> @Transform_Position_dX
               EXEC dbo.call_Error 21, 'Transform_Position_dX is NULL or NaN', @nError OUTPUT
            IF @Transform_Position_dY IS NULL OR @Transform_Position_dY <> @Transform_Position_dY
               EXEC dbo.call_Error 21, 'Transform_Position_dY is NULL or NaN', @nError OUTPUT
            IF @Transform_Position_dZ IS NULL OR @Transform_Position_dZ <> @Transform_Position_dZ
               EXEC dbo.call_Error 21, 'Transform_Position_dZ is NULL or NaN', @nError OUTPUT

            IF @Transform_Rotation_dX IS NULL OR @Transform_Rotation_dX <> @Transform_Rotation_dX
               EXEC dbo.call_Error 21, 'Transform_Rotation_dX is NULL or NaN', @nError OUTPUT
            IF @Transform_Rotation_dY IS NULL OR @Transform_Rotation_dY <> @Transform_Rotation_dY
               EXEC dbo.call_Error 21, 'Transform_Rotation_dY is NULL or NaN', @nError OUTPUT
            IF @Transform_Rotation_dZ IS NULL OR @Transform_Rotation_dZ <> @Transform_Rotation_dZ
               EXEC dbo.call_Error 21, 'Transform_Rotation_dZ is NULL or NaN', @nError OUTPUT
            IF @Transform_Rotation_dW IS NULL OR @Transform_Rotation_dW <> @Transform_Rotation_dW
               EXEC dbo.call_Error 21, 'Transform_Rotation_dW is NULL or NaN', @nError OUTPUT

            IF @Transform_Scale_dX    IS NULL OR @Transform_Scale_dX    <> @Transform_Scale_dX
               EXEC dbo.call_Error 21, 'Transform_Scale_dX    is NULL or NaN', @nError OUTPUT
            IF @Transform_Scale_dY    IS NULL OR @Transform_Scale_dY    <> @Transform_Scale_dY
               EXEC dbo.call_Error 21, 'Transform_Scale_dY    is NULL or NaN', @nError OUTPUT
            IF @Transform_Scale_dZ    IS NULL OR @Transform_Scale_dZ    <> @Transform_Scale_dZ
               EXEC dbo.call_Error 21, 'Transform_Scale_dZ    is NULL or NaN', @nError OUTPUT

            IF @nError = 0
         BEGIN
               -- validate position is inside parent's bound
                  SET @nError = @nError
           END

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
