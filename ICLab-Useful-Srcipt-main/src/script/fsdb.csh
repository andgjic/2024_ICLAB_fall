#!/bin/tcsh
# Brief : This is a script to open/close the FSDB
# Author: Jyun-Wei, Su
# Update: 2023.10.30

# get the variable from setting.csh
source $HOME/script/setting.csh

# check parameter
if ($# == 0) then
  set show = 1
  set help = 1
  goto conclusion
else
  # check if file exit
  if (-e $TESTBED_FILE) then
    #--------------------------------------------------------- section
    switch ($1)
      case 'rtl':
        set section = 'RTL'
        breaksw
      case 'gate':
        set section = 'GATE'
        breaksw
      case 'post':
        set section = 'POST'
        breaksw
      default:
        set show = 0
        set help = 1
        goto conclusion
        breaksw
    endsw
  else
    echo "$TESTBED_FILE not exist"
  endif
  #--------------------------------------------------------- FSDB ON/OFF
  if ($2 == 'on') then
    # find and remove comment in ifdef RTL to endif
    sed -i "/ifdef $section/,/endif/s/\/\/\(.sdf_annotate(.*);\)/\1/g" $TESTBED_FILE
    sed -i "/ifdef $section/,/endif/s/\/\/\(.fsdbDumpfile(.*);\)/\1/g" $TESTBED_FILE
    sed -i "/ifdef $section/,/endif/s/\/\/\(.fsdbDumpvars(.*);\)/\1/g" $TESTBED_FILE
    echo "${GREEN}Uncomment ${section} fsdbDumpfile, fsdbDumpvars done.${NC}"
    set show = 1
    set help = 0
    goto conclusion
  else if ($2 == 'off') then
    # check if file is commented
    if (`awk 'BEGIN { s=0 } /.ifdef '$section'/,/.endif/ { if ($0 ~ /\/\/.*/) { s=1; exit } } END { print s}' $TESTBED_FILE` == "0") then
      #sed -i "/ifdef $section/,/endif/s/\(.sdf_annotate(.*);\)/\/\/\1/g" $TESTBED_FILE
      sed -i "/ifdef $section/,/endif/s/\(.fsdbDumpfile(.*);\)/\/\/\1/g" $TESTBED_FILE
      sed -i "/ifdef $section/,/endif/s/\(.fsdbDumpvars(.*);\)/\/\/\1/g" $TESTBED_FILE
    endif
    echo "${GREEN}Comment ${section} sdf_annotate, fsdbDumpfile, fsdbDumpvars done.${NC}"
    set show = 1
    set help = 0
    goto conclusion
  else
    set show = 0
    set help = 1
    goto conclusion
  endif

endif

conclusion:
# show the state of fsdb file
if ($show == 1) then
  echo ${BLUE}File: $TESTBED_FILE${NC}
  echo ${GREEN}In RTL${NC}
  awk '/.ifdef RTL/,/.endif/ {if ($0 ~ /sdf_/) print}' $TESTBED_FILE
  awk '/.ifdef RTL/,/.endif/ {if ($0 ~ /fsdb/) print}' $TESTBED_FILE
  echo ${GREEN}In GATE${NC}
  awk '/.ifdef GATE/,/.endif/ {if ($0 ~ /sdf_/) print}' $TESTBED_FILE
  awk '/.ifdef GATE/,/.endif/ {if ($0 ~ /fsdb/) print}' $TESTBED_FILE
  echo ${GREEN}In POST${NC}
  awk '/.ifdef POST/,/.endif/ {if ($0 ~ /sdf_/) print}' $TESTBED_FILE
  awk '/.ifdef POST/,/.endif/ {if ($0 ~ /fsdb/) print}' $TESTBED_FILE
endif
# show the usage of this script
if($help == 1) then
  echo "${RED}Please input {rtl, gate, post} {on, off} to turn on/off fsdb file.${NC}"
endif
# exit
exit 1
