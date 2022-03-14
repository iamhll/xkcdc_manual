ROI
---

The codec supports region of interest (ROI) interface, 
specifying at most two areas per frame in the unit of LCU, 
and setting the blocks type and QP for those areas.

Users can use preprocessing algorithms to select ROI 
according to different application scenarios.

Example of ROI with default settings is shown below.

.. image:: roi.png
    :width: 10%

.. table::
   :align: left
   :widths: auto

   .. include:: roi_sub.rst
