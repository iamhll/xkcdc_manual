.. _CfgGroup : ../SwCfgGroup/main.html

SW - Architecture
=================

Structure of XKCDC
--------------------------------

Based on hierarchy, XKCDC can be divided into four levels: sequence level, frame level, LCU level, and pixel level.
More information about the configuration can be found in CfgGroup_

      .. image:: Top.png
         :width: 80%

   #. | The **Sequence level** module contains: module TOP and CFG, which are responsible for providing sequence-related processing.
      | The TOP (Top) module, which performs the encoding/decoding of the current sequence.
      | The CFG (ConFiGuration, Configuration) module, which is used to manage the configuration of the parameters of the current sequence.

   #. | The **Frame level** modules containing: modules KNL and FBS, responsible for providing frame-related processing.
      | The KNL (KerNeL, Kernel) module, which performs the encoding/decoding of the current frame.
      | The FBS (Full Bit Stream) module, which is used to generate the header information of the current frame and add/remove contention codes.

   #. | The **LCU level** module contains: module FTH/DMP, basic class LCU, modules RMD, IME, FME, RDO, REC, ILF and E_C/E_D, responsible for providing LCU-related processing;'
      | The LCU (Largest Coding Unit) basic class, which contains the basic processing at LCU level.
      | The FTH/DMP (FeTcH/DuMP, import/export) module, which is used to read in the original and reference images of the current LCU and write out the reconstructed images of the current LCU.
      | The RMD (Rough Mode Decision) module, which is used to obtain the rough mode of the current LCU.
      | The IME (Integer Motion Estimation) module, which is used to obtain the IMV (Integer Motion Vector) of the current LCU.
      | The FME (Fractional Motion Estimation) module, which is used to obtain the FMV (Fractional Motion Vector) of the current LCU.
      | The RDO (Rate Distortion Optimization) module for adjudicating the final division, mode and MV of the current LCU.
      | The REC (Reconstruction) module for generating the reconstructed pixels of the current LCU.
      | The ILF (In-Loop Filter) module for performing DBF (De-Blocking Filter) and SAO (Sample Adaptive Optimization) filtering of the current LCU.
      | The E_C/E_D (Entropy Coding/Entropy Decoding) module for encoding/decoding information such as division, mode, MV and coefficients of the current LCU.

   #. | The **Pixel level** module contains: the basic library COMMON and the module RFC, which is responsible for providing pixel-related processing.
      | The RFC (Reference Frame Compression) module for compressing/decompressing the reconstructed/reference image of the current LCU.
      | The COMMON basic library, which contains the basic processing at pixel level. Responsible for providing the underlying macro definitions, types, constants and functions. Among them, macro definitions are mainly classified and managed according to modules; types, constants and functions are mainly classified and managed according to general, information, prediction, transformation and cost.



Design Considerations of XKCDC
--------------------------------

The main design considerations are as follows

   #. **Module connection**: XKCDC uses pointer passing in software to simulate physical linkage in hardware. 
      Pointers to other submodules are predefined within each submodule, 
      and each submodule instantiated at the KNL level is connected with each other by assigned their pointers to other related modules.

   #. **Module running**: Module oneshot running consists of several steps: pre-processing, core processing, and post-processing. 
      Pre-processing mainly involves initializing the module's encoding configuration based on the input cfg; 
      core processing mainly involves searching and encoding the CU/PU; 
      post-processing mainly involves updating the data to advance the subsequent encoding operations.

   #. **Code reuse**: The same methods used by different sub-modules are pre-defined in LCU/COMMON module, 
      thus enabling code reuse to make the code more compact and clear. 
      For example, RMD,RDO, and REC all use the same intra prediction function defined in COMMON module.

   #. **Data interaction**: The data that needs to be interacted between different subclasses are placed in LCU. 
      Since each subclass inherits LCU base class, 
      there is no need to define special data interaction methods between subclasses, 
      only one data interaction method needs to be defined in LCU base class, 
      and the subclasses can inherit directly from the parent class.
   
Based on the above design considerations, 
it allows developers to put all their attention on the core module running step,
thus improving the efficiency of development.



Structure of LCU Class
--------------------------------
The design of the LCU class is the core part of the XKCDC codec. 
As shown in following, the structure of LCU Class includes three parts:

      .. image:: LcuStruct.png
         :width: 60%

   #. Public functions

      + Constructor functions, which are used to allocate space and set initial values.
      + Destructor functions, which are used to free space.
      + Connection functions, which are used to connect other modules.
      + Run functions, which are used to run the process of the current LCU.
      + Copy functions, which are used to copy the result of processing the current LCU.


   #. Private functions

      + Load functions, which are used to load the data needed to process the current LCU from the pipeline, pre-stage or file.
      + Processing functions for processing the current LCU, divided into three parts: pre-processing, core processing and post-processing.
      + Tool functions, which are used to provide basic operations at the LCU level, are divided into four main categories:

         - Information tool functions, which are used to calculate information data, such as MPM.
         - Prediction tool functions, which are used to calculate predicted data, such as predicted pixels.
         - Transformation tool functions, which are used to calculate transformed data, such as quantified data.
         - Cost tool functions, which are used to calculate the cost, such as SAD cost.

      + Export functions, which are used to export the input, output and intermediate variables of the current LCU to a file.


   #. Private variables

      + Flag variables, used to store the flags of the current module, such as the strings "RMD", "IME", etc.
      + Connection variables, used to store the address of other modules, such as module CFG, FTH, etc.
      + configuration variables, used to store configuration data, such as operation mode, cost type, etc.
      + pixel variables, used to store pixel-like data, such as original pixels, reference pixels, etc.
      + Information variables, used to store information type data, such as division type, pattern data, etc.

Working Flow of LCU Class
--------------------------------

      .. image:: Lcu.png
         :width: 80%

The processing of the LCU consists of the following four phases:

   #. Creation phase, which will 
      
      + call the constructor to request space for internal variables and assign initial values.

   #. Connection phase, which will
      
      + call the connect function to point the connected variables to the configuration structure, the FTH module and the corresponding predecessor module.

   #. Run phase, which will iteratively

      + call the load function to read in the original and reference pixels from the FTH module (to which the connection variable points) and the corresponding data from the pre-stage module.
      + call the processing functions to complete the processing for the current LCU based on instrumental functions such as information, prediction, transformation and cost.
      + call the export function to export the data of the current LCU to a file.

   #. Destructuring phase, which will

      + call the destructor function to delete the space requested in the build phase.
