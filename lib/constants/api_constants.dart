// const String baseUrl = 'split-trip.com';
const String baseUrl = '192.168.1.31';

const bool secure = false;

Function scheme = (String url) {
  if (secure) {
    return Uri.https(baseUrl, url);
  }

  return Uri.http(baseUrl, url);
};