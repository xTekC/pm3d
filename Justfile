#!/bin/just

##########################################
#        Copyright (c) xTekC.            #
#        Licensed under MPL-2.0.         #
#        See LICENSE for details.        #
# https://www.mozilla.org/en-US/MPL/2.0/ #
##########################################

_default:
  clear && just --list --unsorted

# Watch with fmt and clippy
w:
    clear
    @cargo watch -x "cargo fmt --all && cargo clippy --locked --all-targets"

# Build debug profile
b:
    clear
    @cargo build

# Run debug profile
r:
    clear
    @cargo run

# Format and Lint
fl:
    clear
    @cargo fmt --all
    @cargo clippy --locked --all-targets

# Test all
t:
    clear
    @cargo test

# Update locked Dependencies
u:
    clear
    @cargo update

# Clean build artifacts and Cargo.lock
c:
    clear
    @rm -rf target/ || clear
    @rm Cargo.lock || clear

# Create a new release
rel version:
    sh scripts/release.sh {{ version }}
