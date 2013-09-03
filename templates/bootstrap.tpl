#!/usr/bin/env bash

# Time-stamp: <2013-08-12 12:26:07 Monday by oa>

set -x
aclocal                                         \
&& autoconf                                     \
&& libtoolize --copy --force --automake         \
&& automake --foreign --add-missing
