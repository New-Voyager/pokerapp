class AppApis {
  static final String host = '192.168.1.104'; // '10.0.2.2:9501';

  static final String baseUrl = 'http://$host';

  static final String baseUrlWithDefaultPort = '$baseUrl:9501';

  static final String graphQLBaseUrl = '$baseUrlWithDefaultPort/graphql';
}
