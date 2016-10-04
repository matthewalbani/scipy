#!/bin/bash
set -o pipefail
set -ev
python -c 'import numpy as np; print("relaxed strides checking:", np.ones((10,1),order="C").flags.f_contiguous)'
if [ "$NPY_RELAXED_STRIDES_CHECKING" == "1" ]; then
  python -c 'import numpy as np; assert np.ones((10,1),order="C").flags.f_contiguous'
fi
python -c 'import mpmath.libmp; print("mpmath.libmp.BACKEND:",  mpmath.libmp.BACKEND == "gmpy");  print("mpmath.libmp.BACKEND:", mpmath.libmp.BACKEND)'
python -c 'import mpmath.libmp; assert mpmath.libmp.BACKEND == "gmpy"'
if [ "$USE_WHEEL" == "1" ]; then
  pip wheel . -v
  pip install scipy*.whl -v
  USE_WHEEL_BUILD="--no-build"
elif [ "$USE_SDIST" == "1" ]; then
  python setup.py sdist
  pushd dist;
  pip install scipy*
  popd
  USE_WHEEL_BUILD="--no-build"
fi
python -u $OPTIMIZE runtests.py -g -m $TESTMODE $COVERAGE $USE_WHEEL_BUILD |& tee runtests.log
tools/validate_runtests_log.py $TESTMODE < runtests.log
if [ "$REFGUIDE_CHECK" == "1" ]; then
  python runtests.py -g --refguide-check;
fi
