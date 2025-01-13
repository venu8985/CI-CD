import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:test_signin/bloc/api_service.dart';
import 'package:test_signin/bloc/bloc_event.dart';
import 'package:test_signin/bloc/bloc_state.dart';

class PostBloc extends Cubit<PostStateData> {
  final ApiService apiService;

  PostBloc(this.apiService) : super(LoadingState()) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      emit(LoadingState());
      final posts = await apiService.fetchData(); // Fetch posts from the API
      emit(SuccessState(posts));
    } catch (error) {
      print("Error: $error");
      emit(ErrorState(error.toString()));
    }
  }
}
