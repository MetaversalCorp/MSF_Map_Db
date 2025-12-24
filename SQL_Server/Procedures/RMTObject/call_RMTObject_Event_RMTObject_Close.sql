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

CREATE PROCEDURE dbo.call_RMTObject_Event_RMTObject_Close
(
   @twRMTObjectIx                BIGINT,
   @twRMTObjectIx_Close          BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE INT = 0x02

       DECLARE @bError    INT,
               @twEventIz BIGINT

       DECLARE @nCount    INT = 0

          EXEC @bError = dbo.call_RMTObject_Event @twRMTObjectIx, @twEventIz OUTPUT

            IF @bError = 0
         BEGIN
               DELETE dbo.RMTMatrix                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                WHERE bnMatrix =     @twRMTObjectIx_Close
                   OR bnMatrix = 0 - @twRMTObjectIx_Close

                  SET @nCount += @@ROWCOUNT -- 2

               DELETE dbo.RMTSubsurface                                    -- we actually want to delete the entire tree - all the way down to the pobject!
                WHERE twRMTObjectIx = @twRMTObjectIx_Close

                  SET @nCount += @@ROWCOUNT -- 1

               DELETE dbo.RMTObject                                        -- we actually want to delete the entire tree - all the way down to the pobject!
                WHERE ObjectHead_Self_twObjectIx = @twRMTObjectIx_Close

                  SET @nCount += @@ROWCOUNT -- 1

                  SET @bError = IIF (@nCount = 4, @@ERROR, 1) -- this will only return the error of the last delete statement

                   IF @bError = 0
                BEGIN
                      INSERT #Event
                             (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                      SELECT 'RMTOBJECT_CLOSE',

                             @SBO_CLASS_RMTOBJECT,
                             @twRMTObjectIx,
                             @SBO_CLASS_RMTOBJECT,
                             @twRMTObjectIx_Close,
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
