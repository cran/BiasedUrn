/*************************** fnchyppr.cpp **********************************
* Author:        Agner Fog
* Date created:  2002-10-20
* Last modified: 2023-01-29
* Project:       stocc.zip
* Source URL:    www.agner.org/random
*
* Description:
* Calculation of univariate and multivariate Fisher's noncentral hypergeometric
* probability distribution.
*
* This file contains source code for the class CFishersNCHypergeometric 
* and CMultiFishersNCHypergeometric defined in stocc.h.
*
* Documentation:
* ==============
* The file stocc.h contains class definitions.
* Further documentation on www.agner.org/random
*
* Copyright 2002-2023 by Agner Fog. 
* GNU General Public License http://www.gnu.org/licenses/gpl.html
*****************************************************************************/

#include <string.h>                    // memmove function
#include "stocc.h"                     // class definition


/***********************************************************************
Methods for class CFishersNCHypergeometric
***********************************************************************/

CFishersNCHypergeometric::CFishersNCHypergeometric(int32 n, int32 m, int32 N, double odds, double accuracy) {
    // constructor
    // set parameters
    this->n = n;  this->m = m;  this->N = N;
    this->odds = odds;  this->accuracy = accuracy;

    // check validity of parameters
    if (n < 0 || m < 0 || N < 0 || odds < 0. || n > N || m > N) {
        FatalError("Parameter out of range in class CFishersNCHypergeometric");
    }
    if (accuracy < 0) accuracy = 0;
    if (accuracy > 1) accuracy = 1;
    // initialize
    logodds = log(odds);  scale = rsum = 0.;
    ParametersChanged = 1;
    // calculate xmin and xmax
    xmin = m + n - N;  if (xmin < 0) xmin = 0;
    xmax = n;  if (xmax > m) xmax = m;
}


int32 CFishersNCHypergeometric::mode(void) {
    // Find mode (exact)
    // Uses the method of Liao and Rosen, The American Statistician, vol 55,
    // no 4, 2001, p. 366-369.
    // Note that there is an error in Liao and Rosen's formula. 
    // Replace sgn(b) with -1 in Liao and Rosen's formula. 

    double A, B, C, D;                  // coefficients for quadratic equation
    double x;                           // mode
    int32 L = m + n - N;
    int32 m1 = m + 1, n1 = n + 1;

    if (odds == 1.) {
        // simple hypergeometric
        x = (m + 1.) * (n + 1.) / (N + 2.);
    }
    else {
        // calculate analogously to Cornfield mean
        A = 1. - odds;
        B = (m1 + n1) * odds - L;
        C = -(double)m1 * n1 * odds;
        D = B * B - 4 * A * C;
        D = D > 0. ? sqrt(D) : 0.;
        x = (D - B) / (A + A);
    }
    return int32(x);
}


double CFishersNCHypergeometric::mean(void) {
    // Find approximate mean
    // Calculation analogous with mode
    double a, b;                        // temporaries in calculation
    double mean;                        // mean

    if (odds == 1.) {                   // simple hypergeometric
        return double(m) * n / N;
    }
    // calculate Cornfield mean
    a = (m + n) * odds + (N - m - n);
    b = a * a - 4. * odds * (odds - 1.) * m * n;
    b = b > 0. ? sqrt(b) : 0.;
    mean = (a - b) / (2. * (odds - 1.));
    return mean;
}

double CFishersNCHypergeometric::variance(void) {
    // find approximate variance (poor approximation)    
    double my = mean(); // approximate mean
    // find approximate variance from Fisher's noncentral hypergeometric approximation
    double r1 = my * (m - my); double r2 = (n - my) * (my + N - n - m);
    if (r1 <= 0. || r2 <= 0.) return 0.;
    double var = N * r1 * r2 / ((N - 1) * (m * r2 + (N - m) * r1));
    if (var < 0.) var = 0.;
    return var;
}


double CFishersNCHypergeometric::moments(double * mean_, double * var_) {
    // calculate exact mean and variance
    // return value = sum of f(x), expected = 1.
    double y, sy = 0, sxy = 0, sxxy = 0, me1;
    int32 x, xm, x1;
    const double accur = 0.1 * accuracy;     // accuracy of calculation
    xm = (int32)mean();                      // approximation to mean
    for (x = xm; x <= xmax; x++) {
        y = probability(x);
        x1 = x - xm;  // subtract approximate mean to avoid loss of precision in sums
        sy += y; sxy += x1 * y; sxxy += x1 * x1 * y;
        if (y < accur && x != xm) break;
    }
    for (x = xm - 1; x >= xmin; x--) {
        y = probability(x);
        x1 = x - xm;  // subtract approximate mean to avoid loss of precision in sums
        sy += y; sxy += x1 * y; sxxy += x1 * x1 * y;
        if (y < accur) break;
    }
    me1 = sxy / sy;
    *mean_ = me1 + xm;
    y = sxxy / sy - me1 * me1;
    if (y < 0) y = 0;
    *var_ = y;
    return sy;
}


