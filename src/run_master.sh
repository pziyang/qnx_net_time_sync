#!/bin/sh

# "THE BEER-WARE LICENSE" (Revision 42):
# <xpacne00@stud.fit.vutbr.cz> wrote this file. As long as you retain this
# notice you can do whatever you want with this stuff. If we meet some day,
# and you think this stuff is worth it, you can buy me a beer in return.
# Jan Pacner

#FIXME specify inbound + outbound latency in nsec (compesate e.g. sockets usage)
#  ptpd -l IN,OUT

case "$1" in
  ntp)
    # high debug level + write everything to stdout/stderr instead of log
    # no fork
    # listen on interface
    # allow first adjustment to be big
    ntpd -dddddddd -n -I "$2" -g -c ./ntp/ntp.conf.master
    ;;
  ptp)
    [ "$3" == 'recompile' ] && {
      make -C ./ptp/new/src clean
      make -C ./ptp/new/src
    }
    # be as verbose as possible
    ./ptp/new/src/ptpd2 -G -b "$2" -C -DVfS ;;
  *)
    echo "USAGE: $0 (ptp <eth_device> [recompile]|ntp <eth_device>)" ;;
esac
