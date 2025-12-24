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

CREATE PROCEDURE dbo.call_RMTObject_Validate_Coord_Car
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
   @dX                           FLOAT (53),
   @dY                           FLOAT (53),
   @dZ                           FLOAT (53),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

            IF @dX IS NULL OR @dX <> @dX
               EXEC dbo.call_Error 21, 'dX is NULL or NaN', @nError OUTPUT

            IF @dY IS NULL OR @dY <> @dY
               EXEC dbo.call_Error 21, 'dY is NULL or NaN', @nError OUTPUT

            IF @dZ IS NULL OR @dZ <> @dZ
               EXEC dbo.call_Error 21, 'dZ is NULL or NaN', @nError OUTPUT

            IF @nError = 0
         BEGIN
               -- validate position is inside parent's bound
                  SET @nError = @nError
           END

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
