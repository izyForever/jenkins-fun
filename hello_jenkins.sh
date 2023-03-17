#!/bin/bash
export who=$1
export logPath=$2
echo "Hello Jenkins! Msg from ${who}" > $logPath
