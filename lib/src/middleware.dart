abstract class Middleware<A, S> {
  Middleware next;

  S onState(A action, S state);

  S execute(A action, S state) {
    if (next != null) {
      return next.onState(action, onState(action, state));
    }
    return onState(action, state);
  }
}
