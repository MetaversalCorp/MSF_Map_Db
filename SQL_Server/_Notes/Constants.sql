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

-- Object

       DECLARE @SBO_CLASS_NULL                            INT = 0
       DECLARE @SBO_CLASS_RROOT                           INT = 52
       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72
       DECLARE @SBO_CLASS_RMPOBJECT                       INT = 73

       DECLARE @OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL         INT = 0x10
       DECLARE @OBJECTHEAD_FLAG_SUBSCRIBE_FULL            INT = 0x20

-- RMRoot

       DECLARE @RMROOT_OP_NULL                            INT = 0
       DECLARE @RMROOT_OP_NAME                            INT = 1
    -- DECLARE @RMROOT_OP_TYPE                            INT = 2
       DECLARE @RMROOT_OP_OWNER                           INT = 3
    -- DECLARE @RMROOT_OP_RESOURCE                        INT = 4
    -- DECLARE @RMROOT_OP_TRANSFORM                       INT = 5
    -- DECLARE @RMROOT_OP_ORBIT                           INT = 6
    -- DECLARE @RMROOT_OP_SPIN                            INT = 7
    -- DECLARE @RMROOT_OP_BOUND                           INT = 8
    -- DECLARE @RMROOT_OP_PROPERTIES                      INT = 9
    -- DECLARE @RMROOT_OP_RMROOT_OPEN                     INT = 10
    -- DECLARE @RMROOT_OP_RMROOT_CLOSE                    INT = 11
       DECLARE @RMROOT_OP_RMCOBJECT_OPEN                  INT = 12
       DECLARE @RMROOT_OP_RMCOBJECT_CLOSE                 INT = 13
       DECLARE @RMROOT_OP_RMTOBJECT_OPEN                  INT = 14
       DECLARE @RMROOT_OP_RMTOBJECT_CLOSE                 INT = 15
       DECLARE @RMROOT_OP_RMPOBJECT_OPEN                  INT = 16
       DECLARE @RMROOT_OP_RMPOBJECT_CLOSE                 INT = 17

-- RMCObject

       DECLARE @MVO_RMCOBJECT_TYPE_SATELLITE              INT = 15
       DECLARE @MVO_RMCOBJECT_TYPE_SURFACE                INT = 17

       DECLARE @RMCOBJECT_OP_NULL                         INT = 0
       DECLARE @RMCOBJECT_OP_NAME                         INT = 1
       DECLARE @RMCOBJECT_OP_TYPE                         INT = 2
       DECLARE @RMCOBJECT_OP_OWNER                        INT = 3
       DECLARE @RMCOBJECT_OP_RESOURCE                     INT = 4
       DECLARE @RMCOBJECT_OP_TRANSFORM                    INT = 5
       DECLARE @RMCOBJECT_OP_ORBIT_SPIN                   INT = 6
       DECLARE @RMCOBJECT_OP_BOUND                        INT = 7
       DECLARE @RMCOBJECT_OP_PROPERTIES                   INT = 8
    -- DECLARE @RMCOBJECT_OP_RMROOT_OPEN                  INT = 9
    -- DECLARE @RMCOBJECT_OP_RMROOT_CLOSE                 INT = 10
       DECLARE @RMCOBJECT_OP_RMCOBJECT_OPEN               INT = 11
       DECLARE @RMCOBJECT_OP_RMCOBJECT_CLOSE              INT = 12
       DECLARE @RMCOBJECT_OP_RMTOBJECT_OPEN               INT = 13
       DECLARE @RMCOBJECT_OP_RMTOBJECT_CLOSE              INT = 14
    -- DECLARE @RMCOBJECT_OP_RMPOBJECT_OPEN               INT = 15
    -- DECLARE @RMCOBJECT_OP_RMPOBJECT_CLOSE              INT = 16

-- RMTObject

       DECLARE @MVO_RMTOBJECT_TYPE_COMMUNITY              INT = 9
       DECLARE @MVO_RMTOBJECT_TYPE_PARCEL                 INT = 11

       DECLARE @RMTOBJECT_OP_NULL                         INT = 0
       DECLARE @RMTOBJECT_OP_NAME                         INT = 1
       DECLARE @RMTOBJECT_OP_TYPE                         INT = 2
       DECLARE @RMTOBJECT_OP_OWNER                        INT = 3
       DECLARE @RMTOBJECT_OP_RESOURCE                     INT = 4
       DECLARE @RMTOBJECT_OP_TRANSFORM                    INT = 5
    -- DECLARE @RMTOBJECT_OP_ORBIT                        INT = 6
    -- DECLARE @RMTOBJECT_OP_SPIN                         INT = 7
       DECLARE @RMTOBJECT_OP_BOUND                        INT = 8
       DECLARE @RMTOBJECT_OP_PROPERTIES                   INT = 9
    -- DECLARE @RMTOBJECT_OP_RMROOT_OPEN                  INT = 10
    -- DECLARE @RMTOBJECT_OP_RMROOT_CLOSE                 INT = 11
    -- DECLARE @RMTOBJECT_OP_RMCOBJECT_OPEN               INT = 12
    -- DECLARE @RMTOBJECT_OP_RMCOBJECT_CLOSE              INT = 13
       DECLARE @RMTOBJECT_OP_RMTOBJECT_OPEN               INT = 14
       DECLARE @RMTOBJECT_OP_RMTOBJECT_CLOSE              INT = 15
       DECLARE @RMTOBJECT_OP_RMPOBJECT_OPEN               INT = 16
       DECLARE @RMTOBJECT_OP_RMPOBJECT_CLOSE              INT = 17

-- RMPObject

       DECLARE @RMPOBJECT_OP_NULL                         INT = 0
       DECLARE @RMPOBJECT_OP_NAME                         INT = 1
       DECLARE @RMPOBJECT_OP_TYPE                         INT = 2
       DECLARE @RMPOBJECT_OP_OWNER                        INT = 3
       DECLARE @RMPOBJECT_OP_RESOURCE                     INT = 4
       DECLARE @RMPOBJECT_OP_TRANSFORM                    INT = 5
    -- DECLARE @RMPOBJECT_OP_ORBIT                        INT = 6
    -- DECLARE @RMPOBJECT_OP_SPIN                         INT = 7
       DECLARE @RMPOBJECT_OP_BOUND                        INT = 8
    -- DECLARE @RMPOBJECT_OP_PROPERTIES                   INT = 9
    -- DECLARE @RMPOBJECT_OP_RMROOT_OPEN                  INT = 10
    -- DECLARE @RMPOBJECT_OP_RMROOT_CLOSE                 INT = 11
    -- DECLARE @RMPOBJECT_OP_RMCOBJECT_OPEN               INT = 12
    -- DECLARE @RMPOBJECT_OP_RMCOBJECT_CLOSE              INT = 13
    -- DECLARE @RMPOBJECT_OP_RMTOBJECT_OPEN               INT = 14
    -- DECLARE @RMPOBJECT_OP_RMTOBJECT_CLOSE              INT = 15
       DECLARE @RMPOBJECT_OP_RMPOBJECT_OPEN               INT = 16
       DECLARE @RMPOBJECT_OP_RMPOBJECT_CLOSE              INT = 17
       DECLARE @RMPOBJECT_OP_PARENT                       INT = 18

-- RMTMatrix

       DECLARE @RMTMATRIX_COORD_NUL                       INT = 0
       DECLARE @RMTMATRIX_COORD_CAR                       INT = 1
       DECLARE @RMTMATRIX_COORD_CYL                       INT = 2
       DECLARE @RMTMATRIX_COORD_GEO                       INT = 3

/******************************************************************************************************************************/
