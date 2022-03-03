HW - Introduction
=================

XKCDC-RTL is an integrated C model for H264 encoder, H265 codec and NSTD codec

Diagram
-------

   .. image:: diagram.png
      :width: 40%

   Default version has 5 LCU stages.

   #. For I frame encoding,

      * stage 0 will wake up module FTH to read original pixels
      * stage 1 will wake up module RMD to do intra rough mode decision
      * stage 2 will wake up module RDO, REC, DBF and SAO to do final decision of mode and partition, reconstruction, deblocking and sample adopative optimization
      * stage 3 will wake up module E_C to do entropy encoding
      * stage 4 will wake up module DMP to dump reconstructed pixels

   #. For P frame encoding,

      * stage 0 will wake up module FTH to read original and reference pixels
      * stage 1 will wake up module RMD to do intra rough mode decision if feature IinP is enabled
      * stage 1 will also wake up module IME and FME to do integer and fractional motion estimation
      * stage 2 will wake up module RDO, REC, DBF and SAO to do final decision of mode and partition, reconstruction, deblocking and sample adopative optimization
      * stage 3 will wake up module E_C to do entropy encoding
      * stage 4 will wake up module DMP to dump reconstructed pixels

   #. For I frame decoding,

      * stage 0 does nothing
      * stage 1 will wake up module E_D to do entropy decoding
      * stage 2 will wake up module REC, DBF and SAO to do reconstruction, deblocking and sample adopative optimization
      * stage 3 does nothing
      * stage 4 will wake up module DMP to dump reconstructed pixels

   #. For P frame decoding,

      * stage 0 wake up module FTH to read reference pixels
      * stage 1 will wake up module E_D to do entropy decoding
      * stage 2 will wake up module REC, DBF and SAO to do reconstruction, deblocking and sample adopative optimization
      * stage 3 does nothing
      * stage 4 will wake up module DMP to dump reconstructed pixels


Interface
---------

   .. table::
      :align: left
      :widths: auto

      ======== ================= ============ ============ =============================================
       Group    Name              Direction    Data width   Descriptions
      ======== ================= ============ ============ =============================================
       global   clk               I            1            clock 
       \        rstn              I            1            reset, low active
       \        clk_e_d           I            1            clock for module E_D
       \        rstn_e_d          I            1            reset for module E_D, low active
       apb_s    apb_s_paddr_i     I            32           please refer to APB protocal
       \        apb_s_penable_i   I            1            please refer to APB protocal
       \        apb_s_psel_i      I            1            please refer to APB protocal
       \        apb_s_pwdata_i    I            32           please refer to APB protocal
       \        apb_s_pwrite_i    I            1            please refer to APB protocal
       \        apb_s_pready_o    O            1            please refer to APB protocal
       \        apb_s_prdata_o    O            32           please refer to APB protocal
       \        apb_s_pslverr_o   O            1            please refer to APB protocal
       axi_m    axi_m_araddr_o    O            32           please refer to AXI protocal
       \        axi_m_arburst_o   O            2            please refer to AXI protocal
       \        axi_m_arcache_o   O            4            please refer to AXI protocal
       \        axi_m_arid_o      O            4            please refer to AXI protocal
       \        axi_m_arlen_o     O            4            please refer to AXI protocal
       \        axi_m_arlock_o    O            2            please refer to AXI protocal
       \        axi_m_arprot_o    O            3            please refer to AXI protocal
       \        axi_m_arsize_o    O            3            please refer to AXI protocal
       \        axi_m_arvalid_o   O            1            please refer to AXI protocal
       \        axi_m_arready_i   I            1            please refer to AXI protocal
       \        axi_m_awaddr_o    O            32           please refer to AXI protocal
       \        axi_m_awburst_o   O            2            please refer to AXI protocal
       \        axi_m_awcache_o   O            4            please refer to AXI protocal
       \        axi_m_awid_o      O            4            please refer to AXI protocal
       \        axi_m_awlen_o     O            4            please refer to AXI protocal
       \        axi_m_awlock_o    O            2            please refer to AXI protocal
       \        axi_m_awprot_o    O            3            please refer to AXI protocal
       \        axi_m_awsize_o    O            3            please refer to AXI protocal
       \        axi_m_awvalid_o   O            1            please refer to AXI protocal
       \        axi_m_awready_i   I            1            please refer to AXI protocal
       \        axi_m_rdata_i     I            128          please refer to AXI protocal
       \        axi_m_rid_i       I            4            please refer to AXI protocal
       \        axi_m_rlast_i     I            1            please refer to AXI protocal
       \        axi_m_rresp_i     I            2            please refer to AXI protocal
       \        axi_m_rvalid_i    I            1            please refer to AXI protocal
       \        axi_m_rready_o    O            1            please refer to AXI protocal
       \        axi_m_wid_o       O            4            please refer to AXI protocal
       \        axi_m_wlast_o     O            1            please refer to AXI protocal
       \        axi_m_wstrb_o     O            16           please refer to AXI protocal
       \        axi_m_wvalid_o    O            1            please refer to AXI protocal
       \        axi_m_wdata_o     O            128          please refer to AXI protocal
       \        axi_m_wready_i    I            1            please refer to AXI protocal
       \        axi_m_bid_i       I            4            please refer to AXI protocal
       \        axi_m_bresp_i     I            2            please refer to AXI protocal
       \        axi_m_bvalid_i    I            1            please refer to AXI protocal
       \        axi_m_bready_o    O            1            please refer to AXI protocal
       ERR      err_o             O            2            error indicator, level signal, high active
       \                                                    bit 0: time out
       \                                                    bit 1: frame loss
       IRQ      irq_bgn_o         O            2            interupt of begin, level signal, high active
       \                                                    bit 0: kernel
       \                                                    bit 1: interface
       \        irq_end_o         O            2            interupt of end, level signal, high active
       \                                                    bit 0: kernel
       \                                                    bit 1: interface
      ======== ================= ============ ============ =============================================



