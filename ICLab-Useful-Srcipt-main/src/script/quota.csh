#!/bin/tcsh
# Brief : 
# Author: Jyun-Wei, Su
# Update: 2023.11.06

if ($?prompt) then
  # set filesize limit
  limit filesize 10G
  if (`limit | grep filesize | grep unlimited` != "") then
    echo ">>> Current limit: \033[1;41m`limit | grep filesize`\033[m"
  else
    echo ">>> Current file limit : \033[1;42m`limit | grep filesize`\033[m"
  endif
  #echo '======================================================'

  # show quota
  quota | awk 'NR==4 {printf ">>> Current space usage: "; \
              if     ($1/$2 < 0.5) printf "\033[1;42m%.2f%%\033[m\n", $1/$2*100; \
              else if($1/$2 < 0.8) printf "\033[1;43m%.2f%%\033[m\n", $1/$2*100; \
              else                 printf "\033[1;41m%.2f%%\033[m\n", $1/$2*100}'
  #echo '======================================================'
  echo '>>> \033[1;31mFiles >500M:\033[m'
  find ~/ -type f -size +500M -exec ls -l {} \; | awk '{print $NF}'
  echo '======================================================'
endif
