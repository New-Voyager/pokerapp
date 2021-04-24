#!/usr/bin/python3
import argparse
import asyncio
from python_graphql_client import GraphqlClient
import json

# Setup
# this script creates two players (host, guest) 
# creates two clubs
# configures two games with buyinApproval: true
host_id = "123"
guest_id = "456"

# when the guest sits in a seat, makes a buyin a push notification sent to the host
class GqlClient:

    def __init__(self, url, player_id=None):
        headers = {}
        if player_id:
            headers = {
                'Authorization': f'Bearer {player_id}'
            }
        self.client = GraphqlClient(endpoint=url, headers=headers)

    async def execute(self, query, variables=None):
        result = await self.client.execute_async(query, variables)
        if 'errors' in result:
            print(result)
            raise Exception('Failed to execute query')
        return result['data']

    async def reset_db(self):
        query = "mutation resetDB { resetDB }"
        ret = await self.execute(query)

    async def create_player(self, player: dict) -> str:
        '''
        player dict: {name, email, deviceId, password}
        '''
        query = """mutation createPlayer($player: PlayerCreateInput!)
                    {
                        id: createPlayer(player: $player)
                    }
                """
        variables = {"player": player}
        ret = await self.execute(query, variables=variables)
        return ret['id']

    async def create_club(self, club_name, description) -> str:
        query = """
            mutation ($name: String! $desc: String!)  {
                club: createClub(club:{
                    name: $name
                    description:$desc
                })
            }
        """
        variables = {"name": club_name, "desc": description}
        ret = await self.execute(query, variables=variables)
        return ret['club']

    async def join_club(self, club_code):
        query = """
                mutation ($clubCode: String!) {
                    joinClub(clubCode: $clubCode)
                }
            """
        ret = await self.execute(query, variables={"clubCode": club_code})
        return ret

    async def approve_club_member(self, club_code, player_id):
        query = """
                mutation ($clubCode: String!, $playerId: String!) {
                    approveMember(clubCode: $clubCode, playerUuid: $playerId)
                }
            """
        ret = await self.execute(query, variables={"clubCode": club_code, "playerId": player_id})
        return ret

    async def create_holdem_game(self, club_code, 
        buy_in_approval=False, small_blind=1, 
        big_blind=2, 
        action_time=20,
        min_players=2,
        max_players=9):
        game_input = {
            "title": f"Holdem {small_blind}/{big_blind}",
            "buyInApproval": buy_in_approval,
            "gameType": "HOLDEM",
            "smallBlind": small_blind,
            "bigBlind": big_blind,
            "straddleBet": big_blind*2,
            "actionTime": action_time,
            "buyInMin": 30,
            "buyInMax": 100,
            "minPlayers": min_players,
            "maxPlayers": max_players,
            "gameLength": 60,
        }  

        print(json.dumps(game_input))

        query = """
            mutation ($clubCode: String! $game: GameCreateInput!) {
                game: configureGame(clubCode: $clubCode, game: $game) {
                    gameCode
                }
            }
        """
        ret = await self.execute(query, variables={"clubCode": club_code, "game": game_input})
        return ret["game"]["gameCode"]

    async def live_games(self):
        query = """
                query {
                    games: liveGames {
                        gameCode
                    }
                }
            """
        ret = await self.execute(query)
        games = []
        #print(ret)
        for item in ret['games']:
            games.append(item['gameCode'])
        return games

    async def join_game(self, game_code, seat_no):
        query = """
                mutation ($gameCode: String! $seatNo: Int!) {
                    joinGame(gameCode: $gameCode, seatNo: $seatNo)
                }
            """
        ret = await self.execute(query, variables={"gameCode": game_code, "seatNo": seat_no})
        return ret

    async def buyin(self, game_code, amount):
        query = """
                mutation ($gameCode: String! $amount: Float!) {
                    buyIn(gameCode: $gameCode, amount: $amount) {
                        expireSeconds
                    }
                }
            """
        ret = await self.execute(query, variables={"gameCode": game_code, "amount": amount})
        return ret

async def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--apiserver", help="apiserver")
    parser.add_argument("--setup", action='store_true', help="makes buyin request for guest")
    parser.add_argument("--buyin", action='store_true', help="setups clubs and game")
    args = parser.parse_args()

    if not args.setup  and not args.buyin:
        print('Either --setup or --buyin should be specified')
        exit(1)

    apiserver = 'localhost'
    if args.apiserver:
        apiserver = args.apiserver
    gql_url = f"http://{apiserver}:9501/graphql" 

    if args.setup:
        await setup(gql_url)
    elif args.buyin:
        await buyin(gql_url)

async def buyin(gql_url):
    global guest_id, host_id
    guest_client = GqlClient(gql_url, guest_id)
    live_games = await guest_client.live_games()
    print(live_games)
    game_code = live_games[0]
    await guest_client.join_game(game_code, 2)
    await guest_client.buyin(game_code, 100)

async def setup(gql_url):
    global guest_id, host_id
    client = GqlClient(gql_url)
    await client.reset_db()

    host = {
            "name":"host",
            "email":"host@gmail.com",
            "deviceId": host_id,
            "password":"host"
        }
    host_id = await client.create_player(host)
    print(f"host id: {host_id}")

    guest = {
            "name":"guest",
            "email":"guest@gmail.com",
            "deviceId": guest_id,
            "password":"guest"
        }
    guest_id = await client.create_player(guest)    
    print(f"guest_id: {guest_id}")

    # create a club
    host_client = GqlClient(gql_url, host_id)
    club1_code = await host_client.create_club('club1', 'club1')
    print(club1_code)
    club2_code = await host_client.create_club('club2', 'club2')
    print(club2_code)

    # guest client
    guest_client = GqlClient(gql_url, guest_id)
    await guest_client.join_club(club1_code)
    await guest_client.join_club(club2_code)

    # host approves club membership
    await host_client.approve_club_member(club1_code, guest_id)
    await host_client.approve_club_member(club2_code, guest_id)

    # host creates a new game
    game_code = await host_client.create_holdem_game(club1_code, buy_in_approval=True)
    print(game_code)

if __name__ == "__main__":
    asyncio.run(main())