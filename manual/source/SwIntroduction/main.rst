
SW - Introduction
=================

XKCDC-C-Model is an integrated C model for H264 encoder, H265 codec and NSTD codec,
while sessionTest is a standalone environment for it,
which could do regression test to check the validity and performance (B-D rate)

Contents
--------

   sessionTest includes

   .. table::
      :align: left
      :widths: auto

      ===================================== =============================================================================
       File Name                             Descriptions
      ===================================== =============================================================================
       xkcdc.html                            this document (html version, recomended)
       xkcdc.pdf                             this document (pdf version)
       xkcdc.sh                              regression script
       xkcdc                                 executable file
       cfgBhv/                               behavior related configuration files
       cfgBhv/xkcdc_best.cfg                 behavior related configuration file with best performance
       cfgBhv/xkcdc_high.cfg                 behavior related configuration file with high performance
       cfgBhv/xkcdc_main.cfg                 behavior related configuration file with main performance
       cfgBhv/xkcdc_low.cfg                  behavior related configuration file with low  performance
       cfgGop/                               gop related configuration files
       cfgGop/xkcdc_lowdelay_gop1.cfg        gop related configuration file with gop 1
       cfgGop/xkcdc_randomaccess_gop4.cfg    gop related configuration file with gop 4
       cfgGop/xkcdc_randomaccess_gop8.cfg    gop related configuration file with gop 8
       cfgGop/xkcdc_randomaccess_gop16.cfg   gop related configuration file with gop 16
       cfgGop/xkcdc_randomaccess_gop32.cfg   gop related configuration file with gop 32
       script/                               comparison scripts
       script/getBdRate.py                   B-D rate calculation script (data collection)
       script/getBdRateCore.py               B-D rate calculation script (core calculation)
       script/anchor.log                     comparison anchor (VeriSilicon's coding results)
       dump/runs.log                         md5sum of all the generated bitstreams
       dump/result.log                       PSNR and bit rate information of all the genrated bitsteams
       dump/bdRate.log                       B-D rate results
      ===================================== =============================================================================

Dependency
----------

   sessionTest requires

   .. table::
      :align: left
      :widths: auto

      ==================== ============================================================
       Platform or Tool     Descriptions
      ==================== ============================================================
       Linux                tested on Ubuntu 20.04.3 LTS
       ffmpeg               tested with ffmpeg version 4.2.4-1ubuntu0.1
       md5sum               tested with md5sum GNU coreutils 8.30
       python3 with numpy   tested with Python 3.8.10 (default, Sep 28 2021, 16:10:42)
      ==================== ============================================================

Usage
-----

single run
..........

   #. choose one behaviour configuration file (for example, cfgBhv/xkcdc_main.cfg)
      and one gop configuration file (for example, cfgGop/xkcdc_lowdelay_gop1.cfg)
      and modify them if necessary
   #. execute xkcdc with

      ::

         ./xkcdc -c cfgBhv/xkcdc_main.cfg -c cfgGop/xkcdc_lowdelay_gop1.cfg

      and you will see

      .. image:: usage_singleRun.png
         :width: 80%

simple help
...........

   #. check help with

      ::

         ./xkcdc --help

      and you will see

      .. image:: usage_simpleHelp.png
         :width: 60%

regression run
..............

   #. choose one behaviour configuration file (for example, cfgBhv/xkcdc_main.cfg)
      and one gop configuration file (for example, cfgGop/xkcdc_lowdelay_gop1.cfg)
      and modify them if necessary
   #. | modify xkcdc.sh's parameter CSTR_DIR_SRC to point to the sequence directory if necessary
      | modify xkcdc.sh's parameter LIST_SEQ to list the sequence information if necessary
      | modify xkcdc.sh's parameter LIST_DAT_Q_P to change the tested QP if necessary
      | modify xkcdc.sh's parameter ENUM_LVL_ENC to change the encoding level if necessary
      | modify xkcdc.sh's parameter DATA_PRD_INTRA to change the intra frame's period if necessary
      | modify xkcdc.sh's calling of xkcdc to point to the configuration files you choose if necessary
   #. run xkcdc.sh with

      ::

         ./xkcdc.sh

      and you will see

      .. image:: usage_regressionRunRun.png
         :width: 30%

   #. all the generated files, including the B-D rate results, can be found in directory dump

      .. image:: usage_regressionRunBdRate.png
         :width: 40%

Frequently Asked Questions
--------------------------------


    #. | Where to set parameters ?
       | Parameters can be set in the cfg files (cfgBhv/xkcdc_xxx.cfg, cfgGop/xkcdc_xxx_gopx.cfg), 
         the command line and the regression script(xkcdc.sh), just pay attention to the order
         as the same parameters set later will override the parameters set earlier.

    #. | How to configure frame structure ?
       | Our encoder supports common I/B/P frame structure.
       | **Intra frame** : set the parameter ``datPrdIntra`` for the modification of the I frame period.
       | **Inter frame** : set the parameter ``gopSize`` and the corresponding B/P frame reference relationship 
         in the cfg file (cfgGop/xkcdc_xxx_gopx.cfg) for the modification of the B/P frame structure.
         The parameter configuration is similar to VTM/HM.

    #. | How to configure QP?
       | **Intra frame**: set the parameter ``datQpSeq``.
       | **Inter frame**: set the parameter ``gopDatQpDlt_x``, where ``x`` is the position of the frame in the gop structure.

    #. | How to configure rate control ?
       | Set the parameter ``r_cFlg_0`` to 1, 
         and the parameter ``r_cDatBps`` to the target bitrate (kbps).

    #. | How to choose the target level ?
       | There are corresponding hardware implementations for the 
         level-main (cfgBhv/xkcdc_main.cfg) and the level-low (cfgBhv/xkcdc_low.cfg).
         The area and throughput of the level-low is about halved of the level-main 
         with a BD-rate deterioration of about 5%.