#!/bin/bash
ls *.orig.tar.xz | cut -d_ -f2 | cut -d\. -f 1-3
