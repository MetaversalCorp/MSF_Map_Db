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

CREATE PROCEDURE dbo.call_RMTObject_Validate
(
   @twRPersonaIx                 BIGINT,
   @twRMTObjectIx                BIGINT,
   @ObjectHead_Parent_wClass     SMALLINT        OUTPUT,
   @ObjectHead_Parent_twObjectIx BIGINT          OUTPUT,
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @bAdmin INT = 0,
               @nCount INT

            IF EXISTS (SELECT 1 FROM dbo.Admin WHERE twRPersonaIx = @twRPersonaIx)
               SET @bAdmin = 1

        SELECT @ObjectHead_Parent_wClass     = ObjectHead_Parent_wClass,
               @ObjectHead_Parent_twObjectIx = ObjectHead_Parent_twObjectIx
          FROM dbo.RMTObject
         WHERE ObjectHead_Self_twObjectIx = @twRMTObjectIx

           SET @nCount = @@ROWCOUNT

            IF @twRPersonaIx <= 0
               EXEC dbo.call_Error 1,  'twRPersonaIx is invalid',  @nError OUTPUT
       ELSE IF @twRMTObjectIx <= 0
               EXEC dbo.call_Error 2,  'twRMTObjectIx is invalid', @nError OUTPUT
       ELSE IF @nCount <> 1
               EXEC dbo.call_Error 3,  'twRMTObjectIx is unknown', @nError OUTPUT
       ELSE IF @bAdmin = 0
               EXEC dbo.call_Error 4,  'Invalid rights',           @nError OUTPUT

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
