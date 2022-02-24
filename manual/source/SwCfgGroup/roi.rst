ROI
---

The codec supports fixed position region of interest (ROI), 
specifying at most two special areas from the image in the unit of LCU, 
and setting the type of blocks and QPs for those areas. 

.. table::
      :align: left
      :widths: auto

      ============ ======================= ====== =========== ======== =============== =============== =========== ==================================== ========================================================================= 
       domain       name                    size   short key   type     minimum value   maximum value   precision   default value                       description
      ============ ======================= ====== =========== ======== =============== =============== =========== ==================================== =========================================================================
      roi          roiIdxLcuBgnX           2      /           int      0               127             /           1 5                                  index of ROI's begin LCU in the X (horizontal) direction
      roi          roiIdxLcuBgnY           2      /           int      0               127             /           2 6                                  index of ROI's begin LCU in the Y (vertical)   direction
      roi          roiIdxLcuEndX           2      /           int      0               127             /           3 7                                  index of ROI's begin LCU in the X (horizontal) direction
      roi          roiIdxLcuEndY           2      /           int      0               127             /           4 8                                  index of ROI's begin LCU in the Y (vertical)   direction
      roi          roiFlgTyp               2      /           bool     /               /               /           0 0                                  enable flag for block types of ROI
      roi          roiEnmTyp               2      /           int      0               2               /           0 2                                  block types of ROI (<value> 0: intra; 1: inter; 2: skip)
      roi          roiFlgQp                2      /           bool     /               /               /           0 0                                  enable flag for QP of ROI
      roi          roiDatQp                2      /           int      0               51              /           22 37                                QP value of ROI
      ============ ======================= ====== =========== ======== =============== =============== =========== ==================================== ========================================================================= 