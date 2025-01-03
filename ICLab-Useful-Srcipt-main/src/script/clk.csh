#!/bin/tcsh
# Brief : This is a script to change the clock peroid define
# Author: Jyun-Wei, Su
# Update: 2023.10.23

# get the variable from setting.csh
source $HOME/script/setting.csh

# check parameter
if ($# == 0) then
  # testbed file
  echo ${BLUE}File: $TESTBED_FILE${NC}
  setenv GREP_COLOR '01;32' ; cat --number $TESTBED_FILE | grep --color "define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?"
  # pattern file
  echo ${BLUE}File: $PATTERN_FILE${NC}
  setenv GREP_COLOR '01;32' ; cat --number $PATTERN_FILE | grep --color "define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?"
  # syn file
  echo ${BLUE}File: $SYN_FILE${NC}
  setenv GREP_COLOR '01;32' ; cat --number $SYN_FILE | grep --color "set CYCLE [0-9]\+\.\?[0-9]\?"
  exit 1
else
  #if([string tofloat $1] < 5.0) then
  #  echo "${RED}Cycle time must >= 5. ${NC}"
  #else
    # testbed file
    echo ${BLUE}File: $TESTBED_FILE${NC}
    setenv GREP_COLOR '01;31' ; cat --number $TESTBED_FILE | grep --color "define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?"
    sed -i "s/define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?/define CYCLE_TIME $1/" $TESTBED_FILE
    setenv GREP_COLOR '01;32' ; cat --number $TESTBED_FILE | grep --color "define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?"
    # pattern file
    echo ${BLUE}File: $PATTERN_FILE${NC}
    setenv GREP_COLOR '01;31' ; cat --number $PATTERN_FILE | grep --color "define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?"
    sed -i "s/define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?/define CYCLE_TIME $1/" $PATTERN_FILE
    setenv GREP_COLOR '01;32' ; cat --number $PATTERN_FILE | grep --color "define\s\+CYCLE_TIME\s\+[0-9]\+\.\?[0-9]\?"
    # syn file
    echo ${BLUE}File: $SYN_FILE${NC}
    setenv GREP_COLOR '01;31' ; cat --number $SYN_FILE | grep --color "set CYCLE [0-9]\+\.\?[0-9]\?"
    sed -i "s/set CYCLE [0-9]\+\.\?[0-9]\?/set CYCLE $1/" $SYN_FILE
    setenv GREP_COLOR '01;32' ; cat --number $SYN_FILE | grep --color "set CYCLE [0-9]\+\.\?[0-9]\?"

    # Check if cd was successful
    if ($? == 0) then
      echo "${GREEN}Change cycle time to $1 dnoe. ${NC}"
    endif
  #endif

endif
