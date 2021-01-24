#!/bin/bash

source selectmenu.sh;

selectmenu $@ `ls -1 /`;

echo;
echo ${REPLY[@]}
echo;