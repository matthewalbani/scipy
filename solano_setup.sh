#!/bin/bash
set -v
uname -a
free -m
sudo df -h
ulimit -a
sudo apt-get -f -y install
sudo apt-get -y install libatlas-dev libatlas-base-dev liblapack-dev gfortran libmpc-dev libmpfr-dev libfreetype6-dev libpng-dev zlib1g-dev texlive-fonts-recommended ccache
sudo apt-get update
sudo apt-get -y install python-gmpy
mkdir builds
pushd builds
pip install --install-option="--no-cython-compile" Cython==0.22
pip install $NUMPYSPEC
pip install nose mpmath argparse Pillow codecov
pip install --upgrade pip setuptools
pip install gmpy
if [ "$TESTMODE" == "full" ]; then
  pip install coverage;
fi
if [ "$USE_WHEEL" == "1" ]; then
  pip install wheel;
fi
if [ "$REFGUIDE_CHECK" == "1" ]; then
  pip install matplotlib Sphinx==1.2.3;
fi
python -V
popd
printenv
