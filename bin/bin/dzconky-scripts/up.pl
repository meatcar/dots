#!/bin/bash
UPS="$(yaourt -Qu | wc -l)"
echo $UPS
