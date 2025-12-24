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

CREATE FUNCTION dbo.Format_Control
(
   @Self_wClass             SMALLINT,
   @Self_twObjectIx         BIGINT,
   @Child_wClass            SMALLINT,
   @Child_twObjectIx        BIGINT,
   @wFlags                  SMALLINT,
   @twEventIz               BIGINT
)
RETURNS NVARCHAR (256)
AS
BEGIN
      RETURN '{ ' + 
                '"wClass_Object": ' + CAST (@Self_wClass      AS NVARCHAR (16)) + ', ' +
                '"twObjectIx": '    + CAST (@Self_twObjectIx  AS NVARCHAR (16)) + ', ' +
                '"wClass_Child": '  + CAST (@Child_wClass     AS NVARCHAR (16)) + ', ' +
                '"twChildIx": '     + CAST (@Child_twObjectIx AS NVARCHAR (16)) + ', ' +
                '"wFlags": '        + CAST (@wFlags           AS NVARCHAR (16)) + ', ' +
                '"twEventIz": '     + CAST (@twEventIz        AS NVARCHAR (16)) + 
             ' }'
  END
GO

/******************************************************************************************************************************/
