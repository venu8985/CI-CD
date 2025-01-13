abstract class PostStateData {}

class LoadingState extends PostStateData {}

class SuccessState extends PostStateData {
  final List<dynamic> data;
  SuccessState(this.data);
}

class ErrorState extends PostStateData {
  final String message;
  ErrorState(this.message);
}
