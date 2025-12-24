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

CREATE PROCEDURE dbo.call_RMTObject_Validate_Resource
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
   @Resource_qwResource          BIGINT,
   @Resource_sName               NVARCHAR (48),
   @Resource_sReference          NVARCHAR (128),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

            IF @Resource_qwResource IS NULL
               EXEC dbo.call_Error 21, 'Resource_qwResource is NULL', @nError OUTPUT
            IF @Resource_sName IS NULL
               EXEC dbo.call_Error 21, 'Resource_sName is NULL',      @nError OUTPUT
            IF @Resource_sReference IS NULL
               EXEC dbo.call_Error 21, 'Resource_sReference is NULL', @nError OUTPUT

            -- do we want to check sName and sReference for length or invalid characters

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
