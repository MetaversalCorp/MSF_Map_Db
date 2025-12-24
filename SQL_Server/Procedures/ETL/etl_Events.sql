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
** The NodeJS server calls this function periodically to retrieve events from the queue.
*/

CREATE PROCEDURE dbo.etl_Events
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @t TABLE
                  (
                     twEventIx      BIGINT
                  )

         BEGIN TRANSACTION

        INSERT @t
             ( twEventIx )
        SELECT TOP 100
               twEventIx
          FROM dbo.RMEvent
      ORDER BY twEventIx ASC

        SELECT CONCAT
               (
                 '{ ',
                   '"sType": ',     '"', e.sType, '"',
                 ', "pControl": ',  dbo.Format_Control (e.Self_wClass, e.Self_twObjectIx, e.Child_wClass, e.Child_twObjectIx, e.wFlags, e.twEventIz),
                 ', "pObject": ',   e.sJSON_Object,
                 ', "pChild": ',    e.sJSON_Child,
                 ', "pChange": ',   e.sJSON_Change,
                ' }'
               )
               AS [Object]
          FROM dbo.RMEvent AS e
          JOIN @t          AS t ON t.twEventIx = e.twEventIx
      ORDER BY e.twEventIx
       
        DELETE e
          FROM dbo.RMEvent AS e
          JOIN @t          AS t ON t.twEventIx = e.twEventIx

        SELECT COUNT (*) AS nCount
          FROM dbo.RMEvent
       
        COMMIT TRANSACTION

        RETURN 0
  END
GO

GRANT EXECUTE ON dbo.etl_Events TO WebService
GO

/******************************************************************************************************************************/
