// 예약 관련 API 요청
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/reservation_model.dart';

class ReservationApi {
  // 필요한 라이브러리 및 베이스 URL 설정
  final Dio dio;
  final FlutterSecureStorage storage;
  static const String baseUrl = 'https://k10e203.p.ssafy.io';

  ReservationApi({required this.dio, required this.storage});

  // 내 예약 조회
  Future<List<MyReservationModel>> myReservationinfo() async {
    List<MyReservationModel> reservations = [];
    try {
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        print('No access token available');
        return [];
      }
      final response = await dio.get(
        '$baseUrl/api/reservationinfo',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        List<dynamic> responseData = response.data['data'];
        reservations = responseData
            .map((data) => MyReservationModel.fromJson(data))
            .toList();
      } else {
        print('Failed to fetch reservation information');
      }
    } on DioException catch (e) {
      print('Error fetching reservation information: ${e.message}');
    }
    return reservations;
  }

  // 특정 날짜 예약 조회
  Future<List<ReservationDayModel>?> reservationinfoDay(String date) async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      print('No access token available');
      return null;
    }
    try {
      final response = await dio.get(
        '$baseUrl/api/reservationinfo/search?date=$date',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data.map((item) => ReservationDayModel.fromJson(item)).toList();
      } else {
        print('해당 날짜 예약 정보 불러오기 실패');
        return null;
      }
    } on DioException catch (e) {
      print('Error fetching reservation data: ${e.message}');
      return null;
    }
  }

// 예약 취소 infoId를 전달받아서 요청
  Future<void> reservationCancel(int infoId) async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token available');
    }

    final response = await dio.delete(
      '$baseUrl/api/reservationinfo/$infoId',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );

    if (response.statusCode != 200) {
      // 상태 코드에 따라 적절한 예외를 던집니다.
      throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badCertificate,
          error: response.statusCode == 404
              ? 'Unauthorized cancellation attempt'
              : 'Reservation cancellation failed');
    }
    print('해당 예약을 취소하였습니다!');
  }

  // 예약하기
  Future<void> reservationRequest(Map<String, dynamic> requestData) async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token available');
    }
    try {
      var body = json.encode(requestData); // Map을 직접 인코드
      final response = await dio.post('$baseUrl/api/reservationinfo',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('예약 등록 성공!');
      } else {
        print('예약 등록 실패');
        throw Exception('Failed to register reservation');
      }
    } on DioException catch (e) {
      print('예약 등록 에러: ${e.message}');
      throw Exception('Error making reservation request: ${e.message}');
    }
  }

  // 예약 생성
  Future<void> reservationCreate(Map<String, dynamic> createData) async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token available');
    }
    try {
      var body = json.encode(createData); // Map을 직접 인코드
      final response = await dio.post('$baseUrl/api/reservation',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('예약 생성 성공!');
      } else {
        print('예약 생성 실패');
        throw Exception('Failed to register reservation');
      }
    } on DioException catch (e) {
      print('예약 생성 에러: ${e.message}');
      throw Exception('Error making reservation request: ${e.message}');
    }
  }

  // 예약 취소
  Future<void> reservationFix(Map<String, dynamic> fixData) async {
    String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('No access token available');
    }
    try {
      var body = json.encode(fixData); // Map을 직접 인코드
      final response = await dio.patch('$baseUrl/api/reservation',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
          data: body);

      if (response.statusCode == 200) {
        print('예약 수정 성공!');
      } else {
        print('예약 수정 실패');
        throw Exception('Failed to register reservation');
      }
    } on DioException catch (e) {
      print('예약 수정 에러: ${e.message}');
      throw Exception('Error making reservation request: ${e.message}');
    }
  }
}
