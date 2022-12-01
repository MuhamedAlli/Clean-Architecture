import 'dart:async';
import 'dart:ffi';
import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/domain/usecase/home_usecase.dart';
import 'package:clean_achitecture/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../common/state_renderer/state_renderer.dart';
import '../../../../common/state_renderer/state_renderer_impl.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final StreamController _homeObjectStreamController =
      BehaviorSubject<HomeData>();

  final HomeUseCase _homeUseCase;
  HomeViewModel(this._homeUseCase);

  // --Inputs
  @override
  void start() {
    _getHomeData();
  }

  _getHomeData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));

    // ignore: void_checks
    (await _homeUseCase.execute(Void)).fold((failure) {
      //left -> failure
      //print (failure.message)
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (homeObject) {
      //right -> Authntication -> data (success)
      //print(data.customer?.name)
      inputState.add(ContentState());
      inputHomeObject.add(homeObject.data);
    });
  }

  @override
  void dispose() {
    _homeObjectStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputHomeObject => _homeObjectStreamController.sink;
// --Outputs
  @override
  Stream<HomeData> get outputHomeObject =>
      _homeObjectStreamController.stream.map((homeObject) => homeObject);
}

abstract class HomeViewModelInput {
  Sink get inputHomeObject;
}

abstract class HomeViewModelOutput {
  Stream<HomeData> get outputHomeObject;
}
