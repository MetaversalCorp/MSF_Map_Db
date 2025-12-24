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

CREATE PROCEDURE dbo.call_RMCObject_Event_Properties
(
   @twRMCObjectIx                BIGINT,
   @Properties_fMass             FLOAT (24),
   @Properties_fGravity          FLOAT (24),
   @Properties_fColor            FLOAT (24),
   @Properties_fBrightness       FLOAT (24),
   @Properties_fReflectivity     FLOAT (24)
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
                  SET Properties_fMass         = @Properties_fMass,
                      Properties_fGravity      = @Properties_fGravity,
                      Properties_fColor        = @Properties_fColor,
                      Properties_fBrightness   = @Properties_fBrightness,
                      Properties_fReflectivity = @Properties_fReflectivity
                WHERE ObjectHead_Self_twObjectIx = @twRMCObjectIx

                  SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

                   IF @bError = 0
                BEGIN
                      INSERT #Event
                             (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                      SELECT 'PROPERTIES',

                             @SBO_CLASS_RMCOBJECT,
                             @twRMCObjectIx,
                             @SBO_CLASS_NULL,
                             0,
                             0,
                             @twEventIz,

                             CONCAT
                             (
                               '{ ',
                                 '"pProperties": ',   dbo.Format_Properties_C
                                                      (
                                                         @Properties_fMass,
                                                         @Properties_fGravity,
                                                         @Properties_fColor,
                                                         @Properties_fBrightness,
                                                         @Properties_fReflectivity
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
