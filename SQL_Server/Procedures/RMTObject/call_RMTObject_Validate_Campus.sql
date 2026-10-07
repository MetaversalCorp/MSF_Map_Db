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

DROP PROCEDURE IF EXISTS dbo.call_RMTObject_Validate_Campus
GO

CREATE PROCEDURE dbo.call_RMTObject_Validate_Campus
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMTObjectIx                BIGINT,
   @dLatitude_Min                FLOAT (53),
   @dLatitude_Max                FLOAT (53),
   @dLongitude_Min               FLOAT (53),
   @dLongitude_Max               FLOAT (53),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71
       DECLARE @SBO_CLASS_RMTOBJECT                       INT = 72

            IF @dLatitude_Min IS NULL OR @dLatitude_Min <> @dLatitude_Min
               EXEC dbo.call_Error 21, 'dLatitude_Min is NULL or NaN',  @nError OUTPUT
       ELSE IF @dLatitude_Min NOT BETWEEN -180 AND 180
               EXEC dbo.call_Error 21, 'dLatitude_Min is invalid',      @nError OUTPUT

            IF @dLatitude_Max IS NULL OR @dLatitude_Max <> @dLatitude_Max
               EXEC dbo.call_Error 21, 'dLatitude_Max is NULL or NaN',  @nError OUTPUT
       ELSE IF @dLatitude_Max NOT BETWEEN -180 AND 180
               EXEC dbo.call_Error 21, 'dLatitude_Max is invalid',      @nError OUTPUT

            IF @dLongitude_Min IS NULL OR @dLongitude_Min <> @dLongitude_Min
               EXEC dbo.call_Error 21, 'dLongitude_Min is NULL or NaN', @nError OUTPUT
       ELSE IF @dLongitude_Min NOT BETWEEN -180 AND 180
               EXEC dbo.call_Error 21, 'dLongitude_Min is invalid',     @nError OUTPUT

            IF @dLongitude_Max IS NULL OR @dLongitude_Max <> @dLongitude_Max
               EXEC dbo.call_Error 21, 'dLongitude_Max is NULL or NaN', @nError OUTPUT
       ELSE IF @dLongitude_Max NOT BETWEEN -180 AND 180
               EXEC dbo.call_Error 21, 'dLongitude_Max is invalid',     @nError OUTPUT

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
