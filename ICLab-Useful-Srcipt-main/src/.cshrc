# .cshrc configuration file for iclab workstation
# Author: Jyun-Wei, Su
# Update: 2023.11.06

# Show space usage
source ~/script/quota.csh

# set terminal preference
set autolist = ambiguous 
set complete = enhance
set recexact
set autoexpand
setenv VCS_LIC_EXPIRE_WARNING 0

# Hotkey
alias 0       'source ~/script/cd.csh 0'
alias 1       'source ~/script/cd.csh 1'
alias 2       'source ~/script/cd.csh 2'
alias 3       'source ~/script/cd.csh 3'
alias 4       'source ~/script/cd.csh 4'
alias 5       'source ~/script/cd.csh 5'
alias 6       'source ~/script/cd.csh 6'
alias 7       'source ~/script/cd.csh 7'
alias 8       'source ~/script/cd.csh 8'
alias 9       'source ~/script/cd.csh 9'
alias m       'source ~/script/cd.csh m'
alias @@      'source ~/script/cd.csh @'
alias c       'source ~/script/clk.csh'
alias f       'source ~/script/fsdb.csh'
alias rs      'source ~/.cshrc'
alias setting 'code ~/script/setting.csh'
alias dwip    'evince /usr/cad/synopsys/synthesis/cur/dw/doc/manuals/dwbb_userguide.pdf >& /dev/null &'
alias io      'evince ~iclabTA01/umc018/Doc/umc18io3v5v.pdf >& /dev/null &'
alias myps    'ps -aux | grep $user'
