#!/bin/bash

# Curl script that calls existing curl script with JSON header
curl -H "Content-Type: application/json" "$@"
