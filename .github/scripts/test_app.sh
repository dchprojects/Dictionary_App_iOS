#!/bin/bash

set -eo pipefail

xcodebuild -workspace MyDictionary_App_Swift.xcworkspace \
            -scheme MyDictionary_App_Swift \
            -destination platform=iOS\ Simulator,OS=13.3,name=iPhone\ 11 \
            clean test | xcpretty