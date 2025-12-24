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

CREATE PROCEDURE dbo.call_RMRoot_Event_RMCObject_Close
(
   @twRMRootIx                   BIGINT,
   @twRMCObjectIx                BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE INT = 0x02

       DECLARE @bError    INT,
               @twEventIz BIGINT

          EXEC @bError = dbo.call_RMRoot_Event @twRMRootIx, @twEventIz OUTPUT

            IF @bError = 0
         BEGIN
               DELETE dbo.RMCObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                WHERE ObjectHead_Self_twObjectIx = @twRMCObjectIx

                  SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

                   IF @bError = 0
                BEGIN
                      INSERT #Event
                             (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                      SELECT 'RMCOBJECT_CLOSE',

                             @SBO_CLASS_RMROOT,
                             @twRMRootIx,
                             @SBO_CLASS_RMCOBJECT,
                             @twRMCObjectIx,
                             @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                             @twEventIz,

                             '{ }',

                             '{ }',

                             '{ }'

                         SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)
                  END
           END

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
