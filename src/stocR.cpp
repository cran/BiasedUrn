/*************************** stocR.cpp **********************************
* Author:        Agner Fog
* Date created:  2006
* Last modified: 2024-06-15
* Project:       BiasedUrn
* Source URL:    www.agner.org/random
*
* Description:
* Interface of non-uniform random number generators to R-language implementation.
* This file contains source code for the class StocRBase defined in stocR.h.
*
* Copyright 2006-2024 by Agner Fog. 
* GNU General Public License http://www.gnu.org/licenses/gpl.html
*****************************************************************************/

#include "stocc.h"                     // class definition

/***********************************************************************
Fatal error exit (Replaces userintf.cpp)
***********************************************************************/

void FatalError(const char * ErrorText) {
    // This function outputs an error message and aborts the program.
    
    // Error exit in R.DLL, according to the manual "Writing R Extensions". This fails if R_NO_REMAP is defined, 
    // error("%s", ErrorText);
    Rf_error("%s", ErrorText);             // Error exit in R.DLL
}
