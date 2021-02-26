#!/bin/bash

# runs unit tests on the library
# DEV!
set -e

# cd project root:
cd "$(dirname "$(perl -MCwd -e 'print Cwd::abs_path shift' "$0")")"/..

flutter test test