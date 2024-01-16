#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
NC='\033[0m'

info() {
  echo -e "${GREEN}[Info] $*${NC}" >&2
}

error() {
  echo -e "${RED}[Error] $*${NC}"
}


