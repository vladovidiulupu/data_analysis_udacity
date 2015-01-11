from math import sqrt
import scipy.stats

def welch_2_sample_t_test(n1, u1, var1, n2, u2, var2):
    t = (u1 - u2) / sqrt(var1 / n1 + var2 / n2)
    v = (var1 / n1 + var2/ n2) ** 2 / \
    (var1 ** 2 / ((n1 - 1) * n1 ** 2) + var2 ** 2 / ((n2 - 1) * n2 ** 2))
    print "t = ", t
    print "v = ", v
    
welch_2_sample_t_test(150, .299, .05, 165, .307, .08)