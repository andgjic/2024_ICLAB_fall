-- |-----------------------------------------------------------------------|
-- 
--              Synchronous High Speed Single Port SRAM Compiler 
-- 
--                    UMC 0.18um GenericII Logic Process
--    __________________________________________________________________________
-- 
-- 
--        (C) Copyright 2002-2009 Faraday Technology Corp. All Rights Reserved.
-- 
--      This source code is an unpublished work belongs to Faraday Technology
--      Corp.  It is considered a trade secret and is not to be divulged or
--      used by parties who have not received written authorization from
--      Faraday Technology Corp.
-- 
--      Faraday's home page can be found at:
--      http://www.faraday-tech.com/
--     
-- ________________________________________________________________________________
-- 
--       Module Name       :  Memory_64_128  
--       Word              :  128            
--       Bit               :  64             
--       Byte              :  1              
--       Mux               :  1              
--       Power Ring Type   :  port           
--       Power Ring Width  :  2 (um)         
--       Output Loading    :  0.05 (pf)      
--       Input Data Slew   :  0.02 (ns)      
--       Input Clock Slew  :  0.02 (ns)      
-- 
-- ________________________________________________________________________________
-- 
--       Library          : FSA0M_A
--       Memaker          : 200901.2.1
--       Date             : 2024/10/27 11:40:57
-- 
-- ________________________________________________________________________________
-- 
--
-- Notice on usage: Fixed delay or timing data are given in this model.
--                  It supports SDF back-annotation, please generate SDF file
--                  by EDA tools to get the accurate timing.
--
-- |-----------------------------------------------------------------------|
--
-- Warning : 
--   If customer's design viloate the set-up time or hold time criteria of 
--   synchronous SRAM, it's possible to hit the meta-stable point of 
--   latch circuit in the decoder and cause the data loss in the memory 
--   bitcell. So please follow the memory IP's spec to design your 
--   product.
--
-- |-----------------------------------------------------------------------|
--
--       Library          : FSA0M_A
--       Memaker          : 200901.2.1
--       Date             : Sun Oct 27 11:40:57 CST 2024
--
-- |-----------------------------------------------------------------------|

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

