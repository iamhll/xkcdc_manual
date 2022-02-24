FME
---

FME(Fractional Motion Estimation)
FME performs sub-pixel interpolation at the specified motion vector (IMV or MVP) 
and finds the optimal motion vector based on SATD and MVD cost

Configuration List
..................

.. table::
      :align: left
      :widths: auto

      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== =========================================================================================================================================================================
       domain       name                    size   short key   type     minimum value   maximum value   precision   default value                                                                                                          description
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== =========================================================================================================================================================================
      fme          fmeFlgRun               1      /           bool     /               /               /           1                                                                                                                      enable flag
      fme          fmeEnmModLoad           1      /           int      0               2               /           0                                                                                                                      load mode (<value> 0: load from pipe; 2. load from file; 3. load random data)
      fme          fmeNumTrv               1      /           int      1               2               /           1                                                                                                                      number of traversals to be tested for each LCU
      fme          fmeNumCtr               2      /           int      1               4               /           3 1                                                                                                                    number of center points to be tested for each tranversal (<index> N: the Nth tranversal)
      fme          fmeEnmCtr               2x4    /           int      0               3               /           0 1 2 3 0 0 0 0                                                                                                        center types of each center points (<index> N-M: the Nth tranversal Mth center point) (<value> 0: best results of previous tranversals or IME; 1: MvpA; 2: MvpB; 3: 0-0)
      fme          fmeEnmItp               2x4    /           int      0               2               /           2 1 1 2 1 1 1 1                                                                                                        interpolation types of each center points (<index> N-M: the Nth tranversal Mth center point) (<value> 0: none; 1: quarter; 2: half)
      fme          fmeDatSclMvd            1      /           double   0               7.96875         5           1.0                                                                                                                    scaler to bias mvd cost
      ============ ======================= ====== =========== ======== =============== =============== =========== ====================================================================================================================== =========================================================================================================================================================================