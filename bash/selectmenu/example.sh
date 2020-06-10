#!/bin/bash

source selectmenu.sh;

selectmenu -a0 `ls -1 /`;

printf "$REPLY\n";