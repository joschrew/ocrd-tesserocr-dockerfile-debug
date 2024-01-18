#!/bin/bash

# undo all changes to the example data
dir="data"
git -C $dir clean -fd
git -C $dir restore .
