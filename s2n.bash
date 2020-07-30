#!/usr/bin/env bash

cp $($(nix-build --no-link -A stack2nix-script s2n.nix)) ./stack2nix-output.nix
