-- |-----------------------------------------------------------------------|
-- 
--              Synchronous Dual Port SRAM Compiler 
-- 
--                    UMC 0.18um Generic Logic Process 
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
--       Module Name       :  SJMA180_128X32X1BM1  
--       Word              :  128                  
--       Bit               :  32                   
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
--       Date             : 2024/01/08 18:24:22
-- 
-- ________________________________________________________________________________
-- 
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
--       Date             : 2024/01/08 18:24:22
--
-- |-----------------------------------------------------------------------|

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

-- entity declaration --
entity SJMA180_128X32X1BM1 is
   generic(
      SYN_CS:      integer  := 1;
      NO_SER_TOH:  integer  := 1;
      AddressSize: integer  := 7;
      Bits:        integer  := 32;
      Words:       integer  := 128;
      Bytes:       integer  := 1;
      AspectRatio: integer  := 1;
      Tr2w:        time     := 2.272 ns;
      Tw2r:        time     := 1.699 ns;
      TOH:         time     := 0.757 ns;

      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := True;
      MsgOn: Boolean := True;


      tpd_CKA_DOA0_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA1_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA2_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA3_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA4_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA5_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA6_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA7_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA8_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA9_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA10_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA11_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA12_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA13_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA14_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA15_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA16_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA17_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA18_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA19_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA20_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA21_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA22_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA23_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA24_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA25_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA26_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA27_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA28_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA29_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA30_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKA_DOA31_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);

      tpd_CKB_DOB0_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB1_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB2_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB3_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB4_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB5_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB6_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB7_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB8_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB9_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB10_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB11_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB12_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB13_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB14_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB15_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB16_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB17_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB18_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB19_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB20_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB21_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB22_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB23_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB24_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB25_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB26_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB27_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB28_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB29_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB30_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);
      tpd_CKB_DOB31_posedge : VitalDelayType01 :=  (1.634 ns, 1.634 ns);

      tpd_OEA_DOA0    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA1    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA2    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA3    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA4    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA5    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA6    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA7    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA8    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA9    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA10    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA11    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA12    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA13    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA14    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA15    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA16    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA17    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA18    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA19    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA20    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA21    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA22    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA23    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA24    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA25    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA26    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA27    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA28    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA29    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA30    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEA_DOA31    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB0    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB1    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB2    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB3    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB4    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB5    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB6    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB7    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB8    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB9    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB10    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB11    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB12    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB13    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB14    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB15    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB16    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB17    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB18    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB19    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB20    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB21    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB22    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB23    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB24    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB25    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB26    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB27    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB28    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB29    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB30    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);
      tpd_OEB_DOB31    : VitalDelayType01Z := (1.037 ns, 1.037 ns, 0.647 ns, 1.037 ns, 0.647 ns, 1.037 ns);

      tsetup_A0_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A0_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A1_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A1_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A2_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A2_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A3_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A3_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A4_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A4_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A5_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A5_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A6_CKA_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_A6_CKA_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B0_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B0_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B1_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B1_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B2_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B2_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B3_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B3_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B4_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B4_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B5_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B5_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B6_CKB_posedge_posedge    :  VitalDelayType := 0.736 ns;
      tsetup_B6_CKB_negedge_posedge    :  VitalDelayType := 0.736 ns;
      thold_A0_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A0_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A1_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A1_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A2_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A2_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A3_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A3_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A4_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A4_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A5_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A5_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A6_CKA_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_A6_CKA_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B0_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B0_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B1_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B1_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B2_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B2_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B3_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B3_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B4_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B4_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B5_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B5_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B6_CKB_posedge_posedge     :  VitalDelayType := 0.122 ns;
      thold_B6_CKB_negedge_posedge     :  VitalDelayType := 0.122 ns;
      tsetup_DIA0_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA0_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA1_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA1_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA2_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA2_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA3_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA3_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA4_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA4_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA5_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA5_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA6_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA6_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA7_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA7_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA8_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA8_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA9_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA9_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA10_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA10_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA11_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA11_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA12_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA12_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA13_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA13_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA14_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA14_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA15_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA15_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA16_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA16_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA17_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA17_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA18_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA18_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA19_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA19_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA20_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA20_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA21_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA21_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA22_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA22_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA23_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA23_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA24_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA24_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA25_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA25_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA26_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA26_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA27_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA27_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA28_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA28_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA29_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA29_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA30_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA30_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA31_CKA_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIA31_CKA_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB0_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB0_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB1_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB1_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB2_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB2_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB3_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB3_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB4_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB4_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB5_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB5_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB6_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB6_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB7_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB7_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB8_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB8_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB9_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB9_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB10_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB10_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB11_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB11_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB12_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB12_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB13_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB13_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB14_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB14_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB15_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB15_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB16_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB16_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB17_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB17_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB18_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB18_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB19_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB19_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB20_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB20_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB21_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB21_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB22_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB22_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB23_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB23_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB24_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB24_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB25_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB25_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB26_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB26_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB27_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB27_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB28_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB28_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB29_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB29_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB30_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB30_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB31_CKB_posedge_posedge    :  VitalDelayType := 0.188 ns;
      tsetup_DIB31_CKB_negedge_posedge    :  VitalDelayType := 0.188 ns;
      thold_DIA0_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA0_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA1_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA1_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA2_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA2_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA3_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA3_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA4_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA4_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA5_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA5_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA6_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA6_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA7_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA7_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA8_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA8_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA9_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA9_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA10_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA10_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA11_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA11_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA12_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA12_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA13_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA13_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA14_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA14_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA15_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA15_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA16_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA16_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA17_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA17_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA18_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA18_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA19_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA19_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA20_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA20_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA21_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA21_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA22_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA22_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA23_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA23_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA24_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA24_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA25_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA25_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA26_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA26_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA27_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA27_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA28_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA28_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA29_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA29_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA30_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA30_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA31_CKA_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIA31_CKA_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB0_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB0_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB1_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB1_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB2_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB2_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB3_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB3_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB4_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB4_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB5_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB5_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB6_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB6_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB7_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB7_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB8_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB8_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB9_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB9_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB10_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB10_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB11_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB11_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB12_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB12_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB13_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB13_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB14_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB14_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB15_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB15_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB16_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB16_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB17_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB17_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB18_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB18_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB19_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB19_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB20_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB20_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB21_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB21_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB22_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB22_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB23_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB23_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB24_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB24_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB25_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB25_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB26_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB26_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB27_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB27_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB28_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB28_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB29_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB29_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB30_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB30_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB31_CKB_posedge_posedge     :  VitalDelayType := 0.048 ns;
      thold_DIB31_CKB_negedge_posedge     :  VitalDelayType := 0.048 ns;
      tsetup_WEAN_CKA_posedge_posedge   :  VitalDelayType := 0.347 ns;
      tsetup_WEAN_CKA_negedge_posedge   :  VitalDelayType := 0.347 ns;
      thold_WEAN_CKA_posedge_posedge    :  VitalDelayType := 0.069 ns;
      thold_WEAN_CKA_negedge_posedge    :  VitalDelayType := 0.069 ns;
      tsetup_WEBN_CKB_posedge_posedge   :  VitalDelayType := 0.347 ns;
      tsetup_WEBN_CKB_negedge_posedge   :  VitalDelayType := 0.347 ns;
      thold_WEBN_CKB_posedge_posedge    :  VitalDelayType := 0.069 ns;
      thold_WEBN_CKB_negedge_posedge    :  VitalDelayType := 0.069 ns;
      tsetup_CSA_CKA_posedge_posedge    :  VitalDelayType := 0.743 ns;
      tsetup_CSA_CKA_negedge_posedge    :  VitalDelayType := 0.743 ns;
      tsetup_CSB_CKB_posedge_posedge    :  VitalDelayType := 0.743 ns;
      tsetup_CSB_CKB_negedge_posedge    :  VitalDelayType := 0.743 ns;
      thold_CSA_CKA_posedge_posedge     :  VitalDelayType := 0.000 ns;
      thold_CSA_CKA_negedge_posedge     :  VitalDelayType := 0.000 ns;
      thold_CSB_CKB_posedge_posedge     :  VitalDelayType := 0.000 ns;
      thold_CSB_CKB_negedge_posedge     :  VitalDelayType := 0.000 ns;
      tperiod_CKA                       :  VitalDelayType := 2.272 ns;
      tperiod_CKB                       :  VitalDelayType := 2.272 ns;
      tpw_CKA_posedge                   :  VitalDelayType := 0.757 ns;
      tpw_CKB_posedge                   :  VitalDelayType := 0.757 ns;
      tpw_CKA_negedge                   :  VitalDelayType := 0.757 ns;
      tpw_CKB_negedge                   :  VitalDelayType := 0.757 ns;
      tipd_A0                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A1                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A2                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A3                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A4                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A5                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A6                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B0                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B1                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B2                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B3                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B4                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B5                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_B6                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA0                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA1                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA2                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA3                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA4                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA5                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA6                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA7                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA8                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA9                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA10                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA11                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA12                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA13                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA14                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA15                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA16                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA17                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA18                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA19                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA20                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA21                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA22                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA23                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA24                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA25                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA26                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA27                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA28                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA29                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA30                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIA31                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB0                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB1                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB2                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB3                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB4                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB5                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB6                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB7                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB8                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB9                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB10                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB11                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB12                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB13                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB14                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB15                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB16                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB17                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB18                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB19                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB20                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB21                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB22                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB23                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB24                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB25                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB26                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB27                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB28                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB29                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB30                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_DIB31                    :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEAN                       :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_WEBN                       :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CSA                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CSB                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CKA                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_CKB                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_OEA                        :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_OEB                        :  VitalDelayType01 := (0.000 ns, 0.000 ns)
      );

   port(
      A0                            :   IN   std_logic;
      A1                            :   IN   std_logic;
      A2                            :   IN   std_logic;
      A3                            :   IN   std_logic;
      A4                            :   IN   std_logic;
      A5                            :   IN   std_logic;
      A6                            :   IN   std_logic;
      B0                            :   IN   std_logic;
      B1                            :   IN   std_logic;
      B2                            :   IN   std_logic;
      B3                            :   IN   std_logic;
      B4                            :   IN   std_logic;
      B5                            :   IN   std_logic;
      B6                            :   IN   std_logic;
      DOA0                        :   OUT   std_logic;
      DOA1                        :   OUT   std_logic;
      DOA2                        :   OUT   std_logic;
      DOA3                        :   OUT   std_logic;
      DOA4                        :   OUT   std_logic;
      DOA5                        :   OUT   std_logic;
      DOA6                        :   OUT   std_logic;
      DOA7                        :   OUT   std_logic;
      DOA8                        :   OUT   std_logic;
      DOA9                        :   OUT   std_logic;
      DOA10                        :   OUT   std_logic;
      DOA11                        :   OUT   std_logic;
      DOA12                        :   OUT   std_logic;
      DOA13                        :   OUT   std_logic;
      DOA14                        :   OUT   std_logic;
      DOA15                        :   OUT   std_logic;
      DOA16                        :   OUT   std_logic;
      DOA17                        :   OUT   std_logic;
      DOA18                        :   OUT   std_logic;
      DOA19                        :   OUT   std_logic;
      DOA20                        :   OUT   std_logic;
      DOA21                        :   OUT   std_logic;
      DOA22                        :   OUT   std_logic;
      DOA23                        :   OUT   std_logic;
      DOA24                        :   OUT   std_logic;
      DOA25                        :   OUT   std_logic;
      DOA26                        :   OUT   std_logic;
      DOA27                        :   OUT   std_logic;
      DOA28                        :   OUT   std_logic;
      DOA29                        :   OUT   std_logic;
      DOA30                        :   OUT   std_logic;
      DOA31                        :   OUT   std_logic;
      DOB0                        :   OUT   std_logic;
      DOB1                        :   OUT   std_logic;
      DOB2                        :   OUT   std_logic;
      DOB3                        :   OUT   std_logic;
      DOB4                        :   OUT   std_logic;
      DOB5                        :   OUT   std_logic;
      DOB6                        :   OUT   std_logic;
      DOB7                        :   OUT   std_logic;
      DOB8                        :   OUT   std_logic;
      DOB9                        :   OUT   std_logic;
      DOB10                        :   OUT   std_logic;
      DOB11                        :   OUT   std_logic;
      DOB12                        :   OUT   std_logic;
      DOB13                        :   OUT   std_logic;
      DOB14                        :   OUT   std_logic;
      DOB15                        :   OUT   std_logic;
      DOB16                        :   OUT   std_logic;
      DOB17                        :   OUT   std_logic;
      DOB18                        :   OUT   std_logic;
      DOB19                        :   OUT   std_logic;
      DOB20                        :   OUT   std_logic;
      DOB21                        :   OUT   std_logic;
      DOB22                        :   OUT   std_logic;
      DOB23                        :   OUT   std_logic;
      DOB24                        :   OUT   std_logic;
      DOB25                        :   OUT   std_logic;
      DOB26                        :   OUT   std_logic;
      DOB27                        :   OUT   std_logic;
      DOB28                        :   OUT   std_logic;
      DOB29                        :   OUT   std_logic;
      DOB30                        :   OUT   std_logic;
      DOB31                        :   OUT   std_logic;
      DIA0                        :   IN   std_logic;
      DIA1                        :   IN   std_logic;
      DIA2                        :   IN   std_logic;
      DIA3                        :   IN   std_logic;
      DIA4                        :   IN   std_logic;
      DIA5                        :   IN   std_logic;
      DIA6                        :   IN   std_logic;
      DIA7                        :   IN   std_logic;
      DIA8                        :   IN   std_logic;
      DIA9                        :   IN   std_logic;
      DIA10                        :   IN   std_logic;
      DIA11                        :   IN   std_logic;
      DIA12                        :   IN   std_logic;
      DIA13                        :   IN   std_logic;
      DIA14                        :   IN   std_logic;
      DIA15                        :   IN   std_logic;
      DIA16                        :   IN   std_logic;
      DIA17                        :   IN   std_logic;
      DIA18                        :   IN   std_logic;
      DIA19                        :   IN   std_logic;
      DIA20                        :   IN   std_logic;
      DIA21                        :   IN   std_logic;
      DIA22                        :   IN   std_logic;
      DIA23                        :   IN   std_logic;
      DIA24                        :   IN   std_logic;
      DIA25                        :   IN   std_logic;
      DIA26                        :   IN   std_logic;
      DIA27                        :   IN   std_logic;
      DIA28                        :   IN   std_logic;
      DIA29                        :   IN   std_logic;
      DIA30                        :   IN   std_logic;
      DIA31                        :   IN   std_logic;
      DIB0                        :   IN   std_logic;
      DIB1                        :   IN   std_logic;
      DIB2                        :   IN   std_logic;
      DIB3                        :   IN   std_logic;
      DIB4                        :   IN   std_logic;
      DIB5                        :   IN   std_logic;
      DIB6                        :   IN   std_logic;
      DIB7                        :   IN   std_logic;
      DIB8                        :   IN   std_logic;
      DIB9                        :   IN   std_logic;
      DIB10                        :   IN   std_logic;
      DIB11                        :   IN   std_logic;
      DIB12                        :   IN   std_logic;
      DIB13                        :   IN   std_logic;
      DIB14                        :   IN   std_logic;
      DIB15                        :   IN   std_logic;
      DIB16                        :   IN   std_logic;
      DIB17                        :   IN   std_logic;
      DIB18                        :   IN   std_logic;
      DIB19                        :   IN   std_logic;
      DIB20                        :   IN   std_logic;
      DIB21                        :   IN   std_logic;
      DIB22                        :   IN   std_logic;
      DIB23                        :   IN   std_logic;
      DIB24                        :   IN   std_logic;
      DIB25                        :   IN   std_logic;
      DIB26                        :   IN   std_logic;
      DIB27                        :   IN   std_logic;
      DIB28                        :   IN   std_logic;
      DIB29                        :   IN   std_logic;
      DIB30                        :   IN   std_logic;
      DIB31                        :   IN   std_logic;
      WEAN                           :   IN   std_logic;
      WEBN                           :   IN   std_logic;
      CKA                            :   IN   std_logic;
      CKB                            :   IN   std_logic;
      CSA                            :   IN   std_logic;
      CSB                            :   IN   std_logic;
      OEA                            :   IN   std_logic;
      OEB                            :   IN   std_logic
      );

