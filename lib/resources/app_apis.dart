class AppApis {
  static final String host = '';

  static final String baseUrl = 'http://$host';
  static final String baseUrlWithDefaultPort = '$baseUrl:9501';
  static final String graphQLBaseUrl = '$baseUrlWithDefaultPort/graphql';
}
