abstract class RequestBase<T> {
  String apiUrl;
  T response;
  String error = "";

  void setApiUrl(String url);
  Future doRequest();
}

abstract class AuthRequestBase<T> extends RequestBase<T>{
  bool doRefreshToken = false;

  Future doAuthRequest(String token) ;
}