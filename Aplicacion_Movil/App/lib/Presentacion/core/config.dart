class ApiConfig {
  static String baseUrl = "http://localhost:5000";

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
