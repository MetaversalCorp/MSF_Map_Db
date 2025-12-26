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
-- JavaScript reports time in 1/1000     sec from UTC Jan 1, 1970 (Unix Epoch Time)
-- There are  719162 days between Jan 1, 0001 and Jan 1, 1970
-- There are 86400000 1/1000 sec per day

DROP FUNCTION IF EXISTS Date_DateTime2;

DELIMITER $$

CREATE FUNCTION Date_DateTime2
(
   dtStamp DATETIME  -- DATETIME values must be in UTC and generally generated from UTC_TIMESTAMP()
)
RETURNS BIGINT
DETERMINISTIC
BEGIN
      -- Convert MySQL DATETIME to JavaScript timestamp (milliseconds since Jan 1, 1970)
      -- MySQL's UNIX_TIMESTAMP returns seconds since 1970, so multiply by 1000 for milliseconds
      RETURN UNIX_TIMESTAMP(dtStamp) * 1000;
END$$
  
DELIMITER ;

/* ************************************************************************************************************************** */
