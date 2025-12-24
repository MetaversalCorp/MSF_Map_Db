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

-- DATETIME2  reports time in 1/10000000 sec from UTC Jan 1, 0001
-- JavaScript reports time in 1/1000     sec from UTC Jan 1, 1970 (Unix Epoch Time)
-- There are  719162 days between Jan 1, 0001 and Jan 1, 1970
-- There are 86400000 1/1000 sec per day

CREATE FUNCTION dbo.Date_DateTime2
(
   @dtStamp DATETIME2  -- DATETIME2 values must be in UTC and generally generated from GETUTCDATE ()
)
RETURNS BIGINT
AS
BEGIN
      DECLARE @vb10 VARBINARY (10), 
              @date BIGINT, 
              @time BIGINT

          SET @vb10 = CONVERT (VARBINARY (10), @dtStamp)
          SET @vb10 = CONVERT (VARBINARY (10), REVERSE (@vb10))

          SET @date = CAST (SUBSTRING (@vb10, 1, 3) AS BIGINT)
          SET @time = CAST (SUBSTRING (@vb10, 4, 5) AS BIGINT)

          SET @date -= 719162 -- shift from (SQL) Jan 1, 0001 to (JavaScript) Jan 1, 1970
          SET @time /= 10000

       RETURN @date * 86400000 + @time
  END
GO

/******************************************************************************************************************************/
