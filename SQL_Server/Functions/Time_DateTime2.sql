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
-- S3         reports time in 1/64       sec from UTC Jan 1, 1601
-- There are  584388 days between UTC Jan 1, 0001 and UTC Jan 1, 1601
-- There are 5529600 1/64 sec per day

-- 584388 * 5529600 = 3231431884800

CREATE FUNCTION dbo.Time_DateTime2
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

          SET @date -= 584388 -- shift from (SQL) Jan 1, 0001 to (S3) Jan 1, 1601
          SET @time /= 156250 -- 10000000 / 64

       RETURN @date * 86400 * 64 + @time
  END
GO

/******************************************************************************************************************************/
