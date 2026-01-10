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

DELIMITER $$

CREATE PROCEDURE temp_Version_0
(
)
BEGIN
       DECLARE nResult INT;

            IF NOT EXISTS (SELECT 1 FROM Version WHERE nVersion = 0)
          THEN
                 INSERT INTO Admin
                        ( twRPersonaIx )
                 VALUES ( 1            );
         
                 INSERT INTO RMRoot
                        ( ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMRootId, Owner_twRPersonaIx )
                 VALUES ( 52,                       1,                            70,                     0,                    32,                'Root',          1                  );
                 
                 INSERT INTO RMCType
                        (bType, sType)
                 VALUES ( 0, ''              ),
                        ( 1, 'Universe'      ),
                        ( 2, 'Supercluster'  ),
                        ( 3, 'Galaxy Cluster'),
                        ( 4, 'Galaxy'        ),
                        ( 5, 'Black Hole'    ),
                        ( 6, 'Nebula'        ),
                        ( 7, 'Star Cluster'  ),
                        ( 8, 'Constellation' ),
                        ( 9, 'Star System'   ),
                        (10, 'Star'          ),
                        (11, 'Planet System' ),
                        (12, 'Planet'        ),
                        (13, 'Moon'          ),
                        (14, 'Debris'        ),
                        (15, 'Satellite'     ),
                        (16, 'Transport'     ),
                        (17, 'Surface'       );
                 
                 INSERT INTO RMTType
                        (bType, sType)
                 VALUES ( 0, ''         ),
                        ( 1, 'Root'     ),
                        ( 2, 'Water'    ),
                        ( 3, 'Land'     ),
                        ( 4, 'Country'  ),
                        ( 5, 'Territory'),
                        ( 6, 'State'    ),
                        ( 7, 'County'   ),
                        ( 8, 'City'     ),
                        ( 9, 'Community'),
                        (10, 'Sector'   ),
                        (11, 'Parcel'   );
                 
                 INSERT INTO RMPType
                        (bType, sType)
                 VALUES ( 0, ''         ),
                        ( 1, 'Transport'),
                        ( 2, 'Other'    );
         
                 INSERT INTO Version
                        ( nVersion, sDescription )
                 VALUES ( 0,        'Initialize Database');
        END IF ;
END$$
  
DELIMITER ;

CALL temp_Version_0 ();

DROP PROCEDURE temp_Version_0;

/* ************************************************************************************************************************** */
