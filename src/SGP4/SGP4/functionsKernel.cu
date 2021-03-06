#include "common.h"
#include "commonCUDA.cuh"
#include <math_constants.h>


/* -----------------------------------------------------------------------------
*
*                           function gstime
*
*  this function finds the greenwich sidereal time.
*
*  author        : david vallado                  719-573-2600    1 mar 2001
*
*  inputs          description                    range / units
*    jdut1       - julian date in ut1             days from 4713 bc
*
*  outputs       :
*    gstime      - greenwich sidereal time        0 to 2pi rad
*
*  locals        :
*    temp        - temporary variable for doubles   rad
*    tut1        - julian centuries from the
*                  jan 1, 2000 12 h epoch (ut1)
*
*  coupling      :
*    none
*
*  references    :
*    vallado       2004, 191, eq 3-45
* --------------------------------------------------------------------------- */

__device__ t_var  gstime
	(
	t_var jdut1
	)
{
	const t_var twopi = 2.0 * CUDART_PI;
	const t_var deg2rad = CUDART_PI / 180.0;
	t_var       temp, tut1;

	tut1 = (jdut1 - 2451545.0) / 36525.0;
	temp = -6.2e-6* tut1 * tut1 * tut1 + 0.093104 * tut1 * tut1 +
		(876600.0*3600 + 8640184.812866) * tut1 + 67310.54841;  // sec
	temp = fmod(temp * deg2rad / (t_var)240.0, twopi); //360/86400 = 1/240, to deg, to rad

	// ------------------------ check quadrants ---------------------
	if (temp < 0.0)
		temp += twopi;

	return temp;
}  // end gstime

