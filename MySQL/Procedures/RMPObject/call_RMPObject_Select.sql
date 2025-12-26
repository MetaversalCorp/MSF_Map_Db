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

DROP PROCEDURE IF EXISTS call_RMPObject_Select;

DELIMITER $$

CREATE PROCEDURE call_RMPObject_Select
(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

        SELECT CONCAT
               (
                 '{ ',
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            p.ObjectHead_Parent_wClass,
                                            p.ObjectHead_Parent_twObjectIx,
                                            p.ObjectHead_Self_wClass,
                                            p.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            p.ObjectHead_twEventIz
                                         ),

                  ', "twRMPObjectIx": ', p.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         Format_Name_P
                                         (
                                            p.Name_wsRMPObjectId
                                         ),
                  ', "pType": ',         Format_Type_P
                                         (
                                            p.Type_bType,
                                            p.Type_bSubtype,
                                            p.Type_bFiction,
                                            p.Type_bMovable
                                         ),
                  ', "pOwner": ',        Format_Owner
                                         (
                                            p.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     Format_Resource
                                         (
                                            p.Resource_qwResource,
                                            p.Resource_sName,
                                            p.Resource_sReference
                                         ),
                  ', "pTransform": ',    Format_Transform
                                         (
                                            p.Transform_Position_dX,
                                            p.Transform_Position_dY,
                                            p.Transform_Position_dZ,
                                            p.Transform_Rotation_dX,
                                            p.Transform_Rotation_dY,
                                            p.Transform_Rotation_dZ,
                                            p.Transform_Rotation_dW,
                                            p.Transform_Scale_dX,
                                            p.Transform_Scale_dY,
                                            p.Transform_Scale_dZ
                                         ),
                  ', "pBound": ',        Format_Bound
                                         (
                                            p.Bound_dX,
                                            p.Bound_dY,
                                            p.Bound_dZ
                                         ),

                  ', "nChildren":  ',    IFNULL (cap.nCount, 0),
                 ' }'               
               ) AS `Object`
          FROM Results   AS x
          JOIN RMPObject AS p on p.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMPObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMPOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cap ON cap.ObjectHead_Parent_twObjectIx = p.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
