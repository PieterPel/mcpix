#!/usr/bin/env bash

set -euo pipefail

SYSTEM=$(nix eval --raw nixpkgs#system)
nix build "./tests/integration#homeConfigurations.$SYSTEM.test-user.activationPackage"