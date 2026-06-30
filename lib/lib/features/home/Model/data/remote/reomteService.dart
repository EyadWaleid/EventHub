import 'package:eventhub/lib/features/home/Model/data/remote/model/eventResponse.dart';

abstract class RemoteService{
  Future<EventResponse> getEvent()   ;
  Future<EventResponse>  getSearchedEventsByCatagories(String catagrorey , String keyword);
  Future<EventResponse> getSearchedEvents ( String keyword);
}