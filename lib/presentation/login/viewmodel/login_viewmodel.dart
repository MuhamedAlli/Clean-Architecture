import 'dart:async';

import 'package:clean_achitecture/presentation/base/baseviewmodel.dart';
import 'package:clean_achitecture/presentation/common/freezed_data_classes.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../../domain/usecase/login_usecase.dart';

class LoginViewModel extends BaseViewModel
    implements LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast();
  StreamController isUserLoggenInSuccefullyStreamController =
      StreamController<bool>();
  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  var loginObject = LoginObject("", "");
  //inputs
  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggenInSuccefullyStreamController.close();
  }

  @override
  void start() {
    // view model should tell view please show content state
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputAreAllInputValid => _areAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputValid.add(null);
  }

  @override
  login() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold((failure) {
      //left -> failure
      //print (failure.message)
      inputState
          .add(ErrorState(StateRendererType.popupErrorstate, failure.message));
    }, (data) {
      //right -> Authntication -> data (success)
      //print(data.customer?.name)
      inputState.add(ContentState());
      isUserLoggenInSuccefullyStreamController.add(true);
    });
  }

  //outputs
  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isStringValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isStringValid(userName));

  @override
  Stream<bool> get outAreAllInputValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _areAllInputsValid() {
    return _isStringValid(loginObject.userName) &&
        _isStringValid(loginObject.password);
  }

  bool _isStringValid(String string) {
    return string.isNotEmpty;
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();
  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputAreAllInputValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputValid;
}
