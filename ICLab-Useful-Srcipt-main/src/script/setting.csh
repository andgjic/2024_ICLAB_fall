#!/bin/tcsh
# Brief : This is a script to set variable for cd.csh, clk.csh, fsdb.csh
# Author: Jyun-Wei, Su
# Update: 2024.02.28 add @
# Update: 2023.10.23

# set FOLDER="Lab11/EXERCISE_wocg"
# set FOLDER="Lab12/Exercise"
set FOLDER="Lab12"
# set FOLDER="Midterm_Project"
# set FOLDER="Bonus_formal_verification/Exercise"
# set FOLDER="Final_Project"

# check if the current directory include @
if(`pwd` =~ *@*) then
  set DEBUG=@
else
  set DEBUG
endif

set TESTBED_FILE=$HOME/$DEBUG/$FOLDER/00_TESTBED/TESTBED.v
set PATTERN_FILE=$HOME/$DEBUG/$FOLDER/00_TESTBED/PATTERN.v
set SYN_FILE=$HOME/$DEBUG/$FOLDER/02_SYN/syn.tcl

# Define colors
set GREEN='\033[0;32m'
set BLUE='\033[0;34m'
set RED='\033[0;31m'
set NC='\033[0m' # No Color
