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

-- TIME reports time in 1/64 sec from UTC Jan 1, 1601
-- UNIX reports time in 1/1000 sec from UTC Jan 1, 1970
-- There are  134774 days between UTC Jan 1, 1601 and UTC Jan 1, 1970
-- There are 5529600 1/64 sec per day

-- 134774 * 5529600 = 745246310400

CREATE FUNCTION dbo.DateTime2_Time
(
   @tmStamp BIGINT
)
RETURNS DATETIME2  -- DATETIME2 values must be in UTC
AS
BEGIN

      DECLARE @dt2 DATETIME2,
              @s   BIGINT,
              @mcs BIGINT

          SET @tmStamp -= 745246310400

          SET @s        = @tmStamp / 64;

          SET @mcs      = @tmStamp % 64;
          SET @mcs     *= 1000000
          SET @mcs     /= 64

          SET @dt2 = dateadd (s,   @s, '1970-01-01')
          SET @dt2 = dateadd (mcs, @mcs, @dt2)

       RETURN @dt2
  END
GO

/******************************************************************************************************************************/
