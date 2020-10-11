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
      MutationOptions(documentNode: gql(mutation)),
    );
  }

  static StreamController<List<ClubMessageModel>> _stream;
  static Timer _timer;

  static closeStream() {
    _stream?.close();
    _timer?.cancel();
  }

  static Stream<List<ClubMessageModel>> pollMessages(String clubCode) {
    if (_stream == null || _stream.isClosed)
      _stream = StreamController<List<ClubMessageModel>>.broadcast();

    if (_timer == null || !_timer.isActive)
      _timer = Timer.periodic(AppConstants.clubMessagePollDuration, (_) async {
        List<ClubMessageModel> _messages = [];

        String _query = ClubMessageModel.queryClubMessages(clubCode);
        GraphQLClient _client = graphQLConfiguration.clientToQuery();

        /* messages query */
        QueryResult result = await _client.query(
          QueryOptions(
            documentNode: gql(_query),
          ),
        );

        if (!result.hasException) {
          var jsonResponse = result.data['clubMessages'];

          _messages.addAll(jsonResponse
              .map<ClubMessageModel>(
                  (var messageItem) => ClubMessageModel.fromJson(messageItem))
              .toList());
        }

        _stream.sink.add(_messages.reversed.toList());
      });

    return _stream.stream;
  }
}
