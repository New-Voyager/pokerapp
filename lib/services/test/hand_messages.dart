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
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 2,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 3,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 4,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 5,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 6,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 7,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},
	{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 8,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	},
	{
		"messageType": "PLAYER_ACTED",
		"playerActed": {
			"seatNo": 9,
			"action": "FOLD",
			"amount": 0,
			"timedOut": false,
			"actionTime": 0,
			"stack": 58
		}
	}]
}
''';

String get reloadStackMessage => '''
 {"gameCode":"cgkmtdhya","messageType":"STACK_RELOADED",
    "playerId":"3","oldStack":1036,"newStack":1136,"reloadAmount":100,"status":"PLAYING"}
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

String newGameAnnouncement() => '''
{
	"version": "",
	"clubId": 456,
	"gameId": "574",
	"gameCode": "CG-QRR0QFQAPDXJ4D4",
	"handNum": 1,
	"seatNo": 0,
	"playerId": "0",
	"messageId": "ANNOUNCEMENT:1:DEAL:0:",
	"gameToken": "",
	"handStatus": "DEAL",
	"messages": [{
		"messageType": "ANNOUNCEMENT",
		"announcement": {
			"type": "NewGameType",
			"params": ["HOLDEM"]
		}
	}]
}''';

String dealerChoiceMessage() => '''
{
	"version": "1.0",
	"gameCode": "CG-W9PFBTYON2G2Q2M",
	"playerId": "6026",
	"gameToken": "",
	"messageId": "DEALERCHOICE:1621057258053",
	"messages": [{
		"messageType": "DEALER_CHOICE",
		"dealerChoice": {
			"playerId": "6026",
			"games": [1, 2, 3, 4, 5],
      "timeout": 10
		}
	}]
}''';

