/***************************** STOCR.CPP *********************** 2006-10-21 AF *
*
* Interface of non-uniform random number generators to R-language implementation.
*
* This file contains source code for the class StocRBase defined in stocR.h.
*
* Documentation:
* ==============
*
* © 2006 Agner Fog. GNU General Public License www.gnu.org/copyleft/gpl.html
*******************************************************************************/

#include "stocc.h"                     // class definition

/***********************************************************************
Fatal error exit (Replaces userintf.cpp)
***********************************************************************/

void FatalError(char * ErrorText) {
   // This function outputs an error message and aborts the program.
   error("%s", ErrorText);             // Error exit in R.DLL
}
