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

CREATE FUNCTION dbo.Format_Transform
(
   @Position_dX               FLOAT (53),
   @Position_dY               FLOAT (53),
   @Position_dZ               FLOAT (53),
   @Rotation_dX               FLOAT (53),
   @Rotation_dY               FLOAT (53),
   @Rotation_dZ               FLOAT (53),
   @Rotation_dW               FLOAT (53),
   @Scale_dX                  FLOAT (53),
   @Scale_dY                  FLOAT (53),
   @Scale_dZ                  FLOAT (53)
)
RETURNS NVARCHAR (512)
AS
BEGIN
      RETURN '{ ' + 
                '"Position": ' + dbo.Format_Double3 (@Position_dX, @Position_dY, @Position_dZ)               + ', ' +
                '"Rotation": ' + dbo.Format_Double4 (@Rotation_dX, @Rotation_dY, @Rotation_dZ, @Rotation_dW) + ', ' +
                '"Scale": '    + dbo.Format_Double3 (@Scale_dX,    @Scale_dY,    @Scale_dZ)                  +
             ' }'
  END
GO

/******************************************************************************************************************************/
