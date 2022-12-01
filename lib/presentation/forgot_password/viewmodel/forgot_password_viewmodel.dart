import 'dart:async';
import 'package:clean_achitecture/domain/usecase/forgot_password_usecase.dart';
import 'package:clean_achitecture/presentation/base/baseviewmodel.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../../app/functions.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();
  final ForgotPasswordUsecase _forgotPasswordUsecase;
  ForgotPasswordViewModel(this._forgotPasswordUsecase);
  var email = "";
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUsecase.execute(email)).fold((failure) {
      inputState
          .add(ErrorState(StateRendererType.popupErrorstate, failure.message));
    }, (supportMeassage) {
      inputState.add(SuccesstState(supportMeassage));
    });
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  Stream<bool> get outIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream
          .map((isAllInputValid) => _isAllInputValid());

  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

abstract class ForgotPasswordViewModelInputs {
  forgotPassword();
  setEmail(String email);
  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}
