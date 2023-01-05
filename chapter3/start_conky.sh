#!/bin/bash
killall conky
sleep 10
conky -c $HOME/.harmattan-themes/Glass/God-Mode/.conkyrc
