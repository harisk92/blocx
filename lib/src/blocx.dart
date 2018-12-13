import 'package:blocx/src/middleware.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<A, S> {
  Middleware _middleware;

  PublishSubject<A> _actionSubject = PublishSubject<A>();
  PublishSubject<A> _artifactSubject = PublishSubject<A>();
  BehaviorSubject<S> _stateSubject = BehaviorSubject<S>();

  Stream<S> get state => _stateSubject.stream;

  Stream<A> get artifact => _artifactSubject.stream;

  Bloc() {
    _listen();
  }

  dispose() {
    _actionSubject.close();
    _stateSubject.close();
    _artifactSubject.close();
  }

  void dispatch(A action) {
    if (!_actionSubject.isClosed && !_actionSubject.isPaused)
      _actionSubject.sink.add(action);
  }

  Observable<A> map(Observable<A> eventSubject) => eventSubject;

  void _listen() {
    map(_actionSubject)
        .scan<S>(_processState, initialState)
        .listen(_stateSubject.add);
  }

  S _processState(S state, A action, int index) {
    S newState = _middleware != null
        ? _middleware.execute(action, updateState(state, action))
        : updateState(state, action);
    return newState;
  }

  S updateState(S state, A action);

  S get initialState;

  void middlewares(List<Middleware> v) {
    for (Middleware value in v ?? []) {
      if (_middleware == null) {
        _middleware = value;
      } else {
        _middleware.next = value;
      }
    }
  }
}
