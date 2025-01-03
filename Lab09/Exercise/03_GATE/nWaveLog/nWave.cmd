wvOpenFile -win $_nWave1 -mul \
           {/RAID2/COURSE/iclab/iclab131/Lab09/Exercise/03_GATE/Program_SYN.fsdb} {/RAID2/COURSE/iclab/iclab131/Lab09/Exercise/03_GATE/signal.rc} 
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p/Program"
wvGetSignalSetSignalFilter -win $_nWave1 "formula_result"
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/dut_p/inf/rst_n} \
{/TESTBED/dut_p/Program/warning\[1:0\]} \
{/TESTBED/dut_p/Program/formula_result\[11:0\]} \
{/TESTBED/dut_p/inf/warn_msg\[1:0\]} \
{/TESTBED/dut_p/inf/out_valid} \
{/TESTBED/dut_p/inf/complete} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 3)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/dut_p/inf/rst_n} \
{/TESTBED/dut_p/Program/warning\[1:0\]} \
{/TESTBED/dut_p/Program/formula_result\[11:0\]} \
{/TESTBED/dut_p/inf/warn_msg\[1:0\]} \
{/TESTBED/dut_p/inf/out_valid} \
{/TESTBED/dut_p/inf/complete} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvGetSignalClose -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomIn -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p/Program"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p/inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf/PATTERN"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf/Program_inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p/Program"
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/inf"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/dut_p"
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/dut_p/inf/rst_n} \
{/TESTBED/dut_p/Program/warning\[1:0\]} \
{/TESTBED/dut_p/Program/formula_result\[11:0\]} \
{/TESTBED/dut_p/clk} \
{/TESTBED/dut_p/inf/warn_msg\[1:0\]} \
{/TESTBED/dut_p/inf/out_valid} \
{/TESTBED/dut_p/inf/complete} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvAddSignal -win $_nWave1 -clear
wvAddSignal -win $_nWave1 -group {"G1" \
{/TESTBED/dut_p/inf/rst_n} \
{/TESTBED/dut_p/Program/warning\[1:0\]} \
{/TESTBED/dut_p/Program/formula_result\[11:0\]} \
{/TESTBED/dut_p/clk} \
{/TESTBED/dut_p/inf/warn_msg\[1:0\]} \
{/TESTBED/dut_p/inf/out_valid} \
{/TESTBED/dut_p/inf/complete} \
}
wvAddSignal -win $_nWave1 -group {"G2" \
}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSetPosition -win $_nWave1 {("G1" 4)}
wvGetSignalClose -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 1)}
wvSetPosition -win $_nWave1 {("G1" 0)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 0)}
wvSetPosition -win $_nWave1 {("G1" 1)}
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSaveSignal -win $_nWave1 \
           "/RAID2/COURSE/iclab/iclab131/Lab09/Exercise/03_GATE/signal.rc"
wvSetCursor -win $_nWave1 334934.545455 -snap {("G1" 1)}
wvDisplayGridCount -win $_nWave1 -off
wvGetSignalClose -win $_nWave1
wvReloadFile -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomIn -win $_nWave1
wvZoomOut -win $_nWave1
wvZoomOut -win $_nWave1
wvSetCursor -win $_nWave1 344426.203209 -snap {("G1" 1)}
wvSelectSignal -win $_nWave1 {( "G1" 4 )} 
wvSelectSignal -win $_nWave1 {( "G1" 3 )} 
wvSetPosition -win $_nWave1 {("G1" 3)}
wvSetPosition -win $_nWave1 {("G1" 4)}
wvMoveSelected -win $_nWave1
wvSetPosition -win $_nWave1 {("G1" 4)}
