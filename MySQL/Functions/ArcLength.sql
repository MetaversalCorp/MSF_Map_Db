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

/* ************************************************************************************************************************** */

DROP FUNCTION IF EXISTS ArcLength;

DELIMITER $$

CREATE FUNCTION ArcLength
(
   dRadius          DOUBLE,

   dX0              DOUBLE,
   dY0              DOUBLE,
   dZ0              DOUBLE,

   dX               DOUBLE,
   dY               DOUBLE,
   dZ               DOUBLE
)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
            -- arc length = 2 * radius * arcsin (distance / (2 * radius))

            -- This function assumes dX0, dY0, and dZ0 have already been normalized to dRadius
            -- Origins in the database sit below the surface and must also be normalized to dRadius

       DECLARE dNormal DOUBLE DEFAULT dRadius / SQRT ((dX * dX) + (dY * dY) + (dZ * dZ));

           SET dX = dX * dNormal;
           SET dY = dY * dNormal;
           SET dZ = dZ * dNormal;

           SET dX = dX - dX0;
           SET dY = dY - dY0;
           SET dZ = dZ - dZ0;

        RETURN (2.0 * dRadius) * ASIN (SQRT ((dX * dX) + (dY * dY) + (dZ * dZ)) / (2.0 * dRadius));
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
