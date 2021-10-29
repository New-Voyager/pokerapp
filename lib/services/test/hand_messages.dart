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
            "name": "young",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "2021-04-30T08:07:55.000Z",
            "breakExpTime": ""
          },
          "2": {
            "playerId": "2",
            "name": "carol",
            "status": "PLAYING",
            "stack": 100,
            "round": "DEAL",
            "playerReceived": 0,
            "buyInExpTime": "",
            "breakExpTime": ""
          },
          "3": {
            "playerId": "3",
            "name": "matt",
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

String handResult2MultiPot = '''
{
	"activeSeats": [1, 2, 3, 4],
	"wonAt": "SHOW_DOWN",
	"boards": [{
		"boardNo": 1,
		"cards": [200, 196, 8, 132, 33],
		"playerRank": {
			"4": {
				"boardNo": 1,
				"seatNo": 4,
				"hiRank": 2501,
				"hiCards": [200, 196, 132, 130, 177]
			},
			"1": {
				"boardNo": 1,
				"seatNo": 1,
				"hiRank": 2592,
				"hiCards": [200, 196, 8, 132, 1]
			},
			"2": {
				"boardNo": 1,
				"seatNo": 2,
				"hiRank": 3327,
				"hiCards": [200, 196, 132, 178, 164]
			},
			"3": {
				"boardNo": 1,
				"seatNo": 3,
				"hiRank": 3477,
				"hiCards": [200, 196, 132, 33, 81]
			}
		}
	}],
	"potWinners": [{
		"amount": 400.0,
		"boardWinners": [{
			"boardNo": 1,
			"amount": 400.0,
			"hiWinners": {
				"4": {
					"seatNo": 4,
					"amount": 398.0
				}
			},
			"hiRankText": "Two Pair"
		}]
	}, {
		"potNo": 1,
		"amount": 300.0,
		"boardWinners": [{
			"boardNo": 1,
			"amount": 300.0,
			"hiWinners": {
				"4": {
					"seatNo": 4,
					"amount": 298.0
				}
			},
			"hiRankText": "Two Pair"
		}]
	}, {
		"potNo": 2,
		"amount": 200.0,
		"boardWinners": [{
			"boardNo": 1,
			"amount": 200.0,
			"hiWinners": {
				"4": {
					"seatNo": 4,
					"amount": 199.0
				}
			},
			"hiRankText": "Two Pair"
		}]
	}],
	"pauseTimeSecs": 5000,
	"playerInfo": {
		"1": {
			"id": "6198",
			"balance": {
				"before": 100.0
			}
		},
		"2": {
			"id": "6199",
			"balance": {
				"before": 200.0
			}
		},
		"3": {
			"id": "6200",
			"balance": {
				"before": 300.0
			}
		},
		"4": {
			"id": "6207",
			"balance": {
				"before": 400.0,
				"after": 995.0
			},
			"rakePaid": 5.0
		}
	},
	"playerStats": {
		"6200": {
			"allin": true,
			"wentToShowdown": true,
			"inPreflop": true,
			"inFlop": true,
			"inTurn": true,
			"inRiver": true,
			"actedAtLeastOnce": true
		},
		"6207": {
			"vpip": true,
			"allin": true,
			"wentToShowdown": true,
			"wonChipsAtShowdown": true,
			"inPreflop": true,
			"inFlop": true,
			"inTurn": true,
			"inRiver": true,
			"actedAtLeastOnce": true
		},
		"6198": {
			"postflopRaise": true,
			"vpip": true,
			"allin": true,
			"wentToShowdown": true,
			"inPreflop": true,
			"inFlop": true,
			"inTurn": true,
			"inRiver": true,
			"actedAtLeastOnce": true
		},
		"6199": {
			"vpip": true,
			"allin": true,
			"wentToShowdown": true,
			"inPreflop": true,
			"inFlop": true,
			"inTurn": true,
			"inRiver": true,
			"actedAtLeastOnce": true
		}
	},
	"handNum": 1
}
''';

String multiPotV2Message = '''
{
	"2": [1, 2],
	"3": 6,
	"4": [{
		"1": 1,
		"2": [200, 196, 8, 132, 33],
		"3": [{
			"1": 1,
			"2": {
				"1": 1,
				"2": 1,
				"3": 2592,
				"4": [200, 196, 8, 132, 1]
			}
		}, {
			"1": 2,
			"2": {
				"1": 1,
				"2": 2,
				"3": 3327,
				"4": [200, 196, 132, 178, 164]
			}
		}]
	}],
	"5": [{
		"2": 302.0,
		"3": [{
			"2": 1,
			"3": 302.0,
			"4": [{
				"1": 1,
				"2": {
					"1": 1,
					"2": 297.0
				}
			}],
			"6": "Two Pair"
		}]
	}],
	"6": 5000,
	"7": [{
		"1": 1,
		"2": {
			"1": "6198",
			"6": {
				"1": 100.0,
				"2": 297.0
			},
			"10": 5.0
		}
	}, {
		"1": 2,
		"2": {
			"1": "6199",
			"6": {
				"1": 200.0,
				"2": 100.0
			}
		}
	}, {
		"1": 3,
		"2": {
			"1": "6200",
			"6": {
				"1": 300.0,
				"2": 298.0
			}
		}
	}, {
		"1": 4,
		"2": {
			"1": "6207",
			"6": {
				"1": 400.0,
				"2": 300.0
			}
		}
	}],
	"9": [{
		"1": "6207",
		"2": {
			"4": true,
			"13": true,
			"14": true,
			"15": true,
			"17": 1,
			"18": true
		}
	}, {
		"1": "6198",
		"2": {
			"2": true,
			"4": true,
			"6": true,
			"7": true,
			"8": true,
			"9": true,
			"10": "6199",
			"11": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6199",
		"2": {
			"4": true,
			"6": true,
			"7": true,
			"9": true,
			"10": "6198",
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6200",
		"2": {
			"13": true,
			"14": true,
			"17": 3
		}
	}],
	"10": 1
}
''';

String bombPotJsonMsg = '''
{
	"activeSeats": [1, 2],
	"wonAt": "SHOW_DOWN",
	"boards": [{
		"boardNo": 1,
		"cards": [200, 196, 8, 132, 33],
		"playerRank": {
			"1": {
				"boardNo": 1,
				"seatNo": 1,
				"hiRank": 2592,
				"hiCards": [200, 196, 8, 132, 1]
			},
			"2": {
				"boardNo": 1,
				"seatNo": 2,
				"hiRank": 3327,
				"hiCards": [200, 196, 132, 178, 164]
			}
		}
	}, {
		"boardNo": 2,
		"cards": [104, 36, 72, 84, 177],
		"playerRank": {
			"1": {
				"boardNo": 2,
				"seatNo": 1,
				"hiRank": 6938,
				"hiCards": [104, 72, 84, 177, 114]
			},
			"2": {
				"boardNo": 2,
				"seatNo": 2,
				"hiRank": 3625,
				"hiCards": [104, 84, 177, 178, 164]
			}
		}
	}],
	"potWinners": [{
		"amount": 80.0,
		"boardWinners": [{
			"boardNo": 1,
			"amount": 40.0,
			"hiWinners": {
				"1": {
					"seatNo": 1,
					"amount": 38.0
				}
			},
			"hiRankText": "Two Pair"
		}, {
			"boardNo": 2,
			"amount": 40.0,
			"hiWinners": {
				"2": {
					"seatNo": 2,
					"amount": 38.0
				}
			},
			"hiRankText": "Pair"
		}]
	}],
	"pauseTimeSecs": 5000,
	"playerInfo": {
		"3": {
			"id": "6200",
			"balance": {
				"before": 100.0,
				"after": 88.0
			}
		},
		"1": {
			"id": "6198",
			"balance": {
				"before": 100.0,
				"after": 104.0
			},
			"rakePaid": 2.0
		},
		"2": {
			"id": "6199",
			"balance": {
				"before": 100.0,
				"after": 104.0
			},
			"rakePaid": 2.0
		}
	},
	"playerStats": {
		"6199": {
			"preflopRaise": true,
			"postflopRaise": true,
			"wentToShowdown": true,
			"wonChipsAtShowdown": true,
			"headsup": true,
			"headsupPlayer": "6198",
			"inPreflop": true,
			"inFlop": true,
			"inTurn": true,
			"inRiver": true,
			"actedAtLeastOnce": true
		},
		"6200": {
			"preflopRaise": true,
			"postflopRaise": true,
			"inPreflop": true,
			"inFlop": true,
			"actedAtLeastOnce": true
		},
		"6198": {
			"preflopRaise": true,
			"wentToShowdown": true,
			"wonChipsAtShowdown": true,
			"headsup": true,
			"headsupPlayer": "6199",
			"wonHeadsup": true,
			"inPreflop": true,
			"inFlop": true,
			"inTurn": true,
			"inRiver": true,
			"actedAtLeastOnce": true
		}
	},
	"handNum": 1
}
''';

String bombPotProtoMsg = '''
{
	"2": [1, 2],
	"3": 6,
	"4": [{
		"1": 1,
		"2": [200, 196, 8, 132, 33],
		"3": [{
			"1": 1,
			"2": {
				"1": 1,
				"2": 1,
				"3": 2592,
				"4": [200, 196, 8, 132, 1]
			}
		}, {
			"1": 2,
			"2": {
				"1": 1,
				"2": 2,
				"3": 3327,
				"4": [200, 196, 132, 178, 164]
			}
		}]
	}, {
		"1": 2,
		"2": [104, 36, 72, 84, 177],
		"3": [{
			"1": 2,
			"2": {
				"1": 2,
				"2": 2,
				"3": 3625,
				"4": [104, 84, 177, 178, 164]
			}
		}, {
			"1": 1,
			"2": {
				"1": 2,
				"2": 1,
				"3": 6938,
				"4": [104, 72, 84, 177, 114]
			}
		}]
	}],
	"5": [{
		"2": 80.0,
		"3": [{
			"2": 1,
			"3": 40.0,
			"4": [{
				"1": 1,
				"2": {
					"1": 1,
					"2": 38.0
				}
			}],
			"6": "Two Pair"
		}, {
			"2": 2,
			"3": 40.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 38.0
				}
			}],
			"6": "Pair"
		}]
	}],
	"6": 5000,
	"7": [{
		"1": 1,
		"2": {
			"1": "6231",
			"2": [114, 1],
			"5": 6,
			"6": {
				"1": 100.0,
				"2": 104.0
			},
			"9": 4.0,
			"10": 2.0
		}
	}, {
		"1": 2,
		"2": {
			"1": "6232",
			"2": [178, 164],
			"5": 6,
			"6": {
				"1": 100.0,
				"2": 104.0
			},
			"9": 4.0,
			"10": 2.0
		}
	}, {
		"1": 3,
		"2": {
			"1": "6233",
			"2": [17, 81],
			"5": 3,
			"6": {
				"1": 100.0,
				"2": 88.0
			},
			"9": -12.0
		}
	}],
	"9": [{
		"1": "6231",
		"2": {
			"1": true,
			"7": true,
			"8": true,
			"9": true,
			"10": "6232",
			"11": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6232",
		"2": {
			"1": true,
			"2": true,
			"7": true,
			"8": true,
			"9": true,
			"10": "6231",
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6233",
		"2": {
			"1": true,
			"2": true,
			"13": true,
			"14": true,
			"18": true
		}
	}],
	"10": 1
}
''';

String threePotsResultV2 = '''
{
	"2": [1, 2, 3, 4],
	"3": 6,
	"4": [{
		"1": 1,
		"2": [200, 196, 8, 132, 33],
		"3": [{
			"1": 4,
			"2": {
				"1": 1,
				"2": 4,
				"3": 2501,
				"4": [200, 196, 132, 130, 177]
			}
		}, {
			"1": 1,
			"2": {
				"1": 1,
				"2": 1,
				"3": 2592,
				"4": [200, 196, 8, 132, 1]
			}
		}, {
			"1": 2,
			"2": {
				"1": 1,
				"2": 2,
				"3": 3327,
				"4": [200, 196, 132, 178, 164]
			}
		}, {
			"1": 3,
			"2": {
				"1": 1,
				"2": 3,
				"3": 3477,
				"4": [200, 196, 132, 33, 81]
			}
		}]
	}],
	"5": [{
		"2": 400.0,
		"3": [{
			"2": 1,
			"3": 400.0,
			"4": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 398.0
				}
			}],
			"6": "Two Pair"
		}]
	}, {
		"1": 1,
		"2": 300.0,
		"3": [{
			"2": 1,
			"3": 300.0,
			"4": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 298.0
				}
			}],
			"6": "Two Pair"
		}]
	}, {
		"1": 2,
		"2": 200.0,
		"3": [{
			"2": 1,
			"3": 200.0,
			"4": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 199.0
				}
			}],
			"6": "Two Pair"
		}]
	}],
	"6": 5000,
	"7": [{
		"1": 1,
		"2": {
			"1": "6231",
			"2": [114, 1],
			"5": 6,
			"6": {
				"1": 100.0
			},
			"9": -100.0
		}
	}, {
		"1": 2,
		"2": {
			"1": "6232",
			"2": [178, 164],
			"5": 6,
			"6": {
				"1": 200.0
			},
			"9": -200.0
		}
	}, {
		"1": 3,
		"2": {
			"1": "6233",
			"2": [17, 81],
			"5": 6,
			"6": {
				"1": 300.0
			},
			"9": -300.0
		}
	}, {
		"1": 4,
		"2": {
			"1": "6240",
			"2": [130, 177],
			"5": 6,
			"6": {
				"1": 400.0,
				"2": 995.0
			},
			"9": 595.0,
			"10": 5.0
		}
	}],
	"9": [{
		"1": "6233",
		"2": {
			"6": true,
			"7": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6240",
		"2": {
			"4": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6231",
		"2": {
			"2": true,
			"4": true,
			"6": true,
			"7": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6232",
		"2": {
			"4": true,
			"6": true,
			"7": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}],
	"10": 1
}
''';

String holdemMultiplePotsMessage = '''
{
	"2": [1, 2, 3, 4],
	"3": 6,
	"4": [{
		"1": 1,
		"2": [200, 196, 8, 132, 33],
		"3": [{
			"1": 1,
			"2": {
				"1": 1,
				"2": 1,
				"3": 2592,
				"4": [200, 196, 8, 132, 1]
			}
		}, {
			"1": 2,
			"2": {
				"1": 1,
				"2": 2,
				"3": 3327,
				"4": [200, 196, 132, 178, 164]
			}
		}, {
			"1": 3,
			"2": {
				"1": 1,
				"2": 3,
				"3": 3477,
				"4": [200, 196, 132, 33, 81]
			}
		}, {
			"1": 4,
			"2": {
				"1": 1,
				"2": 4,
				"3": 1609,
				"4": [196, 8, 33, 49, 24]
			}
		}]
	}, {
		"1": 2,
		"2": [104, 36, 72, 84, 177],
		"3": [{
			"1": 3,
			"2": {
				"1": 2,
				"2": 3,
				"3": 4951,
				"4": [104, 72, 84, 177, 81]
			}
		}, {
			"1": 4,
			"2": {
				"1": 2,
				"2": 4,
				"3": 1606,
				"4": [104, 36, 72, 84, 49]
			}
		}, {
			"1": 1,
			"2": {
				"1": 2,
				"2": 1,
				"3": 6938,
				"4": [104, 72, 84, 177, 114]
			}
		}, {
			"1": 2,
			"2": {
				"1": 2,
				"2": 2,
				"3": 3625,
				"4": [104, 84, 177, 178, 164]
			}
		}]
	}],
	"5": [{
		"2": 200.0,
		"3": [{
			"2": 1,
			"3": 100.0,
			"4": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 99.0
				}
			}],
			"6": "Straight"
		}, {
			"2": 2,
			"3": 100.0,
			"4": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 99.0
				}
			}],
			"6": "Straight"
		}]
	}, {
		"1": 1,
		"2": 150.0,
		"3": [{
			"2": 1,
			"3": 75.0,
			"4": [{
				"1": 1,
				"2": {
					"1": 1,
					"2": 74.0
				}
			}],
			"6": "Two Pair"
		}, {
			"2": 2,
			"3": 75.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 74.0
				}
			}],
			"6": "Pair"
		}]
	}, {
		"1": 2,
		"2": 200.0,
		"3": [{
			"2": 1,
			"3": 100.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 99.0
				}
			}],
			"6": "Pair"
		}, {
			"2": 2,
			"3": 100.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 100.0
				}
			}],
			"6": "Pair"
		}]
	}],
	"6": 5000,
	"7": [{
		"1": 1,
		"2": {
			"1": "6376",
			"2": [114, 1],
			"5": 6,
			"6": {
				"1": 100.0,
				"2": 74.0
			},
			"9": -26.0,
			"10": 1.0
		}
	}, {
		"1": 2,
		"2": {
			"1": "6377",
			"2": [178, 164],
			"5": 6,
			"6": {
				"1": 200.0,
				"2": 273.0
			},
			"9": 73.0,
			"10": 2.0
		}
	}, {
		"1": 3,
		"2": {
			"1": "6378",
			"2": [17, 81],
			"5": 6,
			"6": {
				"1": 300.0,
				"2": 100.0
			},
			"9": -200.0
		}
	}, {
		"1": 4,
		"2": {
			"1": "6387",
			"2": [49, 24],
			"5": 6,
			"6": {
				"1": 50.0,
				"2": 198.0
			},
			"9": 148.0,
			"10": 2.0
		}
	}],
	"9": [{
		"1": "6387",
		"2": {
			"1": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6376",
		"2": {
			"1": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6377",
		"2": {
			"1": true,
			"2": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6378",
		"2": {
			"1": true,
			"2": true,
			"6": true,
			"7": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}],
	"10": 1
}
''';

String hiloMultiplePotsMessage = '''
{
	"2": [1, 2, 3, 4],
	"3": 6,
	"4": [{
		"1": 1,
		"2": [200, 196, 8, 52, 33],
		"3": [{
			"1": 1,
			"2": {
				"1": 1,
				"2": 1,
				"3": 2567,
				"4": [180, 36, 200, 196, 33],
				"6": 2147483647
			}
		}, {
			"1": 2,
			"2": {
				"1": 1,
				"2": 2,
				"3": 3332,
				"4": [178, 164, 200, 196, 52],
				"6": 2147483647
			}
		}, {
			"1": 3,
			"2": {
				"1": 1,
				"2": 3,
				"3": 3386,
				"4": [145, 168, 200, 196, 52],
				"5": true,
				"6": 79,
				"7": [200, 8, 33, 17, 81]
			}
		}, {
			"1": 4,
			"2": {
				"1": 1,
				"2": 4,
				"3": 1609,
				"4": [49, 24, 200, 8, 33],
				"5": true,
				"6": 31,
				"7": [200, 8, 33, 49, 24]
			}
		}]
	}, {
		"1": 2,
		"2": [104, 56, 72, 84, 177],
		"3": [{
			"1": 1,
			"2": {
				"1": 2,
				"2": 1,
				"3": 3710,
				"4": [114, 180, 104, 84, 177],
				"5": true,
				"6": 122,
				"7": [56, 72, 84, 1, 36]
			}
		}, {
			"1": 2,
			"2": {
				"1": 2,
				"2": 2,
				"3": 1604,
				"4": [116, 132, 104, 72, 84],
				"6": 2147483647
			}
		}, {
			"1": 3,
			"2": {
				"1": 2,
				"2": 3,
				"3": 4924,
				"4": [81, 168, 104, 84, 177],
				"5": true,
				"6": 244,
				"7": [104, 56, 72, 17, 81]
			}
		}, {
			"1": 4,
			"2": {
				"1": 2,
				"2": 4,
				"3": 1605,
				"4": [49, 113, 104, 72, 84],
				"5": true,
				"6": 244,
				"7": [104, 72, 84, 49, 24]
			}
		}]
	}],
	"5": [{
		"2": 200.0,
		"3": [{
			"2": 1,
			"3": 100.0,
			"4": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 49.0
				}
			}],
			"5": [{
				"1": 4,
				"2": {
					"1": 4,
					"2": 49.0
				}
			}],
			"6": "Straight"
		}, {
			"2": 2,
			"3": 100.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 49.0
				}
			}],
			"5": [{
				"1": 1,
				"2": {
					"1": 1,
					"2": 49.0
				}
			}],
			"6": "Straight"
		}]
	}, {
		"1": 1,
		"2": 150.0,
		"3": [{
			"2": 1,
			"3": 75.0,
			"4": [{
				"1": 1,
				"2": {
					"1": 1,
					"2": 37.0
				}
			}],
			"5": [{
				"1": 3,
				"2": {
					"1": 3,
					"2": 37.0
				}
			}],
			"6": "Two Pair"
		}, {
			"2": 2,
			"3": 75.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 38.0
				}
			}],
			"5": [{
				"1": 1,
				"2": {
					"1": 1,
					"2": 37.0
				}
			}],
			"6": "Straight"
		}]
	}, {
		"1": 2,
		"2": 200.0,
		"3": [{
			"2": 1,
			"3": 100.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 50.0
				}
			}],
			"5": [{
				"1": 3,
				"2": {
					"1": 3,
					"2": 50.0
				}
			}],
			"6": "Pair"
		}, {
			"2": 2,
			"3": 100.0,
			"4": [{
				"1": 2,
				"2": {
					"1": 2,
					"2": 50.0
				}
			}],
			"5": [{
				"1": 3,
				"2": {
					"1": 3,
					"2": 50.0
				}
			}],
			"6": "Straight"
		}]
	}],
	"6": 5000,
	"7": [{
		"1": 1,
		"2": {
			"1": "6376",
			"2": [114, 1, 180, 36],
			"5": 6,
			"6": {
				"1": 100.0,
				"2": 123.0
			},
			"9": 23.0,
			"10": 2.0
		}
	}, {
		"1": 2,
		"2": {
			"1": "6377",
			"2": [178, 164, 116, 132],
			"5": 6,
			"6": {
				"1": 200.0,
				"2": 187.0
			},
			"9": -13.0,
			"10": 1.0
		}
	}, {
		"1": 3,
		"2": {
			"1": "6378",
			"2": [17, 81, 145, 168],
			"5": 6,
			"6": {
				"1": 300.0,
				"2": 237.0
			},
			"9": -63.0
		}
	}, {
		"1": 4,
		"2": {
			"1": "6387",
			"2": [49, 24, 148, 113],
			"5": 6,
			"6": {
				"1": 50.0,
				"2": 98.0
			},
			"9": 48.0,
			"10": 2.0
		}
	}],
	"9": [{
		"1": "6377",
		"2": {
			"1": true,
			"2": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6378",
		"2": {
			"1": true,
			"2": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6387",
		"2": {
			"1": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}, {
		"1": "6376",
		"2": {
			"1": true,
			"6": true,
			"7": true,
			"8": true,
			"13": true,
			"14": true,
			"15": true,
			"16": true,
			"18": true
		}
	}],
	"10": 1
}
''';

String multiPotResult = '''
{
	"gameId": "629",
	"handNum": 1,
	"gameType": "HOLDEM",
	"noCards": 2,
	"handLog": {
		"preflopActions": {
			"potStart": 0,
			"pots": [],
			"actions": [{
				"seatNo": 1,
				"action": "BOMB_POT_BET",
				"amount": 10,
				"timedOut": false,
				"actionTime": 0,
				"stack": 90
			}, {
				"seatNo": 2,
				"action": "BOMB_POT_BET",
				"amount": 10,
				"timedOut": false,
				"actionTime": 0,
				"stack": 190
			}, {
				"seatNo": 3,
				"action": "BOMB_POT_BET",
				"amount": 10,
				"timedOut": false,
				"actionTime": 0,
				"stack": 290
			}, {
				"seatNo": 4,
				"action": "BOMB_POT_BET",
				"amount": 10,
				"timedOut": false,
				"actionTime": 0,
				"stack": 40
			}],
			"seatsPots": []
		},
		"flopActions": {
			"potStart": 40,
			"pots": [40],
			"actions": [{
				"seatNo": 2,
				"action": "ALLIN",
				"amount": 190,
				"timedOut": false,
				"actionTime": 0,
				"stack": 0
			}, {
				"seatNo": 3,
				"action": "ALLIN",
				"amount": 290,
				"timedOut": false,
				"actionTime": 0,
				"stack": 0
			}, {
				"seatNo": 4,
				"action": "ALLIN",
				"amount": 40,
				"timedOut": false,
				"actionTime": 0,
				"stack": 0
			}, {
				"seatNo": 1,
				"action": "ALLIN",
				"amount": 90,
				"timedOut": false,
				"actionTime": 0,
				"stack": 0
			}],
			"seatsPots": [{
				"seats": [1, 2, 3, 4],
				"pot": 40
			}]
		},
		"turnActions": {
			"potStart": 200,
			"pots": [200, 150, 200],
			"actions": [],
			"seatsPots": [{
				"seats": [1, 2, 3, 4],
				"pot": 200
			}, {
				"seats": [1, 2, 3],
				"pot": 150
			}, {
				"seats": [2, 3],
				"pot": 200
			}]
		},
		"riverActions": {
			"potStart": 200,
			"pots": [200, 150, 200],
			"actions": [],
			"seatsPots": [{
				"seats": [1, 2, 3, 4],
				"pot": 200
			}, {
				"seats": [1, 2, 3],
				"pot": 150
			}, {
				"seats": [2, 3],
				"pot": 200
			}]
		},
		"potWinners": {},
		"wonAt": "SHOW_DOWN",
		"showDown": null,
		"handStartedAt": 1628890428,
		"handEndedAt": 1628890433,
		"runItTwice": false,
		"runItTwiceResult": null,
		"seatsPotsShowdown": [],
		"boards": [],
		"potWinners2": {}
	},
	"handStats": {
		"endedAtPreflop": false,
		"endedAtFlop": false,
		"endedAtTurn": false,
		"endedAtRiver": false,
		"endedAtShowdown": true
	},
	"runItTwice": false,
	"buttonPos": 1,
	"smallBlind": 1,
	"bigBlind": 2,
	"ante": 0,
	"maxPlayers": 4,
	"result": {
		"runItTwice": false,
		"activeSeats": [1, 2, 3, 4],
		"wonAt": "SHOW_DOWN",
		"boards": [{
			"boardNo": 1,
			"cards": [200, 196, 8, 132, 33],
			"playerRank": {
				"1": {
					"boardNo": 1,
					"seatNo": 1,
					"hiRank": 2592,
					"hiCards": [200, 196, 8, 132, 1],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				},
				"2": {
					"boardNo": 1,
					"seatNo": 2,
					"hiRank": 3327,
					"hiCards": [200, 196, 132, 178, 164],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				},
				"3": {
					"boardNo": 1,
					"seatNo": 3,
					"hiRank": 3477,
					"hiCards": [200, 196, 132, 33, 81],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				},
				"4": {
					"boardNo": 1,
					"seatNo": 4,
					"hiRank": 1609,
					"hiCards": [196, 8, 33, 49, 24],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				}
			}
		}, {
			"boardNo": 2,
			"cards": [104, 36, 72, 84, 177],
			"playerRank": {
				"1": {
					"boardNo": 2,
					"seatNo": 1,
					"hiRank": 6938,
					"hiCards": [104, 72, 84, 177, 114],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				},
				"2": {
					"boardNo": 2,
					"seatNo": 2,
					"hiRank": 3625,
					"hiCards": [104, 84, 177, 178, 164],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				},
				"3": {
					"boardNo": 2,
					"seatNo": 3,
					"hiRank": 4951,
					"hiCards": [104, 72, 84, 177, 81],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				},
				"4": {
					"boardNo": 2,
					"seatNo": 4,
					"hiRank": 1606,
					"hiCards": [104, 36, 72, 84, 49],
					"lowFound": false,
					"loRank": 0,
					"loCards": [],
					"bestRank": 0,
					"bestCards": []
				}
			}
		}],
		"potWinners": [{
			"potNo": 0,
			"amount": 200,
			"boardWinners": [{
				"boardNo": 1,
				"amount": 100,
				"hiWinners": {
					"4": {
						"seatNo": 4,
						"amount": 99
					}
				},
				"lowWinners": {},
				"hiRankText": "Straight"
			}, {
				"boardNo": 2,
				"amount": 100,
				"hiWinners": {
					"4": {
						"seatNo": 4,
						"amount": 99
					}
				},
				"lowWinners": {},
				"hiRankText": "Straight"
			}],
			"seatsInPots": [1, 2, 3, 4]
		}, {
			"potNo": 1,
			"amount": 150,
			"boardWinners": [{
				"boardNo": 1,
				"amount": 75,
				"hiWinners": {
					"1": {
						"seatNo": 1,
						"amount": 74
					}
				},
				"lowWinners": {},
				"hiRankText": "Two Pair"
			}, {
				"boardNo": 2,
				"amount": 75,
				"hiWinners": {
					"2": {
						"seatNo": 2,
						"amount": 74
					}
				},
				"lowWinners": {},
				"hiRankText": "Pair"
			}],
			"seatsInPots": [1, 2, 3]
		}, {
			"potNo": 2,
			"amount": 200,
			"boardWinners": [{
				"boardNo": 1,
				"amount": 100,
				"hiWinners": {
					"2": {
						"seatNo": 2,
						"amount": 99
					}
				},
				"lowWinners": {},
				"hiRankText": "Pair"
			}, {
				"boardNo": 2,
				"amount": 100,
				"hiWinners": {
					"2": {
						"seatNo": 2,
						"amount": 100
					}
				},
				"lowWinners": {},
				"hiRankText": "Pair"
			}],
			"seatsInPots": [2, 3]
		}],
		"pauseTimeSecs": 5000,
		"playerInfo": {
			"1": {
				"id": "7500",
				"cards": [114, 1],
				"playedUntil": "SHOW_DOWN",
				"balance": {
					"before": 100,
					"after": 74
				},
				"hhCards": [],
				"hhRank": 0,
				"received": -26,
				"rakePaid": 1,
				"name": "young"
			},
			"2": {
				"id": "7501",
				"cards": [178, 164],
				"playedUntil": "SHOW_DOWN",
				"balance": {
					"before": 200,
					"after": 273
				},
				"hhCards": [],
				"hhRank": 0,
				"received": 73,
				"rakePaid": 2,
				"name": "carol"
			},
			"3": {
				"id": "7502",
				"cards": [17, 81],
				"playedUntil": "SHOW_DOWN",
				"balance": {
					"before": 300,
					"after": 100
				},
				"hhCards": [],
				"hhRank": 0,
				"received": -200,
				"rakePaid": 0,
				"name": "matt"
			},
			"4": {
				"id": "7511",
				"cards": [49, 24],
				"playedUntil": "SHOW_DOWN",
				"balance": {
					"before": 50,
					"after": 198
				},
				"hhCards": [],
				"hhRank": 0,
				"received": 148,
				"rakePaid": 2,
				"name": "chris"
			}
		},
		"scoop": false,
		"playerStats": {
			"7500": {
				"preflopRaise": true,
				"postflopRaise": false,
				"threeBet": false,
				"cbet": false,
				"vpip": false,
				"allin": true,
				"wentToShowdown": true,
				"wonChipsAtShowdown": true,
				"headsup": false,
				"headsupPlayer": "0",
				"wonHeadsup": false,
				"badbeat": false,
				"inPreflop": true,
				"inFlop": true,
				"inTurn": true,
				"inRiver": true,
				"consecutiveActionTimeouts": 0,
				"actedAtLeastOnce": true
			},
			"7501": {
				"preflopRaise": true,
				"postflopRaise": true,
				"threeBet": false,
				"cbet": false,
				"vpip": false,
				"allin": true,
				"wentToShowdown": true,
				"wonChipsAtShowdown": true,
				"headsup": false,
				"headsupPlayer": "0",
				"wonHeadsup": false,
				"badbeat": false,
				"inPreflop": true,
				"inFlop": true,
				"inTurn": true,
				"inRiver": true,
				"consecutiveActionTimeouts": 0,
				"actedAtLeastOnce": true
			},
			"7502": {
				"preflopRaise": true,
				"postflopRaise": true,
				"threeBet": false,
				"cbet": false,
				"vpip": false,
				"allin": true,
				"wentToShowdown": true,
				"wonChipsAtShowdown": false,
				"headsup": false,
				"headsupPlayer": "0",
				"wonHeadsup": false,
				"badbeat": false,
				"inPreflop": true,
				"inFlop": true,
				"inTurn": true,
				"inRiver": true,
				"consecutiveActionTimeouts": 0,
				"actedAtLeastOnce": true
			},
			"7511": {
				"preflopRaise": true,
				"postflopRaise": false,
				"threeBet": false,
				"cbet": false,
				"vpip": false,
				"allin": true,
				"wentToShowdown": true,
				"wonChipsAtShowdown": true,
				"headsup": false,
				"headsupPlayer": "0",
				"wonHeadsup": false,
				"badbeat": false,
				"inPreflop": true,
				"inFlop": true,
				"inTurn": true,
				"inRiver": true,
				"consecutiveActionTimeouts": 0,
				"actedAtLeastOnce": true
			}
		},
		"handNum": 1,
		"tipsCollected": 5
	},
	"log": null,
	"gameCode": "cgggnyrb"
}''';
