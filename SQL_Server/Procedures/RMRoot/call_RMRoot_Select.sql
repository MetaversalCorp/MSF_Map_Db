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

CREATE PROCEDURE dbo.call_RMRoot_Select
(
   @nResultSet                   INT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL         INT = 0x10
       DECLARE @OBJECTHEAD_FLAG_SUBSCRIBE_FULL            INT = 0x20

        SELECT CONCAT
               (
                 '{ ',
                    '"pObjectHead": ',   dbo.Format_ObjectHead
                                         (
                                            r.ObjectHead_Parent_wClass,
                                            r.ObjectHead_Parent_twObjectIx,
                                            r.ObjectHead_Self_wClass,
                                            r.ObjectHead_Self_twObjectIx,
                                            IIF (@nResultSet = 0, @OBJECTHEAD_FLAG_SUBSCRIBE_FULL, @OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL),
                                            r.ObjectHead_twEventIz
                                         ),
 
                  ', "twRMRootIx": ',    r.ObjectHead_Self_twObjectIx,      -- is this necessary
 
                  ', "pName": ',         dbo.Format_Name_R
                                         (
                                            r.Name_wsRMRootId
                                         ),
                  ', "pOwner": ',        dbo.Format_Owner
                                         (
                                            r.Owner_twRPersonaIx
                                         ),
                 ' }'               
               ) AS [Object]
          FROM #Results   AS x
          JOIN dbo.RMRoot AS r on r.ObjectHead_Self_twObjectIx = x.ObjectHead_Self_twObjectIx
         WHERE nResultSet = @nResultSet
  END
GO

/******************************************************************************************************************************/
