#!/bin/sh
set -e

response=$(sh -c " $*")

echo "::set-output name=response::$response"