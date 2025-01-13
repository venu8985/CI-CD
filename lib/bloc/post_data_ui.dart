import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_signin/bloc/api_service.dart';
import 'package:test_signin/bloc/bloc_state.dart';
import 'package:test_signin/bloc/post_bloc.dart';

class PostUiData extends StatelessWidget {
  const PostUiData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => PostBloc(ApiService()),
        child: PostDataWidget(),
      ),
    );
  }
}

class PostDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostStateData>(builder: (context, state) {
      if (state is LoadingState) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SuccessState) {
        return ListView.builder(
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return Text(state.data[index]['title']);
            });
      } else if (state is ErrorState) {
        return Center(
          child: Text('error ${state.message}'),
        );
      } else {
        return Center(
          child: Text('No data'),
        );
      }
    });
  }
}
