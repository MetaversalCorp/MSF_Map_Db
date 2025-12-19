rem  Copyright 2025 Metaversal Corporation.
rem  
rem  Licensed under the Apache License, Version 2.0 (the "License");
rem  you may not use this file except in compliance with the License.
rem  You may obtain a copy of the License at
rem  
rem     https://www.apache.org/licenses/LICENSE-2.0
rem  
rem  Unless required by applicable law or agreed to in writing, software
rem  distributed under the License is distributed on an "AS IS" BASIS,
rem  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem  See the License for the specific language governing permissions and
rem  limitations under the License.
rem  
rem  SPDX-License-Identifier: Apache-2.0

copy  .\Database.sql                      ..\_Distrib\MSF_Map.sql
type ..\Users\*.sql                    >> ..\_Distrib\MSF_Map.sql
type ..\Tables\*.sql                   >> ..\_Distrib\MSF_Map.sql
type ..\Views\*.sql                    >> ..\_Distrib\MSF_Map.sql
type ..\Functions\*.sql                >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\*.sql               >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\ETL\*.sql           >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\RMPObject\*.sql     >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\RMTMatrix\*.sql     >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\RMTObject\*.sql     >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\RMCObject\*.sql     >> ..\_Distrib\MSF_Map.sql
type ..\Procedures\RMRoot\*.sql        >> ..\_Distrib\MSF_Map.sql
type ..\Jobs\*.sql                     >> ..\_Distrib\MSF_Map.sql
type ..\Version\*.sql                  >> ..\_Distrib\MSF_Map.sql
