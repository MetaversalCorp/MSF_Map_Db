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

DROP PROCEDURE IF EXISTS call_RMCObject_Validate_Properties;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Validate_Properties
(
   IN    ObjectHead_Parent_wClass      SMALLINT,
   IN    ObjectHead_Parent_twObjectIx  BIGINT,
   IN    twRMCObjectIx                 BIGINT,
   IN    Properties_fMass              FLOAT,
   IN    Properties_fGravity           FLOAT,
   IN    Properties_fColor             FLOAT,
   IN    Properties_fBrightness        FLOAT,
   IN    Properties_fReflectivity      FLOAT,
   INOUT nError                        INT
)
BEGIN
            IF Properties_fMass IS NULL OR Properties_fMass <> Properties_fMass
          THEN
                   CALL call_Error (21, 'Properties_fMass is NULL or NaN',        nError);
        ELSEIF Properties_fMass < 0
          THEN
                   CALL call_Error (21, 'Properties_fMass is invalid',            nError);
        END IF ;

            IF Properties_fGravity IS NULL OR Properties_fGravity <> Properties_fGravity
          THEN
                   CALL call_Error (21, 'Properties_fGravity is NULL or NaN',     nError);
        ELSEIF Properties_fGravity < 0
          THEN
                   CALL call_Error (21, 'Properties_fGravity is invalid',         nError);
        END IF ;

            IF Properties_fColor IS NULL OR Properties_fColor <> Properties_fColor
          THEN
                   CALL call_Error (21, 'Properties_fColor is NULL or NaN',       nError);
        ELSEIF Properties_fColor < 0
          THEN
                   CALL call_Error (21, 'Properties_fColor is invalid',           nError);
        END IF ;

            IF Properties_fBrightness IS NULL OR Properties_fBrightness <> Properties_fBrightness
          THEN
                   CALL call_Error (21, 'Properties_fBrightness is NULL or NaN',  nError);
        ELSEIF Properties_fBrightness < 0
          THEN
                   CALL call_Error (21, 'Properties_fBrightness is invalid',      nError);
        END IF ;

            IF Properties_fReflectivity IS NULL OR Properties_fReflectivity <> Properties_fReflectivity
          THEN
                  CALL call_Error (21, 'Properties_fReflectivity is NULL or NaN', nError);
        ELSEIF Properties_fReflectivity < 0
          THEN
                   CALL call_Error (21, 'Properties_fReflectivity is invalid',    nError);
        END IF ;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
