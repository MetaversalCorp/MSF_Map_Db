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

-- Object

       DECLARE SBO_CLASS_NULL                             INT DEFAULT 0;
       DECLARE SBO_CLASS_RROOT                            INT DEFAULT 52;
       DECLARE SBO_CLASS_RMROOT                           INT DEFAULT 70;
       DECLARE SBO_CLASS_RMCOBJECT                        INT DEFAULT 71;
       DECLARE SBO_CLASS_RMTOBJECT                        INT DEFAULT 72;
       DECLARE SBO_CLASS_RMPOBJECT                        INT DEFAULT 73;

       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_PARTIAL          INT DEFAULT 0x10;
       DECLARE OBJECTHEAD_FLAG_SUBSCRIBE_FULL             INT DEFAULT 0x20;

       DECLARE SUBSCRIBE_REFRESH_EVENT_EX_FLAG_OPEN       INT DEFAULT 0x01;
       DECLARE SUBSCRIBE_REFRESH_EVENT_EX_FLAG_CLOSE      INT DEFAULT 0x02;
       DECLARE SUBSCRIBE_REFRESH_EVENT_EX_FLAG_RESET      INT DEFAULT 0x04;
       DECLARE SUBSCRIBE_REFRESH_EVENT_EX_FLAG_ADDENDUM   INT DEFAULT 0x08;
       DECLARE SUBSCRIBE_REFRESH_EVENT_EX_FLAG_PARTIAL    INT DEFAULT 0x10;

-- RMRoot

       DECLARE RMROOT_OP_NULL                             INT DEFAULT 0;
       DECLARE RMROOT_OP_NAME                             INT DEFAULT 1;
    -- DECLARE RMROOT_OP_TYPE                             INT DEFAULT 2;
       DECLARE RMROOT_OP_OWNER                            INT DEFAULT 3;
    -- DECLARE RMROOT_OP_RESOURCE                         INT DEFAULT 4;
    -- DECLARE RMROOT_OP_TRANSFORM                        INT DEFAULT 5;
    -- DECLARE RMROOT_OP_ORBIT                            INT DEFAULT 6;
    -- DECLARE RMROOT_OP_SPIN                             INT DEFAULT 7;
    -- DECLARE RMROOT_OP_BOUND                            INT DEFAULT 8;
    -- DECLARE RMROOT_OP_PROPERTIES                       INT DEFAULT 9;
    -- DECLARE RMROOT_OP_RMROOT_OPEN                      INT DEFAULT 10;
    -- DECLARE RMROOT_OP_RMROOT_CLOSE                     INT DEFAULT 11;
       DECLARE RMROOT_OP_RMCOBJECT_OPEN                   INT DEFAULT 12;
       DECLARE RMROOT_OP_RMCOBJECT_CLOSE                  INT DEFAULT 13;
       DECLARE RMROOT_OP_RMTOBJECT_OPEN                   INT DEFAULT 14;
       DECLARE RMROOT_OP_RMTOBJECT_CLOSE                  INT DEFAULT 15;
       DECLARE RMROOT_OP_RMPOBJECT_OPEN                   INT DEFAULT 16;
       DECLARE RMROOT_OP_RMPOBJECT_CLOSE                  INT DEFAULT 17;

-- RMCObject

       DECLARE MVO_RMCOBJECT_TYPE_SATELLITE               INT DEFAULT 15;
       DECLARE MVO_RMCOBJECT_TYPE_SURFACE                 INT DEFAULT 17;

       DECLARE RMCOBJECT_OP_NULL                          INT DEFAULT 0;
       DECLARE RMCOBJECT_OP_NAME                          INT DEFAULT 1;
       DECLARE RMCOBJECT_OP_TYPE                          INT DEFAULT 2;
       DECLARE RMCOBJECT_OP_OWNER                         INT DEFAULT 3;
       DECLARE RMCOBJECT_OP_RESOURCE                      INT DEFAULT 4;
       DECLARE RMCOBJECT_OP_TRANSFORM                     INT DEFAULT 5;
       DECLARE RMCOBJECT_OP_ORBIT_SPIN                    INT DEFAULT 6;
       DECLARE RMCOBJECT_OP_BOUND                         INT DEFAULT 7;
       DECLARE RMCOBJECT_OP_PROPERTIES                    INT DEFAULT 8;
    -- DECLARE RMCOBJECT_OP_RMROOT_OPEN                   INT DEFAULT 9;
    -- DECLARE RMCOBJECT_OP_RMROOT_CLOSE                  INT DEFAULT 10;
       DECLARE RMCOBJECT_OP_RMCOBJECT_OPEN                INT DEFAULT 11;
       DECLARE RMCOBJECT_OP_RMCOBJECT_CLOSE               INT DEFAULT 12;
       DECLARE RMCOBJECT_OP_RMTOBJECT_OPEN                INT DEFAULT 13;
       DECLARE RMCOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 14;
    -- DECLARE RMCOBJECT_OP_RMPOBJECT_OPEN                INT DEFAULT 15;
    -- DECLARE RMCOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 16;

