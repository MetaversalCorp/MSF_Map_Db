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

DROP PROCEDURE IF EXISTS call_RMTMatrix_Nul;

DELIMITER $$

CREATE PROCEDURE call_RMTMatrix_Nul
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMTObjectIx                 BIGINT,
   IN    Transform_Position_dX         DOUBLE,
   IN    Transform_Position_dY         DOUBLE,
   IN    Transform_Position_dZ         DOUBLE,
   IN    Transform_Rotation_dX         DOUBLE,
   IN    Transform_Rotation_dY         DOUBLE,
   IN    Transform_Rotation_dZ         DOUBLE,
   IN    Transform_Rotation_dW         DOUBLE,
   IN    Transform_Scale_dX            DOUBLE,
   IN    Transform_Scale_dY            DOUBLE,
   IN    Transform_Scale_dZ            DOUBLE,
   OUT   nResult                       INT
)
BEGIN
       DECLARE SBO_CLASS_RMTOBJECT                       INT DEFAULT 72;
       DECLARE RMTMATRIX_COORD_NUL                       INT DEFAULT 0;

        INSERT INTO RMTSubsurface
               (  twRMTObjectIx, tnGeometry,            dA,  dB,  dC )
        VALUES ( twRMTObjectIx, RMTMATRIX_COORD_NUL,   0,   0,   0 );

        INSERT INTO RMTMatrix
               ( bnMatrix       )
        VALUES ( twRMTObjectIx );

            IF ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT AND ObjectHead_Parent_twObjectIx <> 0
          THEN
               CALL call_RMTMatrix_Mult(twRMTObjectIx, ObjectHead_Parent_twObjectIx);
        END IF ;

          CALL call_RMTMatrix_Translate(twRMTObjectIx, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ);

          CALL call_RMTMatrix_Rotate(twRMTObjectIx, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW);

          CALL call_RMTMatrix_Scale(twRMTObjectIx, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ);

        INSERT INTO RMTMatrix
               ( bnMatrix           )
        VALUES ( 0 - twRMTObjectIx );

          CALL call_RMTMatrix_Inverse(twRMTObjectIx, nResult);
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