String lastHandResult = '''
{
	"hand": {
		"data": {
			"gameId": "448",
			"handNum": 65,
			"gameType": "HOLDEM",
			"noCards": 2,
			"handLog": {
				"preflopActions": {
					"potStart": 0,
					"pots": [],
					"actions": [{
						"seatNo": 2,
						"action": "SB",
						"amount": 1,
						"timedOut": false,
						"actionTime": 0,
						"stack": 115
					}, {
						"seatNo": 3,
						"action": "BB",
						"amount": 2,
						"timedOut": false,
						"actionTime": 0,
						"stack": 214
					}, {
						"seatNo": 4,
						"action": "CALL",
						"amount": 2,
						"timedOut": false,
						"actionTime": 0,
						"stack": 210
					}, {
						"seatNo": 1,
						"action": "CALL",
						"amount": 2,
						"timedOut": false,
						"actionTime": 25,
						"stack": 14
					}, {
						"seatNo": 2,
						"action": "CALL",
						"amount": 2,
						"timedOut": false,
						"actionTime": 0,
						"stack": 114
					}, {
						"seatNo": 3,
						"action": "CHECK",
						"amount": 2,
						"timedOut": false,
						"actionTime": 0,
						"stack": 214
					}]
				},
				"flopActions": {
					"potStart": 8,
					"pots": [8],
					"actions": [{
						"seatNo": 2,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 114
					}, {
						"seatNo": 3,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 214
					}, {
						"seatNo": 4,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 210
					}, {
						"seatNo": 1,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 5,
						"stack": 14
					}]
				},
				"turnActions": {
					"potStart": 8,
					"pots": [8],
					"actions": [{
						"seatNo": 2,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 114
					}, {
						"seatNo": 3,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 214
					}, {
						"seatNo": 4,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 210
					}, {
						"seatNo": 1,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 4,
						"stack": 14
					}]
				},
				"riverActions": {
					"potStart": 8,
					"pots": [8],
					"actions": [{
						"seatNo": 2,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 114
					}, {
						"seatNo": 3,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 214
					}, {
						"seatNo": 4,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 0,
						"stack": 210
					}, {
						"seatNo": 1,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 6,
						"stack": 14
					}]
				},
				"potWinners": {
					"0": {
						"potNo": 0,
						"amount": 8,
						"hiWinners": [{
							"seatNo": 4,
							"loCard": false,
							"amount": 8,
							"winningCards": [1, 2, 178, 177, 116],
							"winningCardsStr": "[ 2♠  2❤  K❤  K♠  9♦ ]",
							"rankStr": "Two Pair",
							"rank": 2714,
							"playerCards": [177, 116],
							"boardCards": [1, 2, 178]
						}],
						"lowWinners": [],
						"pauseTime": 3000
					}
				},
				"wonAt": "SHOW_DOWN",
				"showDown": null,
				"handStartedAt": "1623085004",
				"handEndedAt": "1623085053",
				"runItTwice": false,
				"runItTwiceResult": null
			},
			"rewardTrackingIds": [],
			"boardCards": [1, 88, 2, 100, 178],
			"boardCards2": [],
			"flop": [1, 88, 2],
			"turn": 100,
			"river": 178,
			"players": {
				"1": {
					"id": "1567",
					"cards": [146, 97],
					"bestCards": [1, 2, 100, 178, 97],
					"rank": 3151,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 16,
						"after": 14
					},
					"hhCards": [146, 97, 1, 2, 100],
					"hhRank": 3153,
					"received": 0,
					"rakePaid": 0
				},
				"2": {
					"id": "1549",
					"cards": [152, 65],
					"bestCards": [1, 2, 100, 178, 152],
					"rank": 6032,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 116,
						"after": 114
					},
					"hhCards": [152, 65, 1, 2, 178],
					"hhRank": 6034,
					"received": 0,
					"rakePaid": 0
				},
				"3": {
					"id": "1550",
					"cards": [82, 113],
					"bestCards": [1, 88, 2, 178, 82],
					"rank": 3206,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 216,
						"after": 214
					},
					"hhCards": [82, 113, 1, 88, 2],
					"hhRank": 3210,
					"received": 0,
					"rakePaid": 0
				},
				"4": {
					"id": "1551",
					"cards": [177, 116],
					"bestCards": [1, 2, 178, 177, 116],
					"rank": 2714,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 212,
						"after": 218
					},
					"hhCards": [177, 116, 1, 2, 178],
					"hhRank": 2714,
					"received": 8,
					"rakePaid": 0
				}
			},
			"rakeCollected": 0,
			"highHand": null,
			"playerStats": {
				"1549": {
					"preflopRaise": false,
					"postflopRaise": false,
					"threeBet": false,
					"cbet": false,
					"vpip": true,
					"allin": false,
					"wentToShowdown": true,
					"wonChipsAtShowdown": false,
					"headsup": false,
					"headsupPlayer": "0",
					"wonHeadsup": false,
					"badbeat": false,
					"inPreflop": true,
					"inFlop": true,
					"inTurn": true,
					"inRiver": true
				},
				"1550": {
					"preflopRaise": false,
					"postflopRaise": false,
					"threeBet": false,
					"cbet": false,
					"vpip": false,
					"allin": false,
					"wentToShowdown": true,
					"wonChipsAtShowdown": false,
					"headsup": false,
					"headsupPlayer": "0",
					"wonHeadsup": false,
					"badbeat": false,
					"inPreflop": true,
					"inFlop": true,
					"inTurn": true,
					"inRiver": true
				},
				"1551": {
					"preflopRaise": false,
					"postflopRaise": false,
					"threeBet": false,
					"cbet": false,
					"vpip": true,
					"allin": false,
					"wentToShowdown": true,
					"wonChipsAtShowdown": true,
					"headsup": false,
					"headsupPlayer": "0",
					"wonHeadsup": false,
					"badbeat": false,
					"inPreflop": true,
					"inFlop": true,
					"inTurn": true,
					"inRiver": true
				},
				"1567": {
					"preflopRaise": false,
					"postflopRaise": false,
					"threeBet": false,
					"cbet": false,
					"vpip": true,
					"allin": false,
					"wentToShowdown": true,
					"wonChipsAtShowdown": false,
					"headsup": false,
					"headsupPlayer": "0",
					"wonHeadsup": false,
					"badbeat": false,
					"inPreflop": true,
					"inFlop": true,
					"inTurn": true,
					"inRiver": true
				}
			},
			"handStats": {
				"endedAtPreflop": false,
				"endedAtFlop": false,
				"endedAtTurn": false,
				"endedAtRiver": false,
				"endedAtShowdown": true
			},
			"runItTwice": false,
			"smallBlind": 1,
			"bigBlind": 2,
			"ante": 0,
			"maxPlayers": 4
		}
	},
	"myInfo": {
		"id": 1567,
		"name": "ww",
		"uuid": "dc1f43114b41f55e"
	}
}
''';

