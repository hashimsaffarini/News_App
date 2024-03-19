import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/article.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
}
