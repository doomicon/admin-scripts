#!/bin/bash
#Name:  searchindex.sh
#Desc:  Script for reindexing the Weblogic ALUI 6.1 search service should you receive an error 
#	about specific index missing.
#
#	Error while starting that we are trying to correct:
#	Cannot find queue segment for last committed index request: 
#
#	Must provide the HOME directory for the service, and node name.
#Author:  Rob Owens
##Change##
#initial:ro:/10/02/09
#
#
#
#includes/use
# reindex search service 10.254.15n.78
# Example:
#SEARCH_HOME=/opt/bea/alui/ptsearchserver/6.1
SEARCH_HOME=<path_to_search_home>
# Example:
#NODE=bla01app01s
NODE=<nodename>

# clean up
# Removing the contents of the index directory
rm -rf $SEARCH_HOME/$NODE/index/*
# Recreating the "1" subdirectory
mkdir $SEARCH_HOME/$NODE/index/1
# recreate stub
# Adding the "1" to the ready status text file
echo 1 > $SEARCH_HOME/$NODE/index/ready
cd $SEARCH_HOME/$NODE/index/1
# Reindex the search service
# NOTE!!! libicucc.so missing, so we export library path
#
export LD_LIBRARY_PATH=/lib:/usr/lib:/opt/bea/alui/ptsearchserver/6.1/lib/native/
../../../bin/native/emptyarchive lexicon archive
../../../bin/native/emptyarchive spell spell
# start up, will grab last index from /mnt.blabla and reindex

