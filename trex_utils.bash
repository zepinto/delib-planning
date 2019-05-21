#!/bin/bash

workspace_dir=$(pwd)

trex_git="https://github.com/fredpy/trex2-agent.git"
trex_version='trex_stable'
trex_home="$workspace_dir/trex"

dune_git="https://github.com/lsts/dune.git"
dune_version='master'
dune_home="$workspace_dir/dune"

neptus_git="git@github.com:lsts/neptus.git"
neptus_version='develop'
neptus_home="$workspace_dir/neptus"

europa_git="git@github.com:zepinto/europa.git"
europa_version='stable'
europa_home="$workspace_dir/europa"


export PLASMA_HOME="$europa_home/source"
export EUROPA_HOME="$europa_home"

cpu_cores=(grep -c ^processor /proc/cpuinfo)

install_dependencies()
{
    sudo apt install bzip2 unzip g++ cmake jam ant libboost-all-dev libantlr3c-dev swig openjdk-8-jdk
}

create_workspace()
{
    if [ ! -d $workspace_dir ]; then
        mkdir $workspace_dir
    fi 
}

compile_dune()
{
    if [ ! -d $dune_home ]; then
        mkdir -p $dune_home/build
    fi 
    cd $dune_home
    git clone --branch $dune_version $dune_git source
    cd $dune_home/source && git pull
    cd $dune_home/build
    cmake -DSHARED=ON ../source
    make package -j$(grep -c ^processor /proc/cpuinfo)
    tar xjvf *.tar.bz2
    rm *.tar.bz2
    cd $workspace_dir
}

compile_europa()
{
    if [ ! -d $europa_home ]; then
        mkdir -p $europa_home
    fi 
    cd $europa_home
    git clone --branch $europa_version $europa_git source
    cd $europa_home/source && git pull
    cd $PLASMA_HOME/src/PLASMA && 
    jam -dx \
        -sLOGGER_TYPE= \
        -sVARIANTS=OPTIMIZED \
        -sLIBRARIES=SHARED \
        -j1 \
        build &&

    cd $PLASMA_HOME &&
    
    ant \
        -Djam.args="-dx" \
        -Djam.num.cores="$cpu_cores" \
        -Djam.variant=OPTIMIZED \
        -Djam.libraries=SHARED dist \
        dist
    
}

compile_trex()
{
    if [ ! -d $trex_home ]; then
        mkdir -p $trex_home/build
    fi 
    
    git clone --branch $trex_version $trex_git "$trex_home/source"
    cd $trex_home/source && git pull
    cd $trex_home/build
    DUNE_HOME=$(ls -d -1 $dune_home/build/dune-*/)
    cmake -DWITH_LSTS=ON -DWITH_LSTS_ONBOARD=ON -DWITH_LSTS_SHORESIDE=ON \
      -DEUROPA_HINTS="$PLASMA_HOME/dist/europa" -DDUNE_HOME="$DUNE_HOME" \
      -DDUNE_INCLUDE_DIR="$DUNE_HOME/include" \
      -DDUNE_CORE_LIB="$DUNE_HOME/lib/libdune-core.so" ../source 
    make package -j$(grep -c ^processor /proc/cpuinfo)
}

compile_neptus()
{
    git clone --branch $neptus_version $neptus_git "$neptus_home"
    cd $neptus_home && git pull
    ant jar
}

build_all()
{
    create_workspace
    install_dependencies
    compile_europa
    compile_dune
    compile_trex
}

start_dune()
{
    # Stop DUNE if already running
    while pgrep -x "dune" > /dev/null; do
        killall dune
    done
    
    xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "XP1 Simulator" -e "cd \"$dune_home/build/\";./dune -c development/xp1-trex -p Simulation" &disown
}

start_trex()
{
    # Stop any running instances of amc
    while pgrep -x "amc" > /dev/null; do
        killall amc
    done 
   xterm -xrm 'XTerm.vt100.allowTitleOps: false' -T "T-REX" -e "cd \"$trex_home/build/\";. trex_devel.bash; amc auv/auv1" &disown
}

trex_log()
{
    tail -f $trex_home/build/log/latest/TREX.log
}
