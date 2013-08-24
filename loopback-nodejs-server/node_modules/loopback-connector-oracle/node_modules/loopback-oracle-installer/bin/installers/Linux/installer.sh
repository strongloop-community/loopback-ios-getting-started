#!/bin/bash

export OCI_DIR=$1

SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")
INSTALL_DIR=$(cd -P -- "$SCRIPT_DIR/.." && pwd -P)
source "$INSTALL_DIR/../../lib/utils"

setup_configuration "$OCI_DIR"
cat << MYEOF

---------------------------------------------------------------------------
The node-oracle module and the Oracle specific libraries have been
installed in `pwd`.

The default bashrc (/etc/bashrc) or  user's bash_profile (~/.bash_profile)
paths have been modified to use this path. If you use a shell other than
bash, please remember to set the LD_LIBRARY_PATH prior to using node.

Example:
  \$ export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$OCI_DIR"


Or alternatively, you can add that path to /etc/ld.so.conf (you will
require sudo access to do that).
  echo "$OCI_DIR" | sudo tee -a /etc/ld.so.conf.d/loopback_oracle.conf
  sudo ldconfig

MYEOF