-- RMTObject

       DECLARE MVO_RMTOBJECT_TYPE_COMMUNITY               INT DEFAULT 9;
       DECLARE MVO_RMTOBJECT_TYPE_PARCEL                  INT DEFAULT 11;

       DECLARE RMTOBJECT_OP_NULL                          INT DEFAULT 0;
       DECLARE RMTOBJECT_OP_NAME                          INT DEFAULT 1;
       DECLARE RMTOBJECT_OP_TYPE                          INT DEFAULT 2;
       DECLARE RMTOBJECT_OP_OWNER                         INT DEFAULT 3;
       DECLARE RMTOBJECT_OP_RESOURCE                      INT DEFAULT 4;
       DECLARE RMTOBJECT_OP_TRANSFORM                     INT DEFAULT 5;
    -- DECLARE RMTOBJECT_OP_ORBIT                         INT DEFAULT 6;
    -- DECLARE RMTOBJECT_OP_SPIN                          INT DEFAULT 7;
       DECLARE RMTOBJECT_OP_BOUND                         INT DEFAULT 8;
       DECLARE RMTOBJECT_OP_PROPERTIES                    INT DEFAULT 9;
    -- DECLARE RMTOBJECT_OP_RMROOT_OPEN                   INT DEFAULT 10;
    -- DECLARE RMTOBJECT_OP_RMROOT_CLOSE                  INT DEFAULT 11;
    -- DECLARE RMTOBJECT_OP_RMCOBJECT_OPEN                INT DEFAULT 12;
    -- DECLARE RMTOBJECT_OP_RMCOBJECT_CLOSE               INT DEFAULT 13;
       DECLARE RMTOBJECT_OP_RMTOBJECT_OPEN                INT DEFAULT 14;
       DECLARE RMTOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 15;
       DECLARE RMTOBJECT_OP_RMPOBJECT_OPEN                INT DEFAULT 16;
       DECLARE RMTOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 17;

-- RMPObject

       DECLARE RMPOBJECT_OP_NULL                          INT DEFAULT 0;
       DECLARE RMPOBJECT_OP_NAME                          INT DEFAULT 1;
       DECLARE RMPOBJECT_OP_TYPE                          INT DEFAULT 2;
       DECLARE RMPOBJECT_OP_OWNER                         INT DEFAULT 3;
       DECLARE RMPOBJECT_OP_RESOURCE                      INT DEFAULT 4;
       DECLARE RMPOBJECT_OP_TRANSFORM                     INT DEFAULT 5;
    -- DECLARE RMPOBJECT_OP_ORBIT                         INT DEFAULT 6;
    -- DECLARE RMPOBJECT_OP_SPIN                          INT DEFAULT 7;
       DECLARE RMPOBJECT_OP_BOUND                         INT DEFAULT 8;
    -- DECLARE RMPOBJECT_OP_PROPERTIES                    INT DEFAULT 9;
    -- DECLARE RMPOBJECT_OP_RMROOT_OPEN                   INT DEFAULT 10;
    -- DECLARE RMPOBJECT_OP_RMROOT_CLOSE                  INT DEFAULT 11;
    -- DECLARE RMPOBJECT_OP_RMCOBJECT_OPEN                INT DEFAULT 12;
    -- DECLARE RMPOBJECT_OP_RMCOBJECT_CLOSE               INT DEFAULT 13;
    -- DECLARE RMPOBJECT_OP_RMTOBJECT_OPEN                INT DEFAULT 14;
    -- DECLARE RMPOBJECT_OP_RMTOBJECT_CLOSE               INT DEFAULT 15;
       DECLARE RMPOBJECT_OP_RMPOBJECT_OPEN                INT DEFAULT 16;
       DECLARE RMPOBJECT_OP_RMPOBJECT_CLOSE               INT DEFAULT 17;
       DECLARE RMPOBJECT_OP_PARENT                        INT DEFAULT 18;

-- RMTMatrix

       DECLARE RMTMATRIX_COORD_NUL                        INT DEFAULT 0;
       DECLARE RMTMATRIX_COORD_CAR                        INT DEFAULT 1;
       DECLARE RMTMATRIX_COORD_CYL                        INT DEFAULT 2;
       DECLARE RMTMATRIX_COORD_GEO                        INT DEFAULT 3;

/* ************************************************************************************************************************** */
