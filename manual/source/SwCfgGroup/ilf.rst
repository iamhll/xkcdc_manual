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

   .. include::  ilf_sub.rst
