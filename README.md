# BloCX

BLoC pattern implementation which simplifies process of writing BLoC
and minimizes boilerplate which is needed to be written with traditional BLoC pattern implementation.


# Usage

*First we need to define actions and state*


*Actions*
```
abstract CounterAction{

}

class IncrementCounterAction extends CounterAction{
}
```

*State*
```
class CounterState {
  int counter;

  CounterState() : this.counter = 0;
}
```


*Then we implement BloC as follows*
```
class CounterBloc extends Bloc<CounterAction, CounterState> {
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
```
