SKP
---

The codec supports skip (SKIP) mode in inter prediction, a special one in the merge mode,
without residual information but the skip flag and the candidate list index.

.. table::
      :align: left
      :widths: auto

      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ============================================================================== 
       domain       name                    size   short key   type     minimum value   maximum value   precision   default value                                                                                                          description
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ==============================================================================
      skp          skpFlg                  2      /           bool     /               /               /           1 0                                                                                                                     enable flags for skip (<index> 0: luma; 1:chroma)
      skp          skpEnmScl               1      /           int      0               1               /           1                                                                                                                       scaler type (<value> 0: on D+lambdaR 1: on lambdaR)
      skp          skpDatSclOnChn          2      /           double   0               7.96875         5           1.0 1.0                                                                                                                 scaler to bias skip blocks (<index> 0/1: scaler for luma/chroma)
      skp          skpDatSclOnQp           14     /           double   0               7.96875         5           1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0                                                                 scale to bias skip blocks (<index> 0/1/2/3/4/5/6/7/8/9/10/11/12/13: scaler under QP 0~19/20~21/22~23/24~25/26~27/28~29/30~31/32~33/34~35/36~37/38~39/40~41/42~42/44~51)
      skp          skpDatSclOnMv           5      /           double   0               7.96875         5           1.0 1.0 1.0 1.0 1.0                                                                                                     scale to bias skip blocks (<index> 0/1/2/3/4: scaler under MV 0~7/8~15/16~23/24~31/31~inf 1/4 pixel)
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ============================================================================== 
