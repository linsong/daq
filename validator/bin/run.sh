#!/bin/bash -e

start_dir=$(pwd)
ROOT=$(dirname $0)/..
cd $ROOT

jarfile=$(realpath build/libs/validator-1.0-SNAPSHOT-all.jar)

if [ -z "$1" -o -z "$2" ]; then
    echo Usage: $0 [schema] [target]
    false
fi

schema=$start_dir/$1
target=$start_dir/$2
ignoreset=$start_dir/$3

echo Executing validator ${schema#$start_dir/} ${target#$start_dir/}...

schemafile=$(realpath $schema)
if [ -d $schemafile ]; then
    schemadir=$schemafile
    schemafile=.
else
    schemadir=$(dirname $schemafile)
    schemafile=${schemafile#$schemadir/}
    fulltarget=$(realpath $target)
    target=${fulltarget#$schemadir/}
fi

echo Running schema ${schemafile#$start_dir/} in $schemadir

rm -rf $schemadir/out

error=0
(cd $schemadir; java -jar $jarfile $schemafile $target $ignoreset) || error=$?

echo Validation complete, exit $error
exit $error