double CFishersNCHypergeometric::probability(int32 x) {
    // calculate probability function
    const double accur = accuracy * 0.1;// accuracy of calculation

    if (x < xmin || x > xmax) return 0;
    if (n == 0) return 1.;

    if (odds == 1.) {
        // central hypergeometric
        return exp(
            LnFac(m) - LnFac(x) - LnFac(m - x) +
            LnFac(N - m) - LnFac(n - x) - LnFac((N - m) - (n - x)) -
            (LnFac(N) - LnFac(n) - LnFac(N - n)));
    }

    if (odds == 0.) {
        if (n > N - m) FatalError("Not enough items with nonzero weight in CFishersNCHypergeometric::probability");
        return x == 0;
    }

    if (!rsum) {
        // first time. calculate rsum = reciprocal of sum of proportional 
        // function over all probable x values
        int32 x1, x2;                    // x loop
        double y;                        // value of proportional function
        x1 = (int32)mean();              // start at mean
        if (x1 < xmin) x1 = xmin;
        x2 = x1 + 1;
        scale = 0.; scale = lng(x1);     // calculate scale to avoid overflow
        rsum = 1.;                       // = exp(lng(x1)) with this scale
        for (x1--; x1 >= xmin; x1--) {
            rsum += y = exp(lng(x1));     // sum from x1 and down 
            if (y < accur) break;         // until value becomes negligible
        }
        for (; x2 <= xmax; x2++) {       // sum from x2 and up
            rsum += y = exp(lng(x2));
            if (y < accur) break;         // until value becomes negligible
        }
        rsum = 1. / rsum;                // save reciprocal sum
    }
    return exp(lng(x)) * rsum;          // function value
}


double CFishersNCHypergeometric::probabilityRatio(int32 x, int32 x0) {
    // Calculate probability ratio f(x)/f(x0)
    // This is much faster than calculating a single probability because
    // rsum is not needed
    double a1, a2, a3, a4, f1, f2, f3, f4;
    int32 y, dx = x - x0;
    int invert = 0;

    if (x < xmin || x > xmax) return 0.;
    if (x0 < xmin || x0 > xmax) {
        FatalError("Infinity in CFishersNCHypergeometric::probabilityRatio");
    }
    if (dx == 0.) return 1.;
    if (dx < 0.) {
        invert = 1;
        dx = -dx;
        y = x;  x = x0;  x0 = y;
    }
    a1 = m - x0;  a2 = n - x0;  a3 = x;  a4 = N - m - n + x;
    if (dx <= 28 && x <= 100000) {      // avoid overflow
        // direct calculation
        f1 = f2 = 1.;
        // compute ratio of binomials
        for (y = 0; y < dx; y++) {
            f1 *= a1-- * a2--;
            f2 *= a3-- * a4--;
        }
        // compute odds^dx
        f3 = 1.;  f4 = odds;  y = dx;
        while (y) {
            if (f4 < 1.E-100) {
                f3 = 0.;  break;           // avoid underflow
            }
            if (y & 1) f3 *= f4;
            f4 *= f4;
            y = (unsigned long)(y) >> 1;
        }
        f1 = f3 * f1 / f2;
        if (invert) f1 = 1. / f1;
    }
    else {
        // use logarithms
        f1 = FallingFactorial(a1, dx) + FallingFactorial(a2, dx) -
            FallingFactorial(a3, dx) - FallingFactorial(a4, dx) +
            dx * log(odds);
        if (invert) f1 = -f1;
        f1 = exp(f1);
    }
    return f1;
}


