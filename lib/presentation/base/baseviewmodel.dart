import 'dart:async';

import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  //functions that will be shared in through any viewModel
  final StreamController _inputStreamController = BehaviorSubject<FlowState>();
  @override
  Sink get inputState => _inputStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStreamController.close();
  }
}

//actions or events from view to ViewModel!!!
abstract class BaseViewModelInputs {
  void start();
  void dispose();
  Sink get inputState;
}

//here will be data will be passing to view from View Model!!!!
abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
