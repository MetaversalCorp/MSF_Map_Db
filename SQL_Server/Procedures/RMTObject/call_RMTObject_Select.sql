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

CREATE PROCEDURE dbo.call_RMTObject_Select
(
   @nResultSet                   INT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL         INT = 0x10
       DECLARE @OBJECTHEAD_FLAG_SUBSCRIBE_FULL            INT = 0x20

       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

        SELECT CONCAT
               (
                 '{ ',
                    '"pObjectHead": ',   dbo.Format_ObjectHead
                                         (
                                            t.ObjectHead_Parent_wClass,
                                            t.ObjectHead_Parent_twObjectIx,
                                            t.ObjectHead_Self_wClass,
                                            t.ObjectHead_Self_twObjectIx,
                                            IIF (@nResultSet = 0, @OBJECTHEAD_FLAG_SUBSCRIBE_FULL, @OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            t.ObjectHead_twEventIz
                                         ),

                  ', "twRMTObjectIx": ', t.ObjectHead_Self_twObjectIx,      -- is this necessary

                  ', "pName": ',         dbo.Format_Name_T
                                         (
                                            t.Name_wsRMTObjectId
                                         ),
                  ', "pType": ',         dbo.Format_Type_T
                                         (
                                            t.Type_bType,
                                            t.Type_bSubtype,
                                            t.Type_bFiction
                                         ),
                  ', "pOwner": ',        dbo.Format_Owner
                                         (
                                            t.Owner_twRPersonaIx
                                         ),
                  ', "pResource": ',     dbo.Format_Resource
                                         (
                                            t.Resource_qwResource,
                                            t.Resource_sName,
                                            t.Resource_sReference
                                         ),
                  ', "pTransform": ',    dbo.Format_Transform
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
                  ', "pBound": ',        dbo.Format_Bound
                                         (
                                            t.Bound_dX,
                                            t.Bound_dY,
                                            t.Bound_dZ
                                         ),
                  ', "pProperties": ',   dbo.Format_Properties_T
                                         (
                                            t.Properties_bLockToGround,
                                            t.Properties_bYouth,
                                            t.Properties_bAdult,
                                            t.Properties_bAvatar
                                         ),

                  ', "nChildren":  ',    cat.nCount + cap.nCount,
                 ' }'               
               ) AS [Object]
          FROM #Results      AS x
          JOIN dbo.RMTObject AS t on t.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
         CROSS APPLY (SELECT COUNT (*) AS nCount FROM dbo.RMTObject WHERE ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx AND ObjectHead_Parent_wClass = @SBO_CLASS_RMTOBJECT) AS cat
         CROSS APPLY (SELECT COUNT (*) AS nCount FROM dbo.RMPObject WHERE ObjectHead_Parent_twObjectIx = t.ObjectHead_Self_twObjectIx AND ObjectHead_Parent_wClass = @SBO_CLASS_RMTOBJECT) AS cap
         WHERE nResultSet = @nResultSet
  END
GO

/******************************************************************************************************************************/
