#!/usr/bin/env bash

balena-rcon () {
  mcrcon -t -H localhost -P 25575 -p balena
}
