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
   For now, anyone in this table is considered an admin and can do all adminy stuff
*/

IF OBJECT_ID (N'dbo.Admin', 'U') IS NULL
CREATE TABLE dbo.Admin
(
   twRPersonaIx                        BIGINT          NOT NULL,

   CONSTRAINT PK_Admin PRIMARY KEY CLUSTERED
   (
      twRPersonaIx                     ASC
   )
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/
