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

CREATE FUNCTION dbo.Format_Properties_T
(
   @bLockToGround            TINYINT,
   @bYouth                   TINYINT,
   @bAdult                   TINYINT,
   @bAvatar                  TINYINT
)
RETURNS NVARCHAR (256)
AS
BEGIN
      RETURN '{ ' + 
                '"bLockToGround": ' + CAST (@bLockToGround AS NVARCHAR (4)) + ', ' +
                '"bYouth": '        + CAST (@bYouth        AS NVARCHAR (4)) + ', ' +
                '"bAdult": '        + CAST (@bAdult        AS NVARCHAR (4)) + ', ' +
                '"bAvatar": '       + CAST (@bAvatar       AS NVARCHAR (4)) +
             ' }'
  END
GO

/******************************************************************************************************************************/
