Top
---

Specify more export information, internal block sizes, input video sequence properties, and encoding standard.

============ ======================= ====== =========== ======== =============== =============== =========== =================== =========================================================================================================================================
 domain       name                    size   short key   type     minimum value   maximum value   precision   default value       description
============ ======================= ====== =========== ======== =============== =============== =========== =================== =========================================================================================================================================
 top          flgDmpCsv               1      /           bool     /               /               /           1                   enable flag for the dump of csv-format log
 top          flgDmpYuvRec            1      /           bool     /               /               /           1                   enable flag for the dump of reconstructed YUV
 top          flgDmpDbg               1      /           bool     /               /               /           0                   enable flag for the dump of debug information
 top          flgDistortion           2      /           bool     /               /               /           1 0                 enable flag for (the calculation of) distortion (<index> 0/1: PSNR/MS-SSIM)
 top          flgSizCuIntra           4      /           bool     /               /               /           1 1 1 1             enable flags for the corresponding CU sizes in intra frames (<index> 0/1/2/3: size 08/16/32/64)
 top          flgSizCuInter           4      /           bool     /               /               /           1 1 1 1             enable flags for the corresponding CU sizes in inter frames (<index> 0/1/2/3: size 08/16/32/64)
 top          flgPrtCuIntra           2      /           bool     /               /               /           1 1                 enable flags for the corresponding PU partitions in intra frames (<index> 0/1: 2Nx2N/1Nx1N partition)
 top          flgPrtCuInter           4      /           bool     /               /               /           1 0 0 0             enable flags for the corresponding PU partitions in inter frames (<index> 0/1/2/3: 2Nx2N/2Nx1N/1Nx2N/1Nx1N partition)
 top          numFra                  1      f           int      1               /               /           20                  number of the frames to be processed
 top          idxFraBgn               1      /           int      0               /               /           0                   index of the first frame to be processed
 top          numChn                  1      /           int      1               3               /           3                   number of channels (Y/U/V)
 top          sizFraX                 1      w           int      160             4096            /           416                 size of the frame in the X (horizontal) direction
 top          sizFraY                 1      h           int      160             4096            /           240                 size of the frame in the Y (vertical)   direction
 top          sizSwX                  1      /           int      16              128             /           128                 size of the search window (excluding LCU) in the X (horizontal) direction
 top          sizSwY                  1      /           int      16              128             /           64                  size of the search window (excluding LCU) in the Y (vertical)   direction
 top          sizLcu                  1      /           int      16              64              /           32                  size of LCU
 top          enmStd                  1      /           int      0               3               /           1                   standard (0: H264; 1: H265; 2: NSTD; 3: H266)
 top          enmModRun               1      /           int      0               1               /           0                   run mode (0: encode; 1: decode)
 top          datLvl                  1      /           int      1               /               /           30                  level (valid under H264 standard)
 top          datFps                  1      /           int      1               /               /           60                  frames per second
 top          datQpSeq                1      /           int      0               51              /           14                  QP value of the current sequence
 top          datPrdIntra             1      p           int      -1              /               /           1                   period of intra frames (-1 I(P)(P)(P)...; 0 (I)(I)(I)...; 1 (IP)(IP)(IP)...; 2 (IPP)(IPP)(IPP)...)
============ ======================= ====== =========== ======== =============== =============== =========== =================== =========================================================================================================================================