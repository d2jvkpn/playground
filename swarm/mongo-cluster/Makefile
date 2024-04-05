#!/bin/make

# include envfile
# export $(shell sed 's/=.*//' envfile)

current = $(shell pwd)

connect:
	expect connect.exp

down:
	echo no | bash step05_down.sh
