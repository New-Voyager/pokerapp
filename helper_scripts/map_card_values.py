

cardValues = """  
  1,  1: 2♠
  2,  2: 2❤
  4,  4: 2♦
  8,  8: 2♣
 17, 11: 3♠
 18, 12: 3❤
 20, 14: 3♦
 24, 18: 3♣
 40, 28: 4♣
 33, 21: 4♠
 34, 22: 4❤
 36, 24: 4♦
 50, 32: 5❤
 52, 34: 5♦
 56, 38: 5♣
 49, 31: 5♠
 65, 41: 6♠
 66, 42: 6❤
 68, 44: 6♦
 72, 48: 6♣
 81, 51: 7♠
 82, 52: 7❤
 84, 54: 7♦
 88, 58: 7♣
 97, 61: 8♠
 98, 62: 8❤
100, 64: 8♦
104, 68: 8♣
113, 71: 9♠
114, 72: 9❤
116, 74: 9♦
120, 78: 9♣
130, 82: T❤
132, 84: T♦
136, 88: T♣
129, 81: T♠
152, 98: J♣
145, 91: J♠
146, 92: J❤
148, 94: J♦
161, A1: Q♠
162, A2: Q❤
164, A4: Q♦
168, A8: Q♣
177, B1: K♠
178, B2: K❤
180, B4: K♦
184, B8: K♣
200, C8: A♣
193, C1: A♠
194, C2: A❤
196, C4: A♦"""

output = ''

cardRows = cardValues.split('\n')
for cardRow in cardRows:
    tmp = cardRow.split(':')
    number  = tmp[0].split(',')[0].strip()
    card = tmp[1].strip()
    output += number + ':' + "'" + card + "'," + '\n'

print(output)

'''
Map<String, List<int>> rankCards = {
  'straightAFlush': [129, 146, 161, 177, 193],
  'straightKFlush': [113, 129, 146, 161, 177],
  'straightQFlush': [97, 113, 129, 146, 161],
  'straightJFlush': [81, 97, 113, 129, 146],
  'straightTFlush': [65, 81, 97, 113, 129],
  'straight9Flush': [49, 65, 81, 97, 113],
  'straight8Flush': [33, 49, 65, 81, 97],
  'straight7Flush': [17, 33, 49, 65, 81],
  'straight6Flush': [1, 17, 33, 49, 65],
  'straight5Flush': [193, 1, 17, 33, 49],
  
  // spade, club, hear, diamond
  'fourAAAA': [193, 200, 194, 196],
  'fourKKKK': [177, 184, 178, 180],
  'fourQQQQ': [161, 168, 162, 164],
  'fourJJJJ': [145, 152, 146, 148],
  'fourTTTT': [129, 136, 130, 132],
  'four9999': [113, 120, 114, 116],
  'four8888': [97, 104, 98, 100],
  'four7777': [81, 88, 82, 84],
  'four6666': [65, 72, 66, 68],
  'four5555': [49, 56, 50, 52],
  'four4444': [33, 40, 34, 36],
  'four3333': [17, 24, 18, 20],
  'four2222': [1, 8, 2, 4],
}

2: [1, 2, 4, 8],
3: [17, 18, 20, 24],
4: [33, 34, 36, 40],
5: [49, 50, 52, 56],
6: [65, 66, 68, 72],
7: [81, 82, 84, 88],
8: [97, 98, 100, 104],
9: [113, 114, 116, 120],
10: [129, 130, 132, 136],
11: [145, 146, 148, 152],
12: [161, 162, 164, 168],
13: [177, 178, 180, 184],
14: [193, 194, 196, 200],
'''

