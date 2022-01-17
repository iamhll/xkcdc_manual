
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

       FTH     DAT_SRC_ORI      025      1       R, W         no     no       
       \       SIZ_REF_Y        026      5       R, W         no     no       

       RMD     NUM_GRP          027      4       R, W         no     no       
       \       DAT_MOD_A        028      18      R, W         no     no       
       \       DAT_MOD_B        029      18      R, W         no     no       
       \       DAT_MOD_C        030      18      R, W         no     no       
       \       DAT_MOD_D        031      18      R, W         no     no       
       \       DAT_MOD_E        032      18      R, W         no     no       
       \       DAT_MOD_F        033      18      R, W         no     no       
       \       DAT_MOD_G        034      18      R, W         no     no       
       \       DAT_MOD_H        035      18      R, W         no     no       
       \       DAT_MOD_I        036      18      R, W         no     no       

       IME     NUM_PTN          037      3       R, W         no     no       
       \       DAT_PTN_0        038      30      R, W         no     no       
       \       DAT_PTN_1        039      30      R, W         no     no       
       \       DAT_PTN_2        040      30      R, W         no     no       
       \       DAT_PTN_3        041      30      R, W         no     no       
       \       DAT_PTN_4        042      30      R, W         no     no       
       \       DAT_PTN_5        043      30      R, W         no     no       
       \       DAT_PTN_6        044      30      R, W         no     no       
       \       DAT_PTN_7        045      30      R, W         no     no       
       \       DAT_SCL_MVD      046      8       R, W         no     no       

       FME     FLG_PRT          047      1       R, W         no     no       
       \       NUM_TRV          048      1       R, W         no     no       
       \       NUM_CTR          049      4       R, W         no     no       
       \       ENM_CTR          050      12      R, W         no     no       
       \       ENM_ITP          051      12      R, W         no     no       
       \       DAT_SCL_MVD      052      8       R, W         no     no       
       \       DAT_DLY          053      33      R, W         no     no       

       RDO     FLG_PRT          054      1       R, W         no     no       
       \       FLG_ADD_LU_01    055      1       R, W         no     no       
       \       FLG_SET_CH_36    056      1       R, W         no     no       
       \       NUM_MOD          057      2       R, W         no     no       
       \       DAT_SCL          058      32      R, W         no     no       
       \       DAT_FIT_I_CU_0   059      14      R, W         no     no       
       \       DAT_FIT_I_CU_1   060      14      R, W         no     no       
       \       DAT_FIT_I_PU_0   061      14      R, W         no     no       
       \       DAT_FIT_I_PU_1   062      14      R, W         no     no       
       \       DAT_FIT_I_PU_2   063      14      R, W         no     no       
       \       DAT_FIT_I_PU_3   064      14      R, W         no     no       
       \       DAT_FIT_I_PU_4   065      14      R, W         no     no       
       \       DAT_FIT_I_PU_5   066      14      R, W         no     no       
       \       DAT_FIT_I_TU_0   067      28      R, W         no     no       
       \       DAT_FIT_I_TU_1   068      28      R, W         no     no       
       \       DAT_FIT_I_TU_2   069      28      R, W         no     no       
       \       DAT_FIT_I_TU_3   070      28      R, W         no     no       
       \       DAT_FIT_I_TU_4   071      28      R, W         no     no       
       \       DAT_FIT_I_TU_5   072      28      R, W         no     no       
       \       DAT_FIT_I_TU_6   073      28      R, W         no     no       
       \       DAT_FIT_P_CU_0   074      14      R, W         no     no       
       \       DAT_FIT_P_PU_0   075      14      R, W         no     no       
       \       DAT_FIT_P_PU_1   076      14      R, W         no     no       
       \       DAT_FIT_P_PU_2   077      14      R, W         no     no       
       \       DAT_FIT_P_PU_3   078      14      R, W         no     no       
       \       DAT_FIT_P_PU_4   079      14      R, W         no     no       
       \       DAT_FIT_P_PU_5   080      14      R, W         no     no       
       \       DAT_FIT_P_PU_6   081      14      R, W         no     no       
       \       DAT_FIT_P_TU_0   082      14      R, W         no     no       
       \       DAT_FIT_P_TU_1   083      14      R, W         no     no       
       \       DAT_FIT_P_TU_2   084      14      R, W         no     no       
       \       DAT_FIT_P_TU_3   085      14      R, W         no     no       
       \       DAT_FIT_P_TU_4   086      14      R, W         no     no       
       \       DAT_FIT_P_TU_5   087      14      R, W         no     no       
       \       DAT_DLY_08       088      5       R, W         no     no       
       \       DAT_DLY_16       089      8       R, W         no     no       
       \       DAT_DLY_32       090      9       R, W         no     no       

       ILF     FLG_DBF          091      1       R, W         no     no       
       \       FLG_SAO          092      2       R, W         no     no       
       \       DAT_OFF_BT_DIV2  093      6       R, W         no     no       
       \       DAT_OFF_TC_DIV2  094      6       R, W         no     no       
       \       DAT_SCL_LMD      095      8       R, W         no     no       

       IIP     FLG              096      1       R, W         no     no       
       \       DAT_SCL_ON_QP_0  097      32      R, W         no     no       
       \       DAT_SCL_ON_QP_1  098      32      R, W         no     no       
       \       DAT_SCL_ON_QP_2  099      32      R, W         no     no       
       \       DAT_SCL_ON_QP_3  100      16      R, W         no     no       
       \       DAT_SCL_ON_MV_0  101      32      R, W         no     no       
       \       DAT_SCL_ON_MV_1  102      8       R, W         no     no       

       MRG     FLG              103      1       R, W         no     no       

       SKP     FLG              104      1       R, W         no     no       
       \       DAT_SCL_ON_CHN   105      16      R, W         no     no       
       \       DAT_SCL_ON_QP_0  106      32      R, W         no     no       
       \       DAT_SCL_ON_QP_1  107      32      R, W         no     no       
       \       DAT_SCL_ON_QP_2  108      32      R, W         no     no       
       \       DAT_SCL_ON_QP_3  109      16      R, W         no     no       
       \       DAT_SCL_ON_MV_0  110      32      R, W         no     no       
       \       DAT_SCL_ON_MV_1  111      8       R, W         no     no       

       ITF     FLG_0X03         112      1       R, W         no     no       
       \       FLG_RFC          113      1       R, W         no     no       
       \       FLG_REC_EXT      114      1       R, W         yes    yes      
       \       ENM_WRAPMEM      115      2       R, W         no     no       
       \       ENM_REORDER      116      32      R, W         no     no       
       \       NUM_BS_ENC_MAX   117      32      R, W         yes    yes      
       \       NUM_BS_ENC       118      32      R,           yes    yes      
       \       NUM_BS_DEC       119      32      R, W         no     yes      
       \       ADR_ORI_LU       120      32      R, W         yes    yes      
       \       ADR_ORI_CH       121      32      R, W         yes    yes      
       \       ADR_REF_LU       122      32      R, W         yes    yes      
       \       ADR_REF_CH       123      32      R, W         yes    yes      
       \       ADR_REC_LU       124      32      R, W         yes    yes      
       \       ADR_REC_CH       125      32      R, W         yes    yes      
       \       ADR_REC_EXT_LU   126      32      R, W         yes    yes      
       \       ADR_REC_EXT_CH   127      32      R, W         yes    yes      
       \       ADR_BS           128      32      R, W         yes    yes      
       \       ADR_PRM_REF_LU   129      32      R, W         yes    yes      
       \       ADR_PRM_REF_CH   130      32      R, W         yes    yes      
       \       ADR_PRM_REC_LU   131      32      R, W         yes    yes      
       \       ADR_PRM_REC_CH   132      32      R, W         yes    yes      
       \       STR_ORI_LU       133      32      R, W         yes    yes      
       \       STR_ORI_CH       134      32      R, W         yes    yes      
       \       STR_REF_LU       135      32      R, W         yes    yes      
       \       STR_REF_CH       136      32      R, W         yes    yes      
       \       STR_REC_LU       137      32      R, W         yes    yes      
       \       STR_REC_CH       138      32      R, W         yes    yes      
       \       STR_RFC          139      32      R, W         yes    yes      
       \       SIZ_FRA_LU       140      32      R, W         yes    no       
       \       SIZ_FRA_CH       141      32      R, W         yes    no       
       \       SIZ_MEM_LU       142      32      R, W         yes    no       
       \       SIZ_MEM_CH       143      32      R, W         yes    no       
       \       OFF_REF_LU       144      32      R, W         yes    yes      
       \       OFF_REF_CH       145      32      R, W         yes    yes      
       \       OFF_REC_LU       146      32      R, W         yes    yes      
       \       OFF_REC_CH       147      32      R, W         yes    yes      

       DBG     NUM_SIZ_PU_04    148      32      R,           yes    yes      
       \       NUM_SIZ_PU_08    149      32      R,           yes    yes      
       \       NUM_SIZ_PU_16    150      32      R,           yes    yes      
       \       NUM_SIZ_PU_32    151      32      R,           yes    yes      
       \       NUM_TYP_PU_I     152      32      R,           yes    yes      
       \       NUM_TYP_PU_P     153      32      R,           yes    yes      
       \       NUM_TYP_PU_M     154      32      R,           yes    yes      
       \       NUM_TYP_PU_S     155      32      R,           yes    yes      
       \       NUM_FMV_00_07    156      32      R,           yes    yes      
       \       NUM_FMV_08_15    157      32      R,           yes    yes      
       \       NUM_FMV_16_23    158      32      R,           yes    yes      
       \       NUM_FMV_24_31    159      32      R,           yes    yes      
       \       DAT_QP           160      32      R,           yes    yes      
       \       DAT_LMD          161      32      R,           yes    yes      
       \       ENM_SRC_BNK      162      1       R, W         no     no       

       ROI     0_POS            163      28      R, W         yes    yes      
       \       0_ENM_TYP        164      2       R, W         yes    yes      
       \       0_DAT_QP         165      7       R, W         yes    yes      
       \       1_POS            166      28      R, W         yes    yes      
       \       1_ENM_TYP        167      2       R, W         yes    yes      
       \       1_DAT_QP         168      7       R, W         yes    yes      

       R_C     NUM_BPP          169      16      R, W         yes    yes      
       \       DAT_QP_MIN       170      6       R, W         yes    yes      
       \       DAT_QP_MAX       171      6       R, W         yes    yes      
       \       SMTH_FLG         172      1       R, W         yes    yes      
       \       SMTH_DAT_SCL     173      10      R, W         yes    yes      
       \       SMTH_DAT_THR     174      16      R, W         yes    yes      
       \       SMTH_DAT_DLT     175      5       R, W         yes    yes      
       \       SATD_FLG         176      1       R, W         yes    yes      
       \       SATD_DAT_THR_0   177      32      R, W         yes    yes      
       \       SATD_DAT_THR_1   178      32      R, W         yes    yes      
       \       SATD_DAT_THR_2   179      32      R, W         yes    yes      
       \       SATD_DAT_DLT_0   180      30      R, W         yes    yes      
       \       SATD_DAT_DLT_1   181      5       R, W         yes    yes      
       \       SAMV_FLG         182      1       R, W         yes    yes      
       \       SAMV_DAT_THR_0   183      32      R, W         yes    yes      
       \       SAMV_DAT_THR_1   184      32      R, W         yes    yes      
       \       SAMV_DAT_THR_2   185      32      R, W         yes    yes      
       \       SAMV_DAT_DLT_0   186      30      R, W         yes    yes      
       \       SAMV_DAT_DLT_1   187      5       R, W         yes    yes      

       RSV     RESRVED          188      32      R,           no     yes      
      ======= ================ ======== ======= ============ ====== ======== =============
