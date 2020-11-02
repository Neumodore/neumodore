import 'package:dio/dio.dart';

class ClickupService {
  final Dio http = Dio();

  String authorizationToken;

  ClickupService() {
    http.interceptors.add(AuthInterceptor(this));
  }

  void authorizeClient(oauthCode) async {
    this.authorizationToken = await this.getAuthorizationToken(code: oauthCode);
  }

  Future<String> getAuthorizationToken({
    clientID: "BUXTWDZ8OIY1ZTL4XGQQFVP0EMM0NPB5",
    clientSecret:
        "TSZDSJFZB55BRYET87KVFMFD1U6ID53B8W2INRFLC6BDDKHN88TRJ4D5GBEZ0LQN",
    code: "GOX7E3GUJ358H87YGHXABW6HHL1G1N3N",
  }) async {
    return (await http.get(
      "https://api.clickup.com/api/v2/oauth/token",
      queryParameters: {
        "client_id": clientID,
        'client_secret': clientSecret,
        'code': code
      },
    ))
        .data['access_token'];
  }

  Future getAuthorizedTeams() async {
    return (await http.get('https://api.clickup.com/api/v2/team'));
  }

  Future getSpacesFromTeam(String team) async {
    return (await http
        .get('https://api.clickup.com/api/v2/team/$team/space?archived=false'));
  }

  Future getListsFromSpace(String space) async {
    return (await http.get(
        'https://api.clickup.com/api/v2/space/$space/list?archived=false'));
  }

  Future getStatusesFromList(String list) async {
    return (await http.get('https://api.clickup.com/api/v2/list/$list'));
  }
}

class AuthInterceptor implements Interceptor {
  ClickupService _clickupService;

  AuthInterceptor(ClickupService clickup) {
    _clickupService = clickup;
  }

  @override
  Future onError(DioError err) async => err;

  @override
  Future onRequest(RequestOptions options) async {
    if (_clickupService.authorizationToken != null) {
      options.headers.addAll(
        {'Authorization': _clickupService.authorizationToken},
      );
    }
    return options;
  }

  @override
  Future onResponse(Response response) async {
    if (response.statusCode == 401) {
      _clickupService.authorizationToken = null;
    }
    return response;
  }
}
