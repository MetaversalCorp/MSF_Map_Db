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

CREATE PROCEDURE dbo.call_RMCObject_Validate_Orbit_Spin
(
   @ObjectHead_Parent_wClass     SMALLINT,
   @ObjectHead_Parent_twObjectIx BIGINT,
   @twRMCObjectIx                BIGINT,
   @Orbit_Spin_tmPeriod          BIGINT,
   @Orbit_Spin_tmStart           BIGINT,
   @Orbit_Spin_dA                FLOAT (53),
   @Orbit_Spin_dB                FLOAT (53),
   @nError                       INT = 0         OUTPUT
)
AS
BEGIN
           SET NOCOUNT ON

       DECLARE @SBO_CLASS_RMROOT                          INT = 70
       DECLARE @SBO_CLASS_RMCOBJECT                       INT = 71

            IF @Orbit_Spin_tmPeriod IS NULL
               EXEC dbo.call_Error 21, 'Orbit_Spin_tmPeriod is NULL',    @nError OUTPUT
       ELSE IF @Orbit_Spin_tmPeriod < 0
               EXEC dbo.call_Error 21, 'Orbit_Spin_tmPeriod is invalid', @nError OUTPUT

            IF @Orbit_Spin_tmStart IS NULL
               EXEC dbo.call_Error 21, 'Orbit_Spin_tmStart is NULL',     @nError OUTPUT
       ELSE IF @Orbit_Spin_tmStart NOT BETWEEN 0 AND @Orbit_Spin_tmPeriod
               EXEC dbo.call_Error 21, 'Orbit_Spin_tmStart is invalid',  @nError OUTPUT

            IF @Orbit_Spin_dA IS NULL OR @Orbit_Spin_dA <> @Orbit_Spin_dA
               EXEC dbo.call_Error 21, 'Orbit_Spin_dA is NULL or NaN',   @nError OUTPUT
       ELSE IF @Orbit_Spin_dA < 0
               EXEC dbo.call_Error 21, 'Orbit_Spin_dA is invalid',       @nError OUTPUT

            IF @Orbit_Spin_dB IS NULL OR @Orbit_Spin_dB <> @Orbit_Spin_dB
               EXEC dbo.call_Error 21, 'Orbit_Spin_dB is NULL or NaN',   @nError OUTPUT
       ELSE IF @Orbit_Spin_dB < 0
               EXEC dbo.call_Error 21, 'Orbit_Spin_dB is invalid',       @nError OUTPUT

            IF @nError = 0
         BEGIN
               -- validate bound is inside  parent's   bound
               -- validate bound is outside children's bound
                  SET @nError = @nError
           END

        RETURN @nError
  END
GO

/******************************************************************************************************************************/