double CFishersNCHypergeometric::MakeTable(double * table, int32 MaxLength, int32 * xfirst, int32 * xlast, bool * useTable, double cutoff) {
    // Makes a table of Fisher's noncentral hypergeometric probabilities.
    // Results are returned in the array table of size MaxLength.
    // The values are scaled so that the highest value is 1. The return value
    // is the sum, s, of all the values in the table. The normalized
    // probabilities are obtained by multiplying all values in the table by
    // 1/s.
    // The tails are cut off where the values are < cutoff, so that 
    // *xfirst may be > xmin and *xlast may be < xmax.
    // The value of cutoff will be 0.01 * accuracy if not specified.
    // The first and last x value represented in the table are returned in 
    // *xfirst and *xlast. The resulting probability values are returned in the 
    // first (*xlast - *xfirst + 1) positions of table. If this would require
    // more than MaxLength values then the table is filled with as many 
    // correct values as possible.
    //
    // The function will return the desired length of table when MaxLength = 0.

    double f;                           // probability function value
    double sum;                         // sum of table values
    double a1, a2, b1, b2;              // factors in recursive calculation of f(x)
    int32 x;                            // x value
    int32 x1, x2;                       // lowest and highest x
    int32 i, i0, i1, i2;                // table index
    int32 mode = this->mode();          // mode
    int32 L = n + m - N;                // parameter
    int32 DesiredLength;                // desired length of table

    // limits for x
    x1 = (L > 0) ? L : 0;               // xmin
    x2 = (n < m) ? n : m;               // xmax
    *xfirst = x1;  *xlast = x2;

    // special cases
    if (x1 == x2) goto DETERMINISTIC;
    if (odds <= 0.) {
        if (n > N - m) FatalError("Not enough items with nonzero weight in  CWalleniusNCHypergeometric::MakeTable");
        x1 = 0;
    DETERMINISTIC:
        if (useTable) *useTable = true;
        *xfirst = *xlast = x1;
        if (MaxLength && table) *table = 1.;
        return 1;
    }

    if (useTable) *useTable = true;

    if (MaxLength <= 0) {
        // Return useTabl and DesiredLength
        DesiredLength = x2 - x1 + 1;     // max length of table
        if (DesiredLength > 200) {
            double sd = sqrt(variance()); // calculate approximate standard deviation
            // estimate number of standard deviations to include from normal distribution
            i = (int32)(NumSD(accuracy) * sd + 0.5);
            if (DesiredLength > i) DesiredLength = i;
        }
        return DesiredLength;
    }

    // place mode in the table
    if (mode - x1 <= MaxLength / 2) {
        // There is enough space for left tail
        i0 = mode - x1;
    }
    else if (x2 - mode <= MaxLength / 2) {
        // There is enough space for right tail
        i0 = MaxLength - x2 + mode - 1;
        if (i0 < 0) i0 = 0;
    }
    else {
        // There is not enough space for any of the tails. Place mode in middle of table
        i0 = MaxLength / 2;
    }
    // Table start index
    i1 = i0 - mode + x1;  if (i1 < 0) i1 = 0;

    // Table end index
    i2 = i0 + x2 - mode;  if (i2 > MaxLength - 1) i2 = MaxLength - 1;

    // make center
    table[i0] = sum = f = 1.;

    // make left tail
    x = mode;
    a1 = m + 1 - x;  a2 = n + 1 - x;
    b1 = x;  b2 = x - L;
    for (i = i0 - 1; i >= i1; i--) {
        f *= b1 * b2 / (a1 * a2 * odds); // recursive formula
        a1++;  a2++;  b1--;  b2--;
        sum += table[i] = f;
        if (f < cutoff) {
            i1 = i;  break;               // cut off tail if < accuracy
        }
    }
    if (i1 > 0) {
        // move table down for cut-off left tail
        memmove(table, table + i1, (i0 - i1 + 1) * sizeof(*table));
        // adjust indices
        i0 -= i1;  i2 -= i1;  i1 = 0;
    }
    // make right tail
    x = mode + 1;
    a1 = m + 1 - x;  a2 = n + 1 - x;
    b1 = x;  b2 = x - L;
    f = 1.;
    for (i = i0 + 1; i <= i2; i++) {
        f *= a1 * a2 * odds / (b1 * b2); // recursive formula
        a1--;  a2--;  b1++;  b2++;
        sum += table[i] = f;
        if (f < cutoff) {
            i2 = i;  break;               // cut off tail if < accuracy
        }
    }
    // x limits
    *xfirst = mode - (i0 - i1);
    *xlast = mode + (i2 - i0);

    return sum;
}


