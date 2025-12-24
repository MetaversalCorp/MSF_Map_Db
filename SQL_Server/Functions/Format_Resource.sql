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

CREATE FUNCTION dbo.Format_Resource
(
   @qwResource               BIGINT,
   @sName                    NVARCHAR (48),
   @sReference               NVARCHAR (128)
)
RETURNS NVARCHAR (256)
AS
BEGIN
      DECLARE @n        INT,
              @sName_   NVARCHAR (128)

          SET @sName_ = @sName

           IF SUBSTRING (@sName, 1, 1) = '~'
        BEGIN
              SET @n = CHARINDEX (':', @sName)
               IF @n > 0  AND  LEN (@sName) = @n + 10
                  SET @sName_ = 'https://' + SUBSTRING (@sName, 2, @n - 2) + '-cdn.rp1.com/sector/' + SUBSTRING (@sName, @n + 1, 1) + '/' + SUBSTRING (@sName, @n + 2, 3) + '/' + SUBSTRING (@sName, @n + 5, 3) + '/' + SUBSTRING (@sName, @n + 1, 10) + '.json'
          END

      RETURN '{ ' + 
                '"qwResource": ' + CAST (@qwResource AS NVARCHAR (32)) + ', ' +
                '"sName": '      + '"' + @sName_                 + '"' + ', ' +
                '"sReference": ' + '"' + @sReference             + '"' +
             ' }'
  END
GO

/******************************************************************************************************************************/
