// Post Bloc
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'widgets/form_widgets/form_widgets.dart';

class PostingBloc extends Bloc<PostingEvent, Widget> {
  @override
  // should return post car screen
  PostingBloc() : super(formWidget());
  Stream<Widget> mapEventToState(PostingEvent event) async* {
    if (event is PostingEvent) {
      yield Container(
        child: Text("Posting"),
      );
    }
  }

  Widget postingState() {
    return Container(
      child: Text("Posting"),
    );
  }
}

Widget postingState() {
  return Container(
    child: Text("Posting"),
  );
}

class PostingEvent {}
