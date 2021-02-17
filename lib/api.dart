
import 'dart:convert'; //인코딩 디코딩

import 'package:http/http.dart' as http; //http 종속 추가한 후  터미널  dart pub get 쳐주기
import 'package:http/http.dart';



//이 페이지 같은 경우는 현재 send.get.post.patch.put등을 쉽게 사용할 수있게 해주는 페이지 라고 알고 있습니다. head...?


class Api extends http.BaseClient{ //HTTP 클라이언트의 추상 기본 클래스입니다.
  //이것은 믹스 인 스타일 클래스입니다. 서브 클래스는 send 및 close 를 구현하기 만하면됩니다. 그러면 다양한 편의 메서드를 무료로 얻을 수 있습니다.
  //속성 hashCode (정수) 이 개체의 해시 코드입니다. 읽기 전용 , 상속됨
  //    runtimeType(유형) 개체의 런타임 유형 표현입니다.
  //더 자세한거는 BaseClient  검색

  bool forceGuest;
  Map<String, String> _defaultHeaders ={};
  //_defaultHeaders['device-id'] = UserModel().deviceId;    / @@?????
  Api({this.forceGuest = false}){
    if(!forceGuest){
      // if(UserModel().isLogin) {
      //   _defaultHeaders[HttpHeaders.authorizationHeader] = 'Bearer '+UserModel().getUserToken(); //@@??????
      // }

    }
  }
  http.Client _httpClient =http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) { //request,StreamRequest 객체를 직접 만들고 ??...
    return _httpClient.send(request);
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) { // json형태로 받아오 헤더값을 _mergedHeaders를 통해 response 형태로 돌려주겠다. <> 자리에 보통 String이나... ?????
    return _httpClient.get(url, headers: _mergedHeaders(headers));
  }

  @override
  Future<Response> post(url, {Map<String, String> headers, dynamic body, Encoding encoding}) {
    return _httpClient.post(url, headers: _mergedHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<Response> patch(url, {Map<String, String> headers, dynamic body, Encoding encoding}) {
    return _httpClient.patch(url, body: body, encoding: encoding);
  }

  @override
  Future<Response> put(url, {Map<String, String> headers, dynamic body, Encoding encoding}) {
    return _httpClient.put(url, headers: _mergedHeaders(headers), body: body, encoding: encoding);
  }

  @override
  Future<Response> head(url, {Map<String, String> headers}) {
    return _httpClient.head(url, headers: _mergedHeaders(headers));
  }

  @override
  Future<Response> delete(url, {Map<String, String> headers}) {
    return _httpClient.delete(url, headers: _mergedHeaders(headers));
  }

  Map<String, String> _mergedHeaders(Map<String, String> headers) => {}..addAll(_defaultHeaders)..addAll(headers==null?{}:headers);

  //@@ 해석을 어떻게 해야할까요?  해드가 널일경우 {} , 아니면 헤드값 ?
}