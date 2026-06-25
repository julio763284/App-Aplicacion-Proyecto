class ApiConfig {
  static String baseUrl = "http://10.2.135.49:5001";

  static String url(String path) {
    if (path.startsWith('/')) {
      return '$baseUrl$path';
    }
    return '$baseUrl/$path';
  }

  static void updateBaseUrl(String newBaseUrl) {
    baseUrl = newBaseUrl;
  }
}
