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

DROP PROCEDURE IF EXISTS call_RMTObject_Select;

DELIMITER $$

CREATE PROCEDURE call_RMTObject_Select
(
   IN nResultSet                   INT
)
BEGIN
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;

        SELECT CONCAT
               (
                 '{ ',
                    '"pObjectHead": ',   Format_ObjectHead
                                         (
                                            t.ObjectHead_Parent_wClass,
                                            t.ObjectHead_Parent_twObjectIx,
                                            t.ObjectHead_Self_wClass,
                                            t.ObjectHead_Self_twObjectIx,
                                            IF (nResultSet = 0, OBJECTHEAD_FLAG_SUBSCRIBE_FULL, OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            t.ObjectHead_twEventIz
                                         ),

                  ', "twRMTObjectIx": ', t.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         Format_Name_T
                                         (
                                            t.Name_wsRMTObjectId
                                         ),
                  ', "pType": ',         Format_Type_T
                                         (
                                            t.Type_bType,
                                            t.Type_bSubtype,
                                            t.Type_bFiction
                                         ),
                  ', "pOwner": ',        Format_Owner
                                         (
                                            t.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     Format_Resource
                                         (
                                            t.Resource_qwResource,
                                            t.Resource_sName,
                                            t.Resource_sReference
                                         ),
                  ', "pTransform": ',    Format_Transform
                                         (
                                            t.Transform_Position_dX,
                                            t.Transform_Position_dY,
                                            t.Transform_Position_dZ,
                                            t.Transform_Rotation_dX,
                                            t.Transform_Rotation_dY,
                                            t.Transform_Rotation_dZ,
                                            t.Transform_Rotation_dW,
                                            t.Transform_Scale_dX,
                                            t.Transform_Scale_dY,
                                            t.Transform_Scale_dZ
                                         ),
                  ', "pBound": ',        Format_Bound
                                         (
                                            t.Bound_dX,
                                            t.Bound_dY,
                                            t.Bound_dZ
                                         ),
                  ', "pProperties": ',   Format_Properties_T
                                         (
                                            t.Properties_bLockToGround,
                                            t.Properties_bYouth,
                                            t.Properties_bAdult,
                                            t.Properties_bAvatar
                                         ),

                  ', "nChildren":  ',    IFNULL (cat.nCount, 0) + IFNULL (cap.nCount, 0),
                 ' }'               
               ) AS `Object`
          FROM Results   AS x
          JOIN RMTObject AS t on t.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMTObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cat ON cat.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
     LEFT JOIN (SELECT ObjectHead_Parent_twObjectIx, COUNT(*) AS nCount FROM RMPObject WHERE ObjectHead_Parent_wClass = SBO_CLASS_RMTOBJECT GROUP BY ObjectHead_Parent_twObjectIx) AS cap ON cap.ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx
         WHERE x.nResultSet = nResultSet;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
