import 'dart:async';

class StreamValue<T> {
  final T _initialValue;
  T _latestValue;
  final StreamController<T> _controller;
  bool _hasInitialValue = true;

  StreamValue(T initialValue)
      : _initialValue = initialValue,
        _latestValue = initialValue,
        _controller = StreamController<T>.broadcast();

  Stream<T> get stream => _controller.stream;

  void add(T value) {
    _latestValue = value;
    _hasInitialValue = false;
    _controller.add(value);
  }

  void addError(Object error, [StackTrace? stackTrace]) {
    _controller.addError(error, stackTrace);
  }

  void listen(void Function(T) onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    if (_hasInitialValue) {
      onData(_initialValue);
    } else {
      onData(_latestValue);
    }
    _controller.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void close() {
    _controller.close();
  }
}
