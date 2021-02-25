#!/bin/bash

# runs unit tests on the library

set -e

cd "$(dirname "$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")")" # cd script parent
cd ..

flutter test test