double CFishersNCHypergeometric::lng(int32 x) {
    // natural log of proportional function
    // returns lambda = log(m!*x!/(m-x)!*m2!*x2!/(m2-x2)!*odds^x)
    int32 x2 = n - x, m2 = N - m;
    if (ParametersChanged) {
        mFac = LnFac(m) + LnFac(m2);
        xLast = -99; ParametersChanged = 0;
    }
    if (m < FAK_LEN && m2 < FAK_LEN)  goto DEFLT;
    switch (x - xLast) {
    case 0:   // x unchanged
        break;
    case 1:   // x incremented. calculate from previous value
        xFac += log(double(x) * (m2 - x2) / (double(x2 + 1) * (m - x + 1)));
        break;
    case -1:  // x decremented. calculate from previous value
        xFac += log(double(x2) * (m - x) / (double(x + 1) * (m2 - x2 + 1)));
        break;
    default: DEFLT: // calculate all
        xFac = LnFac(x) + LnFac(x2) + LnFac(m - x) + LnFac(m2 - x2);
    }
    xLast = x;
    return mFac - xFac + x * logodds - scale;
}


/***********************************************************************
calculation methods in class CMultiFishersNCHypergeometric
***********************************************************************/

CMultiFishersNCHypergeometric::CMultiFishersNCHypergeometric(int32 n_, int32 * m_, double * odds_, int colors_, double accuracy_) {
    // constructor
    int i;                              // loop counter

    // copy parameters
    n = n_;  Colors = colors_;  accuracy = accuracy_;

    // check if parameters are valid
    reduced = 2;  N = Nu = 0;  usedcolors = 0;
    for (i = 0; i < Colors; i++) {
        nonzero[i] = 1;                  // remember if color i has m > 0 and odds > 0
        m[usedcolors] = m_[i];           // copy m
        N += m_[i];                      // sum of m
        if (m_[i] <= 0) {
            nonzero[i] = 0;               // color i unused
            reduced |= 1;
            if (m_[i] < 0) FatalError("Parameter m negative in constructor for CMultiFishersNCHypergeometric");
        }
        odds[usedcolors] = odds_[i];     // copy odds
        if (odds_[i] <= 0) {
            nonzero[i] = 0;               // color i unused
            reduced |= 1;
            if (odds_[i] < 0) FatalError("Parameter odds negative in constructor for CMultiFishersNCHypergeometric");
        }
        if (usedcolors > 0 && nonzero[i] && odds[usedcolors] != odds[usedcolors - 1]) {
            reduced &= ~2;                // odds are not all equal
        }
        if (nonzero[i]) {
            Nu += m[usedcolors];          // sum of m for used colors
            usedcolors++;                 // skip color i if zero
        }
    }
    if (N < n) FatalError("Taking more items than there are in constructor for CMultiFishersNCHypergeometric");
    if (Nu < n) FatalError("Not enough items with nonzero weight in constructor for CMultiFishersNCHypergeometric");

    // calculate mFac and logodds
    for (i = 0, mFac = 0.; i < usedcolors; i++) {
        mFac += LnFac(m[i]);
        logodds[i] = log(odds[i]);
    }
    // initialize
    sn = 0;
}


void CMultiFishersNCHypergeometric::mean(double * mu) {
    // calculates approximate mean of multivariate Fisher's noncentral
    // hypergeometric distribution. Result is returned in mu[0..colors-1].
    // The calculation is reasonably fast.
    int i, j;                           // color index
    double mur[MAXCOLORS];              // mean for used colors

    // get mean of used colors
    mean1(mur);

    // resolve unused colors
    for (i = j = 0; i < Colors; i++) {
        if (nonzero[i]) {
            mu[i] = mur[j++];
        }
        else {
            mu[i] = 0.;
        }
    }
}


void CMultiFishersNCHypergeometric::mean1(double * mu) {
    // calculates approximate mean of multivariate Fisher's noncentral
    // hypergeometric distribution, except for unused colors
    double r, r1;                       // iteration variable
    double q;                           // mean of color i
    double W;                           // total weight
    int i;                              // color index
    int iter = 0;                       // iteration counter

    if (usedcolors < 3) {
        // simple cases
        if (usedcolors == 1) mu[0] = n;
        if (usedcolors == 2) {
            mu[0] = CFishersNCHypergeometric(n, m[0], Nu, odds[0] / odds[1]).mean();
            mu[1] = n - mu[0];
        }
    }
    else if (n == Nu) {
        // Taking all balls
        for (i = 0; i < usedcolors; i++) mu[i] = m[i];
    }
    else {
        // not a special case

        // initial guess for r
        for (i = 0, W = 0.; i < usedcolors; i++) W += m[i] * odds[i];
        r = (double)n * Nu / ((Nu - n) * W);

        if (r > 0.) {
            // iteration loop to find r
            do {
                r1 = r;
                for (i = 0, q = 0.; i < usedcolors; i++) {
                    q += m[i] * r * odds[i] / (r * odds[i] + 1.);
                }
                r *= n * (Nu - q) / (q * (Nu - n));
                if (++iter > 100) FatalError("convergence problem in function CMultiFishersNCHypergeometric::mean");
            } while (fabs(r - r1) > 1E-5);
        }

        // get result
        for (i = 0; i < usedcolors; i++) {
            mu[i] = m[i] * r * odds[i] / (r * odds[i] + 1.);
        }
    }
}


