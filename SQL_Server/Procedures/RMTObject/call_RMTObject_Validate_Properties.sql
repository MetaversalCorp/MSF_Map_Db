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

CREATE PROCEDURE dbo.call_RMTObject_Validate_Properties
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
   @Properties_bLockToGround     TINYINT,
   @Properties_bYouth            TINYINT,
   @Properties_bAdult            TINYINT,
   @Properties_bAvatar           TINYINT,
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

            IF @Properties_bLockToGround IS NULL
               EXEC dbo.call_Error 21, 'Properties_bLockToGround is NULL',    @nError OUTPUT
       ELSE IF @Properties_bLockToGround NOT BETWEEN 0 AND 1
               EXEC dbo.call_Error 21, 'Properties_bLockToGround is invalid', @nError OUTPUT

            IF @Properties_bYouth IS NULL
               EXEC dbo.call_Error 21, 'Properties_bYouth is NULL',           @nError OUTPUT
       ELSE IF @Properties_bYouth NOT BETWEEN 0 AND 1
               EXEC dbo.call_Error 21, 'Properties_bYouth is invalid',        @nError OUTPUT

            IF @Properties_bAdult IS NULL
               EXEC dbo.call_Error 21, 'Properties_bAdult is NULL',           @nError OUTPUT
       ELSE IF @Properties_bAdult NOT BETWEEN 0 AND 1
               EXEC dbo.call_Error 21, 'Properties_bAdult is invalid',        @nError OUTPUT

            IF @Properties_bAvatar IS NULL
               EXEC dbo.call_Error 21, 'Properties_bAvatar is NULL',          @nError OUTPUT
       ELSE IF @Properties_bAvatar NOT BETWEEN 0 AND 1
               EXEC dbo.call_Error 21, 'Properties_bAvatar is invalid',       @nError OUTPUT

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
