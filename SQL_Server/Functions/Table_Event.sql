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

CREATE FUNCTION dbo.Table_Event ()
RETURNS @Event TABLE
(
   nOrder                        INT             NOT NULL IDENTITY (0, 1),

   sType                         VARCHAR (32)    NOT NULL,

   Self_wClass                   SMALLINT        NOT NULL,
   Self_twObjectIx               BIGINT          NOT NULL,
   Child_wClass                  SMALLINT        NOT NULL,
   Child_twObjectIx              BIGINT          NOT NULL,
   wFlags                        SMALLINT        NOT NULL,
   twEventIz                     BIGINT          NOT NULL,
   
   sJSON_Object                  NVARCHAR (4000) NOT NULL,
   sJSON_Child                   NVARCHAR (4000) NOT NULL,
   sJSON_Change                  NVARCHAR (4000) NOT NULL
)
AS
BEGIN
       -- This function returns an empty table from which the #Event table is created

       RETURN
END
GO

/******************************************************************************************************************************/
