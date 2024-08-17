#!/bin/bash

curl -sL https://api.github.com/repos/FlyGoat/RyzenAdj/releases/latest | grep tag_name | cut -d\" -f4 | tr -d v
