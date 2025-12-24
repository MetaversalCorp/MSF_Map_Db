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

IF OBJECT_ID (N'dbo.RMTSubsurface', 'U') IS NULL
CREATE TABLE dbo.RMTSubsurface
(
   twRMTObjectIx                       BIGINT     NOT NULL,
                                                                 --                        Nul      Car      Cyl      Geo
   tnGeometry                          TINYINT    NOT NULL,      --                        0        1        2        3
   dA                                  FLOAT (53) NOT NULL,      -- original coordinates   -        x        angle    latitude
   dB                                  FLOAT (53) NOT NULL,      -- original coordinates   -        y        y        longitude
   dC                                  FLOAT (53) NOT NULL,      -- original coordinates   -        z        radius   radius

-- bnMatrix =  twRMTObjectIx is the         transform for this subsurface
-- bnMatrix = -twRMTObjectIx is the inverse transform for this subsurface

   PRIMARY KEY CLUSTERED
   (
      twRMTObjectIx                    ASC
   ),
)
ON [PRIMARY]
GO

IF OBJECT_ID (N'dbo.RMTMatrix', 'U') IS NULL
CREATE TABLE dbo.RMTMatrix
(
   bnMatrix                            BIGINT     NOT NULL,

   d00                                 FLOAT (53) NOT NULL DEFAULT 1,
   d01                                 FLOAT (53) NOT NULL DEFAULT 0,
   d02                                 FLOAT (53) NOT NULL DEFAULT 0,
   d03                                 FLOAT (53) NOT NULL DEFAULT 0,

   d10                                 FLOAT (53) NOT NULL DEFAULT 0,
   d11                                 FLOAT (53) NOT NULL DEFAULT 1,
   d12                                 FLOAT (53) NOT NULL DEFAULT 0,
   d13                                 FLOAT (53) NOT NULL DEFAULT 0,

   d20                                 FLOAT (53) NOT NULL DEFAULT 0,
   d21                                 FLOAT (53) NOT NULL DEFAULT 0,
   d22                                 FLOAT (53) NOT NULL DEFAULT 1,
   d23                                 FLOAT (53) NOT NULL DEFAULT 0,

   d30                                 FLOAT (53) NOT NULL DEFAULT 0,
   d31                                 FLOAT (53) NOT NULL DEFAULT 0,
   d32                                 FLOAT (53) NOT NULL DEFAULT 0,
   d33                                 FLOAT (53) NOT NULL DEFAULT 1,

   PRIMARY KEY CLUSTERED
   (
      bnMatrix                         ASC
   ),
)
ON [PRIMARY]
GO

/******************************************************************************************************************************/
