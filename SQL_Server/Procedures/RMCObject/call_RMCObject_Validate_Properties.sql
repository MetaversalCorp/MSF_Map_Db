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

CREATE PROCEDURE dbo.call_RMCObject_Validate_Properties
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMCObjectIx                BIGINT,
   @Properties_fMass             FLOAT (24),
   @Properties_fGravity          FLOAT (24),
   @Properties_fColor            FLOAT (24),
   @Properties_fBrightness       FLOAT (24),
   @Properties_fReflectivity     FLOAT (24),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

            IF @Properties_fMass IS NULL OR @Properties_fMass <> @Properties_fMass
               EXEC dbo.call_Error 21, 'Properties_fMass is NULL or NaN',         @nError OUTPUT
       ELSE IF @Properties_fMass < 0                                              
               EXEC dbo.call_Error 21, 'Properties_fMass is invalid',             @nError OUTPUT

            IF @Properties_fGravity IS NULL OR @Properties_fGravity <> @Properties_fGravity
               EXEC dbo.call_Error 21, 'Properties_fGravity is NULL or NaN',      @nError OUTPUT
       ELSE IF @Properties_fGravity < 0                                           
               EXEC dbo.call_Error 21, 'Properties_fGravity is invalid',          @nError OUTPUT

            IF @Properties_fColor IS NULL OR @Properties_fColor <> @Properties_fColor
               EXEC dbo.call_Error 21, 'Properties_fColor is NULL or NaN',        @nError OUTPUT
       ELSE IF @Properties_fColor < 0
               EXEC dbo.call_Error 21, 'Properties_fColor is invalid',            @nError OUTPUT

            IF @Properties_fBrightness IS NULL OR @Properties_fBrightness <> @Properties_fBrightness
               EXEC dbo.call_Error 21, 'Properties_fBrightness is NULL or NaN',   @nError OUTPUT
       ELSE IF @Properties_fBrightness < 0
               EXEC dbo.call_Error 21, 'Properties_fBrightness is invalid',       @nError OUTPUT

            IF @Properties_fReflectivity IS NULL OR @Properties_fReflectivity <> @Properties_fReflectivity
               EXEC dbo.call_Error 21, 'Properties_fReflectivity is NULL or NaN', @nError OUTPUT
       ELSE IF @Properties_fReflectivity < 0
               EXEC dbo.call_Error 21, 'Properties_fReflectivity is invalid',     @nError OUTPUT

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
