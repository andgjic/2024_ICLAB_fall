#!/bin/tcsh
# Brief : This is a script to change directory
# Author: Jyun-Wei, Su
# Update: 2024.02.28 add @ 
# Update: 2023.12.23

# get the variable from setting.csh
source $HOME/script/setting.csh

# check parameter
if ($# == 0) then
  echo "${RED}Please input 0~9${NC}"
  exit 1
else
  # cd to folder
  switch ($1)
    case @:
      cd $HOME/@/                      || (echo "${RED}Change directory fail${NC}"; exit 1)
      breaksw
    case [0-9]:
      cd $HOME/$DEBUG/$FOLDER/0$1_*    || (echo "${RED}Change directory fail${NC}"; exit 1)
      breaksw
    case m:
      cd $HOME/$DEBUG/$FOLDER/Memory   || (echo "${RED}Change directory fail${NC}"; exit 1)
      breaksw
    default:
      echo "${RED}Please input 0~9${NC}"
      exit 1
      breaksw
  endsw

  # Check if cd was successful
  if ($? == 0) then
    echo "${GREEN}Current directory: `pwd`${NC}"
  endif
endif
