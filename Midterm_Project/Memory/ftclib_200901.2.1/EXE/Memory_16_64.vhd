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
--       Module Name       :  Memory_16_64  
--       Word              :  64            
--       Bit               :  16            
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
--       Date             : 2024/10/27 12:34:48
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
--       Date             : Sun Oct 27 12:34:49 CST 2024
--
-- |-----------------------------------------------------------------------|

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

-- entity declaration --
entity Memory_16_64 is
   generic(
      SYN_CS:          integer  := 1;
      NO_SER_TOH:      integer  := 1;
      AddressSize:     integer  := 6;
      Bits:            integer  := 16;
      Words:           integer  := 64;
      Bytes:           integer  := 1;
      AspectRatio:     integer  := 1;
      TOH:             time     := 1.137 ns;

      TimingChecksOn: Boolean := True;
      InstancePath: STRING := "*";
      Xon: Boolean := True;
      MsgOn: Boolean := True;

      tpd_CK_DO0_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO1_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO2_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO3_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO4_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO5_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO6_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO7_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO8_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO9_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO10_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO11_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO12_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO13_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO14_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);
      tpd_CK_DO15_posedge : VitalDelayType01 :=  (1.880 ns, 1.880 ns);

      tpd_OE_DO0    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO1    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO2    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO3    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO4    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO5    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO6    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO7    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO8    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO9    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO10    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO11    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO12    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO13    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO14    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tpd_OE_DO15    : VitalDelayType01Z := (0.395 ns, 0.395 ns, 0.518 ns, 0.395 ns, 0.518 ns, 0.395 ns);
      tsetup_A0_CK_posedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A0_CK_negedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A1_CK_posedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A1_CK_negedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A2_CK_posedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A2_CK_negedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A3_CK_posedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A3_CK_negedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A4_CK_posedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A4_CK_negedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A5_CK_posedge_posedge    :  VitalDelayType := 0.661 ns;
      tsetup_A5_CK_negedge_posedge    :  VitalDelayType := 0.661 ns;
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
      tsetup_DI0_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI0_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI1_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI1_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI2_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI2_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI3_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI3_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI4_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI4_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI5_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI5_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI6_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI6_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI7_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI7_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI8_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI8_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI9_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI9_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI10_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI10_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI11_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI11_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI12_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI12_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI13_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI13_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI14_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI14_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI15_CK_posedge_posedge    :  VitalDelayType := 0.575 ns;
      tsetup_DI15_CK_negedge_posedge    :  VitalDelayType := 0.575 ns;
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
      tsetup_WEB_CK_posedge_posedge   :  VitalDelayType := 0.409 ns;
      tsetup_WEB_CK_negedge_posedge   :  VitalDelayType := 0.409 ns;
      thold_WEB_CK_posedge_posedge    :  VitalDelayType := 0.100 ns;
      thold_WEB_CK_negedge_posedge    :  VitalDelayType := 0.100 ns;
      tsetup_CS_CK_posedge_posedge    :  VitalDelayType := 0.826 ns;
      tsetup_CS_CK_negedge_posedge    :  VitalDelayType := 0.826 ns;
      thold_CS_CK_posedge_posedge     :  VitalDelayType := 0.137 ns;
      thold_CS_CK_negedge_posedge     :  VitalDelayType := 0.137 ns;
      tperiod_CK                      :  VitalDelayType := 2.437 ns;
      tpw_CK_posedge                 :  VitalDelayType := 0.363 ns;
      tpw_CK_negedge                 :  VitalDelayType := 0.363 ns;
      tipd_A0                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A1                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A2                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A3                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A4                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_A5                     :  VitalDelayType01 := (0.000 ns, 0.000 ns);
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
      WEB                           :   IN   std_logic;
      CK                            :   IN   std_logic;
      CS                           :   IN   std_logic;
      OE                            :   IN   std_logic
      );

attribute VITAL_LEVEL0 of Memory_16_64 : entity is TRUE;

end Memory_16_64;

-- architecture body --
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.VITAL_Primitives.all;
use IEEE.VITAL_Timing.all;

architecture behavior of Memory_16_64 is
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
          HeaderMsg               => InstancePath & "/Memory_16_64",
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
          HeaderMsg               => InstancePath & "/Memory_16_64",
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
          HeaderMsg               => InstancePath & "/Memory_16_64",
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
          HeaderMsg               => InstancePath & "/Memory_16_64",
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
          HeaderMsg               => InstancePath & "/Memory_16_64",
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

