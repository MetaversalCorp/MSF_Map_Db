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

CREATE PROCEDURE dbo.call_RMCObject_Validate_Bound
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMCObjectIx                BIGINT,
   @Bound_dX                     FLOAT (53),
   @Bound_dY                     FLOAT (53),
   @Bound_dZ                     FLOAT (53),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71

            IF @Bound_dX IS NULL OR @Bound_dX <> @Bound_dX
               EXEC dbo.call_Error 21, 'Bound_dX is NULL or NaN', @nError OUTPUT
       ELSE IF @Bound_dX < 0
               EXEC dbo.call_Error 21, 'Bound_dX is invalid',     @nError OUTPUT

            IF @Bound_dY IS NULL OR @Bound_dY <> @Bound_dY
               EXEC dbo.call_Error 21, 'Bound_dY is NULL or NaN', @nError OUTPUT
       ELSE IF @Bound_dY < 0
               EXEC dbo.call_Error 21, 'Bound_dY is invalid',     @nError OUTPUT

            IF @Bound_dZ IS NULL OR @Bound_dZ <> @Bound_dZ
               EXEC dbo.call_Error 21, 'Bound_dZ is NULL or NaN', @nError OUTPUT
       ELSE IF @Bound_dZ < 0
               EXEC dbo.call_Error 21, 'Bound_dZ is invalid',     @nError OUTPUT

            IF @nError = 0
         BEGIN
               -- validate bound is inside  parent's   bound
               -- validate bound is outside children's bound
                  SET @nError = @nError
           END

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
