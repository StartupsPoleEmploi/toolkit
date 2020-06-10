#!/bin/bash

source selectmenu.sh;

selectmenu `ls -1 /`;

printf "$REPLY\n";
