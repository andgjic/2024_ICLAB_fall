.PHONY:vcs_rtl vcs_gate irun_rtl irun_gate xrun_rtl xrun_gate nWave verdi clean
######################################
# Set your desired file names
######################################
source_file="filelist.f"        # Name of your source file
output_file="simv"              # Desired output simulation file name
log_file="vcs.log"              # Desired log file name
fsdb_file="CC.fsdb"            # Desired log file name

######################################
# Default Setting
######################################
num_CPU_cores="8"               # Number of CPU that used for VCS
TIMESCALE="-timescale=1ns/1fs"
TIMESCALE1="-timescale 1ns/1fs"
VERDI="/usr/cad/synopsys/verdi/2019.06/"
DW_SIM="/usr/cad/synopsys/synthesis/cur/dw/sim_ver/"
UMC018_SIM="/usr/cad/umc018/Verilog/umc18_neg.v"

######################################
# Simulation Option and Command
######################################

# ============== VCS =================
VCS_RTL_SIM = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -y ${DW_SIM} \
    +libext+.v \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
    +define+RTL \
    +notimingchecks 
# =====================================
VCS_GATE_SIM = vcs ${TIMESCALE} \
    -j${num_CPU_cores} \
    -sverilog \
    +v2k \
    -full64 \
    -Mupdate \
    -R \
    -debug_access+all \
    -f ${source_file} \
    -o ${output_file} \
    -l ${log_file} \
    -P ${VERDI}/share/PLI/VCS/linux64/novas.tab \
       ${VERDI}/share/PLI/VCS/linux64/pli.a \
	-v ${UMC018_SIM} \
    +define+GATE \
	-ntb_opts nontcglitch
# =====================================
# ============== irun =================
IRUN_RTL_SIM =  irun -f ${source_file} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL
# =====================================
IRUN_GATE_SIM =  irun -f ${source_file} \
	-override_precision \
	${TIMESCALE1} \
	-sdf_precision 1fs \
	-v ${UMC018_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-nontcglitch \
	-define GATE
# =====================================
# ============== xrun =================
XRUN_RTL_SIM =  xrun -f ${source_file} \
	-mcl ${num_CPU_cores} \
	-incdir ${DW_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-notimingchecks \
	-define RTL
# =====================================
XRUN_GATE_SIM =  xrun -f ${source_file} \
	-mcl ${num_CPU_cores} \
	-override_precision \
	${TIMESCALE1} \
	-sdf_precision 1fs \
	-v ${UMC018_SIM} \
	-loadpli1 debpli:novas_pli_boot \
	-debug \
	-nontcglitch \
	-define GATE
# =====================================
# ============= verdi ================
nWave_ON = nWave -ssf ${fsdb_file}
# =====================================
VERDI_ON = verdi -ssf ${fsdb_file} \
	-sv \
	-f ${source_file} \
    	-nologo           \
	+define+RTL	  \
	+v2k 
# =====================================

vcs_rtl:
	${VCS_RTL_SIM}

vcs_gate:
	${VCS_GATE_SIM}

irun_rtl:
	${IRUN_RTL_SIM}

irun_gate:
	${IRUN_GATE_SIM}

xrun_rtl:
	${XRUN_RTL_SIM}

xrun_gate:
	${XRUN_GATE_SIM}

nWave:
	${nWave_ON}

verdi:
	${VERDI_ON}

clean:
	rm -rf ./csrc 
	rm -rf *.daidir 
	rm -rf *.log 
	rm -rf simv* *.sdf.X
	rm -rf *.key
	rm -rf INCA_libs nWaveLog irun.history og_file
	rm -rf *.fsdb
	rm -rf *.log
	rm -rf *~
	rm -rf *.key
	rm -rf *.conf
	rm -rf *.rc
	rm -rf xcelium.d xrun.history
	rm -rf verdiLog

