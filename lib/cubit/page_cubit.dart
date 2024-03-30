import 'package:flutter_bloc/flutter_bloc.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState(pageIndex: 0));

  void selectedPage(int pageIndex) {
    emit(PageState(pageIndex: pageIndex));
  }
}

class PageState{
  final int pageIndex;
  PageState({
    required this.pageIndex
  });
}