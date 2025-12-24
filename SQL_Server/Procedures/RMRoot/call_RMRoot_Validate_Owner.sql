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

CREATE PROCEDURE dbo.call_RMRoot_Validate_Owner
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMRootIx                   BIGINT,
   @Owner_twRPersonaIx           BIGINT,
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

            IF @Owner_twRPersonaIx IS NULL
               EXEC dbo.call_Error 21, 'Owner_twRPersonaIx is NULL',    @nError OUTPUT
       ELSE IF @Owner_twRPersonaIx NOT BETWEEN 1 AND 0x0000FFFFFFFFFFFC
               EXEC dbo.call_Error 21, 'Owner_twRPersonaIx is invalid', @nError OUTPUT

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
