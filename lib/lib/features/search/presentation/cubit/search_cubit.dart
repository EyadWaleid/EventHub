import 'package:eventhub/features/home/domain/usecases/event_usecases.dart';
import 'package:eventhub/features/search/presentation/cubit/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchEventsUseCase searchEventsUseCase;
  final SearchEventsByCategoryUseCase searchByCategoryUseCase;

  SearchCubit({
    required this.searchEventsUseCase,
    required this.searchByCategoryUseCase,
  }) : super(SearchIdle());

  Future<void> search(String keyword, {String? category}) async {
    if (keyword.trim().isEmpty) {
      emit(SearchIdle());
      return;
    }
    emit(SearchLoading());
    final result = category != null && category.isNotEmpty
        ? await searchByCategoryUseCase(category, keyword.trim())
        : await searchEventsUseCase(keyword.trim());

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (events) => emit(SearchLoaded(events)),
    );
  }

  void reset() => emit(SearchIdle());
}
