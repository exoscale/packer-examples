#!/bin/sh

yum upgrade -y

# install missing packages

yum install -y wget

# clean for real
cloud-init clean
