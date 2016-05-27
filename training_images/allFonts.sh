#! /bin/sh

cat test_index.txt training_index.txt | cut -c 19- | sed -e "s/-[-0-9].*//" | sort -u
