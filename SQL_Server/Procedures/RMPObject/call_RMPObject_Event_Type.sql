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

CREATE PROCEDURE dbo.call_RMPObject_Event_Type
(
   @twRMPObjectIx                BIGINT,
   @Type_bType                   TINYINT,
   @Type_bSubtype                TINYINT,
   @Type_bFiction                TINYINT,
   @Type_bMovable                TINYINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_NULL                            INT = 0
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73

       DECLARE @bError    INT,
               @twEventIz BIGINT

          EXEC @bError = dbo.call_RMPObject_Event @twRMPObjectIx, @twEventIz OUTPUT

            IF @bError = 0
         BEGIN
               UPDATE dbo.RMPObject
                  SET Type_bType    = @Type_bType,
                      Type_bSubtype = @Type_bSubtype,
                      Type_bFiction = @Type_bFiction,
                      Type_bMovable = @Type_bMovable
                WHERE ObjectHead_Self_twObjectIx = @twRMPObjectIx

                  SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

                   IF @bError = 0
                BEGIN
                      INSERT #Event
                             (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                      SELECT 'TYPE',

                             @SBO_CLASS_RMPOBJECT,
                             @twRMPObjectIx,
                             @SBO_CLASS_NULL,
                             0,
                             0,
                             @twEventIz,

                             CONCAT
                             (
                               '{ ',
                                 '"pType": ',         dbo.Format_Type_P
                                                      (
                                                         @Type_bType,
                                                         @Type_bSubtype,
                                                         @Type_bFiction,
                                                         @Type_bMovable
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
