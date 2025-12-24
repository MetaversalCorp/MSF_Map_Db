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

CREATE FUNCTION dbo.Format_Double
(
   @d   FLOAT (53)
)
RETURNS NVARCHAR (32)
AS
BEGIN

      DECLARE @dA      FLOAT (53)    = ABS (@d)
      DECLARE @e       INT           = 0
      DECLARE @sSign   NVARCHAR (1)  = ''
      DECLARE @sExp    NVARCHAR (8)  = ''
      DECLARE @sNum    NVARCHAR (20) = ''

           IF (@dA <> @d)
              SET @sSign = '-'

           IF @dA <> 0  AND  @dA <> 1
        BEGIN
                   IF @dA < CAST ('1e+0' AS FLOAT (53))
                BEGIN
                      WHILE (@dA < CAST (CONCAT ('1e', 0 - @e) AS FLOAT (53))  AND  @e < 310)
                            SET @e += 1

                        SET @dA  *= CAST (CONCAT ('1e+', @e) AS FLOAT (53))
                        SET @sExp = CONCAT ('e-', @e)
                  END
              ELSE IF @dA >= CAST ('1e+1' AS FLOAT (53))
                BEGIN
                      WHILE (@dA >= CAST (CONCAT ('1e+', @e + 1) AS FLOAT (53))  AND  @e < 310)
                            SET @e += 1

                        SET @dA  *= CAST (CONCAT ('1e-', @e) AS FLOAT (53))
                        SET @sExp = CONCAT ('e+', @e)
                  END
          END

           IF (FLOOR (@da) = CEILING (@da))
              SET @sNum = STR (@da, 1)
         ELSE SET @sNum = STR (@dA, 18, 16)

       RETURN CONCAT (@sSign, @sNum, @sExp)
  END
GO

/******************************************************************************************************************************/
