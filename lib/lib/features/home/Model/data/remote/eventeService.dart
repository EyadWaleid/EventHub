
import 'package:dio/dio.dart';
import 'package:eventhub/lib/core/Error/customeExceptions.dart';
import 'package:eventhub/lib/features/home/Model/data/remote/model/eventResponse.dart';
import 'package:eventhub/lib/features/home/Model/data/remote/reomteService.dart';


class EventService implements RemoteService {
  final Dio _dio;

  EventService(this._dio);
  Never _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw NetworkException(errorMessage: 'No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 401:
            throw UnauthorizedException(errorMessage: 'Unauthorized');
          case 404:
            throw NotFoundException(errorMessage: 'Resource not found');
          case 500:
            throw ServerException(errorMessage: 'Internal server error');
          default:
            throw ServerException(errorMessage: 'Bad response: $statusCode');
        }

      case DioExceptionType.cancel:
        throw NetworkException(errorMessage: 'Request cancelled');

      default:
        throw ServerException(errorMessage: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<EventResponse> getEvent() async {
   try{
     final response = await _dio.get(
       "/events.json",
       queryParameters: {"countryCode": "US"},
     );
     return EventResponse.fromJson(response.data);

   } on DioException catch(e){
     _handleDioException(e);
   } catch(e){
      throw ServerException(errorMessage: 'An unexpected error occurred: $e');
   }


  }

  Future<EventResponse>  getSearchedEventsByCatagories(String catagrorey , String keyword) async{
    try{
      final response = await _dio.get(
        "/events.json",
        queryParameters: {"countryCode": "US",
        "classificationName": catagrorey,
          'keyword': keyword},
      );
      return EventResponse.fromJson(response.data);
    } on DioException catch(e){
      _handleDioException(e);
    } catch(e){
      throw ServerException(errorMessage: 'An unexpected error occurred: $e');
    }


  }
  Future<EventResponse> getSearchedEvents ( String keyword) async{
    try{
      final response = await _dio.get(
        "/events.json",
        queryParameters: {"countryCode": "US",
          'keyword': keyword},
      );
      return EventResponse.fromJson(response.data);
    } on DioException catch(e){
      _handleDioException(e);
    } catch(e){
      throw ServerException(errorMessage: 'An unexpected error occurred: $e');
    }


  }
}
