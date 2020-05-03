import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:ftzone/logic/viewmodel/menu_view_model.dart';
import 'package:ftzone/model/menu.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  final _menuVM = MenuViewModel();

  final menuController = StreamController<List<Menu>>();

  Stream<List<Menu>> get menuItems => menuController.stream;

  MenuBloc() {
    menuController.add(_menuVM.getMenuItems());
  }
  
  @override
  MenuState get initialState => MenuInitial();

  @override
  Stream<MenuState> mapEventToState(
    MenuEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
