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

CREATE FUNCTION dbo.IPstob
(
   @sIPAddress     NVARCHAR (16)
)
RETURNS BINARY (4)
AS
BEGIN
      DECLARE @a       INT,
              @b       INT,
              @c       INT,
              @x       BIGINT

          SET @a = CHARINDEX ('.', @sIPAddress)
          SET @b = CHARINDEX ('.', @sIPAddress, @a + 1)
          SET @c = CHARINDEX ('.', @sIPAddress, @b + 1)

          SET @x = 0
          SET @x = @x * 256 + CONVERT (BIGINT, SUBSTRING (@sIPAddress,      1,      @a - 1))
          SET @x = @x * 256 + CONVERT (BIGINT, SUBSTRING (@sIPAddress, @a + 1, @b - @a - 1))
          SET @x = @x * 256 + CONVERT (BIGINT, SUBSTRING (@sIPAddress, @b + 1, @c - @b - 1))
          SET @x = @x * 256 + CONVERT (BIGINT, SUBSTRING (@sIPAddress, @c + 1, 16 - @c - 1))

       RETURN CONVERT (BINARY (4), @x)
END
GO

CREATE FUNCTION dbo.IPbtos
(
   @dwIPAddress    BINARY (4)
)
RETURNS NVARCHAR (16)
AS
BEGIN
      RETURN  CONVERT (VARCHAR (3), CONVERT (INT, SUBSTRING (@dwIPAddress, 1, 1)))
      + '.' + CONVERT (VARCHAR (3), CONVERT (INT, SUBSTRING (@dwIPAddress, 2, 1)))
      + '.' + CONVERT (VARCHAR (3), CONVERT (INT, SUBSTRING (@dwIPAddress, 3, 1)))
      + '.' + CONVERT (VARCHAR (3), CONVERT (INT, SUBSTRING (@dwIPAddress, 4, 1)))
END
GO

/******************************************************************************************************************************/
