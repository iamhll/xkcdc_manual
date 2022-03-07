IME
---

The codec supports integer motion estimation (IME), 
and the best integer motion vector inside the specified 
search pattern is achieved based on the SAD cost and MVD cost.

Examples for search pattern are shown below, 
where their ``imeSizPtnX`` and ``imeSizPtnY`` are 5 
while their slopes are 1, 2, infinite, respectively. 

.. image:: ime_pattern.png
    :width: 40%

.. include:: ime_sub.rst