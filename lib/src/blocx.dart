import 'package:blocx/src/middleware.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc<A, S> {
  Middleware _middleware;

  PublishSubject<A> _actionSubject = PublishSubject<A>();
  PublishSubject<A> _artifactSubject = PublishSubject<A>();
  BehaviorSubject<S> _stateSubject = BehaviorSubject<S>();

  /*
  Stream that exposes latest state
   */
  Stream<S> get state => _stateSubject.stream;

  /*
  Stream that exposes artifacts.Artifacts are meant to be side effects that come with state update for example deleting
  of entry requires you to show dialog or toast message and this could be achieved with artifact.
   */
  Stream<A> get artifact => _artifactSubject.stream;

  Bloc() {
    _listen();
  }

  /*
  Needed to be called when BloC is no more needed
   */
  dispose() {
    _actionSubject.close();
    _stateSubject.close();
    _artifactSubject.close();
  }

  /*
  Used for dispatching actions
   */
  void dispatch(A action) {
    if (!_actionSubject.isClosed && !_actionSubject.isPaused)
      _actionSubject.sink.add(action);
  }

  /*
  Used to transform stream.For example you may have SearchAction which performs live search and you need to delay it until
  user stops entering characters and you want to propagate other actions normally.

  Observable<A> transform (Observable<A> eventSubject)=> Observable.merge([
   eventSubject.where((ev) => ev is SearchAction).debounce(700).distinct(),
   eventSubject.where((ev) => !(ev is SearchAction)),
  ])
   */
  Observable<A> transform(Observable<A> eventSubject) => eventSubject;

  /*
  Initializes BLoC and starts listening for actions.
   */
  void _listen() {
    transform(_actionSubject)
        .scan<S>(_processState, initialState)
        .listen(_stateSubject.add);
  }

  S _processState(S state, A action, int index) {
    S newState = _middleware != null
        ? _middleware.execute(action, updateState(state, action))
        : updateState(state, action);
    return newState;
  }

  /*
  Processes actions and map them to adequate state and returns new state.
   */
  S updateState(S state, A action);

  /*
  Initial state for BloC
   */
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
