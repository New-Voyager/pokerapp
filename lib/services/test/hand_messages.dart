String newHandMessage() => '''
  {
    "version": "",
    "clubId": 244,
    "gameId": "255",
    "gameCode": "CG-J24H8I6GRRMYG62",
    "handNum": 1,
    "seatNo": 0,
    "playerId": "0",
    "messageId": "",
    "gameToken": "",
    "handStatus": "PREFLOP",
    "messages": [{
      "messageType": "NEW_HAND",
      "newHand": {
        "handNum": 1,
        "buttonPos": 1,
        "sbPos": 2,
        "bbPos": 3,
        "nextActionSeat": 1,
        "playerCards": {},
        "gameType": "HOLDEM",
        "noCards": 2,
        "smallBlind": 1,
        "bigBlind": 2,
        "bringIn": 0,
        "straddle": 4,
        "pause": 0,
        "playersInSeats": {
          "1": {
            "playerId": "1",
            "name": "yong",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "2021-04-30T08:07:55.000Z",
            "breakExpTime": ""
          },
          "2": {
            "playerId": "2",
            "name": "brian",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          },
          "3": {
            "playerId": "3",
            "name": "tom",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          },
          "4": {
            "playerId": "4",
            "name": "jim",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          },
          "5": {
            "playerId": "5",
            "name": "rob",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "2021-04-30T08:07:56.000Z",
            "breakExpTime": ""
          },
          "6": {
            "playerId": "6",
            "name": "john",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          },
          "7": {
            "playerId": "7",
            "name": "michael",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          },
          "8": {
            "playerId": "8",
            "name": "bill",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "2021-04-30T08:07:56.000Z",
            "breakExpTime": ""
          },
          "9": {
            "playerId": "9",
            "name": "s",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          }
        }
      }
    }]
  }
''';

String dealCardsMessage() => '''
{
	"clubId": 244,
	"gameId": "255",
	"playerId": "2322",
	"messages": [{
		"messageType": "DEAL",
		"dealCards": {
			"seatNo": 1,
			"cards": "370",
			"cardsStr": "[ 9❤  2♠ ]"
		}
	}]
}
''';

String dealStartedMessage() => '''
  {
    "version": "",
    "clubId": 244,
    "gameId": "255",
    "gameCode": "CG-J24H8I6GRRMYG62",
    "handNum": 1,
    "seatNo": 0,
    "playerId": "0",
    "messageId": "",
    "gameToken": "",
    "handStatus": "PREFLOP",
    "messages": [{
      "messageType": "DEAL_STARTED"
    }]
  }
''';

String yourActionNextActionMsg() => '''
{
	"version": "",
	"clubId": 244,
	"gameId": "255",
	"gameCode": "CG-J24H8I6GRRMYG62",
	"handNum": 1,
	"seatNo": 0,
	"playerId": "0",
	"messageId": "",
	"gameToken": "",
	"handStatus": "PREFLOP",
	"messages": [{
		"messageType": "YOUR_ACTION",
		"seatAction": {
			"seatNo": 1,
			"availableActions": ["FOLD", "STRADDLE", "CALL", "BET", "ALLIN"],
			"straddleAmount": 4,
			"callAmount": 2,
			"raiseAmount": 0,
			"minBetAmount": 0,
			"maxBetAmount": 0,
			"minRaiseAmount": 4,
			"maxRaiseAmount": 100,
			"allInAmount": 100,
			"betOptions": [{
				"text": "3BB",
				"amount": 6
			}, {
				"text": "5BB",
				"amount": 10
			}, {
				"text": "10BB",
				"amount": 20
			}, {
				"text": "All-In",
				"amount": 100
			}]
		}
	}, {
		"messageType": "NEXT_ACTION",
		"actionChange": {
			"seatNo": 1,
			"pots": [0],
			"potUpdates": 3,
			"seatsPots": [{
				"seats": [],
				"pot": 0
			}]
		}
	}]
}
''';

String flopMessage() => '''
{
	"version": "",
	"clubId": 244,
	"gameId": "255",
	"gameCode": "CG-J24H8I6GRRMYG62",
	"handNum": 1,
	"seatNo": 0,
	"playerId": "0",
	"messageId": "ACTION:1:FLOP:2324:1",
	"gameToken": "",
	"handStatus": "FLOP",
	"messages": [{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 8,
			"action": "CHECK",
			"amount": 2,
			"timedOut": false,
			"actionTime": 0,
			"stack": 98
		}
	}, {
		"messageType": "FLOP",
		"flop": {
			"board": [200, 196, 8],
			"cardsStr": "[ A♣  A♦  2♣ ]",
			"pots": [6],
			"seatsPots": [{
				"seats": [1, 5, 8],
				"pot": 6
			}],
			"playerBalance": {
				"1": 98,
				"2": 0,
				"3": 0,
				"4": 0,
				"5": 98,
				"6": 0,
				"7": 0,
				"8": 98,
				"9": 0
			}
		}
	}, {
		"messageType": "YOUR_ACTION",
		"seatAction": {
			"seatNo": 5,
			"availableActions": ["FOLD", "CHECK", "BET", "ALLIN"],
			"straddleAmount": 0,
			"callAmount": 0,
			"raiseAmount": 0,
			"minBetAmount": 0,
			"maxBetAmount": 0,
			"minRaiseAmount": 2,
			"maxRaiseAmount": 98,
			"allInAmount": 98,
			"betOptions": [{
				"text": "50%",
				"amount": 3
			}, {
				"text": "100%",
				"amount": 6
			}, {
				"text": "All-In",
				"amount": 98
			}]
		}
	}, {
		"messageType": "NEXT_ACTION",
		"actionChange": {
			"seatNo": 5,
			"pots": [6],
			"potUpdates": 0,
			"seatsPots": [{
				"seats": [1, 5, 8],
				"pot": 6
			}]
		}
	}]
}
''';


String foldMessage() => '''
{
	"version": "",
	"clubId": 1,
	"gameId": "1",
	"gameCode": "CG-R7T5F6PQYPL857",
	"handNum": 54,
	"seatNo": 0,
	"playerId": "0",
	"messageId": "ACTION:54:PREFLOP:7:200",
	"gameToken": "",
	"handStatus": "PREFLOP",
	"messages": [{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 1,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	}, {
		"messageType": "YOUR_ACTION",
		"seatAction": {
			"seatNo": 8,
			"availableActions": ["FOLD", "CALL", "RAISE", "ALLIN"],
			"straddleAmount": 0,
			"callAmount": 30,
			"raiseAmount": 0,
			"minBetAmount": 0,
			"maxBetAmount": 0,
			"minRaiseAmount": 58,
			"maxRaiseAmount": 152,
			"allInAmount": 152,
			"betOptions": [{
				"text": "2x",
				"amount": 116
			}, {
				"text": "All-In",
				"amount": 152
			}]
		}
	}, {
		"messageType": "NEXT_ACTION",
		"actionChange": {
			"seatNo": 8,
			"pots": [0],
			"potUpdates": 41,
			"seatsPots": [{
				"seats": [],
				"pot": 0
			}]
		}
	}]
}
''';