void CMultiFishersNCHypergeometric::variance(double * var, double * mean_) {
    // calculates approximate variance of multivariate Fisher's noncentral
    // hypergeometric distribution (accuracy is not too good).
    // Variance is returned in variance[0..colors-1].
    // Mean is returned in mean_[0..colors-1] if not NULL.
    // The calculation is reasonably fast.
    double r1, r2;
    double mu[MAXCOLORS];
    int i, j;

    mean1(mu);         // Mean of used colors

    for (i = j = 0; i < Colors; i++) {
        if (nonzero[i]) {
            r1 = mu[j] * (m[j] - mu[j]);
            r2 = (n - mu[j]) * (mu[j] + Nu - n - m[j]);
            if (r1 <= 0. || r2 <= 0.) {
                var[i] = 0.;
            }
            else {
                var[i] = Nu * r1 * r2 / ((Nu - 1) * (m[j] * r2 + (Nu - m[j]) * r1));
            }
            j++;
        }
        else {  // unused color
            var[i] = 0.;
        }
    }

    // Store mean if mean_ is not NULL
    if (mean_) {
        // resolve unused colors
        for (i = j = 0; i < Colors; i++) {
            if (nonzero[i]) {
                mean_[i] = mu[j++];
            }
            else {
                mean_[i] = 0.;
            }
        }
    }
}


double CMultiFishersNCHypergeometric::probability(int32 * x) {
    // Calculate probability function.
    // Note: The first-time call takes very long time because it requires
    // a calculation of all possible x combinations with probability >
    // accuracy, which may be extreme.
    // The calculation uses logarithms to avoid overflow. 
    // (Recursive calculation may be faster, but this has not been implemented)
    int i, j;                           // color index
    int32 xsum = 0;                     // sum of x
    int32 Xu[MAXCOLORS];                // x for used colors

    // resolve unused colors
    for (i = j = 0; i < Colors; i++) {
        if (nonzero[i]) {
            Xu[j++] = x[i];               // copy x to array of used colors
            xsum += x[i];                 // sum of x
        }
        else {
            if (x[i]) return 0.;          // taking balls with zero weight
        }
    }

    if (xsum != n) {
        FatalError("sum of x values not equal to n in function CMultiFishersNCHypergeometric::probability");
    }

    for (i = 0; i < usedcolors; i++) {
        if (Xu[i] > m[i] || Xu[i] < 0 || Xu[i] < n - Nu + m[i]) return 0.;  // Outside bounds for x
    }

    if (n == 0 || n == Nu) return 1.;   // deterministic cases

    if (usedcolors < 3) {               // cases with < 3 colors
        if (usedcolors < 2) return 1.;
        // Univariate probability
        return CFishersNCHypergeometric(n, m[0], Nu, odds[0] / odds[1], accuracy).probability(Xu[0]);
    }

    if (reduced & 2) {
        // All odds are equal. This is multivariate central hypergeometric distribution
        int32 sx = n, sm = N;
        double p = 1.;
        for (i = 0; i < usedcolors - 1; i++) {
            // Use univariate hypergeometric (usedcolors-1) times
            p *= CFishersNCHypergeometric(sx, m[i], sm, 1.).probability(x[i]);
            sx -= x[i];  sm -= m[i];
        }
        return p;
    }

    // all special cases eliminated. Calculate sum of all function values
    if (sn == 0) SumOfAll();            // first time initialize

    return exp(lng(Xu)) * rsum;         // function value
}


