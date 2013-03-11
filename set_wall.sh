#!/bin/sh

feh --bg-scale "$(find $1 | shuf -n1)"