String testResultMessage = '''
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
    "messages": [
{
	"messageType": "RESULT",
	"handResult": {
			"gameId": "14",
			"handNum": 1,
			"gameType": "HOLDEM",
			"noCards": 2,
			"handLog": {
				"preflopActions": {
					"potStart": 0,
					"pots": [],
					"actions": [{
						"seatNo": 2,
						"action": "SB",
						"amount": 1,
						"timedOut": false,
						"actionTime": 0,
						"stack": 29
					}, {
						"seatNo": 1,
						"action": "BB",
						"amount": 2,
						"timedOut": false,
						"actionTime": 0,
						"stack": 28
					}, {
						"seatNo": 2,
						"action": "CALL",
						"amount": 2,
						"timedOut": false,
						"actionTime": 1,
						"stack": 28
					}, {
						"seatNo": 1,
						"action": "CHECK",
						"amount": 2,
						"timedOut": false,
						"actionTime": 3,
						"stack": 28
					}],
					"seatsPots": []
				},
				"flopActions": {
					"potStart": 4,
					"pots": [4],
					"actions": [{
						"seatNo": 2,
						"action": "BET",
						"amount": 4,
						"timedOut": false,
						"actionTime": 4,
						"stack": 24
					}, {
						"seatNo": 1,
						"action": "CALL",
						"amount": 4,
						"timedOut": false,
						"actionTime": 2,
						"stack": 24
					}],
					"seatsPots": [{
						"seats": [1, 2],
						"pot": 4
					}]
				},
				"turnActions": {
					"potStart": 12,
					"pots": [12],
					"actions": [{
						"seatNo": 2,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 22,
						"stack": 24
					}, {
						"seatNo": 1,
						"action": "CHECK",
						"amount": 0,
						"timedOut": false,
						"actionTime": 16,
						"stack": 24
					}],
					"seatsPots": [{
						"seats": [1, 2],
						"pot": 12
					}]
				},
				"riverActions": {
					"potStart": 12,
					"pots": [12],
					"actions": [{
						"seatNo": 2,
						"action": "BET",
						"amount": 2,
						"timedOut": false,
						"actionTime": 5,
						"stack": 22
					}, {
						"seatNo": 1,
						"action": "CALL",
						"amount": 2,
						"timedOut": false,
						"actionTime": 8,
						"stack": 22
					}],
					"seatsPots": [{
						"seats": [1, 2],
						"pot": 12
					}]
				},
				"potWinners": {
					"0": {
						"potNo": 0,
						"amount": 16,
						"hiWinners": [{
							"seatNo": 2,
							"loCard": false,
							"amount": 16,
							"winningCards": [84, 184, 65, 81, 145],
							"winningCardsStr": "[ 7♦  K♣  6♠  7♠  J♠ ]",
							"rankStr": "Pair",
							"rank": 4933,
							"playerCards": [81, 145],
							"boardCards": [84, 184, 65]
						}],
						"lowWinners": [],
						"pauseTime": 3000
					}
				},
				"wonAt": "SHOW_DOWN",
				"showDown": null,
				"handStartedAt": "1627061352",
				"handEndedAt": "1627061422",
				"runItTwice": false,
				"runItTwiceResult": null,
				"seatsPotsShowdown": [{
					"seats": [1, 2],
					"pot": 16
				}]
			},
			"rewardTrackingIds": [],
			"boardCards": [4, 84, 184, 65, 40],
			"boardCards2": [],
			"flop": [4, 84, 184],
			"turn": 65,
			"river": 40,
			"players": {
				"1": {
					"id": "1",
					"cards": [100, 116],
					"bestCards": [84, 184, 65, 100, 116],
					"rank": 6938,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 30,
						"after": 22
					},
					"hhCards": [100, 116, 84, 184, 65],
					"hhRank": 6938,
					"received": 0,
					"rakePaid": 0
				},
				"2": {
					"id": "20",
					"cards": [81, 145],
					"bestCards": [84, 184, 65, 81, 145],
					"rank": 4933,
					"playedUntil": "SHOW_DOWN",
					"balance": {
						"before": 30,
						"after": 38
					},
					"hhCards": [81, 145, 84, 184, 65],
					"hhRank": 4933,
					"received": 16,
					"rakePaid": 0
				}
			},
			"rakeCollected": 0,
			"highHand": null,
			"playerStats": {
				"1": {
					"preflopRaise": false,
					"postflopRaise": false,
					"threeBet": false,
					"cbet": false,
					"vpip": false,
					"allin": false,
					"wentToShowdown": true,
					"wonChipsAtShowdown": false,
					"headsup": true,
					"headsupPlayer": "20",
					"wonHeadsup": false,
					"badbeat": false,
					"inPreflop": true,
					"inFlop": true,
					"inTurn": true,
					"inRiver": true,
					"consecutiveActionTimeouts": 0,
					"actedAtLeastOnce": true
				},
				"20": {
					"preflopRaise": false,
					"postflopRaise": true,
					"threeBet": false,
					"cbet": false,
					"vpip": true,
					"allin": false,
					"wentToShowdown": true,
					"wonChipsAtShowdown": true,
					"headsup": true,
					"headsupPlayer": "1",
					"wonHeadsup": true,
					"badbeat": false,
					"inPreflop": true,
					"inFlop": true,
					"inTurn": true,
					"inRiver": true,
					"consecutiveActionTimeouts": 0,
					"actedAtLeastOnce": true
				}
			},
			"handStats": {
				"endedAtPreflop": false,
				"endedAtFlop": false,
				"endedAtTurn": false,
				"endedAtRiver": false,
				"endedAtShowdown": true
			},
			"runItTwice": false,
			"smallBlind": 1,
			"bigBlind": 2,
			"ante": 0,
			"maxPlayers": 2
		}
}]
}''';
