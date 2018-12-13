import 'package:blocx/blocx.dart';

import 'counter_actions.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterAction, CounterState> {
  // TODO: implement initialState
  @override
  CounterState get initialState => CounterState();

  @override
  CounterState updateState(CounterState state, CounterAction action) {
    switch (action.runtimeType) {
      case IncrementCounterAction:
        return state..counter = state.counter + 1;
        break;
    }
    return state;
  }
}
