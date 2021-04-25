import 'package:graphql_flutter/graphql_flutter.dart';

class GqlError {
  Map<String, String>  _extensions;
  String _path;
  String _message;
  String _code;

  static GqlError fromException(OperationException ex) {
    List<GraphQLError> errors = ex.graphqlErrors;
    final error = errors[0];
    GqlError e = GqlError();
    e._path = error.path[0].toString();
    e._message = error.message.toString();
    dynamic ext = error.extensions;
    e._code = ext['code'].toString();
    e._extensions = Map<String, String>();
    for (final key in error.extensions.keys) {
      if (key == 'code' || key == 'exception') {
        continue;
      }
      e._extensions[key] = ext[key];
    }
    return e;
  }

  String get path => this._path;
  String get message => this._message;
  String get code => this._code;
  Map<String, String> get extensions => this._extensions;
}
