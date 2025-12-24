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

CREATE PROCEDURE dbo.call_RMTObject_Event
(
   @twRMTObjectIx                BIGINT,
   @twEventIz                    BIGINT OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @bError INT

        SELECT @twEventIz = ObjectHead_twEventIz
          FROM dbo.RMTObject
         WHERE ObjectHead_Self_twObjectIx = @twRMTObjectIx

            -- Success will be tested on the update below

        UPDATE dbo.RMTObject
           SET ObjectHead_twEventIz += 1
         WHERE ObjectHead_Self_twObjectIx = @twRMTObjectIx

           SET @bError = IIF (@@ROWCOUNT = 1, @@ERROR, 1)

        RETURN @bError
  END
GO

/******************************************************************************************************************************/
