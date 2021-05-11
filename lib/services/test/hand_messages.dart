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

String runItTwiceMessage() => '''
{
	"clubId": 1,
	"gameId": "1620286504",
	"gameCode": "1620286504",
	"handNum": 1,
	"messageId": "RIT_CONFIRM:1:RESULT:0:",
	"handStatus": "RESULT",
	"messages": [{
		"messageType": "RUN_IT_TWICE",
		"runItTwice": {
			"board1": [200, 196, 8, 132, 33],
			"board2": [72, 84, 40, 100, 97],
			"stage": "PREFLOP",
			"seatsPots": [{
				"seats": [5, 8],
				"pot": 100
			}],
			"seat1": 5,
			"seat2": 8
		}
	}, {
		"messageType": "RESULT",
		"handResult": {
			"gameId": "1620286504",
			"handNum": 1,
			"gameType": "HOLDEM",
			"handLog": {
				"preflopActions": {
					"pot": 100,
					"actions": [{
						"seatNo": 5,
						"amount": 1,
						"stack": 49
					}, {
						"seatNo": 8,
						"action": "BB",
						"amount": 2,
						"stack": 48
					}, {
						"seatNo": 1,
						"action": "FOLD",
						"stack": 50
					}, {
						"seatNo": 5,
						"action": "ALLIN",
						"amount": 50
					}, {
						"seatNo": 8,
						"action": "ALLIN",
						"amount": 50
					}, {
						"seatNo": 5,
						"action": "RUN_IT_TWICE_YES"
					}, {
						"seatNo": 8,
						"action": "RUN_IT_TWICE_YES"
					}]
				},
				"flopActions": {},
				"turnActions": {},
				"riverActions": {},
				"potWinners": {
					"0": {
						"hiWinners": [{
							"seatNo": 5,
							"amount": 50,
							"winningCards": [200, 196, 132, 178, 164],
							"winningCardsStr": "[ A♣  A♦  T♦  K❤  Q♦ ]",
							"rankStr": "Pair",
							"rank": 3327,
							"playerCards": [178, 164],
							"boardCards": [200, 196, 132]
						}]
					}
				},
				"wonAt": "SHOW_DOWN",
				"handStartedAt": "1620286504",
				"handEndedAt": "1620286506",
				"runItTwice": true,
				"runItTwiceResult": {
					"runItTwiceStartedAt": "PREFLOP",
					"board1Winners": {
						"0": {
							"hiWinners": [{
								"seatNo": 5,
								"amount": 50,
								"winningCards": [200, 196, 132, 178, 164],
								"winningCardsStr": "[ A♣  A♦  T♦  K❤  Q♦ ]",
								"rankStr": "Pair",
								"rank": 3327,
								"playerCards": [178, 164],
								"boardCards": [200, 196, 132]
							}]
						}
					},
					"board2Winners": {
						"0": {
							"hiWinners": [{
								"seatNo": 8,
								"amount": 50,
								"winningCards": [72, 84, 100, 97, 81],
								"winningCardsStr": "[ 6♣  7♦  8♦  8♠  7♠ ]",
								"rankStr": "Two Pair",
								"rank": 3101,
								"playerCards": [81],
								"boardCards": [72, 84, 100, 97]
							}]
						}
					}
				}
			},
			"boardCards": [200, 196, 8, 132, 33],
			"boardCards2": [72, 84, 40, 100, 97],
			"flop": [200, 196, 8],
			"turn": 132,
			"river": 33,
			"players": {
				"1": {
					"id": "1",
					"playedUntil": "PREFLOP",
					"balance": {
						"before": 50,
						"after": 50
					}
				},
				"5": {
					"id": "2",
					"cards": [178, 164],
					"bestCards": [84, 100, 97, 178, 164],
					"rank": 4704,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 50,
						"after": 50
					},
					"hhRank": 4294967295,
					"received": 50
				},
				"8": {
					"id": "3",
					"cards": [17, 81],
					"bestCards": [72, 84, 100, 97, 81],
					"rank": 3101,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 50,
						"after": 50
					},
					"hhRank": 4294967295,
					"received": 50
				}
			},
			"playerStats": {
				"1": {
					"inPreflop": true
				},
				"2": {
					"preflopRaise": true,
					"threeBet": true,
					"allin": true,
					"wentToShowdown": true,
					"wonChipsAtShowdown": true,
					"headsup": true,
					"headsupPlayer": "3",
					"wonHeadsup": true,
					"inPreflop": true
				},
				"3": {
					"allin": true,
					"wentToShowdown": true,
					"headsup": true,
					"headsupPlayer": "2",
					"inPreflop": true
				}
			},
			"handStats": {
				"endedAtShowdown": true
			},
			"runItTwice": true
		}
	}, {
		"messageType": "END"
	}]
}''';
