ILF
---

The codec supports deblocking filter(DBF) and sample adaptive offset(SAO) for in-loop filter(ILF).

DBF aims to achieve a smooth transition across the block boundaries while avoiding removal of natural edges.
Since different sequences or parts of the same sequence may have different characteristics,
deblocking adjustment parameters can be sent to control the amount of deblocking filtering applied.
Using more negative offsets will reduce the amount of filtering while using more positive offsets will increase the amount of filtering.

SAO aims to reduce sample distortion by first classifying reconstructed samples into different categories,
obtaining an offset for each category,
and then adding the offset to each sample of the category.
Rate-distortion optimization is adopted to determine sample adaptive offset mode at the encoder side.

.. table::
      :align: left
      :widths: auto

      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== =========================================================================================================================================================================
       domain       name                    size   short key   type     minimum value   maximum value   precision   default value                                                                                                          description
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== =========================================================================================================================================================================
      ilf          ilfFlgRun               1      /           bool     /               /               /           1                                                                                                                      enable flag
      ilf          ilfEnmModLoad           1      /           int      0               2               /           0                                                                                                                      load mode (<value> 0: load from pipe; 2. load from file; 3. load random data)
      ilf          ilfFlgDbf               1      /           bool     /               /               /           1                                                                                                                      enable flag for feature DBF
      ilf          ilfFlgSao               2      /           bool     /               /               /           1 1                                                                                                                    enable flag for feature SAO (<index> 0: luma 1: chroma)
      ilf          ilfDatOffBtDiv2         1      /           int      -6              6               /           0                                                                                                                      parameter BetaOffsetDiv2 for feature DBF
      ilf          ilfDatOffTcDiv2         1      /           int      -6              6               /           0                                                                                                                      parameter   TcOffsetDiv2 for feature DBF
      ilf          ilfDatSclLambda         4      /           double   0               7.96875         5           1.0 0.4 1.0 0.5                                                                                                        scaler to bias lambda (<index> 0/1: intra luma/chroma; 2/3 inter luma/chroma)
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== =========================================================================================================================================================================
