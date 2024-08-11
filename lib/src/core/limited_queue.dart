import 'dart:collection';

extension LimitedQueue<T> on Queue<T> {
  void addWithLimit(T t, int limit) {
    addFirst(t);
    if (this.length > limit) {
      removeLast();
    }
  }
}
