#!/usr/bin/env bash
DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$DIR"
source .envrc
overmind start
