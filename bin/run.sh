#!/usr/bin/env bash

if [ $# -lt 3 ]
then
    echo "Usage:"
    echo "./bin/run.sh two-fer ~/input/ ~/output/"
    exit 1
fi

problem_slug="$1"
input_folder="$2"
output_folder="$3"
tmp_folder="/tmp/solution"

mkdir -p $output_folder

rm -rf $tmp_folder
mkdir -p $tmp_folder

cd $tmp_folder
cp -R $input_folder/* .

find . -mindepth 1 -type f | grep 'Test.java' | xargs -I file sed -i "s/@Ignore(.*)//g;s/@Ignore//g;" file

echo "test {\n  maxHeapSize = '2G'\n  reports.html.required = false\n}\napply plugin: 'com.exercism.plugin'\nbuildscript {\n  dependencies  {\n    classpath files('/opt/test-runner/autotest-runner.jar')\n  }\n}" >> build.gradle
timeout 20 gradle test exercism --offline --no-daemon --warning-mode=none --no-watch-fs --console=plain 2> gradle-test.err
mv results.json $output_folder
