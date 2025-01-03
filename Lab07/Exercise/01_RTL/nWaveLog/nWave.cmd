wvOpenFile -win $_nWave1 -mul \
           {/RAID2/COURSE/iclab/iclab131/Lab07/Exercise/01_RTL/CONV_TOP.fsdb} {/RAID2/COURSE/iclab/iclab131/Lab07/Exercise/01_RTL/signal.rc} 
wvSaveSignal -win $_nWave1 \
           "/RAID2/COURSE/iclab/iclab131/Lab07/Exercise/01_RTL/signal.rc"
wvScrollDown -win $_nWave1 3
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollUp -win $_nWave1 4
wvSelectGroup -win $_nWave1 {Handshake sync}
wvScrollDown -win $_nWave1 10
wvSelectSignal -win $_nWave1 {( "Handshake sync" 8 )} 
wvSetCursor -win $_nWave1 213907.141638 -snap {("Handshake sync" 5)}
wvSelectSignal -win $_nWave1 {( "Handshake sync" 7 )} 
wvSelectSignal -win $_nWave1 {( "Handshake sync" 8 )} 
wvSetCursor -win $_nWave1 131104.377133 -snap {("Handshake sync" 1)}
wvSetCursor -win $_nWave1 184006.143345 -snap {("Handshake sync" 8)}
wvSetCursor -win $_nWave1 156405.221843 -snap {("Handshake sync" 1)}
wvSetCursor -win $_nWave1 204706.834471 -snap {("Handshake sync" 8)}
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvScrollDown -win $_nWave1 1
wvSelectSignal -win $_nWave1 {( "CLK2 module" 6 )} 
wvScrollDown -win $_nWave1 6
wvSetCursor -win $_nWave1 501416.740614 -snap {("CLK2 module" 8)}
wvScrollDown -win $_nWave1 3
wvExit