-- entity declaration --
entity Memory_64_128 is
   generic(
      SYN_CS:          integer  := 1;
      NO_SER_TOH:      integer  := 1;
      AddressSize:     integer  := 7;
      Bits:            integer  := 64;
      Words:           integer  := 128;
      Bytes:           integer  := 1;
      AspectRatio:     integer  := 1;
      TOH:             time     := 1.211 ns;

      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := True;
      MsgOn: Boolean := True;

      tpd_CK_DO0_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO1_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO2_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO3_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO4_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO5_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO6_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO7_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO8_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO9_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO10_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO11_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO12_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO13_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO14_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO15_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO16_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO17_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO18_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO19_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO20_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO21_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO22_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO23_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO24_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO25_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO26_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO27_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO28_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO29_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO30_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO31_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO32_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO33_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO34_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO35_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO36_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO37_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO38_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO39_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO40_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO41_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO42_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO43_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO44_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO45_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO46_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO47_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO48_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO49_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO50_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO51_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO52_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO53_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO54_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO55_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO56_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO57_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO58_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO59_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO60_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO61_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO62_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);
      tpd_CK_DO63_posedge : VitalDelayType01 :=  (1.980 ns, 1.980 ns);

      tpd_OE_DO0    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO1    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO2    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO3    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO4    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO5    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO6    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO7    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO8    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO9    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO10    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO11    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO12    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO13    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO14    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO15    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO16    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO17    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO18    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO19    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO20    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO21    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO22    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO23    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO24    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO25    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO26    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO27    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO28    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO29    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO30    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO31    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO32    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO33    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO34    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO35    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO36    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO37    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO38    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO39    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO40    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO41    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO42    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO43    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO44    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO45    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO46    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO47    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO48    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO49    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO50    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO51    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO52    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO53    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO54    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO55    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO56    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO57    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO58    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO59    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO60    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO61    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO62    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tpd_OE_DO63    : VitalDelayType01Z := (0.438 ns, 0.438 ns, 0.558 ns, 0.438 ns, 0.558 ns, 0.438 ns);
      tsetup_A0_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A0_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A1_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A1_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A2_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A2_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A3_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A3_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A4_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A4_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A5_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A5_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A6_CK_posedge_posedge    :  VitalDelayType := 0.615 ns;
      tsetup_A6_CK_negedge_posedge    :  VitalDelayType := 0.615 ns;
      thold_A0_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A0_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A1_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A1_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A2_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A2_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A3_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A3_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A4_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A4_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A5_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A5_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A6_CK_posedge_posedge     :  VitalDelayType := 0.110 ns;
      thold_A6_CK_negedge_posedge     :  VitalDelayType := 0.110 ns;
      tsetup_DI0_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI0_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI1_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI1_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI2_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI2_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI3_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI3_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI4_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI4_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI5_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI5_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI6_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI6_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI7_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI7_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI8_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI8_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI9_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI9_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI10_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI10_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI11_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI11_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI12_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI12_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI13_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI13_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI14_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI14_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI15_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI15_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI16_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI16_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI17_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI17_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI18_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI18_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI19_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI19_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI20_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI20_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI21_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI21_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI22_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI22_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI23_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI23_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI24_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI24_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI25_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI25_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI26_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI26_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI27_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI27_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI28_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI28_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI29_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI29_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI30_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI30_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI31_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI31_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI32_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI32_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI33_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI33_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI34_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI34_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI35_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI35_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI36_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI36_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI37_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI37_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI38_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI38_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI39_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI39_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI40_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI40_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI41_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI41_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI42_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI42_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI43_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI43_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI44_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI44_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI45_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI45_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI46_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI46_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI47_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI47_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI48_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI48_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI49_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI49_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI50_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI50_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI51_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI51_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI52_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI52_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI53_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI53_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI54_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI54_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI55_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI55_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI56_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI56_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI57_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI57_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI58_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI58_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI59_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI59_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI60_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI60_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI61_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI61_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI62_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI62_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI63_CK_posedge_posedge    :  VitalDelayType := 0.528 ns;
      tsetup_DI63_CK_negedge_posedge    :  VitalDelayType := 0.528 ns;
      thold_DI0_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI0_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI1_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI1_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI2_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI2_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI3_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI3_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI4_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI4_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI5_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI5_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI6_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI6_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI7_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI7_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI8_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI8_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI9_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI9_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI10_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI10_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI11_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI11_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI12_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI12_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI13_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI13_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI14_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI14_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI15_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI15_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI16_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI16_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI17_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI17_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI18_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI18_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI19_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI19_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI20_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI20_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI21_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI21_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI22_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI22_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI23_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI23_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI24_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI24_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI25_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI25_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI26_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI26_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI27_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI27_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI28_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI28_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI29_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI29_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI30_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI30_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI31_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI31_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI32_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI32_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI33_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI33_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI34_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI34_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI35_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI35_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI36_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI36_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI37_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI37_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI38_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI38_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI39_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI39_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI40_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI40_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI41_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI41_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI42_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI42_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI43_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI43_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI44_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI44_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI45_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI45_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI46_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI46_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI47_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI47_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI48_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI48_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI49_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI49_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI50_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI50_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI51_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI51_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI52_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI52_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI53_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI53_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI54_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI54_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI55_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI55_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI56_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI56_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI57_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI57_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI58_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI58_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI59_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI59_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI60_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI60_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI61_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI61_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI62_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI62_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI63_CK_posedge_posedge     :  VitalDelayType := 0.100 ns;
      thold_DI63_CK_negedge_posedge     :  VitalDelayType := 0.100 ns;
      tsetup_WEB_CK_posedge_posedge   :  VitalDelayType := 0.353 ns;
      tsetup_WEB_CK_negedge_posedge   :  VitalDelayType := 0.353 ns;
      thold_WEB_CK_posedge_posedge    :  VitalDelayType := 0.100 ns;
      thold_WEB_CK_negedge_posedge    :  VitalDelayType := 0.100 ns;
      tsetup_CS_CK_posedge_posedge    :  VitalDelayType := 0.769 ns;
      tsetup_CS_CK_negedge_posedge    :  VitalDelayType := 0.769 ns;
      thold_CS_CK_posedge_posedge     :  VitalDelayType := 0.137 ns;
      thold_CS_CK_negedge_posedge     :  VitalDelayType := 0.137 ns;
      tperiod_CK                      :  VitalDelayType := 2.444 ns;
      tpw_CK_posedge                 :  VitalDelayType := 0.363 ns;
      tpw_CK_negedge                 :  VitalDelayType := 0.363 ns;
      tipd_A0                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A1                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A2                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A3                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A4                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A5                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A6                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI0                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI1                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI2                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI3                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI4                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI5                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI6                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI7                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI8                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI9                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI10                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI11                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI12                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI13                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI14                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI15                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI16                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI17                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI18                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI19                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI20                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI21                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI22                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI23                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI24                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI25                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI26                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI27                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI28                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI29                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI30                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI31                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI32                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI33                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI34                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI35                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI36                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI37                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI38                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI39                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI40                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI41                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI42                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI43                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI44                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI45                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI46                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI47                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI48                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI49                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI50                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI51                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI52                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI53                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI54                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI55                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI56                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI57                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI58                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI59                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI60                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI61                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI62                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DI63                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEB                       :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CS                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CK                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_OE                        :  VitalDelayType01 := (0.000 ns, 0.000 ns)      
      );

   port(
      A0                         :   IN   std_logic;
      A1                         :   IN   std_logic;
      A2                         :   IN   std_logic;
      A3                         :   IN   std_logic;
      A4                         :   IN   std_logic;
      A5                         :   IN   std_logic;
      A6                         :   IN   std_logic;
      DO0                        :   OUT   std_logic;
      DO1                        :   OUT   std_logic;
      DO2                        :   OUT   std_logic;
      DO3                        :   OUT   std_logic;
      DO4                        :   OUT   std_logic;
      DO5                        :   OUT   std_logic;
      DO6                        :   OUT   std_logic;
      DO7                        :   OUT   std_logic;
      DO8                        :   OUT   std_logic;
      DO9                        :   OUT   std_logic;
      DO10                        :   OUT   std_logic;
      DO11                        :   OUT   std_logic;
      DO12                        :   OUT   std_logic;
      DO13                        :   OUT   std_logic;
      DO14                        :   OUT   std_logic;
      DO15                        :   OUT   std_logic;
      DO16                        :   OUT   std_logic;
      DO17                        :   OUT   std_logic;
      DO18                        :   OUT   std_logic;
      DO19                        :   OUT   std_logic;
      DO20                        :   OUT   std_logic;
      DO21                        :   OUT   std_logic;
      DO22                        :   OUT   std_logic;
      DO23                        :   OUT   std_logic;
      DO24                        :   OUT   std_logic;
      DO25                        :   OUT   std_logic;
      DO26                        :   OUT   std_logic;
      DO27                        :   OUT   std_logic;
      DO28                        :   OUT   std_logic;
      DO29                        :   OUT   std_logic;
      DO30                        :   OUT   std_logic;
      DO31                        :   OUT   std_logic;
      DO32                        :   OUT   std_logic;
      DO33                        :   OUT   std_logic;
      DO34                        :   OUT   std_logic;
      DO35                        :   OUT   std_logic;
      DO36                        :   OUT   std_logic;
      DO37                        :   OUT   std_logic;
      DO38                        :   OUT   std_logic;
      DO39                        :   OUT   std_logic;
      DO40                        :   OUT   std_logic;
      DO41                        :   OUT   std_logic;
      DO42                        :   OUT   std_logic;
      DO43                        :   OUT   std_logic;
      DO44                        :   OUT   std_logic;
      DO45                        :   OUT   std_logic;
      DO46                        :   OUT   std_logic;
      DO47                        :   OUT   std_logic;
      DO48                        :   OUT   std_logic;
      DO49                        :   OUT   std_logic;
      DO50                        :   OUT   std_logic;
      DO51                        :   OUT   std_logic;
      DO52                        :   OUT   std_logic;
      DO53                        :   OUT   std_logic;
      DO54                        :   OUT   std_logic;
      DO55                        :   OUT   std_logic;
      DO56                        :   OUT   std_logic;
      DO57                        :   OUT   std_logic;
      DO58                        :   OUT   std_logic;
      DO59                        :   OUT   std_logic;
      DO60                        :   OUT   std_logic;
      DO61                        :   OUT   std_logic;
      DO62                        :   OUT   std_logic;
      DO63                        :   OUT   std_logic;
      DI0                        :   IN   std_logic;
      DI1                        :   IN   std_logic;
      DI2                        :   IN   std_logic;
      DI3                        :   IN   std_logic;
      DI4                        :   IN   std_logic;
      DI5                        :   IN   std_logic;
      DI6                        :   IN   std_logic;
      DI7                        :   IN   std_logic;
      DI8                        :   IN   std_logic;
      DI9                        :   IN   std_logic;
      DI10                        :   IN   std_logic;
      DI11                        :   IN   std_logic;
      DI12                        :   IN   std_logic;
      DI13                        :   IN   std_logic;
      DI14                        :   IN   std_logic;
      DI15                        :   IN   std_logic;
      DI16                        :   IN   std_logic;
      DI17                        :   IN   std_logic;
      DI18                        :   IN   std_logic;
      DI19                        :   IN   std_logic;
      DI20                        :   IN   std_logic;
      DI21                        :   IN   std_logic;
      DI22                        :   IN   std_logic;
      DI23                        :   IN   std_logic;
      DI24                        :   IN   std_logic;
      DI25                        :   IN   std_logic;
      DI26                        :   IN   std_logic;
      DI27                        :   IN   std_logic;
      DI28                        :   IN   std_logic;
      DI29                        :   IN   std_logic;
      DI30                        :   IN   std_logic;
      DI31                        :   IN   std_logic;
      DI32                        :   IN   std_logic;
      DI33                        :   IN   std_logic;
      DI34                        :   IN   std_logic;
      DI35                        :   IN   std_logic;
      DI36                        :   IN   std_logic;
      DI37                        :   IN   std_logic;
      DI38                        :   IN   std_logic;
      DI39                        :   IN   std_logic;
      DI40                        :   IN   std_logic;
      DI41                        :   IN   std_logic;
      DI42                        :   IN   std_logic;
      DI43                        :   IN   std_logic;
      DI44                        :   IN   std_logic;
      DI45                        :   IN   std_logic;
      DI46                        :   IN   std_logic;
      DI47                        :   IN   std_logic;
      DI48                        :   IN   std_logic;
      DI49                        :   IN   std_logic;
      DI50                        :   IN   std_logic;
      DI51                        :   IN   std_logic;
      DI52                        :   IN   std_logic;
      DI53                        :   IN   std_logic;
      DI54                        :   IN   std_logic;
      DI55                        :   IN   std_logic;
      DI56                        :   IN   std_logic;
      DI57                        :   IN   std_logic;
      DI58                        :   IN   std_logic;
      DI59                        :   IN   std_logic;
      DI60                        :   IN   std_logic;
      DI61                        :   IN   std_logic;
      DI62                        :   IN   std_logic;
      DI63                        :   IN   std_logic;
      WEB                           :   IN   std_logic;
      CK                            :   IN   std_logic;
      CS                           :   IN   std_logic;
      OE                            :   IN   std_logic
      );

