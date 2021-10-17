import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/services/gql_errors.dart';

class GQLException implements Exception {
  String code;
  String message;

  GQLException() {
    code = 'GENERIC';
    message = 'Error reported';
  }

  GQLException.withGQLErrror(List<GraphQLError> errors) {
    // we care about the first error
    code = 'GENERIC';
    if (errors.length >= 1) {
      if (errors[0].extensions.length > 0) {
        if (errors[0].extensions.containsKey('code')) {
          code = errors[0].extensions['code'];
        }
        message = errors[0].message;
      }
    }
  }
}

String errorText(String code) {
  final errors = getAppTextScreen("errors");
  if (errors != null) {
    String errorText = errors.getText(code);
    if (errorText == "No Text") {
      return "Error occurred on the server";
    }
    return errorText;
  }
  return "Error occurred on the server";
}

String gqlErrorText(GQLException exception) {
  final errors = getAppTextScreen("errors");
  if (errors != null) {
    String errorText = errors.getText(exception.code);
    if (errorText == "No Text") {
      return exception.message;
    }
    return errorText;
  }
  return exception.message;
}
