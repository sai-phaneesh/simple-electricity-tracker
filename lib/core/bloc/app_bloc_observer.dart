import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

/// Custom BlocObserver for debugging and handling BLoC events/transitions
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      print('✅ BLoC Created: ${bloc.runtimeType}');
    }
  }

  @override
  void onEvent(BlocBase bloc, Object? event) {
    super.onEvent(bloc as Bloc, event);
    if (kDebugMode) {
      print('📝 Event: ${bloc.runtimeType} -> $event');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print('🔄 Change: ${bloc.runtimeType} -> $change');
    }
  }

  @override
  void onTransition(BlocBase bloc, Transition transition) {
    super.onTransition(bloc as Bloc, transition);
    if (kDebugMode) {
      print('🔀 Transition: ${bloc.runtimeType} -> $transition');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print('❌ BLoC Error: ${bloc.runtimeType}');
      print('Error: $error');
      print('StackTrace: $stackTrace');
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      print('🗑️ BLoC Closed: ${bloc.runtimeType}');
    }
  }
}
