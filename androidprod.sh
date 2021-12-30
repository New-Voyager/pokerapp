#!/bin/sh
flutter build apk --release --flavor prod -t lib/main.dart --split-per-abi