attribute VITAL_LEVEL0 of Memory_64_128 : entity is TRUE;

end Memory_64_128;

-- architecture body --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

architecture behavior of Memory_64_128 is
   -- attribute VITALMEMORY_LEVEL1 of behavior : architecture is TRUE;

   CONSTANT True_flg:       integer := 0;
   CONSTANT False_flg:      integer := 1;
   CONSTANT Range_flg:      integer := 2;

   FUNCTION Minimum ( CONSTANT t1, t2 : IN TIME ) RETURN TIME IS
   BEGIN
      IF (t1 < t2) THEN RETURN (t1); ELSE RETURN (t2); END IF;
   END Minimum;

   FUNCTION Maximum ( CONSTANT t1, t2 : IN TIME ) RETURN TIME IS
   BEGIN
      IF (t1 < t2) THEN RETURN (t2); ELSE RETURN (t1); END IF;
   END Maximum;

   FUNCTION BVtoI(bin: std_logic_vector) RETURN integer IS
      variable result: integer;
   BEGIN
      result := 0;
      for i in bin'range loop
         if bin(i) = '1' then
            result := result + 2**i;
         end if;
      end loop;
      return result;
   END; -- BVtoI

   PROCEDURE ScheduleOutputDelay (
       SIGNAL   OutSignal        : OUT std_logic;
       VARIABLE Data             : IN  std_logic;
       CONSTANT Delay            : IN  VitalDelayType01 := VitalDefDelay01;
       VARIABLE Previous_A       : IN  std_logic_vector(AddressSize-1 downto 0);
       VARIABLE Current_A        : IN  std_logic_vector(AddressSize-1 downto 0);
       CONSTANT NO_SER_TOH       : IN  integer
   ) IS
   BEGIN

      if (NO_SER_TOH /= 1) then
         OutSignal <= TRANSPORT 'X' AFTER TOH;
         OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
      else
         if (Current_A /= Previous_A) then
            OutSignal <= TRANSPORT 'X' AFTER TOH;
            OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
         else
            OutSignal <= TRANSPORT Data AFTER Maximum(Delay(tr10), Delay(tr01));
         end if;
      end if;
   END ScheduleOutputDelay;

   FUNCTION TO_INTEGER (
     a: std_logic_vector
   ) RETURN INTEGER IS
     VARIABLE y: INTEGER := 0;
   BEGIN
        y := 0;
        FOR i IN a'RANGE LOOP
            y := y * 2;
            IF a(i) /= '1' AND a(i) /= '0' THEN
                y := 0;
                EXIT;
            ELSIF a(i) = '1' THEN
                y := y + 1;
            END IF;
        END LOOP;
        RETURN y;
   END TO_INTEGER;

   function AddressRangeCheck(AddressItem: std_logic_vector; flag_Address: integer) return integer is
     variable Uresult : std_logic;
     variable status  : integer := 0;

   begin
      if (Bits /= 1) then
         Uresult := AddressItem(0) xor AddressItem(1);
         for i in 2 to AddressItem'length-1 loop
            Uresult := Uresult xor AddressItem(i);
         end loop;
      else
         Uresult := AddressItem(0);
      end if;

      if (Uresult = 'U') then
         status := False_flg;
      elsif (Uresult = 'X') then
         status := False_flg;
      elsif (Uresult = 'Z') then
         status := False_flg;
      else
         status := True_flg;
      end if;

      if (status=False_flg) then
        if (flag_Address = True_flg) then
           -- Generate Error Messae --
           assert FALSE report "** MEM_Error: Unknown value occurred in Address." severity WARNING;
        end if;
      end if;

      if (status=True_flg) then
         if ((BVtoI(AddressItem)) >= Words) then
             assert FALSE report "** MEM_Error: Out of range occurred in Address." severity WARNING; 
             status := Range_flg;
         else
             status := True_flg;
         end if;
      end if;

      return status;
   end AddressRangeCheck;

   function CS_monitor(CSItem: std_logic; flag_CS: integer) return integer is
     variable status  : integer := 0;

   begin
      if (CSItem = 'U') then
         status := False_flg;
      elsif (CSItem = 'X') then
         status := False_flg;
      elsif (CSItem = 'Z') then
         status := False_flg;
      else
         status := True_flg;
      end if;

      if (status=False_flg) then
        if (flag_CS = True_flg) then
           -- Generate Error Messae --
           assert FALSE report "** MEM_Error: Unknown value occurred in ChipSelect." severity WARNING;
        end if;
      end if;

      return status;
   end CS_monitor;

   Type memoryArray Is array (Words-1 downto 0) Of std_logic_vector (Bits-1 downto 0);

   SIGNAL CS_ipd         : std_logic := 'X';
   SIGNAL OE_ipd         : std_logic := 'X';
   SIGNAL CK_ipd         : std_logic := 'X';
   SIGNAL A_ipd          : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   SIGNAL WEB_ipd       : std_logic := 'X';
   SIGNAL DI_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DO_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (OE_ipd, OE, tipd_OE);
   VitalWireDelay (CK_ipd, CK, tipd_CK);
   VitalWireDelay (CS_ipd, CS, tipd_CS);
   VitalWireDelay (WEB_ipd, WEB, tipd_WEB);
   VitalWireDelay (A_ipd(0), A0, tipd_A0);
   VitalWireDelay (A_ipd(1), A1, tipd_A1);
   VitalWireDelay (A_ipd(2), A2, tipd_A2);
   VitalWireDelay (A_ipd(3), A3, tipd_A3);
   VitalWireDelay (A_ipd(4), A4, tipd_A4);
   VitalWireDelay (A_ipd(5), A5, tipd_A5);
   VitalWireDelay (A_ipd(6), A6, tipd_A6);
   VitalWireDelay (DI_ipd(0), DI0, tipd_DI0);
   VitalWireDelay (DI_ipd(1), DI1, tipd_DI1);
   VitalWireDelay (DI_ipd(2), DI2, tipd_DI2);
   VitalWireDelay (DI_ipd(3), DI3, tipd_DI3);
   VitalWireDelay (DI_ipd(4), DI4, tipd_DI4);
   VitalWireDelay (DI_ipd(5), DI5, tipd_DI5);
   VitalWireDelay (DI_ipd(6), DI6, tipd_DI6);
   VitalWireDelay (DI_ipd(7), DI7, tipd_DI7);
   VitalWireDelay (DI_ipd(8), DI8, tipd_DI8);
   VitalWireDelay (DI_ipd(9), DI9, tipd_DI9);
   VitalWireDelay (DI_ipd(10), DI10, tipd_DI10);
   VitalWireDelay (DI_ipd(11), DI11, tipd_DI11);
   VitalWireDelay (DI_ipd(12), DI12, tipd_DI12);
   VitalWireDelay (DI_ipd(13), DI13, tipd_DI13);
   VitalWireDelay (DI_ipd(14), DI14, tipd_DI14);
   VitalWireDelay (DI_ipd(15), DI15, tipd_DI15);
   VitalWireDelay (DI_ipd(16), DI16, tipd_DI16);
   VitalWireDelay (DI_ipd(17), DI17, tipd_DI17);
   VitalWireDelay (DI_ipd(18), DI18, tipd_DI18);
   VitalWireDelay (DI_ipd(19), DI19, tipd_DI19);
   VitalWireDelay (DI_ipd(20), DI20, tipd_DI20);
   VitalWireDelay (DI_ipd(21), DI21, tipd_DI21);
   VitalWireDelay (DI_ipd(22), DI22, tipd_DI22);
   VitalWireDelay (DI_ipd(23), DI23, tipd_DI23);
   VitalWireDelay (DI_ipd(24), DI24, tipd_DI24);
   VitalWireDelay (DI_ipd(25), DI25, tipd_DI25);
   VitalWireDelay (DI_ipd(26), DI26, tipd_DI26);
   VitalWireDelay (DI_ipd(27), DI27, tipd_DI27);
   VitalWireDelay (DI_ipd(28), DI28, tipd_DI28);
   VitalWireDelay (DI_ipd(29), DI29, tipd_DI29);
   VitalWireDelay (DI_ipd(30), DI30, tipd_DI30);
   VitalWireDelay (DI_ipd(31), DI31, tipd_DI31);
   VitalWireDelay (DI_ipd(32), DI32, tipd_DI32);
   VitalWireDelay (DI_ipd(33), DI33, tipd_DI33);
   VitalWireDelay (DI_ipd(34), DI34, tipd_DI34);
   VitalWireDelay (DI_ipd(35), DI35, tipd_DI35);
   VitalWireDelay (DI_ipd(36), DI36, tipd_DI36);
   VitalWireDelay (DI_ipd(37), DI37, tipd_DI37);
   VitalWireDelay (DI_ipd(38), DI38, tipd_DI38);
   VitalWireDelay (DI_ipd(39), DI39, tipd_DI39);
   VitalWireDelay (DI_ipd(40), DI40, tipd_DI40);
   VitalWireDelay (DI_ipd(41), DI41, tipd_DI41);
   VitalWireDelay (DI_ipd(42), DI42, tipd_DI42);
   VitalWireDelay (DI_ipd(43), DI43, tipd_DI43);
   VitalWireDelay (DI_ipd(44), DI44, tipd_DI44);
   VitalWireDelay (DI_ipd(45), DI45, tipd_DI45);
   VitalWireDelay (DI_ipd(46), DI46, tipd_DI46);
   VitalWireDelay (DI_ipd(47), DI47, tipd_DI47);
   VitalWireDelay (DI_ipd(48), DI48, tipd_DI48);
   VitalWireDelay (DI_ipd(49), DI49, tipd_DI49);
   VitalWireDelay (DI_ipd(50), DI50, tipd_DI50);
   VitalWireDelay (DI_ipd(51), DI51, tipd_DI51);
   VitalWireDelay (DI_ipd(52), DI52, tipd_DI52);
   VitalWireDelay (DI_ipd(53), DI53, tipd_DI53);
   VitalWireDelay (DI_ipd(54), DI54, tipd_DI54);
   VitalWireDelay (DI_ipd(55), DI55, tipd_DI55);
   VitalWireDelay (DI_ipd(56), DI56, tipd_DI56);
   VitalWireDelay (DI_ipd(57), DI57, tipd_DI57);
   VitalWireDelay (DI_ipd(58), DI58, tipd_DI58);
   VitalWireDelay (DI_ipd(59), DI59, tipd_DI59);
   VitalWireDelay (DI_ipd(60), DI60, tipd_DI60);
   VitalWireDelay (DI_ipd(61), DI61, tipd_DI61);
   VitalWireDelay (DI_ipd(62), DI62, tipd_DI62);
   VitalWireDelay (DI_ipd(63), DI63, tipd_DI63);

   end block;

   VitalBUFIF1 (q      => DO0,
                data   => DO_int(0),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO0);
   VitalBUFIF1 (q      => DO1,
                data   => DO_int(1),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO1);
   VitalBUFIF1 (q      => DO2,
                data   => DO_int(2),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO2);
   VitalBUFIF1 (q      => DO3,
                data   => DO_int(3),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO3);
   VitalBUFIF1 (q      => DO4,
                data   => DO_int(4),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO4);
   VitalBUFIF1 (q      => DO5,
                data   => DO_int(5),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO5);
   VitalBUFIF1 (q      => DO6,
                data   => DO_int(6),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO6);
   VitalBUFIF1 (q      => DO7,
                data   => DO_int(7),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO7);
   VitalBUFIF1 (q      => DO8,
                data   => DO_int(8),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO8);
   VitalBUFIF1 (q      => DO9,
                data   => DO_int(9),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO9);
   VitalBUFIF1 (q      => DO10,
                data   => DO_int(10),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO10);
   VitalBUFIF1 (q      => DO11,
                data   => DO_int(11),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO11);
   VitalBUFIF1 (q      => DO12,
                data   => DO_int(12),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO12);
   VitalBUFIF1 (q      => DO13,
                data   => DO_int(13),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO13);
   VitalBUFIF1 (q      => DO14,
                data   => DO_int(14),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO14);
   VitalBUFIF1 (q      => DO15,
                data   => DO_int(15),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO15);
   VitalBUFIF1 (q      => DO16,
                data   => DO_int(16),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO16);
   VitalBUFIF1 (q      => DO17,
                data   => DO_int(17),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO17);
   VitalBUFIF1 (q      => DO18,
                data   => DO_int(18),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO18);
   VitalBUFIF1 (q      => DO19,
                data   => DO_int(19),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO19);
   VitalBUFIF1 (q      => DO20,
                data   => DO_int(20),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO20);
   VitalBUFIF1 (q      => DO21,
                data   => DO_int(21),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO21);
   VitalBUFIF1 (q      => DO22,
                data   => DO_int(22),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO22);
   VitalBUFIF1 (q      => DO23,
                data   => DO_int(23),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO23);
   VitalBUFIF1 (q      => DO24,
                data   => DO_int(24),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO24);
   VitalBUFIF1 (q      => DO25,
                data   => DO_int(25),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO25);
   VitalBUFIF1 (q      => DO26,
                data   => DO_int(26),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO26);
   VitalBUFIF1 (q      => DO27,
                data   => DO_int(27),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO27);
   VitalBUFIF1 (q      => DO28,
                data   => DO_int(28),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO28);
   VitalBUFIF1 (q      => DO29,
                data   => DO_int(29),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO29);
   VitalBUFIF1 (q      => DO30,
                data   => DO_int(30),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO30);
   VitalBUFIF1 (q      => DO31,
                data   => DO_int(31),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO31);
   VitalBUFIF1 (q      => DO32,
                data   => DO_int(32),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO32);
   VitalBUFIF1 (q      => DO33,
                data   => DO_int(33),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO33);
   VitalBUFIF1 (q      => DO34,
                data   => DO_int(34),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO34);
   VitalBUFIF1 (q      => DO35,
                data   => DO_int(35),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO35);
   VitalBUFIF1 (q      => DO36,
                data   => DO_int(36),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO36);
   VitalBUFIF1 (q      => DO37,
                data   => DO_int(37),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO37);
   VitalBUFIF1 (q      => DO38,
                data   => DO_int(38),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO38);
   VitalBUFIF1 (q      => DO39,
                data   => DO_int(39),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO39);
   VitalBUFIF1 (q      => DO40,
                data   => DO_int(40),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO40);
   VitalBUFIF1 (q      => DO41,
                data   => DO_int(41),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO41);
   VitalBUFIF1 (q      => DO42,
                data   => DO_int(42),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO42);
   VitalBUFIF1 (q      => DO43,
                data   => DO_int(43),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO43);
   VitalBUFIF1 (q      => DO44,
                data   => DO_int(44),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO44);
   VitalBUFIF1 (q      => DO45,
                data   => DO_int(45),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO45);
   VitalBUFIF1 (q      => DO46,
                data   => DO_int(46),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO46);
   VitalBUFIF1 (q      => DO47,
                data   => DO_int(47),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO47);
   VitalBUFIF1 (q      => DO48,
                data   => DO_int(48),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO48);
   VitalBUFIF1 (q      => DO49,
                data   => DO_int(49),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO49);
   VitalBUFIF1 (q      => DO50,
                data   => DO_int(50),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO50);
   VitalBUFIF1 (q      => DO51,
                data   => DO_int(51),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO51);
   VitalBUFIF1 (q      => DO52,
                data   => DO_int(52),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO52);
   VitalBUFIF1 (q      => DO53,
                data   => DO_int(53),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO53);
   VitalBUFIF1 (q      => DO54,
                data   => DO_int(54),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO54);
   VitalBUFIF1 (q      => DO55,
                data   => DO_int(55),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO55);
   VitalBUFIF1 (q      => DO56,
                data   => DO_int(56),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO56);
   VitalBUFIF1 (q      => DO57,
                data   => DO_int(57),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO57);
   VitalBUFIF1 (q      => DO58,
                data   => DO_int(58),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO58);
   VitalBUFIF1 (q      => DO59,
                data   => DO_int(59),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO59);
   VitalBUFIF1 (q      => DO60,
                data   => DO_int(60),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO60);
   VitalBUFIF1 (q      => DO61,
                data   => DO_int(61),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO61);
   VitalBUFIF1 (q      => DO62,
                data   => DO_int(62),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO62);
   VitalBUFIF1 (q      => DO63,
                data   => DO_int(63),
                enable => OE_ipd,
                tpd_enable_q => tpd_OE_DO63);

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : PROCESS (CS_ipd, 
                            OE_ipd,
                            A_ipd,
                            WEB_ipd,
                            DI_ipd,
                            CK_ipd)

   -- timing check results
   VARIABLE Tviol_A_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEB_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DI_CK_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_CS_CK_posedge  : STD_ULOGIC := '0';

   VARIABLE Pviol_CK    : STD_ULOGIC := '0';
   VARIABLE Pdata_CK    : VitalPeriodDataType := VitalPeriodDataInit;

   VARIABLE Tmkr_A_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEB_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DI_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_CS_CK_posedge   : VitalTimingDataType := VitalTimingDataInit;

   VARIABLE DO_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore  : memoryArray;

   VARIABLE ck_change   : std_logic_vector(1 downto 0);
   VARIABLE web_cs      : std_logic_vector(1 downto 0);

   -- previous latch data
   VARIABLE Latch_A        : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE Latch_DI       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEB      : std_logic := 'X';
   VARIABLE Latch_CS       : std_logic := 'X';

   -- internal latch data
   VARIABLE A_i            : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE DI_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEB_i          : std_logic := 'X';
   VARIABLE CS_i           : std_logic := 'X';

   VARIABLE last_A         : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');

   VARIABLE LastClkEdge    : std_logic := 'X';

   VARIABLE flag_A: integer   := True_flg;
   VARIABLE flag_CS: integer   := True_flg;

   begin

   ------------------------
   --  Timing Check Section
   ------------------------
   if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_A_CK_posedge,
          TimingData              => Tmkr_A_CK_posedge,
          TestSignal              => A_ipd,
          TestSignalName          => "A",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A0_CK_posedge_posedge,
          SetupLow                => tsetup_A0_CK_negedge_posedge,
          HoldHigh                => thold_A0_CK_negedge_posedge,
          HoldLow                 => thold_A0_CK_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CS_ipd = '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/Memory_64_128",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_WEB_CK_posedge,
          TimingData              => Tmkr_WEB_CK_posedge,
          TestSignal              => WEB_ipd,
          TestSignalName          => "WEB",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEB_CK_posedge_posedge,
          SetupLow                => tsetup_WEB_CK_negedge_posedge,
          HoldHigh                => thold_WEB_CK_negedge_posedge,
          HoldLow                 => thold_WEB_CK_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CS_ipd = '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/Memory_64_128",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_DI_CK_posedge,
          TimingData              => Tmkr_DI_CK_posedge,
          TestSignal              => DI_ipd,
          TestSignalName          => "DI",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DI0_CK_posedge_posedge,
          SetupLow                => tsetup_DI0_CK_negedge_posedge,
          HoldHigh                => thold_DI0_CK_negedge_posedge,
          HoldLow                 => thold_DI0_CK_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CS_ipd = '1' AND WEB_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/Memory_64_128",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_CS_CK_posedge,
          TimingData              => Tmkr_CS_CK_posedge,
          TestSignal              => CS_ipd,
          TestSignalName          => "CS",
          TestDelay               => 0 ns,
          RefSignal               => CK_ipd,
          RefSignalName           => "CK",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_CS_CK_posedge_posedge,
          SetupLow                => tsetup_CS_CK_negedge_posedge,
          HoldHigh                => thold_CS_CK_negedge_posedge,
          HoldLow                 => thold_CS_CK_posedge_posedge,
          CheckEnabled            => NOW /= 0 ns,
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/Memory_64_128",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalPeriodPulseCheck (
          Violation               => Pviol_CK,
          PeriodData              => Pdata_CK,
          TestSignal              => CK_ipd,
          TestSignalName          => "CK",
          TestDelay               => 0 ns,
          Period                  => tperiod_CK,
          PulseWidthHigh          => tpw_CK_posedge,
          PulseWidthLow           => tpw_CK_negedge,
          CheckEnabled            => NOW /= 0 ns AND CS_ipd = '1',
          HeaderMsg               => InstancePath & "/Memory_64_128",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
   end if;

   -------------------------
   --  Functionality Section
   -------------------------

       if (CS_ipd = '1' and CS_ipd'event) then
          if (SYN_CS = 0) then
             DO_zd := (OTHERS => 'X');
             DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
          end if;
       end if;

       if (CK_ipd'event) then
         ck_change := LastClkEdge&CK_ipd;
         case ck_change is
            when "01"   =>
                if (CS_monitor(CS_ipd,flag_CS) = True_flg) then
                   -- Reduce error message --
                   flag_CS := True_flg;
                else
                   flag_CS := False_flg;
                end if;

                Latch_A    := A_ipd;
                Latch_CS   := CS_ipd;
                Latch_DI  := DI_ipd;
                Latch_WEB := WEB_ipd;

                -- memory_function
                A_i    := Latch_A;
                CS_i   := Latch_CS;
                DI_i  := Latch_DI;
                WEB_i := Latch_WEB;

                web_cs    := WEB_i&CS_i;
                case web_cs is
                   when "11" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO_zd := memoryCore(to_integer(A_i));
                           ScheduleOutputDelay(DO_int(0), DO_zd(0),
                              tpd_CK_DO0_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(1), DO_zd(1),
                              tpd_CK_DO1_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(2), DO_zd(2),
                              tpd_CK_DO2_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(3), DO_zd(3),
                              tpd_CK_DO3_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(4), DO_zd(4),
                              tpd_CK_DO4_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(5), DO_zd(5),
                              tpd_CK_DO5_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(6), DO_zd(6),
                              tpd_CK_DO6_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(7), DO_zd(7),
                              tpd_CK_DO7_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(8), DO_zd(8),
                              tpd_CK_DO8_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(9), DO_zd(9),
                              tpd_CK_DO9_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(10), DO_zd(10),
                              tpd_CK_DO10_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(11), DO_zd(11),
                              tpd_CK_DO11_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(12), DO_zd(12),
                              tpd_CK_DO12_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(13), DO_zd(13),
                              tpd_CK_DO13_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(14), DO_zd(14),
                              tpd_CK_DO14_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(15), DO_zd(15),
                              tpd_CK_DO15_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(16), DO_zd(16),
                              tpd_CK_DO16_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(17), DO_zd(17),
                              tpd_CK_DO17_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(18), DO_zd(18),
                              tpd_CK_DO18_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(19), DO_zd(19),
                              tpd_CK_DO19_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(20), DO_zd(20),
                              tpd_CK_DO20_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(21), DO_zd(21),
                              tpd_CK_DO21_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(22), DO_zd(22),
                              tpd_CK_DO22_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(23), DO_zd(23),
                              tpd_CK_DO23_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(24), DO_zd(24),
                              tpd_CK_DO24_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(25), DO_zd(25),
                              tpd_CK_DO25_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(26), DO_zd(26),
                              tpd_CK_DO26_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(27), DO_zd(27),
                              tpd_CK_DO27_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(28), DO_zd(28),
                              tpd_CK_DO28_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(29), DO_zd(29),
                              tpd_CK_DO29_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(30), DO_zd(30),
                              tpd_CK_DO30_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(31), DO_zd(31),
                              tpd_CK_DO31_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(32), DO_zd(32),
                              tpd_CK_DO32_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(33), DO_zd(33),
                              tpd_CK_DO33_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(34), DO_zd(34),
                              tpd_CK_DO34_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(35), DO_zd(35),
                              tpd_CK_DO35_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(36), DO_zd(36),
                              tpd_CK_DO36_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(37), DO_zd(37),
                              tpd_CK_DO37_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(38), DO_zd(38),
                              tpd_CK_DO38_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(39), DO_zd(39),
                              tpd_CK_DO39_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(40), DO_zd(40),
                              tpd_CK_DO40_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(41), DO_zd(41),
                              tpd_CK_DO41_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(42), DO_zd(42),
                              tpd_CK_DO42_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(43), DO_zd(43),
                              tpd_CK_DO43_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(44), DO_zd(44),
                              tpd_CK_DO44_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(45), DO_zd(45),
                              tpd_CK_DO45_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(46), DO_zd(46),
                              tpd_CK_DO46_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(47), DO_zd(47),
                              tpd_CK_DO47_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(48), DO_zd(48),
                              tpd_CK_DO48_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(49), DO_zd(49),
                              tpd_CK_DO49_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(50), DO_zd(50),
                              tpd_CK_DO50_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(51), DO_zd(51),
                              tpd_CK_DO51_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(52), DO_zd(52),
                              tpd_CK_DO52_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(53), DO_zd(53),
                              tpd_CK_DO53_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(54), DO_zd(54),
                              tpd_CK_DO54_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(55), DO_zd(55),
                              tpd_CK_DO55_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(56), DO_zd(56),
                              tpd_CK_DO56_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(57), DO_zd(57),
                              tpd_CK_DO57_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(58), DO_zd(58),
                              tpd_CK_DO58_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(59), DO_zd(59),
                              tpd_CK_DO59_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(60), DO_zd(60),
                              tpd_CK_DO60_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(61), DO_zd(61),
                              tpd_CK_DO61_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(62), DO_zd(62),
                              tpd_CK_DO62_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(63), DO_zd(63),
                              tpd_CK_DO63_posedge,
                              last_A,A_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       end if;

                   when "01" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore(to_integer(A_i)) := DI_i;
                           DO_zd := memoryCore(to_integer(A_i));
                           ScheduleOutputDelay(DO_int(0), DO_zd(0),
                              tpd_CK_DO0_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(1), DO_zd(1),
                              tpd_CK_DO1_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(2), DO_zd(2),
                              tpd_CK_DO2_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(3), DO_zd(3),
                              tpd_CK_DO3_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(4), DO_zd(4),
                              tpd_CK_DO4_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(5), DO_zd(5),
                              tpd_CK_DO5_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(6), DO_zd(6),
                              tpd_CK_DO6_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(7), DO_zd(7),
                              tpd_CK_DO7_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(8), DO_zd(8),
                              tpd_CK_DO8_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(9), DO_zd(9),
                              tpd_CK_DO9_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(10), DO_zd(10),
                              tpd_CK_DO10_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(11), DO_zd(11),
                              tpd_CK_DO11_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(12), DO_zd(12),
                              tpd_CK_DO12_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(13), DO_zd(13),
                              tpd_CK_DO13_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(14), DO_zd(14),
                              tpd_CK_DO14_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(15), DO_zd(15),
                              tpd_CK_DO15_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(16), DO_zd(16),
                              tpd_CK_DO16_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(17), DO_zd(17),
                              tpd_CK_DO17_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(18), DO_zd(18),
                              tpd_CK_DO18_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(19), DO_zd(19),
                              tpd_CK_DO19_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(20), DO_zd(20),
                              tpd_CK_DO20_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(21), DO_zd(21),
                              tpd_CK_DO21_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(22), DO_zd(22),
                              tpd_CK_DO22_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(23), DO_zd(23),
                              tpd_CK_DO23_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(24), DO_zd(24),
                              tpd_CK_DO24_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(25), DO_zd(25),
                              tpd_CK_DO25_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(26), DO_zd(26),
                              tpd_CK_DO26_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(27), DO_zd(27),
                              tpd_CK_DO27_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(28), DO_zd(28),
                              tpd_CK_DO28_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(29), DO_zd(29),
                              tpd_CK_DO29_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(30), DO_zd(30),
                              tpd_CK_DO30_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(31), DO_zd(31),
                              tpd_CK_DO31_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(32), DO_zd(32),
                              tpd_CK_DO32_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(33), DO_zd(33),
                              tpd_CK_DO33_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(34), DO_zd(34),
                              tpd_CK_DO34_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(35), DO_zd(35),
                              tpd_CK_DO35_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(36), DO_zd(36),
                              tpd_CK_DO36_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(37), DO_zd(37),
                              tpd_CK_DO37_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(38), DO_zd(38),
                              tpd_CK_DO38_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(39), DO_zd(39),
                              tpd_CK_DO39_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(40), DO_zd(40),
                              tpd_CK_DO40_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(41), DO_zd(41),
                              tpd_CK_DO41_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(42), DO_zd(42),
                              tpd_CK_DO42_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(43), DO_zd(43),
                              tpd_CK_DO43_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(44), DO_zd(44),
                              tpd_CK_DO44_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(45), DO_zd(45),
                              tpd_CK_DO45_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(46), DO_zd(46),
                              tpd_CK_DO46_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(47), DO_zd(47),
                              tpd_CK_DO47_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(48), DO_zd(48),
                              tpd_CK_DO48_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(49), DO_zd(49),
                              tpd_CK_DO49_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(50), DO_zd(50),
                              tpd_CK_DO50_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(51), DO_zd(51),
                              tpd_CK_DO51_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(52), DO_zd(52),
                              tpd_CK_DO52_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(53), DO_zd(53),
                              tpd_CK_DO53_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(54), DO_zd(54),
                              tpd_CK_DO54_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(55), DO_zd(55),
                              tpd_CK_DO55_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(56), DO_zd(56),
                              tpd_CK_DO56_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(57), DO_zd(57),
                              tpd_CK_DO57_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(58), DO_zd(58),
                              tpd_CK_DO58_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(59), DO_zd(59),
                              tpd_CK_DO59_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(60), DO_zd(60),
                              tpd_CK_DO60_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(61), DO_zd(61),
                              tpd_CK_DO61_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(62), DO_zd(62),
                              tpd_CK_DO62_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(63), DO_zd(63),
                              tpd_CK_DO63_posedge,
                              last_A,A_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO_zd := (OTHERS => 'X');
                                DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "10" |
                        "00" |
                        "X0" |
                        "U0" |
                        "Z0"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO_zd := (OTHERS => 'X');
                                    DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;
                -- end memory_function
                last_A := A_ipd;

            when "10"   => -- do nothing
            when others => if (NOW /= 0 ns) then
                              assert FALSE report "** MEM_Error: Abnormal transition occurred." severity WARNING;
                           end if;
                           if (CS_ipd /= '1') then
                              DO_zd := (OTHERS => 'X');
                              DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                              if (WEB_ipd /= '1') then
                                 FOR i IN Words-1 downto 0 LOOP
                                 memoryCore(i) := (OTHERS => 'X');
                                 END LOOP;
                              end if;
                           end if;
         end case;

         LastClkEdge := CK_ipd;
       end if;

       if (Tviol_A_CK_posedge     = 'X' or
           Tviol_WEB_CK_posedge  = 'X' or
           Tviol_DI_CK_posedge   = 'X' or
           Tviol_CS_CK_posedge    = 'X' or
           Pviol_CK               = 'X'
          ) then

         if (Pviol_CK = 'X') then
            if (CS_ipd /= '0') then
               DO_zd := (OTHERS => 'X');
               DO_int <= TRANSPORT (OTHERS => 'X');
               if (WEB_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore(i) := (OTHERS => 'X');
                  END LOOP;
               end if;
            end if;
         else
            FOR i IN AddressSize-1 downto 0 LOOP
              if (Tviol_A_CK_posedge = 'X') then
                 Latch_A(i) := 'X';
              else
                 Latch_A(i) := Latch_A(i);
              end if;
            END LOOP;
            FOR i IN Bits-1 downto 0 LOOP
              if (Tviol_DI_CK_posedge = 'X') then
                 Latch_DI(i) := 'X';
              else
                 Latch_DI(i) := Latch_DI(i);
              end if;
            END LOOP;
            if (Tviol_WEB_CK_posedge = 'X') then
               Latch_WEB := 'X';
            else
               Latch_WEB := Latch_WEB;
            end if;
            if (Tviol_CS_CK_posedge = 'X') then
               Latch_CS := 'X';
            else
               Latch_CS := Latch_CS;
            end if;

                -- memory_function
                A_i    := Latch_A;
                CS_i   := Latch_CS;
                DI_i  := Latch_DI;
                WEB_i := Latch_WEB;

                web_cs    := WEB_i&CS_i;
                case web_cs is
                   when "11" => 
                       -------- Reduce error message --------------------------
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           DO_zd := memoryCore(to_integer(A_i));
                           ScheduleOutputDelay(DO_int(0), DO_zd(0),
                              tpd_CK_DO0_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(1), DO_zd(1),
                              tpd_CK_DO1_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(2), DO_zd(2),
                              tpd_CK_DO2_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(3), DO_zd(3),
                              tpd_CK_DO3_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(4), DO_zd(4),
                              tpd_CK_DO4_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(5), DO_zd(5),
                              tpd_CK_DO5_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(6), DO_zd(6),
                              tpd_CK_DO6_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(7), DO_zd(7),
                              tpd_CK_DO7_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(8), DO_zd(8),
                              tpd_CK_DO8_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(9), DO_zd(9),
                              tpd_CK_DO9_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(10), DO_zd(10),
                              tpd_CK_DO10_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(11), DO_zd(11),
                              tpd_CK_DO11_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(12), DO_zd(12),
                              tpd_CK_DO12_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(13), DO_zd(13),
                              tpd_CK_DO13_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(14), DO_zd(14),
                              tpd_CK_DO14_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(15), DO_zd(15),
                              tpd_CK_DO15_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(16), DO_zd(16),
                              tpd_CK_DO16_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(17), DO_zd(17),
                              tpd_CK_DO17_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(18), DO_zd(18),
                              tpd_CK_DO18_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(19), DO_zd(19),
                              tpd_CK_DO19_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(20), DO_zd(20),
                              tpd_CK_DO20_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(21), DO_zd(21),
                              tpd_CK_DO21_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(22), DO_zd(22),
                              tpd_CK_DO22_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(23), DO_zd(23),
                              tpd_CK_DO23_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(24), DO_zd(24),
                              tpd_CK_DO24_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(25), DO_zd(25),
                              tpd_CK_DO25_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(26), DO_zd(26),
                              tpd_CK_DO26_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(27), DO_zd(27),
                              tpd_CK_DO27_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(28), DO_zd(28),
                              tpd_CK_DO28_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(29), DO_zd(29),
                              tpd_CK_DO29_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(30), DO_zd(30),
                              tpd_CK_DO30_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(31), DO_zd(31),
                              tpd_CK_DO31_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(32), DO_zd(32),
                              tpd_CK_DO32_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(33), DO_zd(33),
                              tpd_CK_DO33_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(34), DO_zd(34),
                              tpd_CK_DO34_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(35), DO_zd(35),
                              tpd_CK_DO35_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(36), DO_zd(36),
                              tpd_CK_DO36_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(37), DO_zd(37),
                              tpd_CK_DO37_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(38), DO_zd(38),
                              tpd_CK_DO38_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(39), DO_zd(39),
                              tpd_CK_DO39_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(40), DO_zd(40),
                              tpd_CK_DO40_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(41), DO_zd(41),
                              tpd_CK_DO41_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(42), DO_zd(42),
                              tpd_CK_DO42_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(43), DO_zd(43),
                              tpd_CK_DO43_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(44), DO_zd(44),
                              tpd_CK_DO44_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(45), DO_zd(45),
                              tpd_CK_DO45_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(46), DO_zd(46),
                              tpd_CK_DO46_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(47), DO_zd(47),
                              tpd_CK_DO47_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(48), DO_zd(48),
                              tpd_CK_DO48_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(49), DO_zd(49),
                              tpd_CK_DO49_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(50), DO_zd(50),
                              tpd_CK_DO50_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(51), DO_zd(51),
                              tpd_CK_DO51_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(52), DO_zd(52),
                              tpd_CK_DO52_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(53), DO_zd(53),
                              tpd_CK_DO53_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(54), DO_zd(54),
                              tpd_CK_DO54_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(55), DO_zd(55),
                              tpd_CK_DO55_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(56), DO_zd(56),
                              tpd_CK_DO56_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(57), DO_zd(57),
                              tpd_CK_DO57_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(58), DO_zd(58),
                              tpd_CK_DO58_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(59), DO_zd(59),
                              tpd_CK_DO59_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(60), DO_zd(60),
                              tpd_CK_DO60_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(61), DO_zd(61),
                              tpd_CK_DO61_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(62), DO_zd(62),
                              tpd_CK_DO62_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(63), DO_zd(63),
                              tpd_CK_DO63_posedge,
                              last_A,A_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       end if;

                   when "01" => 
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           -- Reduce error message --
                           flag_A := True_flg;
                           --------------------------
                           memoryCore(to_integer(A_i)) := DI_i;
                           DO_zd := memoryCore(to_integer(A_i));
                           ScheduleOutputDelay(DO_int(0), DO_zd(0),
                              tpd_CK_DO0_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(1), DO_zd(1),
                              tpd_CK_DO1_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(2), DO_zd(2),
                              tpd_CK_DO2_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(3), DO_zd(3),
                              tpd_CK_DO3_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(4), DO_zd(4),
                              tpd_CK_DO4_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(5), DO_zd(5),
                              tpd_CK_DO5_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(6), DO_zd(6),
                              tpd_CK_DO6_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(7), DO_zd(7),
                              tpd_CK_DO7_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(8), DO_zd(8),
                              tpd_CK_DO8_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(9), DO_zd(9),
                              tpd_CK_DO9_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(10), DO_zd(10),
                              tpd_CK_DO10_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(11), DO_zd(11),
                              tpd_CK_DO11_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(12), DO_zd(12),
                              tpd_CK_DO12_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(13), DO_zd(13),
                              tpd_CK_DO13_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(14), DO_zd(14),
                              tpd_CK_DO14_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(15), DO_zd(15),
                              tpd_CK_DO15_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(16), DO_zd(16),
                              tpd_CK_DO16_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(17), DO_zd(17),
                              tpd_CK_DO17_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(18), DO_zd(18),
                              tpd_CK_DO18_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(19), DO_zd(19),
                              tpd_CK_DO19_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(20), DO_zd(20),
                              tpd_CK_DO20_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(21), DO_zd(21),
                              tpd_CK_DO21_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(22), DO_zd(22),
                              tpd_CK_DO22_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(23), DO_zd(23),
                              tpd_CK_DO23_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(24), DO_zd(24),
                              tpd_CK_DO24_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(25), DO_zd(25),
                              tpd_CK_DO25_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(26), DO_zd(26),
                              tpd_CK_DO26_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(27), DO_zd(27),
                              tpd_CK_DO27_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(28), DO_zd(28),
                              tpd_CK_DO28_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(29), DO_zd(29),
                              tpd_CK_DO29_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(30), DO_zd(30),
                              tpd_CK_DO30_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(31), DO_zd(31),
                              tpd_CK_DO31_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(32), DO_zd(32),
                              tpd_CK_DO32_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(33), DO_zd(33),
                              tpd_CK_DO33_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(34), DO_zd(34),
                              tpd_CK_DO34_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(35), DO_zd(35),
                              tpd_CK_DO35_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(36), DO_zd(36),
                              tpd_CK_DO36_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(37), DO_zd(37),
                              tpd_CK_DO37_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(38), DO_zd(38),
                              tpd_CK_DO38_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(39), DO_zd(39),
                              tpd_CK_DO39_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(40), DO_zd(40),
                              tpd_CK_DO40_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(41), DO_zd(41),
                              tpd_CK_DO41_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(42), DO_zd(42),
                              tpd_CK_DO42_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(43), DO_zd(43),
                              tpd_CK_DO43_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(44), DO_zd(44),
                              tpd_CK_DO44_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(45), DO_zd(45),
                              tpd_CK_DO45_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(46), DO_zd(46),
                              tpd_CK_DO46_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(47), DO_zd(47),
                              tpd_CK_DO47_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(48), DO_zd(48),
                              tpd_CK_DO48_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(49), DO_zd(49),
                              tpd_CK_DO49_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(50), DO_zd(50),
                              tpd_CK_DO50_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(51), DO_zd(51),
                              tpd_CK_DO51_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(52), DO_zd(52),
                              tpd_CK_DO52_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(53), DO_zd(53),
                              tpd_CK_DO53_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(54), DO_zd(54),
                              tpd_CK_DO54_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(55), DO_zd(55),
                              tpd_CK_DO55_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(56), DO_zd(56),
                              tpd_CK_DO56_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(57), DO_zd(57),
                              tpd_CK_DO57_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(58), DO_zd(58),
                              tpd_CK_DO58_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(59), DO_zd(59),
                              tpd_CK_DO59_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(60), DO_zd(60),
                              tpd_CK_DO60_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(61), DO_zd(61),
                              tpd_CK_DO61_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(62), DO_zd(62),
                              tpd_CK_DO62_posedge,
                              last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DO_int(63), DO_zd(63),
                              tpd_CK_DO63_posedge,
                              last_A,A_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DO_zd := (OTHERS => 'X');
                           DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;

                   when "1X" |
                        "1U" |
                        "1Z" => DO_zd := (OTHERS => 'X');
                                DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH; 
                   when "10" |
                        "00" |
                        "X0" |
                        "U0" |
                        "Z0"   => -- do nothing
                   when others =>
                                if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                                   -- Reduce error message --
                                   flag_A := True_flg;
                                   --------------------------
                                   memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                                    -- Reduce error message --
                                    flag_A := False_flg;
                                    --------------------------
                                    DO_zd := (OTHERS => 'X');
                                    DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                else
                                   -- Reduce error message --
                                   flag_A := False_flg;
                                   --------------------------
                                   DO_zd := (OTHERS => 'X');
                                   DO_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                   FOR i IN Words-1 downto 0 LOOP
                                      memoryCore(i) := (OTHERS => 'X');
                                   END LOOP;
                                end if;
                end case;
                -- end memory_function

         end if;
       end if;

   end PROCESS;

end behavior;

