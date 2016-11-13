#!/usr/bin/python3

import sys
import os

INDEX_FILE = os.getenv( "HLP_INDEX_LOC" )
HLP_FILES_LOC = os.getenv( "HLP_FILES_LOC" )

# --------------------------
def get_help_files( keywords ):
    files = []
    with open( INDEX_FILE, 'r' ) as index:
        for line in index:
            if all( word in line for word in keywords ):
                files.append( HLP_FILES_LOC + line.split()[-1] )

    return files

# --------------------------
def print_help_files( keywords ):
    files = get_help_files( keywords )

    for file in files:
        with open( file, 'r' ) as f:
            print( f.read() )

# --------------------------
if len( sys.argv ) == 1:
    with open( INDEX_FILE, 'r' ) as index:
        print( index.read() )
else:
    print_help_files( sys.argv[1:] )
