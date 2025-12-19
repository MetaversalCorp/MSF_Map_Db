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

CREATE TABLE IF NOT EXISTS RMTSubsurface
(
   twRMTObjectIx                       BIGINT            NOT NULL,
                                                                 --                        Nul      Car      Cyl      Geo
   tnGeometry                          TINYINT UNSIGNED  NOT NULL, --                        0        1        2        3
   dA                                  DOUBLE            NOT NULL,      -- original coordinates   -        x        angle    latitude
   dB                                  DOUBLE            NOT NULL,      -- original coordinates   -        y        y        longitude
   dC                                  DOUBLE            NOT NULL,      -- original coordinates   -        z        radius   radius

-- bnMatrix =  twRMTObjectIx is the         transform for this subsurface
-- bnMatrix = -twRMTObjectIx is the inverse transform for this subsurface

   PRIMARY KEY
   (
      twRMTObjectIx                    ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS RMTMatrix
(
   bnMatrix                            BIGINT            NOT NULL,

   d00                                 DOUBLE            NOT NULL DEFAULT 1,
   d01                                 DOUBLE            NOT NULL DEFAULT 0,
   d02                                 DOUBLE            NOT NULL DEFAULT 0,
   d03                                 DOUBLE            NOT NULL DEFAULT 0,

   d10                                 DOUBLE            NOT NULL DEFAULT 0,
   d11                                 DOUBLE            NOT NULL DEFAULT 1,
   d12                                 DOUBLE            NOT NULL DEFAULT 0,
   d13                                 DOUBLE            NOT NULL DEFAULT 0,

   d20                                 DOUBLE            NOT NULL DEFAULT 0,
   d21                                 DOUBLE            NOT NULL DEFAULT 0,
   d22                                 DOUBLE            NOT NULL DEFAULT 1,
   d23                                 DOUBLE            NOT NULL DEFAULT 0,

   d30                                 DOUBLE            NOT NULL DEFAULT 0,
   d31                                 DOUBLE            NOT NULL DEFAULT 0,
   d32                                 DOUBLE            NOT NULL DEFAULT 0,
   d33                                 DOUBLE            NOT NULL DEFAULT 1,

   PRIMARY KEY
   (
      bnMatrix                         ASC
   )
)
ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

/* ************************************************************************************************************************** */
