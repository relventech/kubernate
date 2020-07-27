#!/bin/bash
sed "s/tagVersion/$1/g" pods.yml > kubernates-pod.yml
