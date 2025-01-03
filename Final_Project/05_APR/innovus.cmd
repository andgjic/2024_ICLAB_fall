#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Fri Dec 13 11:03:47 2024                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.15-s105_1 (64bit) 07/27/2021 14:15 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.15-s105_1 NR210726-1341/20_15-UB (database version 18.20.554) {superthreading v2.14}
#@(#)CDS: AAE 20.15-s020 (64bit) 07/27/2021 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.15-s024_1 () Jul 23 2021 04:46:45 ( )
#@(#)CDS: SYNTECH 20.15-s012_1 () Jul 12 2021 23:29:38 ( )
#@(#)CDS: CPE v20.15-s071
#@(#)CDS: IQuantus/TQuantus 20.1.1-s460 (64bit) Fri Mar 5 18:46:16 PST 2021 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getVersion
win
create_rc_corner -name RC_Corner -cap_table {RC/u18_Faraday.CapTbl} -preRoute_res {1.0} -preRoute_cap {1.0} -preRoute_clkres {0.0} -preRoute_clkcap {0.0} -postRoute_res {1.0} -postRoute_cap {1.0} -postRoute_xcap {1.0} -postRoute_clkres {0.0} -postRoute_clkcap {0.0} -qx_tech_file {RC/icecaps.tch}
create_library_set -name lib_max -timing {LIB/fsa0m_a_generic_core_ss1p62v125c.lib LIB/fsa0m_a_t33_generic_io_ss1p62v125c.lib LIB/SUMA180_1024X8X1BM2_WC.lib} -si {CeltIC/u18_ss.cdb}
create_library_set -name lib_min -timing {LIB/fsa0m_a_generic_core_ff1p98vm40c.lib LIB/fsa0m_a_t33_generic_io_ff1p98vm40c.lib LIB/SUMA180_1024X8X1BM2_BC.lib} -si {CeltIC/u18_ff.cdb}
create_constraint_mode -name func_mode -sdc_files {CHIP.sdc}
