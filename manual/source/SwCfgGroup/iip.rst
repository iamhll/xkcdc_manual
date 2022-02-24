IIP
---

The codec supports intra block in P frame (IIP), choosing the optimal I block or P block in P frame based on rate-distortion.


.. table::
      :align: left
      :widths: auto

      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ============================================================================== 
       domain       name                    size   short key   type     minimum value   maximum value   precision   default value                                                                                                          description
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ==============================================================================
      iip          iipEnmStg               1      /           int      0               4               /           3                                                                                                                       decision stage of IIP (<value> 0: disable IIP; 1: do IIP decision in IME stage; 2: do rough IIP decision in IME stage and do final IIP decision in RDO stage; 3. do IIP decision in RDO stage; 4. do IIP decision in CFG stage (fix ratio and fix position))
      iip          iipEnmScl               1      /           int      0               1               /           0                                                                                                                       scaler type (<value> 0: on D+lambdaR 1: on lambdaR)
      iip          iipDatRatio             1      /           int      1               /               /           4                                                                                                                       the reciprocal of the ratio of iip blocks
      iip          iipDatSclOnQp           14     /           double   0               7.96875         5           1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25 1.25                                                   scaler to bias intra blocks (<index> 0/1/2/3/4/5/6/7/8/9/10/11/12/13: scaler under QP 0~19/20~21/22~23/24~25/26~27/28~29/30~31/32~33/34~35/36~37/38~39/40~41/42~42/44~51)
      iip          iipDatSclOnMv           5      /           double   0               7.96875         5           1.0 1.0 1.0 1.0 1.0                                                                                                     scale to bias intra blocks (<index> 0/1/2/3/4: scaler under MV 0~7/8~15/16~23/24~31/31~inf 1/4 pixel)
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ============================================================================== 
