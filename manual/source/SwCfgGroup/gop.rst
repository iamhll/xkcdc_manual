GOP
---

The codecs supports common group of pictures (GOP), 

In the video coding sequence, there are mainly three types of frames: I frame, P frame, B frame

I frame is intra-coded frame, which does not refer to other frames and only uses the information of this frame for encoding

P frame is predictive-coded frame, which refers to the previous I frame or P frame and uses the information for inter motion prediction

B frame is bidirectional predictive-coded frame, which refers both the previous frame (I frame or P frame) and the subsequent image frame (P frame)
and uses the information for inter bidirectional motion prediction.

In our GOP structure, the size of GOP refers to the distance between two I frames, which means the frames in GOP does not need to refer to other frames outside the GOP
we can specify its size, set the frame types , set their relative positions inside and set delta QP for each frame. 

An example is as follows

.. image:: GOP.png
      :width: 20%

In this picture, the size of GOP is 4, and the frame types are BBBP, we can also specify their relative positions and their reference frames

For example, the datPoc of P frame is 4, and its deltaPoc is -4, because it refers to the first I frame, and the distance is -4. 
Besides, we can also set the deltaQp


.. include:: gop_sub.rst