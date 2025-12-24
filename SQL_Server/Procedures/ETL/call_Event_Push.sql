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

/*
** Procedures call this function to push events onto the queue.
*/

CREATE PROCEDURE dbo.call_Event_Push
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @bError INT

        INSERT dbo.RMEvent
             ( sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change )
        SELECT sType, Self_wClass, Self_twObjectIx, Child_wClass, Child_twObjectIx, wFlags, twEventIz, sJSON_Object, sJSON_Child, sJSON_Change
          FROM #Event
      ORDER BY nOrder ASC

           SET @bError = IIF (@@ERROR = 0, 0, 1)

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
