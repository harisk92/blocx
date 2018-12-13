import 'counter_actions.dart';
import 'counter_bloc.dart';

void main() {
  CounterBloc bloc = CounterBloc();
  bloc.dispatch(IncrementCounterAction());
}
