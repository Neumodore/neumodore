import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClickupApiService {
  final Dio http = Dio();
  final String _clickupKey = 'clickupToken';
  SharedPreferences _shared;

  bool _authorizing = false;

  get authorizationToken {
    try {
      return this._shared.getString(_clickupKey);
    } catch (e) {
      return null;
    }
  }

  bool get isLoggedIn {
    return this.authorizationToken != null;
  }

  set authorizationToken(String nVal) {
    if (nVal == null)
      _shared.remove(_clickupKey);
    else
      _shared.setString(_clickupKey, nVal);
  }

  ClickupApiService(
    this._shared,
  ) {
    http.interceptors.add(AuthInterceptor(this));
  }

  Future authorizeClient(String oauthCode) async {
    if (!_authorizing) {
      this._authorizing = true;
      try {
        this.authorizationToken =
            await this.getAuthorizationToken(code: oauthCode);
      } catch (e) {
        this._authorizing = false;
        rethrow;
      } finally {
        this._authorizing = false;
      }
    }
  }

  Future<String> getAuthorizationToken({
    clientID: "BUXTWDZ8OIY1ZTL4XGQQFVP0EMM0NPB5",
    clientSecret:
        "TSZDSJFZB55BRYET87KVFMFD1U6ID53B8W2INRFLC6BDDKHN88TRJ4D5GBEZ0LQN",
    code: "GOX7E3GUJ358H87YGHXABW6HHL1G1N3N",
  }) async {
    return (await http.post(
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
    return (await http.get('https://api.clickup.com/api/v2/team')).data;
  }

  Future getSpacesFromTeam(String team) async {
    return (await http.get(
            'https://api.clickup.com/api/v2/team/$team/space?archived=false'))
        .data;
  }

  Future getListsFromSpace(String space) async {
    return (await http.get(
            'https://api.clickup.com/api/v2/space/$space/list?archived=false'))
        .data;
  }

  Future getStatusesFromList(String list) async {
    return (await http.get('https://api.clickup.com/api/v2/list/$list')).data;
  }
}

class AuthInterceptor implements Interceptor {
  ClickupApiService _clickupService;

  AuthInterceptor(ClickupApiService clickup) {
    _clickupService = clickup;
  }

  @override
  Future onRequest(RequestOptions options) async {
    if (_clickupService?.authorizationToken != null) {
      options.headers.addAll({
        'Authorization': _clickupService.authorizationToken,
      });
      return options;
    }
  }

  @override
  Future onResponse(Response response) async {
    if (response.statusCode == 401) {
      _clickupService.authorizationToken = null;
    }
    return response;
  }

  @override
  Future<DioError> onError(DioError err) async {
    return err;
  }
}