double CMultiFishersNCHypergeometric::moments(double * mean, double * variance, int32 * combinations) {
    // calculates mean and variance of the Fisher's noncentral hypergeometric 
    // distribution by calculating all combinations of x-values with
    // probability > accuracy.
    // Return value = 1.
    // Returns the mean in mean[0...colors-1]
    // Returns the variance in variance[0...colors-1]

    int i, j;                           // color index
    if (sn == 0) {
        // first time initialization includes calculation of mean and variance
        SumOfAll();
    }
    // copy results and resolve unused colors
    for (i = j = 0; i < Colors; i++) {
        if (nonzero[i]) {
            mean[i] = sx[j];
            variance[i] = sxx[j];
            j++;
        }
        else {
            mean[i] = variance[i] = 0.;
        }
    }
    if (combinations) *combinations = sn;
    return 1.;
}


void CMultiFishersNCHypergeometric::SumOfAll() {
    // this function does the very time consuming job of calculating the sum
    // of the proportional function g(x) over all possible combinations of
    // the x[i] values with probability > accuracy. These combinations are 
    // generated by the recursive function loop().
    // The mean and variance are generated as by-products.

    int i;                              // color index
    int32 msum;                         // sum of m[i]

    // get approximate mean
    mean1(sx);

    // round mean to integers
    for (i = 0, msum = 0; i < usedcolors; i++) {
        msum += xm[i] = (int32)(sx[i] + 0.4999999);
    }
    // adjust truncated x values to make the sum = n
    msum -= n;
    for (i = 0; msum < 0; i++) {
        if (xm[i] < m[i]) {
            xm[i]++; msum++;
        }
    }
    for (i = 0; msum > 0; i++) {
        if (xm[i] > 0) {
            xm[i]--; msum--;
        }
    }

    // adjust scale factor to g(mean) to avoid overflow
    scale = 0.; scale = lng(xm);

    // initialize for recursive loops
    sn = 0;
    for (i = usedcolors - 1, msum = 0; i >= 0; i--) {
        remaining[i] = msum;  msum += m[i];
    }
    for (i = 0; i < usedcolors; i++) {
        sx[i] = 0;  sxx[i] = 0;
    }

    // recursive loops to calculate sums of g(x) over all x combinations
    rsum = 1. / loop(n, 0);

    // calculate mean and variance
    for (i = 0; i < usedcolors; i++) {
        sxx[i] = sxx[i] * rsum - sx[i] * sx[i] * rsum * rsum;
        sx[i] = sx[i] * rsum;
    }
}


double CMultiFishersNCHypergeometric::loop(int32 n, int c) {
    // recursive function to loop through all combinations of x-values.
    // used by SumOfAll
    int32 x, x0;                        // x of color c
    int32 xmin, xmax;                   // min and max of x[c]
    double s1, s2, sum = 0.;            // sum of g(x) values
    int i;                              // loop counter

    if (c < usedcolors - 1) {
        // not the last color
        // calculate min and max of x[c] for given x[0]..x[c-1]
        xmin = n - remaining[c];  if (xmin < 0) xmin = 0;
        xmax = m[c]; if (xmax > n) xmax = n;
        x0 = xm[c];  if (x0 < xmin) x0 = xmin;  if (x0 > xmax) x0 = xmax;
        // loop for all x[c] from mean and up
        for (x = x0, s2 = 0.; x <= xmax; x++) {
            xi[c] = x;
            sum += s1 = loop(n - x, c + 1); // recursive loop for remaining colors
            if (s1 < accuracy && s1 < s2) break; // stop when values become negligible
            s2 = s1;
        }
        // loop for all x[c] from mean and down
        for (x = x0 - 1; x >= xmin; x--) {
            xi[c] = x;
            sum += s1 = loop(n - x, c + 1);   // recursive loop for remaining colors
            if (s1 < accuracy && s1 < s2) break; // stop when values become negligible
            s2 = s1;
        }
    }
    else {
        // last color
        xi[c] = n;
        // sums and squaresums    
        s1 = exp(lng(xi));                 // proportional function g(x)
        for (i = 0; i < usedcolors; i++) { // update sums
            sx[i] += s1 * xi[i];
            sxx[i] += s1 * xi[i] * xi[i];
        }
        sn++;
        sum += s1;
    }
    return sum;
}


double CMultiFishersNCHypergeometric::lng(int32 * x) {
    // natural log of proportional function g(x)
    double y = 0.;
    int i;
    for (i = 0; i < usedcolors; i++) {
        y += x[i] * logodds[i] - LnFac(x[i]) - LnFac(m[i] - x[i]);
    }
    return mFac + y - scale;
}
