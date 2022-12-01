import 'dart:async';
import 'dart:ffi';

import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/domain/usecase/details_usecase.dart';
import 'package:clean_achitecture/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/state_renderer/state_renderer.dart';
import '../../common/state_renderer/state_renderer_impl.dart';

class DetailsViewModel extends BaseViewModel
    with DetailsViewModelInput, DetailsViewModelOutput {
  final DetailsUseCase _detailsUseCase;
  final StreamController _setailsDataStreamController =
      BehaviorSubject<DetailsData>();
  DetailsViewModel(this._detailsUseCase);

  //--Inputs
  @override
  void start() {
    _getDetailsData();
  }

  @override
  void dispose() {
    _setailsDataStreamController.close();
    super.dispose();
  }

  _getDetailsData() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));

    // ignore: void_checks
    (await _detailsUseCase.execute(Void)).fold((failure) {
      //left -> failure
      //print (failure.message)
      inputState.add(
          ErrorState(StateRendererType.fullScreenErrorState, failure.message));
    }, (detailsObject) {
      //right -> Authntication -> data (success)
      //print(data.customer?.name)
      inputState.add(ContentState());
      inputDetailsData.add(detailsObject);
    });
  }

  @override
  Sink get inputDetailsData => _setailsDataStreamController.sink;
  //--Outputs
  @override
  Stream<DetailsData> get outputDetailsData =>
      _setailsDataStreamController.stream.map((detailsData) => detailsData);
}

abstract class DetailsViewModelInput {
  Sink get inputDetailsData;
}

abstract class DetailsViewModelOutput {
  Stream<DetailsData> get outputDetailsData;
}
