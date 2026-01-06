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

DROP PROCEDURE IF EXISTS dbo.call_RMRoot_Event_RMTObject_Close
GO

CREATE PROCEDURE dbo.call_RMRoot_Event_RMTObject_Close
(
   @twRMRootIx                   BIGINT,
   @twRMTObjectIx_Close          BIGINT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE INT = 0x02

       DECLARE @bError    INT,
               @twEventIz BIGINT

            -- Create the temp TObject table
        SELECT * INTO #TObject FROM dbo.Table_Object ()

            -- Create the temp PObject table
        SELECT * INTO #PObject FROM dbo.Table_Object ()

          EXEC @bError = dbo.call_RMRoot_Event @twRMRootIx, @twEventIz OUTPUT

            IF @bError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMTObject_Delete_Descendants @twRMTObjectIx_Close
           END

            IF @bError = 0
         BEGIN
                   EXEC @bError = dbo.call_RMPObject_Delete_Descendants NULL
           END

            IF @bError = 0
         BEGIN
                 INSERT #Event
                        (sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change)
                 SELECT 'RMTOBJECT_CLOSE',

                        @SBO_CLASS_RMROOT,
                        @twRMRootIx,
                        @SBO_CLASS_RMTOBJECT,
                        @twRMTObjectIx_Close,
                        @SBA_SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE,
                        @twEventIz,

                        '{ }',

                        '{ }',

                        '{ }'

                    SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)
           END

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
