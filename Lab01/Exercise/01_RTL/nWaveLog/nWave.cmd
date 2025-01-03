wvOpenFile -win $_nWave1 -mul \
           {/RAID2/COURSE/iclab/iclab131/Lab01/Exercise/01_RTL/SSC.fsdb} {/RAID2/COURSE/iclab/iclab131/Lab01/Exercise/01_RTL/signal.rc} 
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSelectGroup -win $_nWave1 {G3}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvExpandBus -win $_nWave1 {("G2" 3)}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvCollapseBus -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvCut -win $_nWave1
wvSetPosition -win $_nWave1 {("G3" 0)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvGetSignalOpen -win $_nWave1
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/card_num\[63:0\]} \
{/TESTBED/input_money\[8:0\]} \
{/TESTBED/out_change\[8:0\]} \
{/TESTBED/out_valid} \
{/TESTBED/price\[31:0\]} \
{/TESTBED/snack_num\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/DUT_SSC/total\[7:0\]} \
{/TESTBED/DUT_SSC/total_sort\[7:0\]} \
{/TESTBED/DUT_SSC/buy\[7:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/card_num\[63:0\]} \
{/TESTBED/input_money\[8:0\]} \
{/TESTBED/out_change\[8:0\]} \
{/TESTBED/out_valid} \
{/TESTBED/price\[31:0\]} \
{/TESTBED/snack_num\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/DUT_SSC/total\[7:0\]} \
{/TESTBED/DUT_SSC/total_sort\[7:0\]} \
{/TESTBED/DUT_SSC/buy\[7:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvGetSignalClose -win $_nWave1
wvSaveSignal -win $_nWave1 \
           "/RAID2/COURSE/iclab/iclab131/Lab01/Exercise/01_RTL/signal.rc"
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSelectGroup -win $_nWave1 {G2}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/DUT_SSC"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/DUT_SSC"
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/card_num\[63:0\]} \
{/TESTBED/input_money\[8:0\]} \
{/TESTBED/out_change\[8:0\]} \
{/TESTBED/out_valid} \
{/TESTBED/price\[31:0\]} \
{/TESTBED/snack_num\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/DUT_SSC/total\[7:0\]} \
{/TESTBED/DUT_SSC/total_sort\[7:0\]} \
{/TESTBED/DUT_SSC/buy\[7:0\]} \
{/TESTBED/DUT_SSC/remain\[8:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvSetPosition -win $_nWave1 {("G2" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/card_num\[63:0\]} \
{/TESTBED/input_money\[8:0\]} \
{/TESTBED/out_change\[8:0\]} \
{/TESTBED/out_valid} \
{/TESTBED/price\[31:0\]} \
{/TESTBED/snack_num\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/DUT_SSC/total\[7:0\]} \
{/TESTBED/DUT_SSC/total_sort\[7:0\]} \
{/TESTBED/DUT_SSC/buy\[7:0\]} \
{/TESTBED/DUT_SSC/remain\[8:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetPosition -win $_nWave1 {("G2" 4)}
wvGetSignalClose -win $_nWave1
wvSetCursor -win $_nWave1 106474.521912 -snap {("G2" 2)}
wvResizeWindow -win $_nWave1 149 609 1276 576
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/DUT_SSC"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/DUT_SSC"
wvSetPosition -win $_nWave1 {("G2" 5)}
wvSetPosition -win $_nWave1 {("G2" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/card_num\[63:0\]} \
{/TESTBED/input_money\[8:0\]} \
{/TESTBED/out_change\[8:0\]} \
{/TESTBED/out_valid} \
{/TESTBED/price\[31:0\]} \
{/TESTBED/snack_num\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/DUT_SSC/total\[7:0\]} \
{/TESTBED/DUT_SSC/total_sort\[7:0\]} \
{/TESTBED/DUT_SSC/buy\[7:0\]} \
{/TESTBED/DUT_SSC/remain\[8:0\]} \
{/TESTBED/DUT_SSC/id\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 5 )} 
wvSetPosition -win $_nWave1 {("G2" 5)}
wvSetPosition -win $_nWave1 {("G2" 5)}
wvSetPosition -win $_nWave1 {("G2" 5)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/card_num\[63:0\]} \
{/TESTBED/input_money\[8:0\]} \
{/TESTBED/out_change\[8:0\]} \
{/TESTBED/out_valid} \
{/TESTBED/price\[31:0\]} \
{/TESTBED/snack_num\[31:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
{/TESTBED/DUT_SSC/total\[7:0\]} \
{/TESTBED/DUT_SSC/total_sort\[7:0\]} \
{/TESTBED/DUT_SSC/buy\[7:0\]} \
{/TESTBED/DUT_SSC/remain\[8:0\]} \
{/TESTBED/DUT_SSC/id\[2:0\]} \
}
wvAddSignal -win $_nWave1 -group {"G3" \
}
wvSelectSignal -win $_nWave1 {( "G2" 5 )} 
wvSetPosition -win $_nWave1 {("G2" 5)}
wvGetSignalClose -win $_nWave1
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetCursor -win $_nWave1 108289.302789 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 106972.480080 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 106220.009960 -snap {("G2" 4)}
wvZoom -win $_nWave1 92433.400810 100079.959514
wvSetCursor -win $_nWave1 109112.199381 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 106987.309063 -snap {("G2" 3)}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvExpandBus -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 13)}
wvSelectSignal -win $_nWave1 {( "G2" 3 )} 
wvSetPosition -win $_nWave1 {("G2" 3)}
wvCollapseBus -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 3)}
wvSetPosition -win $_nWave1 {("G2" 5)}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvExpandBus -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 13)}
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 2 )} 
wvSetPosition -win $_nWave1 {("G2" 2)}
wvCollapseBus -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 2)}
wvSetPosition -win $_nWave1 {("G2" 5)}
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSelectSignal -win $_nWave1 {( "G2" 4 )} 
wvSetRadix -win $_nWave1 -format UDec
wvSetCursor -win $_nWave1 106735.977950 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 105677.340839 -snap {("G3" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvSetCursor -win $_nWave1 107946.936949 -snap {("G3" 0)}
wvSetCursor -win $_nWave1 107840.311628 -snap {("G3" 0)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoom -win $_nWave1 31996.963563 59393.724696
wvExit
