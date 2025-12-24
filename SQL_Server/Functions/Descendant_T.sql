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

CREATE FUNCTION dbo.Descendant_T
(
   @Ancestor_wClass            SMALLINT,
   @Ancestor_twObjectIx        BIGINT,
   @Descendant_wClass          SMALLINT,
   @Descendant_twObjectIx      BIGINT
)
RETURNS INT
AS
BEGIN
      DECLARE @nCount INT

       ; WITH Tree AS
              (
                SELECT oa.ObjectHead_Parent_wClass,
                       oa.ObjectHead_Parent_twObjectIx,
                       oa.ObjectHead_Self_wClass,
                       oa.ObjectHead_Self_twObjectIx
                  FROM dbo.RMTObject AS oa
                 WHERE oa.ObjectHead_Self_wClass     = @Descendant_wClass
                   AND oa.ObjectHead_Self_twObjectIx = @Descendant_twObjectIx
                       
                 UNION ALL
      
                SELECT ob.ObjectHead_Parent_wClass,
                       ob.ObjectHead_Parent_twObjectIx,
                       ob.ObjectHead_Self_wClass,
                       ob.ObjectHead_Self_twObjectIx
                  FROM dbo.RMTObject AS ob
                  JOIN Tree          AS t  ON t.ObjectHead_Parent_wClass     = ob.ObjectHead_Self_wClass
                                          AND t.ObjectHead_Parent_twObjectIx = ob.ObjectHead_Self_twObjectIx
              )
       SELECT @nCount = COUNT (*)
         FROM Tree
        WHERE ObjectHead_Self_wClass     = @Ancestor_wClass
          AND ObjectHead_Self_twObjectIx = @Ancestor_twObjectIx

       RETURN @nCount
  END
GO

/******************************************************************************************************************************/
