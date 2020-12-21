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
make pull
```

Bring up the servers.
```
make stack-up
docker ps
```

Run botrunner.
```
BOTRUNNER_SCRIPT=river-action-3-bots.yaml make botrunner
BOTRUNNER_SCRIPT=river-action-2-bots-1-human.yaml make botrunner
BOTRUNNER_SCRIPT=play-many-hands.yaml make botrunner

# You can disable nats messages using PRINT_GAME_MSG and PRINT_HAND_MSG variables.
BOTRUNNER_SCRIPT=river-action-3-bots.yaml PRINT_GAME_MSG=false PRINT_HAND_MSG=false make botrunner
```

Bring down the servers and clean up data.
```
make stack-down && make stack-clean
```
