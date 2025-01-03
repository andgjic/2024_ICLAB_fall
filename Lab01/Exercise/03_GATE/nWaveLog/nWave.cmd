wvSetPosition -win $_nWave1 {("G1" 0)}
wvOpenFile -win $_nWave1 \
           {/RAID2/COURSE/iclab/iclab131/Lab01/Exercise/03_GATE/SSC_SYN.fsdb}
wvGetSignalOpen -win $_nWave1
wvGetSignalSetScope -win $_nWave1 "/TESTBED"
wvGetSignalSetScope -win $_nWave1 "/TESTBED/DUT_SSC"
wvGetSignalOpen -win $_nWave1
wvGetSignalOpen -win $_nWave1
wvExit
