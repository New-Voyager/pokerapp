# pokerapp

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Testing with bot runner

Download the server images.
```
make pullver is 
```

Bring up the servers.
```
make stack-up
docker ps
```

Run botrunner.
```
BOTRUNNER_SCRIPT=botrunner_scripts/river-action-3-bots.yaml make botrunner
        Club Owner: c2dc2c3d-13da-46cc-8c66-caa0c77459de
        Club Player: 4b93e2be-7992-45c3-a2dd-593c2f708cb7
BOTRUNNER_SCRIPT=botrunner_scripts/river-action-2-bots-1-human.yaml make botrunner
BOTRUNNER_SCRIPT=botrunner_scripts/play-many-hands.yaml make botrunner
BOTRUNNER_SCRIPT=botrunner_scripts/3-bots-reward-tracking.yaml make botrunner

Use the following commands to run 4-card PLO
BOTRUNNER_SCRIPT=botrunner_scripts/plo-many-hands.yaml make botrunner

# You can disable nats messages using PRINT_GAME_MSG and PRINT_HAND_MSG variables.
BOTRUNNER_SCRIPT=botrunner_scripts/river-action-3-bots.yaml PRINT_GAME_MSG=false PRINT_HAND_MSG=false make botrunner
```

Bring down the servers and clean up data.
```
make stack-down && make stack-clean
```

## Run the project on a physical device (Android).
Enable USB debugging on your phone (https://developer.android.com/studio/debug/dev-options).

Connect the phone to your PC via USB cable.

Verify your phone is recognized in `adb devices` command.
```
$ adb devices

List of devices attached
01000b1c7c6ecbb5        device
```

On the Android Studio, your phone should now show up 
on the devices drop-down along with the emulator.

Select your phone on the devices drop-down then Run main.dart.


## To build for test releases
flutter build  apk  --release --split-per-abi
Upload token: qf4U9aqAL4RLK3oMJdEhAIkTWfgYT3qVAwOaxYIiEY
https://www.diawi.com/

curl https://upload.diawi.com/ -F token='qf4U9aqAL4RLK3oMJdEhAIkTWfgYT3qVAwOaxYIiEY' \
-F file=@build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk

## To run from command line

# dev
flutter run --flavor dev -t lib/main_dev.dart

# test
flutter run --flavor testFlavor -t lib/main_test.dart

# prod
flutter run --flavor prod -t lib/main_prod1.dart
