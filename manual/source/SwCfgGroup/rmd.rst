RMD
---

RMD(Rough Mode Decision)
RMD is a fast algorithm for intra mode decision, 
all modes of all PUs are ordered according to SATD cost.
In this way, a small number of modes are involved in the final rate-distortion optimization process.

Configuration List
..................

.. table::
      :align: left
      :widths: auto

      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ============================================================================== 
       domain       name                    size   short key   type     minimum value   maximum value   precision   default value                                                                                                          description
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ==============================================================================
      rmd          rmdFlgRun               1      /           bool     /               /               /           1                                                                                                                      enable flag
      rmd          rmdEnmModLoad           1      /           int      0               2               /           0                                                                                                                      load mode (<value> 0: load from pipe; 2. load from file; 3. load random data)
      rmd          rmdNumGrp               1      /           int      1               35              /           12                                                                                                                     number of the intra-mode groups to be tested for each PU
      rmd          rmdSizGrp               1      /           int      1               6               /           3                                                                                                                      size   of the intra-mode groups to be tested for each PU
      rmd          rmdDatMod               42     /           int      -1              34              /           2 3 4 5 6 7 10 8 9 11 12 13 14 15 16 17 -1 -1 18 19 20 21 22 23 26 24 25 27 28 29 30 31 32 33 34 -1 -1 -1 -1 -1 -1 -1  data   of the intra-mode groups to be tested for each PU
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== ============================================================================== 