LTR
---
   The encoder supports two methods of long term reference. The first method is that long term P frame always refers to I frame, and the second method is that long term P frame refers to the nearest long term P frame or I frame. The relationship is shown below.
   
   .. image:: ltr_diagram.png
      :width: 30%


   .. table::
      :align: left
      :widths: auto

      ============ =========== ====== =========== ======== =============== =============== =========== =============== ===========================================================================================================
       domain       name        size   short key   type     minimum value   maximum value   precision   default value   description
      ============ =========== ====== =========== ======== =============== =============== =========== =============== ===========================================================================================================
       ltr          ltrFlg      1      /           bool     /               /               /           0               enable flag for LTR (long term reference)
       ltr          ltrEnmMod   1      /           int      0               1               /           0               mode of LTR (0: always referring to I frames; 1: referring to the nearest long term P frames or I frames)
       ltr          ltrDatPrd   1      /           int      0               /               /           4               period of LTR frames (0: (L)(L)(L)...; 1: (LS)(LS)(LS); 2: (LSS)(LSS)(LSS)...)
      ============ =========== ====== =========== ======== =============== =============== =========== =============== ===========================================================================================================
