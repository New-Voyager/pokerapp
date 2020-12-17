class AppApis {
  static final String host = '10.0.2.2';

  static final String baseUrl = 'http://$host';

  static final String baseUrlWithDefaultPort = '$baseUrl:9501';

  static final String graphQLBaseUrl = '$baseUrlWithDefaultPort/graphql';
}
