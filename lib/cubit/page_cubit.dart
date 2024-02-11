import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modernlogintute/cubit/page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState(pageIndex: 0));

  void selectedPage(int pageIndex) {
    emit(PageState(pageIndex: pageIndex));
  }
}