Integration Consideration
--------------------------
    #. **CLOCK**

       There are two clocks ``clk`` and ``clk_e_d``, which are asynchronously processed internally. 
       The top layer can give asynchronous clocks or synchronous clocks, 
       but it is recommended that the clock frequency of ``clk_e_d`` be lower.

    #. **Standard Cell and Memory**

       There is no replacement requirement for standard cells.

       The logical memory used is shown below.
       In the type column, ``sram_sp_behave`` refers to single port, 
       ``sram_sp_be_behave`` refers to single port with bit enable,
       ``sram_tp_behave`` and ``fifo`` refer to pseudo dual port. 
       Besides, ``sizeMem`` refers to depth while ``dataMemWd`` refers to width.

       .. image:: mem_logical.png
         :width: 60%

       The four physical memories placed by default are shown below. 1. 
       Behavioral model 2. FPGA model 3. GF22 model 4. GF28 model. 
       The switch is in include/define.vh, the behavior model is enabled by default, 
       and the behavior model under lib/behave is called; 
       The other three models are FPGA_INST, GF_22_INST and GF_28_INST under src/enc/enc_mem. 
       Only the model of FPGA_INST is provided, all files with the suffix ``v`` are models, 
       and all files with the suffix ``vh`` are instantiation. 
       Meanwhile, there is no split inside, only a piece of memory is instantiated.
       Only files with the suffix ``vh`` need to be replaced in the code. 

       .. image:: mem_physical.png
         :width: 60%

    #. **AXI Interface**

       AXI3.0 is used, without different ID and outstanding. The maximum burst length is 
       ```SIZE_LCU*`DATA_PXL_WD/`ITF_DATA_AXI_DAT_WD``, and other bit width information is 
       under ``DEFINE FOR ITF`` in defines_enc.vh.



Register
--------

   .. table::
      :align: left
      :widths: auto

      ======= ================ ======== ======= ============ ====== ======== =============
       group   name             offset   width   behaviour    bank   shadow   description
      ======= ================ ======== ======= ============ ====== ======== =============
       TOP     DAT_VER          000      32      R,           no     no       version
       \       FLG_RUN          001      1       R, W, SC     no     yes      start, high active, self clear
       \       FLG_ERR          002      2       R, W         no     no       enable flag for error indicators, high active
       \                                                                      bit 0: time out
       \                                                                      bit 1: frame loss
       \       FLG_IRQ_BGN      003      2       R, W         no     no       enable flag for begin interupts, high active
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       FLG_IRQ_END      004      2       R, W         no     no       enable flag for end interupts, high active
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       FLG_BNK          005      2       R, W         no     yes      enable for flag for banks, high active
       \                                                                      bit 0: bank 0
       \                                                                      bit 1: bank 1
       \       FLG_SIZ_PU       006      4       R, W         no     no       enable for flag for PU, high active
       \                                                                      bit 0: PU 04×04
       \                                                                      bit 1: PU 08×08
       \                                                                      bit 2: PU 16x16
       \                                                                      bit 3: PU 32x32
       \       MSK_ERR          007      2       R, W         no     no       mask for error indicators, high active
       \                                                                      bit 0: time out
       \                                                                      bit 1: frame loss
       \       MSK_IRQ_BGN      008      2       R, W         no     no       mask for begin interupts, high active
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       MSK_IRQ_END      009      2       R, W         no     no       mask for end interupts, high active
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       CLR_ERR          010      2       R, W, SC     no     no       mask for error indicators, high active, self clear
       \                                                                      bit 0: time out
       \                                                                      bit 1: frame loss
       \       CLR_IRQ_BGN      011      2       R, W, SC     no     no       mask for begin interupts, high active, self clear
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       CLR_IRQ_END      012      2       R, W, SC     no     no       mask for end interupts, high active, self clear
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       SIZ_FRA_X        013      12      R, W         yes    no       frame width
       \                                                                      value x -> x + 1 pixel in width
       \       SIZ_FRA_Y        014      12      R, W         yes    no       frame height
       \                                                                      value x -> x + 1 pixel in height
       \       ENM_MOD_RUN      015      1       R, W         no     no       run mode
       \                                                                      value 0: encoding
       \                                                                      value 1: deoding
       \       ENM_TYP          016      1       R, W         yes    yes      encoding type
       \                                                                      value 0: intra
       \                                                                      value 1: inter
       \       DAT_QP           017      6       R, W         yes    yes      qp
       \       DAT_DLY_MAX      018      32      R, W         no     no       maximum cycle in one LCU stages, if exceed, time-out error would assert
       \                                                                      value x: x + 1 cycle
       \       FLG_RUN          019      2       R,           no     no       start indicator
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       FLG_ERR          020      2       R,           no     no       error indicator, high active
       \                                                                      bit 0: time out
       \                                                                      bit 1: frame loss
       \       FLG_IRQ_BGN      021      2       R,           no     no       begin indicator, high active
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       FLG_IRQ_END      022      2       R,           no     no       end indicator, high active
       \                                                                      bit 0: kernel
       \                                                                      bit 1: interface
       \       IDX_LCU_X        023      7       R,           yes    no       horizontal position of current LCU
       \       IDX_LCU_Y        024      7       R,           yes    no       vertical position of current LCU

       FTH     DAT_SRC_ORI      025      1       R, W         no     no       the source of original pixels to be processed by FTH
       \                                                                      0: externel memory; 1:cache
       \       SIZ_REF_Y        026      5       R, W         no     no       the height (h) of the reference pixels to be processed by FTH
       \                                                                      vertically [-h+1, h-1] and horizontally [-64, 64]

       RMD     NUM_GRP          027      4       R, W         no     no       the number of groups of search modes that RMD needs to process
       \                                                                      n: RMD needs to search the first (n + 1) groups of modes, n belongs to [0,12]
       \       DAT_MOD_A        028      18      R, W         no     no       the 5n~(5n+4) search mode to be processed by RMD, where n = 0
       \                                                                      bit 29:24 : nth search mode (x: The search mode is x, where x belongs to [0, 34] and {63})
       \                                                                      bit 23:18 : (n+1)th search mode
       \                                                                      bit 17:12 : (n+2)th search mode 
       \                                                                      bit 11:06 : (n+3)th search mode
       \                                                                      bit 05:00 : (n+4)th search mode
       \                                                                      three modes is a group, and modes 0, 1, 10 and 26 can only appear in position 0 of each group
       \                                                                      three modes of the same group must belong only to [2, 17] or belong to {0, 1} and [18, 34]
       \                                                                      if the mode value is 63, the mode does not participate in the search process
       \       DAT_MOD_B        029      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 1, other definitions are as above
       \       DAT_MOD_C        030      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 2, other definitions are as above
       \       DAT_MOD_D        031      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 3, other definitions are as above
       \       DAT_MOD_E        032      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 4, other definitions are as above
       \       DAT_MOD_F        033      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 5, other definitions are as above
       \       DAT_MOD_G        034      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 6, other definitions are as above
       \       DAT_MOD_H        035      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 7, other definitions are as above
       \       DAT_MOD_I        036      18      R, W         no     no       the 5n~5n+4 search mode to be processed by RMD, where n = 8, other definitions are as above

       IME     NUM_PTN          037      3       R, W         no     no       Number of search patterns to be processed by IME.
       \                                                                      n: IME needs to execute the first n + 1 patterns, n belongs to [0, 7].
       \       DAT_PTN_0        038      30      R, W         no     no       The 0th search pattern of the IME.
       \                                                                      bit 29-27 (Source of the center of the search pattern):
       \                                                                         0 : Centered on the IMV described by the register. 
       \                                                                         1 : Centered on the result of LCU. 
       \                                                                         2 : Centered on the result of the 0th QLCU.
       \                                                                         3 : Centered on the result of the 1st QLCU.
       \                                                                         4 : Centered on the result of the 2nd QLCU.
       \                                                                         5 : Centered on the result of the 3rd QLCU.
       \                                                                      bit 26-20 (IMV horizontal coordinate of the register description).
       \                                                                      bit 19-14 (IMV vertical coordinate described by the register).
       \                                                                      bit 13-08 (The width of the search pattern):
       \                                                                         -w the width w pixels of the search pattern.
       \                                                                      bit 07-03 (the height of the search pattern):
       \                                                                         -h height h pixels of the search pattern.
       \                                                                      bit 02-01 (the slope of the search pattern):
       \                                                                         0 : 1/2.
       \                                                                         1 : 1/1.
       \                                                                         2 : 2/1.
       \                                                                         3 : inf.
       \                                                                      bit 00 (downsampling enable, high valid).
       \       DAT_PTN_1        039      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_PTN_2        040      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_PTN_3        041      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_PTN_4        042      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_PTN_5        043      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_PTN_6        044      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_PTN_7        045      30      R, W         no     no       Same as DAT_PTN_0.
       \       DAT_SCL_MVD      046      8       R, W         no     no       MVD cost scaling during IME:
       \                                                                         X : MVD cost scaling is x / 32 times.

       FME     FLG_PRT          047      1       R, W         no     no       FME uses pre-partition to enable high efficiency.
       \       NUM_TRV          048      1       R, W         no     no       Number of traversals required to process FME.
       \                                                                         n: FME needs to process the first n + 1 traversal, n belongs to [0, 1].
       \       NUM_CTR          049      4       R, W         no     no       Number of search centers that FME needs to process.
       \                                                                         bit 3-2 : the number of search centers to process for the 0th traverse.
       \                                                                            n: This traversal needs n + 1 centers before processing, and n belongs to [0, 2].
       \                                                                         bit 1-0 : Number of search centers to process for the first traversal.
       \       ENM_CTR          050      12      R, W         no     no       Search centers to be processed by FME.
       \                                                                         bit 23-21 : (the 0th center of the 0th traversal).
       \                                                                            0: centered on the IMV of the current block.
       \                                                                            1: centered on the MvpA of the current block.
       \                                                                            2: centered on the MvpB of the current block.
       \                                                                            3: centered on (0,0).
       \                                                                            4: centered on the FMV of the current block.
       \                                                                         bit 20-18 : the 1st center of the 0th traversal.
       \                                                                         bit 17-15 : 2nd center of the 0th traversal.
       \                                                                         bit 14-12 : 3rd center of the 0th traversal.
       \                                                                         bit 11-09 : 0th center of the 1st iteration.
       \                                                                         bit 08-06 : center 0 of 1st iteration.
       \                                                                         bit 08-06 : 1st center of the 1st iteration.
       \                                                                         bit 05-03 : 2nd center of the 1st iteration.
       \                                                                         bit 02-00 : 3rd center of the 1st iteration.
       \       ENM_ITP          051      12      R, W         no     no       The way FME needs to handle the search center.
       \                                                                         bit 15-14 : 0th traversal of 0th way.
       \                                                                            0: 1/2 interpolation.
       \                                                                            1: 1/4 interpolation.
       \                                                                            2: no interpolation.
       \                                                                         bit 13-12 : 1 way for the 0th iteration.
       \                                                                         bit 11-10 : 2 ways of the 0th iteration.
       \                                                                         bit 09-08 : 3 ways of the 0th iteration.
       \                                                                         bit 07-06 : 0 ways of the 1st iteration.
       \                                                                         bit 05-04 : 1 way of the 1st iteration.
       \                                                                         bit 03-02 : 2 ways of the 1st iteration.
       \                                                                         bit 01-00 : 3 ways of the 1st iteration.
       \       DAT_SCL_MVD      052      8       R, W         no     no       Scaling of MVD tokens in the IME process.
       \                                                                         x : MVD tokens are scaled to x / 32 times.
       \       DAT_DLY          053      33      R, W         no     no       FME startup delay between each processing round.
       \                                                                         n : delayed n-cycle start, n belongs to [0, 32].

       RDO     FLG_PRT          054      1       R, W         no     no       enable flag for RDO adopts pre-stage partition, high active
       \       FLG_ADD_LU_01    055      1       R, W         no     no       enable flag for RDO additionally tests modes 0 and 1 for luma, high active
       \       FLG_SET_CH_36    056      1       R, W         no     no       enable flag for RDO forced chroma mode to 36, high active
       \       NUM_MOD          057      2       R, W         no     no       rough number of modes that RDO needs to process
       \                                                                      n: RDO needs to process the first (n + 1) rough modes
       \                                                                      n belongs to [0, 2]
       \       DAT_SCL          058      32      R, W         no     no       Lambda scaling factor during stage RDO
       \                                                                      bit 31:24 : I-frame luma channel (x: Lambda scaled to x / 32 times)
       \                                                                      bit 23:16 : I-frame chroma channel 
       \                                                                      bit 15:08 : P-frame luma channel 
       \                                                                      bit 07:00 : P-frame chroma channel
       \       DAT_FIT_I_CU_0   059      14      R, W         no     no       parameter to calculate CU fitting RCst when size equals to 4 for luma channel in I-block
       \       DAT_FIT_I_CU_1   060      14      R, W         no     no       parameter to calculate CU fitting RCst when size equals to 8 for luma channel in I-block
       \       DAT_FIT_I_PU_0   061      14      R, W         no     no       parameter to calculate PU fitting RCst when idxMpm equals to -1 for luma channel in I-block
       \       DAT_FIT_I_PU_1   062      14      R, W         no     no       parameter to calculate PU fitting RCst when idxMpm equals to 0 for luma channel in I-block
       \       DAT_FIT_I_PU_2   063      14      R, W         no     no       parameter to calculate PU fitting RCst when idxMpm equals to 1 for luma channel in I-block
       \       DAT_FIT_I_PU_3   064      14      R, W         no     no       parameter to calculate PU fitting RCst when idxMpm equals to 2 for luma channel in I-block
       \       DAT_FIT_I_PU_4   065      14      R, W         no     no       parameter to calculate PU fitting RCst when idxMpm equals to -1 for chroma channel in I-block
       \       DAT_FIT_I_PU_5   066      14      R, W         no     no       parameter to calculate PU fitting RCst when idxMpm equals to 0 for chroma channel in I-block
       \       DAT_FIT_I_TU_0   067      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 4 for luma in I-block
       \       DAT_FIT_I_TU_1   068      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 8 for luma in I-block
       \       DAT_FIT_I_TU_2   069      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 16 for luma in I-block
       \       DAT_FIT_I_TU_3   070      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 32 for luma in I-block
       \       DAT_FIT_I_TU_4   071      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 4 for chroma in I-block
       \       DAT_FIT_I_TU_5   072      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 8 for chroma in I-block
       \       DAT_FIT_I_TU_6   073      28      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 16 for chroma in I-block
       \       DAT_FIT_P_CU_0   074      14      R, W         no     no       parameter to calculate CU fitting RCst for luma channel in P-block
       \       DAT_FIT_P_PU_0   075      14      R, W         no     no       parameter to calculate PU flgMrg fitting RCst when flgMrg equals to 0 in P-block
       \       DAT_FIT_P_PU_1   076      14      R, W         no     no       parameter to calculate PU flgMrg fitting RCst when flgMrg equals to 1 in P-block
       \       DAT_FIT_P_PU_2   077      14      R, W         no     no       parameter to calculate PU idxMvp fitting RCst when idxMvp equals to 0 in P-block
       \       DAT_FIT_P_PU_3   078      14      R, W         no     no       parameter to calculate PU idxMvp fitting RCst when idxMvp equals to 1 in P-block
       \       DAT_FIT_P_PU_4   079      14      R, W         no     no       parameter to calculate PU idxMrg fitting RCst when idxMrg equals to 0 in P-block
       \       DAT_FIT_P_PU_5   080      14      R, W         no     no       parameter to calculate PU idxMrg fitting RCst when idxMrg equals to 1 or 2 in P-block
       \       DAT_FIT_P_PU_6   081      14      R, W         no     no       parameter to calculate PU mvd fitting RCst in P-block
       \       DAT_FIT_P_TU_0   082      14      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 8 for luma in P-block
       \       DAT_FIT_P_TU_1   083      14      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 16 for luma in P-block
       \       DAT_FIT_P_TU_2   084      14      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 32 for luma in P-block
       \       DAT_FIT_P_TU_3   085      14      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 4 for chroma in P-block
       \       DAT_FIT_P_TU_4   086      14      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 8 for chroma in P-block
       \       DAT_FIT_P_TU_5   087      14      R, W         no     no       parameter to calculate TU fitting RCst when size equals to 16 for chroma in P-block
       \       DAT_DLY_08       088      5       R, W         no     no       startup delay between each 08x08 block of RDO
       \                                                                      n: delay n cycles to start, n belongs to [0, 19]
       \       DAT_DLY_16       089      8       R, W         no     no       startup delay between each 16x16 block of RDO
       \                                                                      n: delay n cycles to start, n belongs to [0, 69]
       \       DAT_DLY_32       090      9       R, W         no     no       startup delay between each 32x32 block of RDO
       \                                                                      n: delay n cycles to start, n belongs to [0, 349]

       ILF     FLG_DBF          091      1       R, W         no     no       enable flag for deblocking filter, high active
       \       FLG_SAO          092      2       R, W         no     no       enable flag for sample adaptive offset, high active
       \                                                                      bit 1: chroma
       \                                                                      bit 0: luma
       \       DAT_OFF_BT_DIV2  093      6       R, W         no     no       offsetBetaDiv2 parameter for deblocking filter
       \       DAT_OFF_TC_DIV2  094      6       R, W         no     no       offsetTcDiv2 parameter for deblocking filter
       \       DAT_SCL_LMD      095      8       R, W         no     no       lambda scaling for in-loop filter
       \                                                                      bit 07:00 -> luma channel of intra frame
       \                                                                      value x: lambda is scaled to x of thirty two

       IIP     FLG              096      1       R, W         no     no       enable flag for IIP, high active
       \       DAT_SCL_ON_QP_0  097      32      R, W         no     no       the (4n~4n+3)th scaling factor of the IIP process based on QP, here n = 0
       \                                                                      bit 31-24: the (4n)th scaling factor , x: the corresponding rate cost scaling is x/32
       \                                                                      bit 23-16: the (4n+1)th scaling factor
       \                                                                      bit 15-08: the (4n+2)th scaling factor
       \                                                                      bit 07-00: the (4n+3)th scaling factor
       \                                                                      the 0th to 12th scaling factors correspond to the cases when the QP belongs to 0~19, 20~21, 22~23, 24~25, 26~27, 28~29, 30~31, 32~33, 34~35, 36~37, 38~39, 40~41, 42~43, 44~51 and act on the rate cost block of the I block
       \       DAT_SCL_ON_QP_1  098      32      R, W         no     no       the (4n~4n+3)th scaling factor of the IIP process based on QP, here n = 1 , other ibid
       \       DAT_SCL_ON_QP_2  099      32      R, W         no     no       the (4n~4n+3)th scaling factor of the IIP process based on QP, here n = 2 , other ibid
       \       DAT_SCL_ON_QP_3  100      16      R, W         no     no       the 12th~13th scaling factor of the IIP process based on qp
       \                                                                      bit 15-08: the 12th scaling factor
                                                                              bit 07-00: the 13th scaling factor
       \       DAT_SCL_ON_MV_0  101      32      R, W         no     no       the (4n~4n+3)th scaling factor of the IIP process based on MV, here n = 0
       \                                                                      bit 31-24: the (4n)th scaling factor, x: the corresponding rate cost scaling is x/32
       \                                                                      bit 23-16: the (4n+1)th scaling factor
       \                                                                      bit 15-08: the (4n+2)th scaling factor
       \                                                                      bit 07-00: the (4n+3)th scaling factor
       \                                                                      the 0th to 12th scaling factors correspond to the cases when the abs of FMV belongs to 0~7, 8~15, 16~23, 24~31, 31~inf and act on the rate cost block of the I block
       \       DAT_SCL_ON_MV_1  102      8       R, W         no     no       the 4th scaling factor of the IIP process based on MV
       \                                                                      bit 07-00: the 4th scaling factor

       MRG     FLG              103      1       R, W         no     no       enable flag for MRG, high active

       SKP     FLG              104      1       R, W         no     no       enable flag for SKP, high active
       \       DAT_SCL_ON_CHN   105      16      R, W         no     no       the scaling factor of the SKP process based on CHN
       \                                                                      bit 15-08: the scaling factor of chroma channal, x: the corresponding rate cost scaling is x/32
       \                                                                      bit 15-08: the scaling factor of luma channal
       \       DAT_SCL_ON_QP_0  106      32      R, W         no     no       the (4n~4n+3)th scaling factor of the SKP process based on QP, here n = 0
       \                                                                      bit 31-24: the (4n)th scaling factor, x: the corresponding rate cost scaling is x/32
       \                                                                      bit 23-16: the (4n+1)th scaling factor
       \                                                                      bit 15-08: the (4n+2)th scaling factor
       \                                                                      bit 07-00: the (4n+3)th scaling factor
       \                                                                      the 0th to 12th scaling factors correspond to the cases when the QP belongs to 0~19, 20~21, 22~23, 24~25, 26~27, 28~29, 30~31, 32~33, 34~35, 36~37, 38~39, 40~41, 42~43, 44~51 and act on the TU rate cost of non-SKP blocks
       \       DAT_SCL_ON_QP_1  107      32      R, W         no     no       the (4n~4n+3)th scaling factor of the SKP process based on QP, here n = 1 , other ibid
       \       DAT_SCL_ON_QP_2  108      32      R, W         no     no       the (4n~4n+3)th scaling factor of the SKP process based on QP, here n = 2 , other ibid
       \       DAT_SCL_ON_QP_3  109      16      R, W         no     no       the 12th~13th scaling factor of the SKP process based on qp
       \                                                                      bit 15-08: the 12th scaling factor
       \                                                                      bit 07-00: the 13th scaling factor
       \       DAT_SCL_ON_MV_0  110      32      R, W         no     no       the (4n~4n+3)th scaling factor of the SKP process based on MV, here n = 0
       \                                                                      bit 31-24: the (4n)th scaling factor, x: the corresponding rate cost scaling is x/32
       \                                                                      bit 23-16: the (4n+1)th scaling factor
       \                                                                      bit 15-08: the (4n+2)th scaling factor
       \                                                                      bit 07-00: the (4n+3)th scaling factor
       \                                                                      the 0th to 12th scaling factors correspond to the cases when the abs of FMV belongs to 0~7, 8~15, 16~23, 24~31, 31~inf and act on the TU rate cost of non-SKP blocks
       \       DAT_SCL_ON_MV_1  111      8       R, W         no     no       the 4th scaling factor of the SKP process based on MV
       \                                                                      bit 07-00: the 4th scaling factor

       ITF     FLG_0X03         112      1       R, W         no     no       enable flag for adding/removing 0x03, high avtive
       \       FLG_RFC          113      1       R, W         no     no       enable flag for reference frame compression (RFC), high avtive
       \       FLG_REC_EXT      114      1       R, W         yes    yes      enable flag for exporting an additional reconstructed pixels, high active 
       \       ENM_WRAPMEM      115      2       R, W         no     no       enable flag for rotational storage
       \                                                                      0: no rotation
       \                                                                      1: software configuration
       \                                                                      2: hardware adaptive rotation
       \       ENM_REORDER      116      32      R, W         no     no       enable flag for reordering
       \                                                                      0: normal order
       \                                                                      1: rotate 90° clockwise to read
       \       NUM_BS_ENC_MAX   117      32      R, W         yes    yes      the maximum value of the bitstream length, high effective
       \                                                                      n: the length of the bitstream does not exceed n bytes
       \       NUM_BS_ENC       118      32      R,           yes    yes      the length of the bitstream obtained from the encoder(byte)
       \                                                                      n: get the bitstream of n bytes
       \       NUM_BS_DEC       119      32      R, W         no     yes      the length of the bitstream sent to the decoder(byte)
       \                                                                      n: will deliver a bitstream of n bytes
       \       ADR_ORI_LU       120      32      R, W         yes    yes      the memory address assigned for the original pixels of luminance component
       \                                                                      the unit of address is byte, the same below.
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_ORI_CH       121      32      R, W         yes    yes      the memory address assigned for the original pixels of chroma component
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_REF_LU       122      32      R, W         yes    yes      the memory address assigned for the reference pixels of luminance component
       \                                                                      (data part, always valid)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_REF_CH       123      32      R, W         yes    yes      the memory address assigned for the reference pixels of chroma component
       \                                                                      (data part, always valid)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_REC_LU       124      32      R, W         yes    yes      the memory address assigned for the reconstructed pixels of luminance component
       \                                                                      (data part, always valid)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_REC_CH       125      32      R, W         yes    yes      the memory address assigned for the reconstructed pixels of chroma component
       \                                                                      (data part, always valid)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_REC_EXT_LU   126      32      R, W         yes    yes      the memory address assigned for the additional reconstructed pixels of luminance component
       \                                                                      (data part, always valid)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_REC_EXT_CH   127      32      R, W         yes    yes      the memory address assigned for the additional reconstructed pixels of chroma component
       \                                                                      (data part, always valid)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_BS           128      32      R, W         yes    yes      the memory address assigned for the bitstream
       \                                                                      (no alignment required)
       \       ADR_PRM_REF_LU   129      32      R, W         yes    yes      the memory address assigned for the reference pixels of luminance component
       \                                                                      (parameter part, only valid when RFC is enabled)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_PRM_REF_CH   130      32      R, W         yes    yes      the memory address assigned for the reference pixels of chroma component
       \                                                                      (parameter part, only valid when RFC is enabled)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_PRM_REC_LU   131      32      R, W         yes    yes      the memory address assigned for the reconstructed pixels of luminance component
       \                                                                      (parameter part, only valid when RFC is enabled)
       \                                                                      (requires 32 byte alignment.) 
       \       ADR_PRM_REC_CH   132      32      R, W         yes    yes       the memory address assigned for the reconstructed pixels of chroma component
       \                                                                      (parameter part, only valid when RFC is enabled)
       \                                                                      (requires 32 byte alignment.) 
       \       STR_ORI_LU       133      32      R, W         yes    yes      the storage step size assigned for the original pixels of luminance component
       \                                                                      the unit is byte, the same below
       \                                                                      the original pixels are stored in rows, and the step size describes the relative offset between rows.
       \                                                                      (requires 32 byte alignment.) 
       \       STR_ORI_CH       134      32      R, W         yes    yes      the storage step size assigned for the original pixels of chroma component
       \                                                                      (requires 32 byte alignment.) 
       \       STR_REF_LU       135      32      R, W         yes    yes      the storage step size assigned for the reference pixels of luminance component
       \                                                                      the reference pixels are stored in rows when RFC is disabled, and the step size describes the relative offset between rows.
       \                                                                      the reference pixels are stored in 4 LCU when RFC is enabled, and the step size describes the relative offset between blocks.
       \                                                                      (requires 32 byte alignment.) 
       \       STR_REF_CH       136      32      R, W         yes    yes      the storage step size assigned for the reference pixels of chroma component
       \                                                                      (requires 32 byte alignment.) 
       \       STR_REC_LU       137      32      R, W         yes    yes      the storage step size assigned for the reconstructed pixels of luminance component
       \                                                                      the reconstructed pixels are stored in rows when RFC is disabled, and the step size describes the relative offset between rows.
       \                                                                      the reconstructed pixels are stored in 4 LCU when RFC is enabled, and the step size describes the relative offset between blocks.
       \                                                                      (requires 32 byte alignment.) 
       \       STR_REC_CH       138      32      R, W         yes    yes      the storage step size assigned for the reconstructed pixels of chroma component
       \                                                                      (requires 32 byte alignment.) 
       \       STR_RFC          139      32      R, W         yes    yes      to be removed
       \       SIZ_FRA_LU       140      32      R, W         yes    no       the storage space for one reconstructed or reference frame of luminance component
       \                                                                      (enabled when ENM_WRAPMEM equals to 2)
       \       SIZ_FRA_CH       141      32      R, W         yes    no       the storage space for one reconstructed or reference frame of chroma component
       \                                                                      (enabled when ENM_WRAPMEM equals to 2)
       \       SIZ_MEM_LU       142      32      R, W         yes    no       the storage space for reconstructed and reference pixels of luminance component
       \                                                                      (enabled when ENM_WRAPMEM equals to 1 or 2)
       \       SIZ_MEM_CH       143      32      R, W         yes    no       the storage space for reconstructed and reference pixels of chroma component
       \                                                                      (enabled when ENM_WRAPMEM equals to 1 or 2)
       \       OFF_REF_LU       144      32      R, W         yes    yes      the offset for reference pixels of luminance component in the rotation space
       \                                                                      (enabled when ENM_WRAPMEM equals to 1)
       \       OFF_REF_CH       145      32      R, W         yes    yes      the offset for reference pixels of chroma component in the rotation space
       \                                                                      (enabled when ENM_WRAPMEM equals to 1)
       \       OFF_REC_LU       146      32      R, W         yes    yes      the offset for reconstructed pixels of luminance component in the rotation space
       \                                                                      (enabled when ENM_WRAPMEM equals to 1)
       \       OFF_REC_CH       147      32      R, W         yes    yes      the offset for reconstructed pixels of chroma component in the rotation space
       \                                                                      (enabled when ENM_WRAPMEM equals to 1)

       DBG     NUM_SIZ_PU_04    148      32      R,           yes    yes      the number of 04x04 PUs in a frame
       \       NUM_SIZ_PU_08    149      32      R,           yes    yes      the number of 08x08 PUs in a frame
       \       NUM_SIZ_PU_16    150      32      R,           yes    yes      the number of 16x16 PUs in a frame
       \       NUM_SIZ_PU_32    151      32      R,           yes    yes      the number of 32x32 PUs in a frame
       \       NUM_TYP_PU_I     152      32      R,           yes    yes      the number of I blocks in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_TYP_PU_P     153      32      R,           yes    yes      the number of P blocks in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_TYP_PU_M     154      32      R,           yes    yes      the number of Merge blocks in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_TYP_PU_S     155      32      R,           yes    yes      the number of Skip blocks in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_FMV_00_07    156      32      R,           yes    yes      the number of blocks with FMV less than 08 in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_FMV_08_15    157      32      R,           yes    yes      the number of blocks with FMV less than 16 in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_FMV_16_23    158      32      R,           yes    yes      the number of blocks with FMV less than 24 in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       NUM_FMV_24_31    159      32      R,           yes    yes      the number of blocks with FMV less than 32 in the P frame
       \                                                                      (in the unit of 8x8 blocks)
       \       DAT_QP           160      32      R,           yes    yes      the sum of QPs in a frame 
       \                                                                      (in the unit of LCU)
       \       DAT_LMD          161      32      R,           yes    yes      the sum of LUMDAs in a frame 
       \                                                                      (in the unit of LCU)
       \       ENM_SRC_BNK      162      1       R, W         no     no       the control source for bank
       \                                                                      0: register
       \                                                                      1: externel

       ROI     0_POS            163      28      R, W         yes    yes      the position for region of interest (ROI) 0
       \                                                                      bit 27:21 -> the horizontal position of the start LCU
       \                                                                      bit 20:14 -> the vertical position of the start LCU
       \                                                                      bit 13:07 -> the horizontal position of the end LCU
       \                                                                      bit 06:00 -> the vertical position of the end LCU
       \       0_ENM_TYP        164      2       R, W         yes    yes      the block type for ROI 0
       \                                                                      bit 1:0 -> the forced block type
       \                                                                      0: no force
       \                                                                      1: intra block
       \                                                                      2: inter block
       \                                                                      3: skip block
       \       0_DAT_QP         165      7       R, W         yes    yes      the QP for ROI 0
       \                                                                      bit 6 -> the enable flag for the forced QP
       \                                                                      bit 5:0 -> the forced QP
       \       1_POS            166      28      R, W         yes    yes      the position for region of interest (ROI)1
       \                                                                      bit 27:21 -> the horizontal position of the start LCU
       \                                                                      bit 20:14 -> the vertical position of the start LCU
       \                                                                      bit 13:07 -> the horizontal position of the end LCU
       \                                                                      bit 06:00 -> the vertical position of the end LCU
       \       1_ENM_TYP        167      2       R, W         yes    yes      the block type for ROI 1
       \                                                                      bit 1:0 -> the forced block type
       \                                                                      0: no force
       \                                                                      1: intra block
       \                                                                      2: inter block
       \                                                                      3: skip block
       \       1_DAT_QP         168      7       R, W         yes    yes      the QP for ROI 1
       \                                                                      bit 6 -> the enable flag for the forced QP
       \                                                                      bit 5:0 -> the forced QP

       R_C     NUM_BPP          169      16      R, W         yes    yes      the target bit per pixel (BPP)
       \                                                                      x: target BPP equals x / 256
       \       DAT_QP_MIN       170      6       R, W         yes    yes      the minimum QP
       \       DAT_QP_MAX       171      6       R, W         yes    yes      the maximum QP
       \       SMTH_FLG         172      1       R, W         yes    yes      the enable flag for smooth (SMTH) algorithm, high active
       \       SMTH_DAT_SCL     173      10      R, W         yes    yes      the scaling factor used by the SMTH algorithm
       \                                                                      x: the bitrate difference is scaled to x / 1024
       \       SMTH_DAT_THR     174      16      R, W         yes    yes      the adjustment threshold used by the SMTH algorithm
       \                                                                      x: QP adjustment is enabled only when the bitrate difference exceeds x
       \       SMTH_DAT_DLT     175      5       R, W         yes    yes      the QP threshold used by the SMTH algorithm
       \                                                                      x: QP adjustment is no more than x
       \       SATD_FLG         176      1       R, W         yes    yes      the enable flag for sum of absolute transformed difference (SATD), high active
       \       SATD_DAT_THR_0   177      32      R, W         yes    yes      the 2n~2n+1-th threshold used by SATD algorithm where n = 0
       \                                                                      bit 31:16 -> the 2n-th threshold
       \                                                                          x: the threshold is x, belongs to [0, 65535]
       \                                                                      bit 15:00 -> the 2n+1-th threshold
       \                                                                      when SATD is less than the threshold n, the increment n is used.
       \                                                                      otherwise, continue to query the threshold n+1
       \       SATD_DAT_THR_1   178      32      R, W         yes    yes      the 2n~2n+1-th threshold used by SATD algorithm where n = 1
       \       SATD_DAT_THR_2   179      32      R, W         yes    yes      the 2n~2n+1-th threshold used by SATD algorithm where n = 2
       \       SATD_DAT_DLT_0   180      30      R, W         yes    yes      the 6n~6n+5-th increment used by SATD algorithm where n = 0
       \                                                                      bit 29:25 -> the 6n-th increment
       \                                                                          x: the increment is x, belongs to [-16, 15]
       \                                                                      bit 24:20 -> the 6n+1-th increment
       \                                                                      bit 19:15 -> the 6n+2-th increment
       \                                                                      bit 14:10 -> the 6n+3-th increment
       \                                                                      bit 09:05 -> the 6n+4-th increment
       \                                                                      bit 04:00 -> the 6n+5-th increment
       \       SATD_DAT_DLT_1   181      5       R, W         yes    yes      the 6th increment used by SATD algorithm
       \                                                                      bit 04:00 -> the 6-th increment
       \       SAMV_FLG         182      1       R, W         yes    yes      the enable flag for sum of absolute motion vector (SAMV), high avtive
       \       SAMV_DAT_THR_0   183      32      R, W         yes    yes      the 2n~2n+1-th threshold used by SAMV algorithm where n = 0
       \                                                                      bit 31:16 -> the 2n-th threshold
       \                                                                          x: the threshold is x, belongs to [0, 65535]
       \                                                                      bit 15:00 -> the 2n+1-th threshold
       \                                                                      when SAMV is less than the threshold n, the increment n is used.
       \                                                                      otherwise, continue to query the threshold n+1
       \       SAMV_DAT_THR_1   184      32      R, W         yes    yes      the 2n~2n+1-th threshold used by SAMV algorithm where n = 1
       \       SAMV_DAT_THR_2   185      32      R, W         yes    yes      the 2n~2n+1-th threshold used by SAMV algorithm where n = 2
       \       SAMV_DAT_DLT_0   186      30      R, W         yes    yes      the 6n~6n+5-th increment used by SAMV algorithm where n = 0
       \                                                                      bit 29:25 -> the 6n-th increment
       \                                                                          x: the increment is x, belongs to [-16, 15]
       \                                                                      bit 24:20 -> the 6n+1-th increment
       \                                                                      bit 19:15 -> the 6n+2-th increment
       \                                                                      bit 14:10 -> the 6n+3-th increment
       \                                                                      bit 09:05 -> the 6n+4-th increment
       \                                                                      bit 04:00 -> the 6n+5-th increment
       \       SAMV_DAT_DLT_1   187      5       R, W         yes    yes      the 6th increment used by SATD algorithm
       \                                                                      bit 04:00 -> the 6-th increment

       RSV     RESRVED          188      32      R,           no     yes      the reserved register
      ======= ================ ======== ======= ============ ====== ======== =============