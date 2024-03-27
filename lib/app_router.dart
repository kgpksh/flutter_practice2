import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice2/bloc/cubit/cubit_copywith/copywith_user_list_cubit.dart';
import 'package:flutter_practice2/bloc/cubit/cubit_inherit/inherit_user_list_extends_cubit.dart';
import 'package:flutter_practice2/views/cubit/user_list.dart';
import 'package:flutter_practice2/views/cubit/user_list_copywith.dart';
import 'package:flutter_practice2/views/home_page.dart';
import 'package:flutter_practice2/views/web_api_list/web_api_list.dart';

class AppRouter {
  final _userListExtendsCubit = InheritUserListExtendsCubit();
  final _copyWithListCubit = CopyWithUserListCubit();

  Route? onGenerateroute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/webApiList':
        return MaterialPageRoute(builder: (_) => WebApiList());
      case '/cubitWebApiList':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _userListExtendsCubit,
                child: InheritUserListForCubitExtends()));
      case '/cubitCopyWith' :
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                value: _copyWithListCubit,
                child: CopyWithUserList()));
      default:
        return null;
    }
  }
}
