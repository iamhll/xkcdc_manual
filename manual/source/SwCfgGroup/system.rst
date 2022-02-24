System
------

Specify the input file, coding level and output log of the codec.

============ ======================= ====== =========== ======== =============== =============== =========== =============== ======================================================================================================================================================
 domain       name                    size   short key   type     minimum value   maximum value   precision   default value   description
============ ======================= ====== =========== ======== =============== =============== =========== =============== ======================================================================================================================================================
 system       strFileYuv              1      i           string   /               /               /           /               location of the YUV file
 system       strPrefixDump           1      d           string   /               /               /           /               dump prefix
 system       strPrefixLoad           1      l           string   /               /               /           /               load prefix
 system       enmLvlEnc               1      e           int      0               3               /           0               level of encoding (<value> 0: hardware; 1: software)
 system       enmLvlLog               1      v           int      0               5               /           1               level of the output log (<value> 0: no log; 1: enable basic log; 2: enable frame-level log; 3: enable LCU-level log; 4: enable PU/TU/CU-level log)
============ ======================= ====== =========== ======== =============== =============== =========== =============== ======================================================================================================================================================