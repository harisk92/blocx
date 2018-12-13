abstract class Middleware<A, S> {
  /*
   Next middleware to be called.
   */
  Middleware next;

  /*
  Process,transform and map action and state.
  For example you want to log state to console

  S onState(A action,S state){
  print(state);
  return state;
  }
   */
  S onState(A action, S state);

  S execute(A action, S state) {
    if (next != null) {
      return next.onState(action, onState(action, state));
    }
    return onState(action, state);
  }
}
