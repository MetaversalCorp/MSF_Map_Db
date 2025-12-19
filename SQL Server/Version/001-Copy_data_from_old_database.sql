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

            IF NOT EXISTS (SELECT 1 FROM dbo.Version WHERE nVersion = 1)
         BEGIN
                     IF EXISTS (SELECT 1 FROM sys.databases WHERE name = N'MVD_RP1_Map')
                  BEGIN
                          INSERT RMCObject
                               ( ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity )
                          SELECT ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMCObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Orbit_Spin_tmPeriod, Orbit_Spin_tmStart, Orbit_Spin_dA, Orbit_Spin_dB, Bound_dX, Bound_dY, Bound_dZ, Properties_fMass, Properties_fGravity, Properties_fColor, Properties_fBrightness, Properties_fReflectivity
                            FROM MVD_RP1_Map.dbo.RMCObject
                        ORDER BY ObjectHead_Self_twObjectIx
               
                          INSERT RMTObject
                               ( ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar )
                          SELECT ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMTObjectId, Type_bType, Type_bSubtype, Type_bFiction, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ, Properties_bLockToGround, Properties_bYouth, Properties_bAdult, Properties_bAvatar
                            FROM MVD_RP1_Map.dbo.RMTObject
                        ORDER BY ObjectHead_Self_twObjectIx
               
                          INSERT RMTSubsurface
                               ( bnMatrix, d00, d01, d02, d03, d10, d11, d12, d13, d20, d21, d22, d23, d30, d31, d32, d33 )
                          SELECT bnMatrix, d00, d01, d02, d03, d10, d11, d12, d13, d20, d21, d22, d23, d30, d31, d32, d33
                            FROM MVD_RP1_Map.dbo.RMTSubsurface
                        ORDER BY twRMTObjectIx
      
                          INSERT RMTMatrix
                               ( twRMTObjectIx, tnGeometry, dA, dB, dC )
                          SELECT twRMTObjectIx, tnGeometry, dA, dB, dC
                            FROM MVD_RP1_Map.dbo.RMTMatrix
                        ORDER BY bnMatrix
      
                          INSERT RMPObject
                               ( ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ )
                          SELECT ObjectHead_Parent_wClass, ObjectHead_Parent_twObjectIx, ObjectHead_Self_wClass, ObjectHead_Self_twObjectIx, ObjectHead_twEventIz, ObjectHead_wFlags, Name_wsRMPObjectId, Type_bType, Type_bSubtype, Type_bFiction, Type_bMovable, Owner_twRPersonaIx, Resource_qwResource, Resource_sName, Resource_sReference, Transform_Position_dX, Transform_Position_dY, Transform_Position_dZ, Transform_Rotation_dX, Transform_Rotation_dY, Transform_Rotation_dZ, Transform_Rotation_dW, Transform_Scale_dX, Transform_Scale_dY, Transform_Scale_dZ, Bound_dX, Bound_dY, Bound_dZ
                            FROM MVD_RP1_Map.dbo.RMPObject
                           WHERE ObjectHead_Self_twObjectIx > 2
                        ORDER BY ObjectHead_Self_twObjectIx
      
                    END
      
                 INSERT Version
                        ( nVersion, sDescription )
                 VALUES ( 1,        'Copy data from old database');
           END
GO

/******************************************************************************************************************************/
