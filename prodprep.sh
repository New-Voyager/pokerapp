#!/bin/sh
mkdir -p ios/config/prod
cp ../devops/pokerapp/GoogleService-Info.plist ios/config/prod/
cp ../devops/pokerapp/google-services.json android/app/src/prod/
cp ../devops/pokerapp/upload-keystore.jks android/app
