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

DROP PROCEDURE IF EXISTS call_RMCObject_Select;

DELIMITER $$

CREATE PROCEDURE call_RMCObject_Select
(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;

        SELECT CONCAT
               (
                 '{ ',
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            c.ObjectHead_Parent_wClass,
                                            c.ObjectHead_Parent_twObjectIx,
                                            c.ObjectHead_Self_wClass,
                                            c.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            c.ObjectHead_twEventIz
                                         ),

                  ', "twRMCObjectIx": ', c.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         Format_Name_C
                                         (
                                            c.Name_wsRMCObjectId
                                         ),
                  ', "pType": ',         Format_Type_C
                                         (
                                            c.Type_bType,
                                            c.Type_bSubtype,
                                            c.Type_bFiction
                                         ),
                  ', "pOwner": ',        Format_Owner
                                         (
                                            c.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     Format_Resource
                                         (
                                            c.Resource_qwResource,
                                            c.Resource_sName,
                                            c.Resource_sReference
                                         ),
                  ', "pTransform": ',    Format_Transform
                                         (
                                            c.Transform_Position_dX,
                                            c.Transform_Position_dY,
                                            c.Transform_Position_dZ,
                                            c.Transform_Rotation_dX,
                                            c.Transform_Rotation_dY,
                                            c.Transform_Rotation_dZ,
                                            c.Transform_Rotation_dW,
                                            c.Transform_Scale_dX,
                                            c.Transform_Scale_dY,
                                            c.Transform_Scale_dZ
                                         ),
                  ', "pOrbit_Spin": ',   Format_Orbit_Spin
                                         (
                                            c.Orbit_Spin_tmPeriod,
                                            c.Orbit_Spin_tmStart,
                                            c.Orbit_Spin_dA,
                                            c.Orbit_Spin_dB
                                         ),
                  ', "pBound": ',        Format_Bound
                                         (
                                            c.Bound_dX,
                                            c.Bound_dY,
                                            c.Bound_dZ
                                         ),
                  ', "pProperties": ',   Format_Properties_C
                                         (
                                            c.Properties_fMass,
                                            c.Properties_fGravity,
                                            c.Properties_fColor,
                                            c.Properties_fBrightness,
                                            c.Properties_fReflectivity
                                         ),

                  ', "nChildren":  ',    IFNULL (cac.nCount, 0) + IFNULL (cat.nCount, 0),
                 ' }'               
               ) AS `Object`
          FROM Results   AS x
          JOIN RMCObject AS c on c.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMCObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cac ON cac.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMTObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMCOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cat ON cat.ObjectHead_Parent_twObjectIx = c.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
