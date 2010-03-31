#!/usr/bin/env bash

###########################################################################
# Copyright (c) 2010 Minh Van Nguyen <nguyenminh2@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# http://www.gnu.org/licenses/
###########################################################################

# Wrap up a source distribution of the book "Algorithmic Graph Theory".
# Before running this script, you need to ensure that the book compiles OK
# by running the .tex files through LaTeX. In particular, issuing the command
#
# $ make
#
# from GRAPH_ROOT would compile the LaTeX source files and produce a PDF
# version of the book. This command should not result in any errors.
#
# Assume that GRAPH_ROOT is the top-level directory of this source tree.
# For a version release, issue the command
#
# $ GRAPH_ROOT/graph.sh --sdist x.y
#
# This results in a source tarball named "graph-theory-x.y.tar.bz2" and a
# PDF version of the book named "graph-theory-x.y.pdf". Thus, a version
# release has a version number of the form x.y, where x signifies the
# major version number and y signifies the minor version number.
#
# Apart from the version release, you could also wrap up a revision release
# by issuing the command
#
# $ GRAPH_ROOT/graph.sh --sdist
#
# This has the effect of taking the current revision or snapshot of the
# source tree and produce a bug fix release. The resulting source tarball is
# named "latest-rxxx.tar.bz2" and a PDF version of the book is named
# "latest-rxxx.pdf". You can think of the command
# "GRAPH_ROOT/graph.sh --sdist" as producing a nightly build of the whole
# source tree and wrap up that tree for distribution. If this project were
# hosted on a server that allows for nightly builds or working daily
# snapshots, the command "GRAPH_ROOT/graph.sh --sdist" would serve that
# purpose.

GRAPH_ROOT="$2"
cd "$GRAPH_ROOT"
NAME=""
VERSION=""

if [ "$1" = "--revision" ]; then
    echo "Wrap up revision release..."
    VERSION=`hg tip | head -1 | awk '{split($2, array, ":"); print array[1]}'`
    NAME="latest-r"
else
    echo "Wrap up version release..."
    VERSION="$1"
    NAME="graph-theory-"
fi

# Test if there is a file called "book.pdf". That file results from
# running the command "make" from GRAPH_ROOT.
if [ -e "book.pdf" ] && [ -f "book.pdf" ]; then
    cd ..
    cp -rf "$GRAPH_ROOT" "$NAME$VERSION"
    mv "$NAME$VERSION"/book.pdf "$NAME$VERSION".pdf
    tar -jcf "$NAME$VERSION".tar.bz2 "$NAME$VERSION"
    rm -rf "$NAME$VERSION"
    # You should now be left with the original source tree named
    # "graph-theory-x.y". In addition, you now have two new files named
    # "<NAME><VERSION>.tar.bz2" and "<NAME><VERSION>.pdf".
else
    echo "File book.pdf does not exist. Exiting..."
    exit 1
fi