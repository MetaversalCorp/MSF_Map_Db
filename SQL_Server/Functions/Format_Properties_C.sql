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

CREATE FUNCTION dbo.Format_Properties_C
(
   @fMass                    FLOAT (24),
   @fGravity                 FLOAT (24),
   @fColor                   FLOAT (24),
   @fBrightness              FLOAT (24),
   @fReflectivity            FLOAT (24)
)
RETURNS NVARCHAR (256)
AS
BEGIN
      RETURN '{ ' + 
                '"fMass": '         + dbo.Format_Float (@fMass)         + ', ' +
                '"fGravity": '      + dbo.Format_Float (@fGravity)      + ', ' +
                '"fColor": '        + dbo.Format_Float (@fColor)        + ', ' +
                '"fBrightness": '   + dbo.Format_Float (@fBrightness)   + ', ' +
                '"fReflectivity": ' + dbo.Format_Float (@fReflectivity) +
             ' }'
  END
GO

/******************************************************************************************************************************/
