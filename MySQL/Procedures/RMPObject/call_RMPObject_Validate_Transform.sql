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

DROP PROCEDURE IF EXISTS call_RMPObject_Validate_Transform;

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Validate_Transform
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMPObjectIx                 BIGINT,
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
   INOUT nError                        INT
)
BEGIN
            IF Transform_Position_dX IS NULL OR Transform_Position_dX <> Transform_Position_dX
          THEN
                   CALL call_Error (21, 'Transform_Position_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dY IS NULL OR Transform_Position_dY <> Transform_Position_dY
          THEN
                   CALL call_Error (21, 'Transform_Position_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Position_dZ IS NULL OR Transform_Position_dZ <> Transform_Position_dZ
          THEN
                   CALL call_Error (21, 'Transform_Position_dZ is NULL or NaN', nError);
        END IF ;

            IF Transform_Rotation_dX IS NULL OR Transform_Rotation_dX <> Transform_Rotation_dX
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dX is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dY IS NULL OR Transform_Rotation_dY <> Transform_Rotation_dY
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dY is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dZ IS NULL OR Transform_Rotation_dZ <> Transform_Rotation_dZ
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dZ is NULL or NaN', nError);
        END IF ;
            IF Transform_Rotation_dW IS NULL OR Transform_Rotation_dW <> Transform_Rotation_dW
          THEN
                   CALL call_Error (21, 'Transform_Rotation_dW is NULL or NaN', nError);
        END IF ;

            IF Transform_Scale_dX IS NULL OR Transform_Scale_dX <> Transform_Scale_dX
          THEN
                   CALL call_Error (21, 'Transform_Scale_dX is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dY IS NULL OR Transform_Scale_dY <> Transform_Scale_dY
          THEN
                   CALL call_Error (21, 'Transform_Scale_dY is NULL or NaN',    nError);
        END IF ;
            IF Transform_Scale_dZ IS NULL OR Transform_Scale_dZ <> Transform_Scale_dZ
          THEN
                   CALL call_Error (21, 'Transform_Scale_dZ is NULL or NaN',    nError);
        END IF ;

            IF nError = 0
          THEN
                     -- validate position is inside parent's bound
                    SET nError = nError;
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
