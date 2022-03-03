R_C
---

The codec supports frame-level rate control algorithm based on R-λ and multiple LCU-level rate control algorithms.

The frame-level rate control algorithm is inspired by JCTVC-K0103, setting ``r_cDatBps`` to the target bitrate(kbps).

The LCU-level algorithms consist of sum of absolute derivation (SADR), sum of absolute transformed difference (SATD) and sum of absolute motion vector (SAMV), all of which use the similar algorithm, setting corresponding delta QP and threshold if necessary.

The algorithm works as following: when SADR/SATD/SAMV is less than the threshold n, the delta QP n is used. Otherwise, continue to query the threshold n+1.

============ ======================= ====== =========== ======== =============== =============== =========== ====================================== =========================================================================================================================================================================================================================
 domain       name                    size   short key   type     minimum value   maximum value   precision   default value                          description
============ ======================= ====== =========== ======== =============== =============== =========== ====================================== =========================================================================================================================================================================================================================
 r_c          r_cFlg                  8      /           bool     /               /               /           0 0 0 0 0 0 0 0                        enable flags (<index> 0: R-λ based frame-level RC; 1/2: smooth based LCU-level intra/inter RC; 3/4: SADR based LCU-level intra/inter RC; 5/6: SATD based LCU-level intra/inter RC; 7: SAMV based LCU-level inter RC)
 r_c          r_cDatBps               1      /           double   0               /               /           12000.0                                target bit rate of averaged frames (unit: kbps)
 r_c          r_cDatBpsIntra          1      /           double   0               /               /           39321.6                                out of date, which will be removed later
 r_c          r_cDatBpsInter          1      /           double   0               /               /           11796.48                               out of date, which will be removed later
 r_c          r_cDatQpMinIntra        1      /           int      0               51              /           5                                      minimum QP allowed in intra frames
 r_c          r_cDatQpMinInter        1      /           int      0               51              /           5                                      minimum QP allowed in inter frames
 r_c          r_cDatQpMaxIntra        1      /           int      0               51              /           50                                     maximum QP allowed in intra frames
 r_c          r_cDatQpMaxInter        1      /           int      0               51              /           50                                     maximum QP allowed in inter frames
 r_c          r_cDatThrRatiIntra      6      /           int      0               /               /           1 2 3 6 9 15                           out of date, which will be removed later
 r_c          r_cDatDltRatiIntra      7      /           int      0               51              /           0 1 2 3 6 9 15                         out of date, which will be removed later
 r_c          r_cDatThrRatiInter      6      /           int      0               /               /           2 4 6 12 18 30                         out of date, which will be removed later
 r_c          r_cDatDltRatiInter      7      /           int      0               51              /           0 1 2 3 6 9 15                         out of date, which will be removed later
 r_c          r_cDatSclSmthIntra      1      /           double   0               0.9990234375    10          0.25                                   out of date, which will be removed later
 r_c          r_cDatSclSmthInter      1      /           double   0               0.9990234375    10          0.25                                   out of date, which will be removed later
 r_c          r_cDatThrSmthIntra      1      /           int      0               /               /           1000                                   out of date, which will be removed later
 r_c          r_cDatThrSmthInter      1      /           int      0               /               /           1000                                   out of date, which will be removed later
 r_c          r_cDatDltSmthIntra      1      /           int      0               7               /           1                                      out of date, which will be removed later
 r_c          r_cDatDltSmthInter      1      /           int      0               7               /           1                                      out of date, which will be removed later
 r_c          r_cDatPrmSmthIntra      3      /           double   /               /               /           -64.62 0.1546 89.08                    out of date, which will be removed later
 r_c          r_cDatPrmSmthInter      3      /           double   /               /               /           -253.4 0.02585 269.5                   out of date, which will be removed later
 r_c          r_cDatThrSadrIntra      6      /           int      0               32767           /           1854 2363 5019 14161 18900 27758       threshold of SADR based LCU-level intra RC
 r_c          r_cDatDltSadrIntra      7      /           int      -16             15              /           0 0 0 0 1 1 1                          delta QP  of SADR based LCU-level intra RC
 r_c          r_cDatThrSadrInter      6      /           int      0               32767           /           1854 2363 5019 14161 18900 27758       threshold of SADR based LCU-level inter RC
 r_c          r_cDatDltSadrInter      7      /           int      -16             15              /           0 0 0 0 1 2 3                          delta QP  of SADR based LCU-level inter RC
 r_c          r_cDatThrSatdIntra      6      /           int      0               65535           /           7532 8478 13480 32816 41550 51096      threshold of SATD based LCU-level intra RC
 r_c          r_cDatDltSatdIntra      7      /           int      -16             15              /           0 0 0 0 1 1 1                          delta QP  of SATD based LCU-level intra RC
 r_c          r_cDatThrSatdInter      6      /           int      0               65536           /           1638 1822 2068 3109 3622 4513          threshold of SATD based LCU-level inter RC
 r_c          r_cDatDltSatdInter      7      /           int      -16             15              /           0 0 0 0 1 2 3                          delta QP  of SATD based LCU-level inter RC
 r_c          r_cDatThrSamvInter      6      /           int      0               2047            /           0 0 0 9 17 42                          threshold of SAMV based LCU-level inter RC
 r_c          r_cDatDltSamvInter      7      /           int      -16             15              /           0 0 0 0 1 1 1                          delta QP  of SAMV based LCU-level inter RC
============ ======================= ====== =========== ======== =============== =============== =========== ====================================== =========================================================================================================================================================================================================================