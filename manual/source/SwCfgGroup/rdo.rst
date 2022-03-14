RDO
---

The codec supports rate-distorion optimization (RDO), selecting the encoding parameters 
according to its bit rate cost and the distortion cost by a certain strategy to achieve the best encoding performance.

the coding strategy is as follows:
          Cst = DCst + lamda * RCst

Different encoding levels have different methods for calculating distortion cost and bit rate cost.

For example, When the coding level is 0, the DCst is the sum of squared Error, 
and the RCst is calculated by the fitting method. And some parameters related with RCst fitting is in the table below.

.. table::
   :align: left
   :widths: auto

   .. include:: rdo_sub.rst
