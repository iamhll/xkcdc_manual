R_C
---

The codec supports frame-level rate control algorithm based on R-λ and multiple LCU-level rate control algorithms.

The frame-level rate control algorithm is inspired by JCTVC-K0103, setting ``r_cDatBps`` to the target bitrate(kbps).

The LCU-level algorithms consist of sum of absolute derivation (SADR), sum of absolute transformed difference (SATD) and sum of absolute motion vector (SAMV), all of which use the similar algorithm, setting corresponding delta QP and threshold if necessary.

The algorithm works as following: when SADR/SATD/SAMV is less than the threshold n, the delta QP n is used. Otherwise, continue to query the threshold n+1.

.. include:: r_c_sub.rst