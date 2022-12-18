#!/bin/bash
cd ~/gpmp2/build
cmake -DGPMP2_BUILD_PYTHON_TOOLBOX:=ON ..
make python-install 