attribute VITAL_LEVEL0 of SJMA180_128X32X1BM1 : entity is TRUE;

end SJMA180_128X32X1BM1;

-- architecture body --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

architecture behavior of SJMA180_128X32X1BM1 is
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

   SIGNAL CSA_ipd        : std_logic := 'X';
   SIGNAL CSB_ipd        : std_logic := 'X';
   SIGNAL OEA_ipd        : std_logic := 'X';
   SIGNAL OEB_ipd        : std_logic := 'X';
   SIGNAL CKA_ipd        : std_logic := 'X';
   SIGNAL CKB_ipd        : std_logic := 'X';
   SIGNAL A_ipd          : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   SIGNAL B_ipd          : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   SIGNAL WEAN_ipd       : std_logic := 'X';
   SIGNAL WEBN_ipd       : std_logic := 'X';
   SIGNAL DIA_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DIB_ipd        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DOA_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   SIGNAL DOB_int        : std_logic_vector(Bits-1 downto 0) := (others => 'X');

begin

   ---------------------
   --  INPUT PATH DELAYs
   ---------------------
   WireDelay : block
   begin
   VitalWireDelay (CSA_ipd, CSA, tipd_CSA);
   VitalWireDelay (CSB_ipd, CSB, tipd_CSB);
   VitalWireDelay (WEAN_ipd, WEAN, tipd_WEAN);
   VitalWireDelay (WEBN_ipd, WEBN, tipd_WEBN);
   VitalWireDelay (OEA_ipd, OEA, tipd_OEA);
   VitalWireDelay (OEB_ipd, OEB, tipd_OEB);
   VitalWireDelay (CKA_ipd, CKA, tipd_CKA);
   VitalWireDelay (CKB_ipd, CKB, tipd_CKB);
   VitalWireDelay (A_ipd(0), A0, tipd_A0);
   VitalWireDelay (A_ipd(1), A1, tipd_A1);
   VitalWireDelay (A_ipd(2), A2, tipd_A2);
   VitalWireDelay (A_ipd(3), A3, tipd_A3);
   VitalWireDelay (A_ipd(4), A4, tipd_A4);
   VitalWireDelay (A_ipd(5), A5, tipd_A5);
   VitalWireDelay (A_ipd(6), A6, tipd_A6);
   VitalWireDelay (B_ipd(0), B0, tipd_B0);
   VitalWireDelay (B_ipd(1), B1, tipd_B1);
   VitalWireDelay (B_ipd(2), B2, tipd_B2);
   VitalWireDelay (B_ipd(3), B3, tipd_B3);
   VitalWireDelay (B_ipd(4), B4, tipd_B4);
   VitalWireDelay (B_ipd(5), B5, tipd_B5);
   VitalWireDelay (B_ipd(6), B6, tipd_B6);
   VitalWireDelay (DIA_ipd(0), DIA0, tipd_DIA0);
   VitalWireDelay (DIB_ipd(0), DIB0, tipd_DIB0);
   VitalWireDelay (DIA_ipd(1), DIA1, tipd_DIA1);
   VitalWireDelay (DIB_ipd(1), DIB1, tipd_DIB1);
   VitalWireDelay (DIA_ipd(2), DIA2, tipd_DIA2);
   VitalWireDelay (DIB_ipd(2), DIB2, tipd_DIB2);
   VitalWireDelay (DIA_ipd(3), DIA3, tipd_DIA3);
   VitalWireDelay (DIB_ipd(3), DIB3, tipd_DIB3);
   VitalWireDelay (DIA_ipd(4), DIA4, tipd_DIA4);
   VitalWireDelay (DIB_ipd(4), DIB4, tipd_DIB4);
   VitalWireDelay (DIA_ipd(5), DIA5, tipd_DIA5);
   VitalWireDelay (DIB_ipd(5), DIB5, tipd_DIB5);
   VitalWireDelay (DIA_ipd(6), DIA6, tipd_DIA6);
   VitalWireDelay (DIB_ipd(6), DIB6, tipd_DIB6);
   VitalWireDelay (DIA_ipd(7), DIA7, tipd_DIA7);
   VitalWireDelay (DIB_ipd(7), DIB7, tipd_DIB7);
   VitalWireDelay (DIA_ipd(8), DIA8, tipd_DIA8);
   VitalWireDelay (DIB_ipd(8), DIB8, tipd_DIB8);
   VitalWireDelay (DIA_ipd(9), DIA9, tipd_DIA9);
   VitalWireDelay (DIB_ipd(9), DIB9, tipd_DIB9);
   VitalWireDelay (DIA_ipd(10), DIA10, tipd_DIA10);
   VitalWireDelay (DIB_ipd(10), DIB10, tipd_DIB10);
   VitalWireDelay (DIA_ipd(11), DIA11, tipd_DIA11);
   VitalWireDelay (DIB_ipd(11), DIB11, tipd_DIB11);
   VitalWireDelay (DIA_ipd(12), DIA12, tipd_DIA12);
   VitalWireDelay (DIB_ipd(12), DIB12, tipd_DIB12);
   VitalWireDelay (DIA_ipd(13), DIA13, tipd_DIA13);
   VitalWireDelay (DIB_ipd(13), DIB13, tipd_DIB13);
   VitalWireDelay (DIA_ipd(14), DIA14, tipd_DIA14);
   VitalWireDelay (DIB_ipd(14), DIB14, tipd_DIB14);
   VitalWireDelay (DIA_ipd(15), DIA15, tipd_DIA15);
   VitalWireDelay (DIB_ipd(15), DIB15, tipd_DIB15);
   VitalWireDelay (DIA_ipd(16), DIA16, tipd_DIA16);
   VitalWireDelay (DIB_ipd(16), DIB16, tipd_DIB16);
   VitalWireDelay (DIA_ipd(17), DIA17, tipd_DIA17);
   VitalWireDelay (DIB_ipd(17), DIB17, tipd_DIB17);
   VitalWireDelay (DIA_ipd(18), DIA18, tipd_DIA18);
   VitalWireDelay (DIB_ipd(18), DIB18, tipd_DIB18);
   VitalWireDelay (DIA_ipd(19), DIA19, tipd_DIA19);
   VitalWireDelay (DIB_ipd(19), DIB19, tipd_DIB19);
   VitalWireDelay (DIA_ipd(20), DIA20, tipd_DIA20);
   VitalWireDelay (DIB_ipd(20), DIB20, tipd_DIB20);
   VitalWireDelay (DIA_ipd(21), DIA21, tipd_DIA21);
   VitalWireDelay (DIB_ipd(21), DIB21, tipd_DIB21);
   VitalWireDelay (DIA_ipd(22), DIA22, tipd_DIA22);
   VitalWireDelay (DIB_ipd(22), DIB22, tipd_DIB22);
   VitalWireDelay (DIA_ipd(23), DIA23, tipd_DIA23);
   VitalWireDelay (DIB_ipd(23), DIB23, tipd_DIB23);
   VitalWireDelay (DIA_ipd(24), DIA24, tipd_DIA24);
   VitalWireDelay (DIB_ipd(24), DIB24, tipd_DIB24);
   VitalWireDelay (DIA_ipd(25), DIA25, tipd_DIA25);
   VitalWireDelay (DIB_ipd(25), DIB25, tipd_DIB25);
   VitalWireDelay (DIA_ipd(26), DIA26, tipd_DIA26);
   VitalWireDelay (DIB_ipd(26), DIB26, tipd_DIB26);
   VitalWireDelay (DIA_ipd(27), DIA27, tipd_DIA27);
   VitalWireDelay (DIB_ipd(27), DIB27, tipd_DIB27);
   VitalWireDelay (DIA_ipd(28), DIA28, tipd_DIA28);
   VitalWireDelay (DIB_ipd(28), DIB28, tipd_DIB28);
   VitalWireDelay (DIA_ipd(29), DIA29, tipd_DIA29);
   VitalWireDelay (DIB_ipd(29), DIB29, tipd_DIB29);
   VitalWireDelay (DIA_ipd(30), DIA30, tipd_DIA30);
   VitalWireDelay (DIB_ipd(30), DIB30, tipd_DIB30);
   VitalWireDelay (DIA_ipd(31), DIA31, tipd_DIA31);
   VitalWireDelay (DIB_ipd(31), DIB31, tipd_DIB31);

   end block;

   VitalBUFIF1 (q      => DOA0,
                data   => DOA_int(0),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA0);
   VitalBUFIF1 (q      => DOA1,
                data   => DOA_int(1),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA1);
   VitalBUFIF1 (q      => DOA2,
                data   => DOA_int(2),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA2);
   VitalBUFIF1 (q      => DOA3,
                data   => DOA_int(3),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA3);
   VitalBUFIF1 (q      => DOA4,
                data   => DOA_int(4),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA4);
   VitalBUFIF1 (q      => DOA5,
                data   => DOA_int(5),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA5);
   VitalBUFIF1 (q      => DOA6,
                data   => DOA_int(6),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA6);
   VitalBUFIF1 (q      => DOA7,
                data   => DOA_int(7),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA7);
   VitalBUFIF1 (q      => DOA8,
                data   => DOA_int(8),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA8);
   VitalBUFIF1 (q      => DOA9,
                data   => DOA_int(9),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA9);
   VitalBUFIF1 (q      => DOA10,
                data   => DOA_int(10),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA10);
   VitalBUFIF1 (q      => DOA11,
                data   => DOA_int(11),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA11);
   VitalBUFIF1 (q      => DOA12,
                data   => DOA_int(12),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA12);
   VitalBUFIF1 (q      => DOA13,
                data   => DOA_int(13),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA13);
   VitalBUFIF1 (q      => DOA14,
                data   => DOA_int(14),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA14);
   VitalBUFIF1 (q      => DOA15,
                data   => DOA_int(15),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA15);
   VitalBUFIF1 (q      => DOA16,
                data   => DOA_int(16),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA16);
   VitalBUFIF1 (q      => DOA17,
                data   => DOA_int(17),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA17);
   VitalBUFIF1 (q      => DOA18,
                data   => DOA_int(18),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA18);
   VitalBUFIF1 (q      => DOA19,
                data   => DOA_int(19),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA19);
   VitalBUFIF1 (q      => DOA20,
                data   => DOA_int(20),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA20);
   VitalBUFIF1 (q      => DOA21,
                data   => DOA_int(21),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA21);
   VitalBUFIF1 (q      => DOA22,
                data   => DOA_int(22),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA22);
   VitalBUFIF1 (q      => DOA23,
                data   => DOA_int(23),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA23);
   VitalBUFIF1 (q      => DOA24,
                data   => DOA_int(24),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA24);
   VitalBUFIF1 (q      => DOA25,
                data   => DOA_int(25),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA25);
   VitalBUFIF1 (q      => DOA26,
                data   => DOA_int(26),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA26);
   VitalBUFIF1 (q      => DOA27,
                data   => DOA_int(27),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA27);
   VitalBUFIF1 (q      => DOA28,
                data   => DOA_int(28),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA28);
   VitalBUFIF1 (q      => DOA29,
                data   => DOA_int(29),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA29);
   VitalBUFIF1 (q      => DOA30,
                data   => DOA_int(30),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA30);
   VitalBUFIF1 (q      => DOA31,
                data   => DOA_int(31),
                enable => OEA_ipd,
                tpd_enable_q => tpd_OEA_DOA31);

   VitalBUFIF1 (q      => DOB0,
                data   => DOB_int(0),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB0);
   VitalBUFIF1 (q      => DOB1,
                data   => DOB_int(1),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB1);
   VitalBUFIF1 (q      => DOB2,
                data   => DOB_int(2),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB2);
   VitalBUFIF1 (q      => DOB3,
                data   => DOB_int(3),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB3);
   VitalBUFIF1 (q      => DOB4,
                data   => DOB_int(4),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB4);
   VitalBUFIF1 (q      => DOB5,
                data   => DOB_int(5),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB5);
   VitalBUFIF1 (q      => DOB6,
                data   => DOB_int(6),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB6);
   VitalBUFIF1 (q      => DOB7,
                data   => DOB_int(7),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB7);
   VitalBUFIF1 (q      => DOB8,
                data   => DOB_int(8),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB8);
   VitalBUFIF1 (q      => DOB9,
                data   => DOB_int(9),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB9);
   VitalBUFIF1 (q      => DOB10,
                data   => DOB_int(10),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB10);
   VitalBUFIF1 (q      => DOB11,
                data   => DOB_int(11),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB11);
   VitalBUFIF1 (q      => DOB12,
                data   => DOB_int(12),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB12);
   VitalBUFIF1 (q      => DOB13,
                data   => DOB_int(13),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB13);
   VitalBUFIF1 (q      => DOB14,
                data   => DOB_int(14),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB14);
   VitalBUFIF1 (q      => DOB15,
                data   => DOB_int(15),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB15);
   VitalBUFIF1 (q      => DOB16,
                data   => DOB_int(16),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB16);
   VitalBUFIF1 (q      => DOB17,
                data   => DOB_int(17),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB17);
   VitalBUFIF1 (q      => DOB18,
                data   => DOB_int(18),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB18);
   VitalBUFIF1 (q      => DOB19,
                data   => DOB_int(19),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB19);
   VitalBUFIF1 (q      => DOB20,
                data   => DOB_int(20),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB20);
   VitalBUFIF1 (q      => DOB21,
                data   => DOB_int(21),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB21);
   VitalBUFIF1 (q      => DOB22,
                data   => DOB_int(22),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB22);
   VitalBUFIF1 (q      => DOB23,
                data   => DOB_int(23),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB23);
   VitalBUFIF1 (q      => DOB24,
                data   => DOB_int(24),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB24);
   VitalBUFIF1 (q      => DOB25,
                data   => DOB_int(25),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB25);
   VitalBUFIF1 (q      => DOB26,
                data   => DOB_int(26),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB26);
   VitalBUFIF1 (q      => DOB27,
                data   => DOB_int(27),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB27);
   VitalBUFIF1 (q      => DOB28,
                data   => DOB_int(28),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB28);
   VitalBUFIF1 (q      => DOB29,
                data   => DOB_int(29),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB29);
   VitalBUFIF1 (q      => DOB30,
                data   => DOB_int(30),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB30);
   VitalBUFIF1 (q      => DOB31,
                data   => DOB_int(31),
                enable => OEB_ipd,
                tpd_enable_q => tpd_OEB_DOB31);

   --------------------
   --  BEHAVIOR SECTION
   --------------------
   VITALBehavior : PROCESS (CSA_ipd,
                            CSB_ipd,
                            OEA_ipd,
                            OEB_ipd,
                            A_ipd,
                            B_ipd,
                            WEAN_ipd,
                            WEBN_ipd,
                            DIA_ipd,
                            DIB_ipd,
                            CKA_ipd,
                            CKB_ipd)

   -- timing check results
   VARIABLE Tviol_A_CKA_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_B_CKB_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEAN_CKA_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_WEBN_CKB_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_DIA_CKA_posedge   : STD_ULOGIC := '0';
   VARIABLE Tviol_DIB_CKB_posedge   : STD_ULOGIC := '0';
   VARIABLE Tviol_CSA_CKA_posedge  : STD_ULOGIC := '0';
   VARIABLE Tviol_CSB_CKB_posedge  : STD_ULOGIC := '0';

   VARIABLE Pviol_CKA    : STD_ULOGIC := '0';
   VARIABLE Pviol_CKB    : STD_ULOGIC := '0';
   VARIABLE Pdata_CKA    : VitalPeriodDataType := VitalPeriodDataInit;
   VARIABLE Pdata_CKB    : VitalPeriodDataType := VitalPeriodDataInit;

   VARIABLE Tmkr_A_CKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_B_CKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEAN_CKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_WEBN_CKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DIA_CKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_DIB_CKB_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_CSA_CKA_posedge   : VitalTimingDataType := VitalTimingDataInit;
   VARIABLE Tmkr_CSB_CKB_posedge   : VitalTimingDataType := VitalTimingDataInit;

   VARIABLE DOA_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE DOB_zd : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE memoryCore  : memoryArray;

   VARIABLE cka_change   : std_logic_vector(1 downto 0);
   VARIABLE ckb_change   : std_logic_vector(1 downto 0);
   VARIABLE wea_csa      : std_logic_vector(1 downto 0);
   VARIABLE web_csb      : std_logic_vector(1 downto 0);

   -- previous latch data
   VARIABLE Latch_A        : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE Latch_B        : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE Latch_DIA       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_DIB       : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE Latch_WEAN      : std_logic := 'X';
   VARIABLE Latch_WEBN      : std_logic := 'X';
   VARIABLE Latch_CSA       : std_logic := 'X';
   VARIABLE Latch_CSB       : std_logic := 'X';

   -- internal latch data
   VARIABLE A_i            : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE B_i            : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE DIA_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE DIB_i           : std_logic_vector(Bits-1 downto 0) := (others => 'X');
   VARIABLE WEAN_i          : std_logic := 'X';
   VARIABLE WEBN_i          : std_logic := 'X';
   VARIABLE CSA_i           : std_logic := 'X';
   VARIABLE CSB_i           : std_logic := 'X';

   VARIABLE Last_WEAN_i      : std_logic := 'X';
   VARIABLE Last_WEBN_i      : std_logic := 'X';

   VARIABLE last_A         : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE last_B         : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');

   VARIABLE LastClkAEdge    : std_logic := 'X';
   VARIABLE LastClkBEdge    : std_logic := 'X';

   VARIABLE flag_A: integer   := True_flg;
   VARIABLE flag_B: integer   := True_flg;
   VARIABLE flag_CSA: integer   := True_flg;
   VARIABLE flag_CSB: integer   := True_flg;

   VARIABLE LastCycleAAddress  : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE LastCycleBAddress  : std_logic_vector(AddressSize-1 downto 0) := (others => 'X');
   VARIABLE Last_tc_ClkA_PosEdge     : time := 0 ns;
   VARIABLE Last_tc_ClkB_PosEdge     : time := 0 ns;

   begin

   ------------------------
   --  Timing Check Section
   ------------------------
   if (TimingChecksOn) then
         VitalSetupHoldCheck (
          Violation               => Tviol_A_CKA_posedge,
          TimingData              => Tmkr_A_CKA_posedge,
          TestSignal              => A_ipd,
          TestSignalName          => "A",
          TestDelay               => 0 ns,
          RefSignal               => CKA_ipd,
          RefSignalName           => "CKA",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_A0_CKA_posedge_posedge,
          SetupLow                => tsetup_A0_CKA_negedge_posedge,
          HoldHigh                => thold_A0_CKA_negedge_posedge,
          HoldLow                 => thold_A0_CKA_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSA_ipd = '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_B_CKB_posedge,
          TimingData              => Tmkr_B_CKB_posedge,
          TestSignal              => B_ipd,
          TestSignalName          => "B",
          TestDelay               => 0 ns,
          RefSignal               => CKB_ipd,
          RefSignalName           => "CKB",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_B0_CKB_posedge_posedge,
          SetupLow                => tsetup_B0_CKB_negedge_posedge,
          HoldHigh                => thold_B0_CKB_negedge_posedge,
          HoldLow                 => thold_B0_CKB_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_WEAN_CKA_posedge,
          TimingData              => Tmkr_WEAN_CKA_posedge,
          TestSignal              => WEAN_ipd,
          TestSignalName          => "WEAN",
          TestDelay               => 0 ns,
          RefSignal               => CKA_ipd,
          RefSignalName           => "CKA",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEAN_CKA_posedge_posedge,
          SetupLow                => tsetup_WEAN_CKA_negedge_posedge,
          HoldHigh                => thold_WEAN_CKA_negedge_posedge,
          HoldLow                 => thold_WEAN_CKA_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSA_ipd = '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_WEBN_CKB_posedge,
          TimingData              => Tmkr_WEBN_CKB_posedge,
          TestSignal              => WEBN_ipd,
          TestSignalName          => "WEBN",
          TestDelay               => 0 ns,
          RefSignal               => CKB_ipd,
          RefSignalName           => "CKB",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_WEBN_CKB_posedge_posedge,
          SetupLow                => tsetup_WEBN_CKB_negedge_posedge,
          HoldHigh                => thold_WEBN_CKB_negedge_posedge,
          HoldLow                 => thold_WEBN_CKB_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_DIA_CKA_posedge,
          TimingData              => Tmkr_DIA_CKA_posedge,
          TestSignal              => DIA_ipd,
          TestSignalName          => "DIA",
          TestDelay               => 0 ns,
          RefSignal               => CKA_ipd,
          RefSignalName           => "CKA",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DIA0_CKA_posedge_posedge,
          SetupLow                => tsetup_DIA0_CKA_negedge_posedge,
          HoldHigh                => thold_DIA0_CKA_negedge_posedge,
          HoldLow                 => thold_DIA0_CKA_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSA_ipd = '1' AND WEAN_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
         VitalSetupHoldCheck (
          Violation               => Tviol_DIB_CKB_posedge,
          TimingData              => Tmkr_DIB_CKB_posedge,
          TestSignal              => DIB_ipd,
          TestSignalName          => "DIB",
          TestDelay               => 0 ns,
          RefSignal               => CKB_ipd,
          RefSignalName           => "CKB",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_DIB0_CKB_posedge_posedge,
          SetupLow                => tsetup_DIB0_CKB_negedge_posedge,
          HoldHigh                => thold_DIB0_CKB_negedge_posedge,
          HoldLow                 => thold_DIB0_CKB_posedge_posedge,
          CheckEnabled            =>
                           NOW /= 0 ns AND CSB_ipd = '1' AND WEBN_ipd /= '1',
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_CSA_CKA_posedge,
          TimingData              => Tmkr_CSA_CKA_posedge,
          TestSignal              => CSA_ipd,
          TestSignalName          => "CSA",
          TestDelay               => 0 ns,
          RefSignal               => CKA_ipd,
          RefSignalName           => "CKA",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_CSA_CKA_posedge_posedge,
          SetupLow                => tsetup_CSA_CKA_negedge_posedge,
          HoldHigh                => thold_CSA_CKA_negedge_posedge,
          HoldLow                 => thold_CSA_CKA_posedge_posedge,
          CheckEnabled            => NOW /= 0 ns,
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalSetupHoldCheck (
          Violation               => Tviol_CSB_CKB_posedge,
          TimingData              => Tmkr_CSB_CKB_posedge,
          TestSignal              => CSB_ipd,
          TestSignalName          => "CSB",
          TestDelay               => 0 ns,
          RefSignal               => CKB_ipd,
          RefSignalName           => "CKB",
          RefDelay                => 0 ns,
          SetupHigh               => tsetup_CSB_CKB_posedge_posedge,
          SetupLow                => tsetup_CSB_CKB_negedge_posedge,
          HoldHigh                => thold_CSB_CKB_negedge_posedge,
          HoldLow                 => thold_CSB_CKB_posedge_posedge,
          CheckEnabled            => NOW /= 0 ns,
          RefTransition           => 'R',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalPeriodPulseCheck (
          Violation               => Pviol_CKA,
          PeriodData              => Pdata_CKA,
          TestSignal              => CKA_ipd,
          TestSignalName          => "CKA",
          TestDelay               => 0 ns,
          Period                  => tperiod_CKA,
          PulseWidthHigh          => tpw_CKA_posedge,
          PulseWidthLow           => tpw_CKA_negedge,
          CheckEnabled            => NOW /= 0 ns AND CSA_ipd = '1',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);

         VitalPeriodPulseCheck (
          Violation               => Pviol_CKB,
          PeriodData              => Pdata_CKB,
          TestSignal              => CKB_ipd,
          TestSignalName          => "CKB",
          TestDelay               => 0 ns,
          Period                  => tperiod_CKB,
          PulseWidthHigh          => tpw_CKB_posedge,
          PulseWidthLow           => tpw_CKB_negedge,
          CheckEnabled            => NOW /= 0 ns AND CSB_ipd = '1',
          HeaderMsg               => InstancePath & "/SJMA180_128X32X1BM1",
          Xon                     => Xon,
          MsgOn                   => MsgOn,
          MsgSeverity             => WARNING);
   end if;

   -------------------------
   --  Functionality Section
   -------------------------

       if (CKA_ipd'event) then
         cka_change := LastClkAEdge&CKA_ipd;
         case cka_change is
            when "01"   =>
                if (CS_monitor(CSA_ipd,flag_CSA) = True_flg) then
                   -- Reduce error message --
                   flag_CSA := True_flg;
                else
                   flag_CSA := False_flg;
                end if;

                Latch_A      := A_ipd;
                Latch_CSA    := CSA_ipd;
                Latch_DIA   := DIA_ipd;
                Latch_WEAN  := WEAN_ipd;

                -- memory_functionA
                A_i    := Latch_A;
                CSA_i  := Latch_CSA;
                DIA_i  := Latch_DIA;
                WEAN_i := Latch_WEAN;

                wea_csa    := WEAN_i&CSA_i;
                case wea_csa is
                   when "11" =>
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           if ((A_i = LastCycleBAddress) and
                               (Last_WEBN_i = '0') and
                               ((NOW-Last_tc_ClkB_PosEdge) < Tw2r)) then
                                 -- read and write the same address
                              assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                              DOA_zd := (OTHERS => 'X');
                              DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           else
                              DOA_zd := memoryCore(to_integer(A_i));
                              ScheduleOutputDelay(DOA_int(0), DOA_zd(0),
                              tpd_CKA_DOA0_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(1), DOA_zd(1),
                              tpd_CKA_DOA1_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(2), DOA_zd(2),
                              tpd_CKA_DOA2_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(3), DOA_zd(3),
                              tpd_CKA_DOA3_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(4), DOA_zd(4),
                              tpd_CKA_DOA4_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(5), DOA_zd(5),
                              tpd_CKA_DOA5_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(6), DOA_zd(6),
                              tpd_CKA_DOA6_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(7), DOA_zd(7),
                              tpd_CKA_DOA7_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(8), DOA_zd(8),
                              tpd_CKA_DOA8_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(9), DOA_zd(9),
                              tpd_CKA_DOA9_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(10), DOA_zd(10),
                              tpd_CKA_DOA10_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(11), DOA_zd(11),
                              tpd_CKA_DOA11_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(12), DOA_zd(12),
                              tpd_CKA_DOA12_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(13), DOA_zd(13),
                              tpd_CKA_DOA13_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(14), DOA_zd(14),
                              tpd_CKA_DOA14_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(15), DOA_zd(15),
                              tpd_CKA_DOA15_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(16), DOA_zd(16),
                              tpd_CKA_DOA16_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(17), DOA_zd(17),
                              tpd_CKA_DOA17_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(18), DOA_zd(18),
                              tpd_CKA_DOA18_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(19), DOA_zd(19),
                              tpd_CKA_DOA19_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(20), DOA_zd(20),
                              tpd_CKA_DOA20_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(21), DOA_zd(21),
                              tpd_CKA_DOA21_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(22), DOA_zd(22),
                              tpd_CKA_DOA22_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(23), DOA_zd(23),
                              tpd_CKA_DOA23_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(24), DOA_zd(24),
                              tpd_CKA_DOA24_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(25), DOA_zd(25),
                              tpd_CKA_DOA25_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(26), DOA_zd(26),
                              tpd_CKA_DOA26_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(27), DOA_zd(27),
                              tpd_CKA_DOA27_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(28), DOA_zd(28),
                              tpd_CKA_DOA28_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(29), DOA_zd(29),
                              tpd_CKA_DOA29_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(30), DOA_zd(30),
                              tpd_CKA_DOA30_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(31), DOA_zd(31),
                              tpd_CKA_DOA31_posedge,last_A,A_i,NO_SER_TOH);
                           end if;
                           -- Reduce error message --
                           flag_A := True_flg;
                       end if;
                       LastCycleAAddress := A_i;

                   when "01" =>
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           if (A_i = LastCycleBAddress) then
                              if ((Last_WEBN_i = '1') and ((NOW-Last_tc_ClkB_PosEdge) < Tr2w)) then
                                 -- read and write the same address
                                 assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                                 DOB_zd := (OTHERS => 'X');
                                 DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                 memoryCore(to_integer(A_i)) := DIA_i;
                              elsif ((Last_WEBN_i = '0') and ((NOW-Last_tc_ClkB_PosEdge) < Tw2r)) then
                                 assert FALSE report "** MEM_Error: Port A and B write the same Address, core is unknown." severity WARNING;
                                 memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                              else
                                 memoryCore(to_integer(A_i)) := DIA_i;
                              end if;
                           else
                              memoryCore(to_integer(A_i)) := DIA_i;
                           end if;
                           -- Reduce error message --
                           flag_A := True_flg;
                           -- write through --
                           DOA_zd := DIA_i;
                           ScheduleOutputDelay(DOA_int(0), DOA_zd(0),
                           tpd_CKA_DOA0_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(1), DOA_zd(1),
                           tpd_CKA_DOA1_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(2), DOA_zd(2),
                           tpd_CKA_DOA2_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(3), DOA_zd(3),
                           tpd_CKA_DOA3_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(4), DOA_zd(4),
                           tpd_CKA_DOA4_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(5), DOA_zd(5),
                           tpd_CKA_DOA5_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(6), DOA_zd(6),
                           tpd_CKA_DOA6_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(7), DOA_zd(7),
                           tpd_CKA_DOA7_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(8), DOA_zd(8),
                           tpd_CKA_DOA8_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(9), DOA_zd(9),
                           tpd_CKA_DOA9_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(10), DOA_zd(10),
                           tpd_CKA_DOA10_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(11), DOA_zd(11),
                           tpd_CKA_DOA11_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(12), DOA_zd(12),
                           tpd_CKA_DOA12_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(13), DOA_zd(13),
                           tpd_CKA_DOA13_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(14), DOA_zd(14),
                           tpd_CKA_DOA14_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(15), DOA_zd(15),
                           tpd_CKA_DOA15_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(16), DOA_zd(16),
                           tpd_CKA_DOA16_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(17), DOA_zd(17),
                           tpd_CKA_DOA17_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(18), DOA_zd(18),
                           tpd_CKA_DOA18_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(19), DOA_zd(19),
                           tpd_CKA_DOA19_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(20), DOA_zd(20),
                           tpd_CKA_DOA20_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(21), DOA_zd(21),
                           tpd_CKA_DOA21_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(22), DOA_zd(22),
                           tpd_CKA_DOA22_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(23), DOA_zd(23),
                           tpd_CKA_DOA23_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(24), DOA_zd(24),
                           tpd_CKA_DOA24_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(25), DOA_zd(25),
                           tpd_CKA_DOA25_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(26), DOA_zd(26),
                           tpd_CKA_DOA26_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(27), DOA_zd(27),
                           tpd_CKA_DOA27_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(28), DOA_zd(28),
                           tpd_CKA_DOA28_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(29), DOA_zd(29),
                           tpd_CKA_DOA29_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(30), DOA_zd(30),
                           tpd_CKA_DOA30_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(31), DOA_zd(31),
                           tpd_CKA_DOA31_posedge,last_A,A_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           -- write through --
                           DOA_zd := DIA_i;
                           ScheduleOutputDelay(DOA_int(0), DOA_zd(0),
                           tpd_CKA_DOA0_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(1), DOA_zd(1),
                           tpd_CKA_DOA1_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(2), DOA_zd(2),
                           tpd_CKA_DOA2_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(3), DOA_zd(3),
                           tpd_CKA_DOA3_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(4), DOA_zd(4),
                           tpd_CKA_DOA4_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(5), DOA_zd(5),
                           tpd_CKA_DOA5_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(6), DOA_zd(6),
                           tpd_CKA_DOA6_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(7), DOA_zd(7),
                           tpd_CKA_DOA7_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(8), DOA_zd(8),
                           tpd_CKA_DOA8_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(9), DOA_zd(9),
                           tpd_CKA_DOA9_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(10), DOA_zd(10),
                           tpd_CKA_DOA10_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(11), DOA_zd(11),
                           tpd_CKA_DOA11_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(12), DOA_zd(12),
                           tpd_CKA_DOA12_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(13), DOA_zd(13),
                           tpd_CKA_DOA13_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(14), DOA_zd(14),
                           tpd_CKA_DOA14_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(15), DOA_zd(15),
                           tpd_CKA_DOA15_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(16), DOA_zd(16),
                           tpd_CKA_DOA16_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(17), DOA_zd(17),
                           tpd_CKA_DOA17_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(18), DOA_zd(18),
                           tpd_CKA_DOA18_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(19), DOA_zd(19),
                           tpd_CKA_DOA19_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(20), DOA_zd(20),
                           tpd_CKA_DOA20_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(21), DOA_zd(21),
                           tpd_CKA_DOA21_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(22), DOA_zd(22),
                           tpd_CKA_DOA22_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(23), DOA_zd(23),
                           tpd_CKA_DOA23_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(24), DOA_zd(24),
                           tpd_CKA_DOA24_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(25), DOA_zd(25),
                           tpd_CKA_DOA25_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(26), DOA_zd(26),
                           tpd_CKA_DOA26_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(27), DOA_zd(27),
                           tpd_CKA_DOA27_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(28), DOA_zd(28),
                           tpd_CKA_DOA28_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(29), DOA_zd(29),
                           tpd_CKA_DOA29_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(30), DOA_zd(30),
                           tpd_CKA_DOA30_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(31), DOA_zd(31),
                           tpd_CKA_DOA31_posedge,last_A,A_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DOA_zd := (OTHERS => 'X');
                           DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                       LastCycleAAddress := A_i;
                   when "1X" |
                        "1U" |
                        "1Z"   =>
                       DOA_zd := (OTHERS => 'X');
                       DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;

                   when "10" |
                        "00" |
                        "X0" |
                        "U0" |
                        "Z0"   => -- do nothing
                   when others =>
                       DOA_zd := (OTHERS => 'X');
                       DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                       else
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                end case;
                Last_WEAN_i := WEAN_i;
                -- end memory_functionA

                last_A := A_ipd;

                if (CSA_i = '1') then
                   Last_tc_ClkA_PosEdge := NOW;
                end if;
            when "10"   => -- do nothing
            when others => if (NOW /= 0 ns and CSA_ipd /= '0') then
                              assert FALSE report "** MEM_Error: Abnormal transition occurred." severity WARNING;
                              if (WEAN_ipd /= '1') then
                                 DOA_zd := (OTHERS => 'X');
                                 DOA_int <= TRANSPORT (OTHERS => 'X');
                                 FOR i IN Words-1 downto 0 LOOP
                                   memoryCore(i) := (OTHERS => 'X');
                                 END LOOP;
			      else
                                 DOA_int <= TRANSPORT (OTHERS => 'X');			      	
			      end if;	
                           end if;
         end case;
         LastClkAEdge := CKA_ipd;
       end if;

       if (CKB_ipd'event) then
         ckb_change := LastClkBEdge&CKB_ipd;
         case ckb_change is
            when "01"   =>
                if (CS_monitor(CSB_ipd,flag_CSB) = True_flg) then
                   -- Reduce error message --
                   flag_CSB := True_flg;
                else
                   flag_CSB := False_flg;
                end if;

                Latch_B      := B_ipd;
                Latch_CSB    := CSB_ipd;
                Latch_DIB   := DIB_ipd;
                Latch_WEBN  := WEBN_ipd;

                -- memory_functionB
                B_i    := Latch_B;
                CSB_i  := Latch_CSB;
                DIB_i  := Latch_DIB;
                WEBN_i := Latch_WEBN;

                web_csb    := WEBN_i&CSB_i;
                case web_csb is
                   when "11" =>
                       if (AddressRangeCheck(B_i,flag_B) = True_flg) then
                           if ((B_i = LastCycleAAddress) and
                               (Last_WEAN_i = '0') and
                               ((NOW-Last_tc_ClkA_PosEdge) < Tw2r)) then
                                 -- read and write the same address
                              assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                              DOB_zd := (OTHERS => 'X');
                              DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           else
                              DOB_zd := memoryCore(to_integer(B_i));
                              ScheduleOutputDelay(DOB_int(0), DOB_zd(0),
                              tpd_CKB_DOB0_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(1), DOB_zd(1),
                              tpd_CKB_DOB1_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(2), DOB_zd(2),
                              tpd_CKB_DOB2_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(3), DOB_zd(3),
                              tpd_CKB_DOB3_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(4), DOB_zd(4),
                              tpd_CKB_DOB4_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(5), DOB_zd(5),
                              tpd_CKB_DOB5_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(6), DOB_zd(6),
                              tpd_CKB_DOB6_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(7), DOB_zd(7),
                              tpd_CKB_DOB7_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(8), DOB_zd(8),
                              tpd_CKB_DOB8_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(9), DOB_zd(9),
                              tpd_CKB_DOB9_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(10), DOB_zd(10),
                              tpd_CKB_DOB10_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(11), DOB_zd(11),
                              tpd_CKB_DOB11_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(12), DOB_zd(12),
                              tpd_CKB_DOB12_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(13), DOB_zd(13),
                              tpd_CKB_DOB13_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(14), DOB_zd(14),
                              tpd_CKB_DOB14_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(15), DOB_zd(15),
                              tpd_CKB_DOB15_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(16), DOB_zd(16),
                              tpd_CKB_DOB16_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(17), DOB_zd(17),
                              tpd_CKB_DOB17_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(18), DOB_zd(18),
                              tpd_CKB_DOB18_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(19), DOB_zd(19),
                              tpd_CKB_DOB19_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(20), DOB_zd(20),
                              tpd_CKB_DOB20_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(21), DOB_zd(21),
                              tpd_CKB_DOB21_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(22), DOB_zd(22),
                              tpd_CKB_DOB22_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(23), DOB_zd(23),
                              tpd_CKB_DOB23_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(24), DOB_zd(24),
                              tpd_CKB_DOB24_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(25), DOB_zd(25),
                              tpd_CKB_DOB25_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(26), DOB_zd(26),
                              tpd_CKB_DOB26_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(27), DOB_zd(27),
                              tpd_CKB_DOB27_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(28), DOB_zd(28),
                              tpd_CKB_DOB28_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(29), DOB_zd(29),
                              tpd_CKB_DOB29_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(30), DOB_zd(30),
                              tpd_CKB_DOB30_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(31), DOB_zd(31),
                              tpd_CKB_DOB31_posedge,last_B,B_i,NO_SER_TOH);
                           end if;
                           -- Reduce error message --
                           flag_B := True_flg;
                       end if;
                       LastCycleBAddress := B_i;

                   when "01" =>
                       if (AddressRangeCheck(B_i,flag_B) = True_flg) then
                           if (B_i = LastCycleAAddress) then
                              if ((Last_WEAN_i = '1') and ((NOW-Last_tc_ClkA_PosEdge) < Tr2w)) then
                                 -- read and write the same address
                                 assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                                 DOA_zd := (OTHERS => 'X');
                                 DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                 memoryCore(to_integer(B_i)) := DIB_i;
                              elsif ((Last_WEAN_i = '0') and ((NOW-Last_tc_ClkA_PosEdge) < Tw2r)) then
                                 assert FALSE report "** MEM_Error: Port A and B write the same Address, core is unknown." severity WARNING;
                                 memoryCore(to_integer(B_i)) := (OTHERS => 'X');
                              else
                                 memoryCore(to_integer(B_i)) := DIB_i;
                              end if;
                           else
                              memoryCore(to_integer(B_i)) := DIB_i;
                           end if;
                           -- Reduce error message --
                           flag_B := True_flg;
                           -- write through --
                           DOB_zd := DIB_i;
                              ScheduleOutputDelay(DOB_int(0), DOB_zd(0),
                              tpd_CKB_DOB0_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(1), DOB_zd(1),
                              tpd_CKB_DOB1_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(2), DOB_zd(2),
                              tpd_CKB_DOB2_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(3), DOB_zd(3),
                              tpd_CKB_DOB3_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(4), DOB_zd(4),
                              tpd_CKB_DOB4_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(5), DOB_zd(5),
                              tpd_CKB_DOB5_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(6), DOB_zd(6),
                              tpd_CKB_DOB6_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(7), DOB_zd(7),
                              tpd_CKB_DOB7_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(8), DOB_zd(8),
                              tpd_CKB_DOB8_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(9), DOB_zd(9),
                              tpd_CKB_DOB9_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(10), DOB_zd(10),
                              tpd_CKB_DOB10_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(11), DOB_zd(11),
                              tpd_CKB_DOB11_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(12), DOB_zd(12),
                              tpd_CKB_DOB12_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(13), DOB_zd(13),
                              tpd_CKB_DOB13_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(14), DOB_zd(14),
                              tpd_CKB_DOB14_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(15), DOB_zd(15),
                              tpd_CKB_DOB15_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(16), DOB_zd(16),
                              tpd_CKB_DOB16_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(17), DOB_zd(17),
                              tpd_CKB_DOB17_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(18), DOB_zd(18),
                              tpd_CKB_DOB18_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(19), DOB_zd(19),
                              tpd_CKB_DOB19_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(20), DOB_zd(20),
                              tpd_CKB_DOB20_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(21), DOB_zd(21),
                              tpd_CKB_DOB21_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(22), DOB_zd(22),
                              tpd_CKB_DOB22_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(23), DOB_zd(23),
                              tpd_CKB_DOB23_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(24), DOB_zd(24),
                              tpd_CKB_DOB24_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(25), DOB_zd(25),
                              tpd_CKB_DOB25_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(26), DOB_zd(26),
                              tpd_CKB_DOB26_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(27), DOB_zd(27),
                              tpd_CKB_DOB27_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(28), DOB_zd(28),
                              tpd_CKB_DOB28_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(29), DOB_zd(29),
                              tpd_CKB_DOB29_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(30), DOB_zd(30),
                              tpd_CKB_DOB30_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(31), DOB_zd(31),
                              tpd_CKB_DOB31_posedge,last_B,B_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(B_i,flag_B) = Range_flg) then
                           -- Reduce error message --
                           flag_B := False_flg;
                           --------------------------
                           -- write through --
                           DOB_zd := DIB_i;
                              ScheduleOutputDelay(DOB_int(0), DOB_zd(0),
                              tpd_CKB_DOB0_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(1), DOB_zd(1),
                              tpd_CKB_DOB1_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(2), DOB_zd(2),
                              tpd_CKB_DOB2_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(3), DOB_zd(3),
                              tpd_CKB_DOB3_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(4), DOB_zd(4),
                              tpd_CKB_DOB4_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(5), DOB_zd(5),
                              tpd_CKB_DOB5_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(6), DOB_zd(6),
                              tpd_CKB_DOB6_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(7), DOB_zd(7),
                              tpd_CKB_DOB7_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(8), DOB_zd(8),
                              tpd_CKB_DOB8_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(9), DOB_zd(9),
                              tpd_CKB_DOB9_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(10), DOB_zd(10),
                              tpd_CKB_DOB10_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(11), DOB_zd(11),
                              tpd_CKB_DOB11_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(12), DOB_zd(12),
                              tpd_CKB_DOB12_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(13), DOB_zd(13),
                              tpd_CKB_DOB13_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(14), DOB_zd(14),
                              tpd_CKB_DOB14_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(15), DOB_zd(15),
                              tpd_CKB_DOB15_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(16), DOB_zd(16),
                              tpd_CKB_DOB16_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(17), DOB_zd(17),
                              tpd_CKB_DOB17_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(18), DOB_zd(18),
                              tpd_CKB_DOB18_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(19), DOB_zd(19),
                              tpd_CKB_DOB19_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(20), DOB_zd(20),
                              tpd_CKB_DOB20_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(21), DOB_zd(21),
                              tpd_CKB_DOB21_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(22), DOB_zd(22),
                              tpd_CKB_DOB22_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(23), DOB_zd(23),
                              tpd_CKB_DOB23_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(24), DOB_zd(24),
                              tpd_CKB_DOB24_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(25), DOB_zd(25),
                              tpd_CKB_DOB25_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(26), DOB_zd(26),
                              tpd_CKB_DOB26_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(27), DOB_zd(27),
                              tpd_CKB_DOB27_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(28), DOB_zd(28),
                              tpd_CKB_DOB28_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(29), DOB_zd(29),
                              tpd_CKB_DOB29_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(30), DOB_zd(30),
                              tpd_CKB_DOB30_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(31), DOB_zd(31),
                              tpd_CKB_DOB31_posedge,last_B,B_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_B := False_flg;
                           --------------------------
                           DOB_zd := (OTHERS => 'X');
                           DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                       LastCycleBAddress := B_i;
                   when "1X" |
                        "1U" |
                        "1Z"   =>
                       DOB_zd := (OTHERS => 'X');
                       DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;

                   when "10" |
                        "00" |
                        "X0" |
                        "U0" |
                        "Z0"   => -- do nothing
                   when others =>
                       DOB_zd := (OTHERS => 'X');
                       DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       if (AddressRangeCheck(B_i,flag_B) = True_flg) then
                           memoryCore(to_integer(B_i)) := (OTHERS => 'X');
                       elsif (AddressRangeCheck(B_i,flag_B) = Range_flg) then
                           -- Reduce error message --
                           flag_B := False_flg;
                           --------------------------
                       else
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                end case;
                Last_WEBN_i := WEBN_i;
                -- end memory_functionB

                last_B := B_ipd;

                if (CSB_i = '1') then
                   Last_tc_ClkB_PosEdge := NOW;
                end if;
            when "10"   => -- do nothing
            when others => if (NOW /= 0 ns and CSB_ipd /= '0') then
                              assert FALSE report "** MEM_Error: Abnormal transition occurred." severity WARNING;
                              if (WEBN_ipd /= '1') then
                                 DOB_zd := (OTHERS => 'X');
                                 DOB_int <= TRANSPORT (OTHERS => 'X');
                                 FOR i IN Words-1 downto 0 LOOP
                                   memoryCore(i) := (OTHERS => 'X');
                                 END LOOP;
			      else
                                 DOB_int <= TRANSPORT (OTHERS => 'X');			      	
			      end if;
                           end if; 
         end case;
         LastClkBEdge := CKB_ipd;
       end if;

       -- timingcheck_violationA
       if (Tviol_A_CKA_posedge      = 'X' or
           Tviol_WEAN_CKA_posedge  = 'X' or
           Tviol_DIA_CKA_posedge   = 'X' or
           Tviol_CSA_CKA_posedge    = 'X' or
           Pviol_CKA                = 'X'
          ) then

         if (Pviol_CKA = 'X') then
            if (CSA_ipd /= '0') then
               if (WEAN_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore(i) := (OTHERS => 'X');
                  END LOOP;
               else
                  DOA_zd := (OTHERS => 'X');
                  DOA_int <= TRANSPORT (OTHERS => 'X');
               end if;
            end if;
         else
            FOR i IN AddressSize-1 downto 0 LOOP
              if (Tviol_A_CKA_posedge = 'X') then
                 Latch_A(i) := 'X';
              else
                 Latch_A(i) := Latch_A(i);
              end if;
            END LOOP;

            FOR i IN Bits-1 downto 0 LOOP
              if (Tviol_DIA_CKA_posedge = 'X') then
                 Latch_DIA(i) := 'X';
              else
                 Latch_DIA(i) := Latch_DIA(i);
              end if;
            END LOOP;

            if (Tviol_CSA_CKA_posedge = 'X') then
               Latch_CSA := 'X';
            else
               Latch_CSA := Latch_CSA;
            end if;
            if (Tviol_WEAN_CKA_posedge = 'X') then
               Latch_WEAN := 'X';
            else
               Latch_WEAN := Latch_WEAN;
            end if;
                -- memory_functionA
                A_i    := Latch_A;
                CSA_i  := Latch_CSA;
                DIA_i  := Latch_DIA;
                WEAN_i := Latch_WEAN;

                wea_csa    := WEAN_i&CSA_i;
                case wea_csa is
                   when "11" =>
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           if ((A_i = LastCycleBAddress) and
                               (Last_WEBN_i = '0') and
                               ((NOW-Last_tc_ClkB_PosEdge) < Tw2r)) then
                                 -- read and write the same address
                              assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                              DOA_zd := (OTHERS => 'X');
                              DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           else
                              DOA_zd := memoryCore(to_integer(A_i));
                              ScheduleOutputDelay(DOA_int(0), DOA_zd(0),
                              tpd_CKA_DOA0_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(1), DOA_zd(1),
                              tpd_CKA_DOA1_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(2), DOA_zd(2),
                              tpd_CKA_DOA2_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(3), DOA_zd(3),
                              tpd_CKA_DOA3_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(4), DOA_zd(4),
                              tpd_CKA_DOA4_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(5), DOA_zd(5),
                              tpd_CKA_DOA5_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(6), DOA_zd(6),
                              tpd_CKA_DOA6_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(7), DOA_zd(7),
                              tpd_CKA_DOA7_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(8), DOA_zd(8),
                              tpd_CKA_DOA8_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(9), DOA_zd(9),
                              tpd_CKA_DOA9_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(10), DOA_zd(10),
                              tpd_CKA_DOA10_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(11), DOA_zd(11),
                              tpd_CKA_DOA11_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(12), DOA_zd(12),
                              tpd_CKA_DOA12_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(13), DOA_zd(13),
                              tpd_CKA_DOA13_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(14), DOA_zd(14),
                              tpd_CKA_DOA14_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(15), DOA_zd(15),
                              tpd_CKA_DOA15_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(16), DOA_zd(16),
                              tpd_CKA_DOA16_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(17), DOA_zd(17),
                              tpd_CKA_DOA17_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(18), DOA_zd(18),
                              tpd_CKA_DOA18_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(19), DOA_zd(19),
                              tpd_CKA_DOA19_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(20), DOA_zd(20),
                              tpd_CKA_DOA20_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(21), DOA_zd(21),
                              tpd_CKA_DOA21_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(22), DOA_zd(22),
                              tpd_CKA_DOA22_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(23), DOA_zd(23),
                              tpd_CKA_DOA23_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(24), DOA_zd(24),
                              tpd_CKA_DOA24_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(25), DOA_zd(25),
                              tpd_CKA_DOA25_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(26), DOA_zd(26),
                              tpd_CKA_DOA26_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(27), DOA_zd(27),
                              tpd_CKA_DOA27_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(28), DOA_zd(28),
                              tpd_CKA_DOA28_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(29), DOA_zd(29),
                              tpd_CKA_DOA29_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(30), DOA_zd(30),
                              tpd_CKA_DOA30_posedge,last_A,A_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOA_int(31), DOA_zd(31),
                              tpd_CKA_DOA31_posedge,last_A,A_i,NO_SER_TOH);
                           end if;
                           -- Reduce error message --
                           flag_A := True_flg;
                       end if;
                       LastCycleAAddress := A_i;

                   when "01" =>
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           if (A_i = LastCycleBAddress) then
                              if ((Last_WEBN_i = '1') and ((NOW-Last_tc_ClkB_PosEdge) < Tr2w)) then
                                 -- read and write the same address
                                 assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                                 DOB_zd := (OTHERS => 'X');
                                 DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                 memoryCore(to_integer(A_i)) := DIA_i;
                              elsif ((Last_WEBN_i = '0') and ((NOW-Last_tc_ClkB_PosEdge) < Tw2r)) then
                                 assert FALSE report "** MEM_Error: Port A and B write the same Address, core is unknown." severity WARNING;
                                 memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                              else
                                 memoryCore(to_integer(A_i)) := DIA_i;
                              end if;
                           else
                              memoryCore(to_integer(A_i)) := DIA_i;
                           end if;
                           -- Reduce error message --
                           flag_A := True_flg;
                           -- write through --
                           DOA_zd := DIA_i;
                           ScheduleOutputDelay(DOA_int(0), DOA_zd(0),
                           tpd_CKA_DOA0_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(1), DOA_zd(1),
                           tpd_CKA_DOA1_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(2), DOA_zd(2),
                           tpd_CKA_DOA2_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(3), DOA_zd(3),
                           tpd_CKA_DOA3_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(4), DOA_zd(4),
                           tpd_CKA_DOA4_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(5), DOA_zd(5),
                           tpd_CKA_DOA5_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(6), DOA_zd(6),
                           tpd_CKA_DOA6_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(7), DOA_zd(7),
                           tpd_CKA_DOA7_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(8), DOA_zd(8),
                           tpd_CKA_DOA8_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(9), DOA_zd(9),
                           tpd_CKA_DOA9_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(10), DOA_zd(10),
                           tpd_CKA_DOA10_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(11), DOA_zd(11),
                           tpd_CKA_DOA11_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(12), DOA_zd(12),
                           tpd_CKA_DOA12_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(13), DOA_zd(13),
                           tpd_CKA_DOA13_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(14), DOA_zd(14),
                           tpd_CKA_DOA14_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(15), DOA_zd(15),
                           tpd_CKA_DOA15_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(16), DOA_zd(16),
                           tpd_CKA_DOA16_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(17), DOA_zd(17),
                           tpd_CKA_DOA17_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(18), DOA_zd(18),
                           tpd_CKA_DOA18_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(19), DOA_zd(19),
                           tpd_CKA_DOA19_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(20), DOA_zd(20),
                           tpd_CKA_DOA20_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(21), DOA_zd(21),
                           tpd_CKA_DOA21_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(22), DOA_zd(22),
                           tpd_CKA_DOA22_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(23), DOA_zd(23),
                           tpd_CKA_DOA23_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(24), DOA_zd(24),
                           tpd_CKA_DOA24_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(25), DOA_zd(25),
                           tpd_CKA_DOA25_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(26), DOA_zd(26),
                           tpd_CKA_DOA26_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(27), DOA_zd(27),
                           tpd_CKA_DOA27_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(28), DOA_zd(28),
                           tpd_CKA_DOA28_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(29), DOA_zd(29),
                           tpd_CKA_DOA29_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(30), DOA_zd(30),
                           tpd_CKA_DOA30_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(31), DOA_zd(31),
                           tpd_CKA_DOA31_posedge,last_A,A_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           -- write through --
                           DOA_zd := DIA_i;
                           ScheduleOutputDelay(DOA_int(0), DOA_zd(0),
                           tpd_CKA_DOA0_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(1), DOA_zd(1),
                           tpd_CKA_DOA1_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(2), DOA_zd(2),
                           tpd_CKA_DOA2_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(3), DOA_zd(3),
                           tpd_CKA_DOA3_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(4), DOA_zd(4),
                           tpd_CKA_DOA4_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(5), DOA_zd(5),
                           tpd_CKA_DOA5_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(6), DOA_zd(6),
                           tpd_CKA_DOA6_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(7), DOA_zd(7),
                           tpd_CKA_DOA7_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(8), DOA_zd(8),
                           tpd_CKA_DOA8_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(9), DOA_zd(9),
                           tpd_CKA_DOA9_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(10), DOA_zd(10),
                           tpd_CKA_DOA10_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(11), DOA_zd(11),
                           tpd_CKA_DOA11_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(12), DOA_zd(12),
                           tpd_CKA_DOA12_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(13), DOA_zd(13),
                           tpd_CKA_DOA13_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(14), DOA_zd(14),
                           tpd_CKA_DOA14_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(15), DOA_zd(15),
                           tpd_CKA_DOA15_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(16), DOA_zd(16),
                           tpd_CKA_DOA16_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(17), DOA_zd(17),
                           tpd_CKA_DOA17_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(18), DOA_zd(18),
                           tpd_CKA_DOA18_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(19), DOA_zd(19),
                           tpd_CKA_DOA19_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(20), DOA_zd(20),
                           tpd_CKA_DOA20_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(21), DOA_zd(21),
                           tpd_CKA_DOA21_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(22), DOA_zd(22),
                           tpd_CKA_DOA22_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(23), DOA_zd(23),
                           tpd_CKA_DOA23_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(24), DOA_zd(24),
                           tpd_CKA_DOA24_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(25), DOA_zd(25),
                           tpd_CKA_DOA25_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(26), DOA_zd(26),
                           tpd_CKA_DOA26_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(27), DOA_zd(27),
                           tpd_CKA_DOA27_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(28), DOA_zd(28),
                           tpd_CKA_DOA28_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(29), DOA_zd(29),
                           tpd_CKA_DOA29_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(30), DOA_zd(30),
                           tpd_CKA_DOA30_posedge,last_A,A_i,NO_SER_TOH);
                           ScheduleOutputDelay(DOA_int(31), DOA_zd(31),
                           tpd_CKA_DOA31_posedge,last_A,A_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                           DOA_zd := (OTHERS => 'X');
                           DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                       LastCycleAAddress := A_i;
                   when "1X" |
                        "1U" |
                        "1Z"   =>
                       DOA_zd := (OTHERS => 'X');
                       DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;

                   when "10" |
                        "00" |
                        "X0" |
                        "U0" |
                        "Z0"   => -- do nothing
                   when others =>
                       DOA_zd := (OTHERS => 'X');
                       DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       if (AddressRangeCheck(A_i,flag_A) = True_flg) then
                           memoryCore(to_integer(A_i)) := (OTHERS => 'X');
                       elsif (AddressRangeCheck(A_i,flag_A) = Range_flg) then
                           -- Reduce error message --
                           flag_A := False_flg;
                           --------------------------
                       else
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                end case;
                Last_WEAN_i := WEAN_i;
                -- end memory_functionA
         end if;
       end if;
       -- end timingcheck_violationA

       -- timingcheck_violationB
       if (Tviol_B_CKB_posedge      = 'X' or
           Tviol_WEBN_CKB_posedge  = 'X' or
           Tviol_DIB_CKB_posedge   = 'X' or
           Tviol_CSB_CKB_posedge    = 'X' or
           Pviol_CKB                = 'X'
          ) then

         if (Pviol_CKB = 'X') then
            if (CSB_ipd /= '0') then
               if (WEBN_ipd /= '1') then
                  FOR i IN Words-1 downto 0 LOOP
                     memoryCore(i) := (OTHERS => 'X');
                  END LOOP;
               else
                  DOB_zd := (OTHERS => 'X');
                  DOB_int <= TRANSPORT (OTHERS => 'X');
               end if;
            end if;
         else
            FOR i IN AddressSize-1 downto 0 LOOP
              if (Tviol_B_CKB_posedge = 'X') then
                 Latch_B(i) := 'X';
              else
                 Latch_B(i) := Latch_B(i);
              end if;
            END LOOP;

            FOR i IN Bits-1 downto 0 LOOP
              if (Tviol_DIB_CKB_posedge = 'X') then
                 Latch_DIB(i) := 'X';
              else
                 Latch_DIB(i) := Latch_DIB(i);
              end if;
            END LOOP;

            if (Tviol_CSB_CKB_posedge = 'X') then
               Latch_CSB := 'X';
            else
               Latch_CSB := Latch_CSB;
            end if;
            if (Tviol_WEBN_CKB_posedge = 'X') then
               Latch_WEBN := 'X';
            else
               Latch_WEBN := Latch_WEBN;
            end if;
                -- memory_functionB
                B_i    := Latch_B;
                CSB_i  := Latch_CSB;
                DIB_i  := Latch_DIB;
                WEBN_i := Latch_WEBN;

                web_csb    := WEBN_i&CSB_i;
                case web_csb is
                   when "11" =>
                       if (AddressRangeCheck(B_i,flag_B) = True_flg) then
                           if ((B_i = LastCycleAAddress) and
                               (Last_WEAN_i = '0') and
                               ((NOW-Last_tc_ClkA_PosEdge) < Tw2r)) then
                                 -- read and write the same address
                              assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                              DOB_zd := (OTHERS => 'X');
                              DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           else
                              DOB_zd := memoryCore(to_integer(B_i));
                              ScheduleOutputDelay(DOB_int(0), DOB_zd(0),
                              tpd_CKB_DOB0_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(1), DOB_zd(1),
                              tpd_CKB_DOB1_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(2), DOB_zd(2),
                              tpd_CKB_DOB2_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(3), DOB_zd(3),
                              tpd_CKB_DOB3_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(4), DOB_zd(4),
                              tpd_CKB_DOB4_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(5), DOB_zd(5),
                              tpd_CKB_DOB5_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(6), DOB_zd(6),
                              tpd_CKB_DOB6_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(7), DOB_zd(7),
                              tpd_CKB_DOB7_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(8), DOB_zd(8),
                              tpd_CKB_DOB8_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(9), DOB_zd(9),
                              tpd_CKB_DOB9_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(10), DOB_zd(10),
                              tpd_CKB_DOB10_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(11), DOB_zd(11),
                              tpd_CKB_DOB11_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(12), DOB_zd(12),
                              tpd_CKB_DOB12_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(13), DOB_zd(13),
                              tpd_CKB_DOB13_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(14), DOB_zd(14),
                              tpd_CKB_DOB14_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(15), DOB_zd(15),
                              tpd_CKB_DOB15_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(16), DOB_zd(16),
                              tpd_CKB_DOB16_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(17), DOB_zd(17),
                              tpd_CKB_DOB17_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(18), DOB_zd(18),
                              tpd_CKB_DOB18_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(19), DOB_zd(19),
                              tpd_CKB_DOB19_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(20), DOB_zd(20),
                              tpd_CKB_DOB20_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(21), DOB_zd(21),
                              tpd_CKB_DOB21_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(22), DOB_zd(22),
                              tpd_CKB_DOB22_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(23), DOB_zd(23),
                              tpd_CKB_DOB23_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(24), DOB_zd(24),
                              tpd_CKB_DOB24_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(25), DOB_zd(25),
                              tpd_CKB_DOB25_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(26), DOB_zd(26),
                              tpd_CKB_DOB26_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(27), DOB_zd(27),
                              tpd_CKB_DOB27_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(28), DOB_zd(28),
                              tpd_CKB_DOB28_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(29), DOB_zd(29),
                              tpd_CKB_DOB29_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(30), DOB_zd(30),
                              tpd_CKB_DOB30_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(31), DOB_zd(31),
                              tpd_CKB_DOB31_posedge,last_B,B_i,NO_SER_TOH);
                           end if;
                           -- Reduce error message --
                           flag_B := True_flg;
                       end if;
                       LastCycleBAddress := B_i;

                   when "01" =>
                       if (AddressRangeCheck(B_i,flag_B) = True_flg) then
                           if (B_i = LastCycleAAddress) then
                              if ((Last_WEAN_i = '1') and ((NOW-Last_tc_ClkA_PosEdge) < Tr2w)) then
                                 -- read and write the same address
                                 assert FALSE report "** MEM_Warning: Read and Write the same address." severity WARNING;
                                 DOA_zd := (OTHERS => 'X');
                                 DOA_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                                 memoryCore(to_integer(B_i)) := DIB_i;
                              elsif ((Last_WEAN_i = '0') and ((NOW-Last_tc_ClkA_PosEdge) < Tw2r)) then
                                 assert FALSE report "** MEM_Error: Port A and B write the same Address, core is unknown." severity WARNING;
                                 memoryCore(to_integer(B_i)) := (OTHERS => 'X');
                              else
                                 memoryCore(to_integer(B_i)) := DIB_i;
                              end if;
                           else
                              memoryCore(to_integer(B_i)) := DIB_i;
                           end if;
                           -- Reduce error message --
                           flag_B := True_flg;
                           -- write through --
                           DOB_zd := DIB_i;
                              ScheduleOutputDelay(DOB_int(0), DOB_zd(0),
                              tpd_CKB_DOB0_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(1), DOB_zd(1),
                              tpd_CKB_DOB1_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(2), DOB_zd(2),
                              tpd_CKB_DOB2_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(3), DOB_zd(3),
                              tpd_CKB_DOB3_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(4), DOB_zd(4),
                              tpd_CKB_DOB4_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(5), DOB_zd(5),
                              tpd_CKB_DOB5_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(6), DOB_zd(6),
                              tpd_CKB_DOB6_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(7), DOB_zd(7),
                              tpd_CKB_DOB7_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(8), DOB_zd(8),
                              tpd_CKB_DOB8_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(9), DOB_zd(9),
                              tpd_CKB_DOB9_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(10), DOB_zd(10),
                              tpd_CKB_DOB10_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(11), DOB_zd(11),
                              tpd_CKB_DOB11_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(12), DOB_zd(12),
                              tpd_CKB_DOB12_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(13), DOB_zd(13),
                              tpd_CKB_DOB13_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(14), DOB_zd(14),
                              tpd_CKB_DOB14_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(15), DOB_zd(15),
                              tpd_CKB_DOB15_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(16), DOB_zd(16),
                              tpd_CKB_DOB16_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(17), DOB_zd(17),
                              tpd_CKB_DOB17_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(18), DOB_zd(18),
                              tpd_CKB_DOB18_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(19), DOB_zd(19),
                              tpd_CKB_DOB19_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(20), DOB_zd(20),
                              tpd_CKB_DOB20_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(21), DOB_zd(21),
                              tpd_CKB_DOB21_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(22), DOB_zd(22),
                              tpd_CKB_DOB22_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(23), DOB_zd(23),
                              tpd_CKB_DOB23_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(24), DOB_zd(24),
                              tpd_CKB_DOB24_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(25), DOB_zd(25),
                              tpd_CKB_DOB25_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(26), DOB_zd(26),
                              tpd_CKB_DOB26_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(27), DOB_zd(27),
                              tpd_CKB_DOB27_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(28), DOB_zd(28),
                              tpd_CKB_DOB28_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(29), DOB_zd(29),
                              tpd_CKB_DOB29_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(30), DOB_zd(30),
                              tpd_CKB_DOB30_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(31), DOB_zd(31),
                              tpd_CKB_DOB31_posedge,last_B,B_i,NO_SER_TOH);
                       elsif (AddressRangeCheck(B_i,flag_B) = Range_flg) then
                           -- Reduce error message --
                           flag_B := False_flg;
                           --------------------------
                           -- write through --
                           DOB_zd := DIB_i;
                              ScheduleOutputDelay(DOB_int(0), DOB_zd(0),
                              tpd_CKB_DOB0_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(1), DOB_zd(1),
                              tpd_CKB_DOB1_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(2), DOB_zd(2),
                              tpd_CKB_DOB2_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(3), DOB_zd(3),
                              tpd_CKB_DOB3_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(4), DOB_zd(4),
                              tpd_CKB_DOB4_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(5), DOB_zd(5),
                              tpd_CKB_DOB5_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(6), DOB_zd(6),
                              tpd_CKB_DOB6_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(7), DOB_zd(7),
                              tpd_CKB_DOB7_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(8), DOB_zd(8),
                              tpd_CKB_DOB8_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(9), DOB_zd(9),
                              tpd_CKB_DOB9_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(10), DOB_zd(10),
                              tpd_CKB_DOB10_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(11), DOB_zd(11),
                              tpd_CKB_DOB11_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(12), DOB_zd(12),
                              tpd_CKB_DOB12_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(13), DOB_zd(13),
                              tpd_CKB_DOB13_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(14), DOB_zd(14),
                              tpd_CKB_DOB14_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(15), DOB_zd(15),
                              tpd_CKB_DOB15_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(16), DOB_zd(16),
                              tpd_CKB_DOB16_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(17), DOB_zd(17),
                              tpd_CKB_DOB17_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(18), DOB_zd(18),
                              tpd_CKB_DOB18_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(19), DOB_zd(19),
                              tpd_CKB_DOB19_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(20), DOB_zd(20),
                              tpd_CKB_DOB20_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(21), DOB_zd(21),
                              tpd_CKB_DOB21_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(22), DOB_zd(22),
                              tpd_CKB_DOB22_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(23), DOB_zd(23),
                              tpd_CKB_DOB23_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(24), DOB_zd(24),
                              tpd_CKB_DOB24_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(25), DOB_zd(25),
                              tpd_CKB_DOB25_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(26), DOB_zd(26),
                              tpd_CKB_DOB26_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(27), DOB_zd(27),
                              tpd_CKB_DOB27_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(28), DOB_zd(28),
                              tpd_CKB_DOB28_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(29), DOB_zd(29),
                              tpd_CKB_DOB29_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(30), DOB_zd(30),
                              tpd_CKB_DOB30_posedge,last_B,B_i,NO_SER_TOH);
                              ScheduleOutputDelay(DOB_int(31), DOB_zd(31),
                              tpd_CKB_DOB31_posedge,last_B,B_i,NO_SER_TOH);
                       else
                           -- Reduce error message --
                           flag_B := False_flg;
                           --------------------------
                           DOB_zd := (OTHERS => 'X');
                           DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                       LastCycleBAddress := B_i;
                   when "1X" |
                        "1U" |
                        "1Z"   =>
                       DOB_zd := (OTHERS => 'X');
                       DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;

                   when "10" |
                        "00" |
                        "X0" |
                        "U0" |
                        "Z0"   => -- do nothing
                   when others =>
                       DOB_zd := (OTHERS => 'X');
                       DOB_int <= TRANSPORT (OTHERS => 'X') AFTER TOH;
                       if (AddressRangeCheck(B_i,flag_B) = True_flg) then
                           memoryCore(to_integer(B_i)) := (OTHERS => 'X');
                       elsif (AddressRangeCheck(B_i,flag_B) = Range_flg) then
                           -- Reduce error message --
                           flag_B := False_flg;
                           --------------------------
                       else
                           FOR i IN Words-1 downto 0 LOOP
                              memoryCore(i) := (OTHERS => 'X');
                           END LOOP;
                       end if;
                end case;
                Last_WEBN_i := WEBN_i;
                -- end memory_functionB
         end if;
       end if;
       -- end timingcheck_violationB

   end PROCESS;
end behavior;
