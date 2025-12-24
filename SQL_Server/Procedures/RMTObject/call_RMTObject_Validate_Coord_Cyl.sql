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

CREATE PROCEDURE dbo.call_RMTObject_Validate_Coord_Cyl
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
   @dTheta                       FLOAT (53),
   @dY                           FLOAT (53),
   @dRadius                      FLOAT (53),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

            IF @dTheta IS NULL OR @dTheta <> @dTheta
               EXEC dbo.call_Error 21, 'dTheta is NULL or NaN',  @nError OUTPUT
       ELSE IF @dTheta NOT BETWEEN -180 AND 180
               EXEC dbo.call_Error 21, 'dTheta is invalid',      @nError OUTPUT

            IF @dY IS NULL OR @dY <> @dY
               EXEC dbo.call_Error 21, 'dY is NULL or NaN',      @nError OUTPUT

            IF @dRadius IS NULL OR @dRadius <> @dRadius
               EXEC dbo.call_Error 21, 'dRadius is NULL or NaN', @nError OUTPUT
       ELSE IF @dRadius = 0
               EXEC dbo.call_Error 21, 'dRadius is invalid',     @nError OUTPUT

            IF @nError = 0
         BEGIN
               -- validate position is inside parent's bound
                  SET @nError = @nError
           END

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
