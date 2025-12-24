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

CREATE PROCEDURE dbo.call_RMCObject_Validate_Type
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMCObjectIx                BIGINT,
   @Type_bType                   TINYINT,
   @Type_bSubtype                TINYINT,
   @Type_bFiction                TINYINT,
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71

       DECLARE @Parent_bType    TINYINT,
               @Parent_bSubtype TINYINT,
               @Self_bType      TINYINT,
               @Self_bSubtype   TINYINT

            IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMCOBJECT
         BEGIN
                 SELECT @Parent_bType    = Type_bType,
                        @Parent_bSubtype = Type_bSubtype
                   FROM dbo.RMCObject AS o
                  WHERE ObjectHead_Self_twObjectIx = @ObjectHead_Parent_twObjectIx
           END

            IF @twRMCObjectIx > 0
         BEGIN
                 SELECT @Self_bType    = Type_bType,
                        @Self_bSubtype = Type_bSubtype
                   FROM dbo.RMCObject AS o
                  WHERE ObjectHead_Self_twObjectIx = @twRMCObjectIx
-- get max children's type and subtype

           END

-- attachment points can't have cildren

            IF @Type_bType IS NULL
               EXEC dbo.call_Error 21, 'Type_bType is NULL',       @nError OUTPUT

            IF @Type_bSubtype IS NULL
               EXEC dbo.call_Error 21, 'Type_bSubtype is NULL',    @nError OUTPUT

            IF @Type_bFiction IS NULL
               EXEC dbo.call_Error 21, 'Type_bFiction is NULL',    @nError OUTPUT
       ELSE IF @Type_bFiction NOT BETWEEN 0 AND 1
               EXEC dbo.call_Error 21, 'Type_bFiction is invalid', @nError OUTPUT

            IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMCOBJECT  AND  @Type_bType < @Parent_bType
               EXEC dbo.call_Error 21, 'Type_bType must be greater than or equal to its parent''s Type_bType', @nError OUTPUT
       ELSE IF @ObjectHead_Parent_wClass = @SBO_CLASS_RMCOBJECT  AND  @Type_bType = @Parent_bType  AND  @Type_bSubtype <= @Parent_bSubtype
               EXEC dbo.call_Error 21, 'Type_bSubtype must be greater than its parent''s Type_bType', @nError OUTPUT

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
