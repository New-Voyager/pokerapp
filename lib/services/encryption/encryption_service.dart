import 'dart:convert';
import 'dart:developer';
import 'package:cryptography/cryptography.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:pokerapp/main_helper.dart';

class EncryptionService {
  AesGcm gcm = AesGcm.with128bits();
  SecretKey key;
  bool initialized = false;

  EncryptionService();

  Future<void> init() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    String _query = """query getEncryptionKey {
      encryptionKey
    }""";

    QueryResult result = await _client.query(
      QueryOptions(document: gql(_query)),
    );

    if (result.hasException) {
      return null;
    }

    List<int> bytes = Uuid.parse(result.data['encryptionKey']);
    this.key = SecretKey(bytes);
    this.initialized = true;
  }

  List<int> b64decodeString(String s) => base64.decode(s);

  Future<List<int>> decodeAndDecrypt(String s) async {
    final decoded = b64decodeString(s);
    return decrypt(decoded);
  }

  Future<List<int>> decrypt(List<int> data) async {
    if (!this.initialized) {
      await init();
    }

    // SecretBox sb = SecretBox.fromConcatenation(data,
    //     nonceLength: gcm.nonceLength, macLength: gcm.macAlgorithm.macLength);
    //
    // The secret box initialization above is what I meant to use,
    // but it throws an error because
    // fromConcatenation function has a bug that parses the ciphertext
    // part of the payload from a wrong byte offset which has a pending PR
    // as of today (6/25/2021).
    //
    // https://github.com/dint-dev/cryptography/pull/51
    //
    // Manually slicing the payload bytes as a workaround.
    //
    SecretBox sb = SecretBox(
      data.sublist(gcm.nonceLength, data.length - gcm.macAlgorithm.macLength),
      nonce: data.sublist(0, gcm.nonceLength),
      mac: Mac(data.sublist(data.length - gcm.macAlgorithm.macLength)),
    );
    List<int> decrypted = await this.gcm.decrypt(sb, secretKey: this.key);
    return decrypted;
  }

  void dispose() {
    log('encryption service -- disposing');
  }
}
