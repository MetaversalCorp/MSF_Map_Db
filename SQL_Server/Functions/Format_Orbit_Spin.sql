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

CREATE FUNCTION dbo.Format_Orbit_Spin
(
   @tmPeriod                 BIGINT,
   @tmStart                  BIGINT,
   @dA                       FLOAT (53),
   @dB                       FLOAT (53)
)
RETURNS NVARCHAR (256)
AS
BEGIN
      RETURN '{ ' + 
                '"tmPeriod": ' + CAST (@tmPeriod AS NVARCHAR (32)) + ', ' +
                '"tmStart": '  + CAST (@tmStart  AS NVARCHAR (32)) + ', ' +
                '"dA": '       + dbo.Format_Double (@dA)           + ', ' +
                '"dB": '       + dbo.Format_Double (@dB)           +
             ' }'
  END
GO

/******************************************************************************************************************************/
