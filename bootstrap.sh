#!/bin/sh

IDETemplateMacrosTarget=".swiftpm/xcode/package.xcworkspace/xcshareddata/IDETemplateMacros.plist"
IDETemplateMacrosSource="./IDETemplateMacros.plist"

# Copy template for new files to include copyright header.
cp $IDETemplateMacrosSource $IDETemplateMacrosTarget
