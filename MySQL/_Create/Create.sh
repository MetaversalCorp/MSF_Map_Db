
#!/bin/bash
#  Copyright 2025 Metaversal Corporation.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
#  SPDX-License-Identifier: Apache-2.0

# Ensure script stops on error
set -e

# Copy Database.sql to _Distrib/MSF_Map.sql
cp ./Database.sql ../_Distrib/MSF_Map.sql

# Append contents of all .sql files from each directory to MSF_Map.sql
cat ../Users/*.sql                >> ../_Distrib/MSF_Map.sql
cat ../Tables/*.sql               >> ../_Distrib/MSF_Map.sql
cat ../Views/*.sql                >> ../_Distrib/MSF_Map.sql
cat ../Functions/*.sql            >> ../_Distrib/MSF_Map.sql
cat ../Procedures/*.sql           >> ../_Distrib/MSF_Map.sql
cat ../Procedures/ETL/*.sql       >> ../_Distrib/MSF_Map.sql
cat ../Procedures/RMPObject/*.sql >> ../_Distrib/MSF_Map.sql
cat ../Procedures/RMTMatrix/*.sql >> ../_Distrib/MSF_Map.sql
cat ../Procedures/RMTObject/*.sql >> ../_Distrib/MSF_Map.sql
cat ../Procedures/RMCObject/*.sql >> ../_Distrib/MSF_Map.sql
cat ../Procedures/RMRoot/*.sql    >> ../_Distrib/MSF_Map.sql
cat ../Jobs/*.sql                 >> ../_Distrib/MSF_Map.sql
