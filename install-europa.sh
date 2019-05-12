#!/usr/bin/bash

export EUROPA_HOME=~/europa
if [! -d $EUROPA_HOME]; then
  mkdir $EUROPA_HOME
  cd $EUROPA_HOME
  wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/europa-pso/europa-2.6-linux64.zip
  wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/europa-pso/europa-2.6-linux64-static-libs.zip
  unzip europa-2.6-linux64.zip
  unzip europa-2.6-linux64-static-libs.zip
  rm *.zip
fi

