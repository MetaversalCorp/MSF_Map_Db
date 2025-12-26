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

-- DATETIME2  reports time in 1/10000000 sec from UTC Jan 1, 0001
-- S3         reports time in 1/64       sec from UTC Jan 1, 1601
-- There are  584388 days between UTC Jan 1, 0001 and UTC Jan 1, 1601
-- There are 5529600 1/64 sec per day

-- 584388 * 5529600 = 3231431884800

DROP FUNCTION IF EXISTS Time_DateTime2;

DELIMITER $$

CREATE FUNCTION Time_DateTime2
(
   dtStamp DATETIME  -- DATETIME values must be in UTC and generally generated from UTC_TIMESTAMP()
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
      -- Convert MySQL DATETIME to S3 timestamp format
      -- MySQL uses seconds since 1970, S3 uses 1/64 sec since 1601
      -- There are 134774 days between Jan 1, 1601 and Jan 1, 1970
      -- 134774 * 86400 * 64 = 745246310400
      RETURN (UNIX_TIMESTAMP(dtStamp) * 64) + 745246310400;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
