# Test expression for mean of Fisher

require(BiasedUrn)
require(stats)

m1 = 80
m2 = 60
n  = 100
N  = m1+m2
odds = 5.1
xmin = minHypergeo(m1, m2, n) 
xmax = maxHypergeo(m1, m2, n) 
mean = meanFNCHypergeo(m1, m2, n, odds, precision=1E-7)
var = varFNCHypergeo(m1, m2, n, odds, precision=1E-7) 

P0 = 0; P1 = 0; P2 = 0

for (j in xmin : xmax) {
   P0 = P0 + odds^j * choose(m1,j)*choose(m2,n-j)
   P1 = P1 + j*odds^j * choose(m1,j)*choose(m2,n-j)
   P2 = P2 + j*j*odds^j * choose(m1,j)*choose(m2,n-j)
}
mean1 = P1/P0
var1 = P2/P0 - mean1^2
e1 = (mean-mean1)/mean
e2 = (var-var1)/var

