import 'dart:async';
import 'dart:developer';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/models/club_message_model.dart';
import 'package:pokerapp/resources/app_constants.dart';

import '../../main.dart';

class ClubMessageService {
  static Future<void> sendMessage(ClubMessageModel messageModel) async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    final String mutation = await messageModel.mutationSendClubMessage();

    log(mutation);

    _client.mutate(
      MutationOptions(document: gql(mutation)),
    );
  }

  static StreamController<List<ClubMessageModel>> _stream;
  static Timer _timer;

  static closeStream() {
    _stream?.close();
    _timer?.cancel();
  }

  static markMessagesAsRead(String clubCode) async {
    String query = '''
      mutation markMessagesRead(\$clubCode: String!) {
        read: markMessagesRead(clubCode: \$clubCode)
      }
    ''';
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    dynamic variables = {
      "clubCode": clubCode,
    };
    /* messages query */
    var result = await _client.mutate(
      MutationOptions(
        document: gql(query),
        variables: variables,
      ),
    );

    if (result.hasException) return false;
    return result.data['read'];
  }

  static Future<int> _fetchData(
      String clubCode, int next, List<ClubMessageModel> _messages) async {
    String _query = ClubMessageModel.queryClubMessages(clubCode, next: next);
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    /* messages query */
    QueryResult result = await _client.query(
      QueryOptions(
        document: gql(_query),
      ),
    );
    bool newMessagesAdded = false;
    if (!result.hasException) {
      var jsonResponse = result.data['clubMessages'];
      final newMessages = jsonResponse
          .map<ClubMessageModel>(
              (var messageItem) => ClubMessageModel.fromJson(messageItem))
          .toList();
      if (newMessages.length > 0) {
        newMessagesAdded = true;
      }
      // _messages.addAll(newMessages);
      // add all new Messages that are non existing
      for (final message in newMessages) {
        if (_messages.every((m) => m.id != message.id)) {
          _messages.add(message);
        }
      }
      for (final message in _messages) {
        if (message.id > next) {
          next = message.id;
        }
      }
    }
    log('querying messages: next: $next newMessagesAdded: $newMessagesAdded');
    return next;
  }

  static Stream<List<ClubMessageModel>> pollMessages(String clubCode) {
    if (_stream == null || _stream.isClosed)
      _stream = StreamController<List<ClubMessageModel>>.broadcast();

    int next = 0;
    List<ClubMessageModel> _messages = [];
    if (_timer == null || !_timer.isActive) {
      _timer = Timer.periodic(AppConstants.clubMessagePollDuration, (_) async {
        int len = _messages.length;
        next = await _fetchData(clubCode, next, _messages);
        if (_messages.length != len && !_stream.isClosed) {
          _stream.sink.add(_messages.reversed.toList());
          ClubMessageService.markMessagesAsRead(clubCode);
        }
      });
    }

    return _stream.stream;
  }
}
