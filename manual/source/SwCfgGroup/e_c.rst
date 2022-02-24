E_C
---------------------

The codec supports Context-based Adaptive Binary Arithmetic Coding (CABAC).
The Sign Data Hiding (SDH) technology is used to hide the last non-zero symbol bit of each CG.

============ ======================= ====== =========== ======== =============== =============== =========== ==================== ======================================================================================
 domain       name                    size   short key   type     minimum value   maximum value   precision   default value        description
============ ======================= ====== =========== ======== =============== =============== =========== ==================== ======================================================================================
e_c          e_cFlgRun               1      /           bool     /               /               /           1                     enable flag
e_c          e_cFlgSbh               1      /           bool     /               /               /           0                     enable flag for sign bit hidden
e_c          e_cEnmModLoad           1      /           int      0               2               /           0                     load mode (<value> 0: load from pipe; 2. load from file; 3. load random data)
============ ======================= ====== =========== ======== =============== =============== =========== ==================== ======================================================================================


