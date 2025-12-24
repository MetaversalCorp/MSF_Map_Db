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

CREATE FUNCTION dbo.ArcLength
(
   @dRadius          FLOAT (53),

   @dX0              FLOAT (53),
   @dY0              FLOAT (53),
   @dZ0              FLOAT (53),

   @dX               FLOAT (53),
   @dY               FLOAT (53),
   @dZ               FLOAT (53)
)
RETURNS FLOAT (53)
AS
BEGIN
            -- arc length = 2 * radius * arcsin (distance / (2 * radius))

            -- This function assumes dX0, dY0, and dZ0 have already been normalized to dRadius
            -- Origins in the database sit below the surface and must also be normalized to dRadius

       DECLARE @dNormal FLOAT (53) = @dRadius / SQRT ((@dX * @dX) + (@dY * @dY) + (@dZ * @dZ))

           SET @dX *= @dNormal
           SET @dY *= @dNormal
           SET @dZ *= @dNormal

           SET @dX -= @dX0
           SET @dY -= @dY0
           SET @dZ -= @dZ0

        RETURN (2.0 * @dRadius) * ASIN (SQRT ((@dX * @dX) + (@dY * @dY) + (@dZ * @dZ)) / (2.0 * @dRadius))
  END
GO

/******************************************************************************************************************************/
