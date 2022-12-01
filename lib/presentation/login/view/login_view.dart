import 'package:clean_achitecture/app/di.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:clean_achitecture/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:clean_achitecture/presentation/resources/color_manager.dart';
import 'package:clean_achitecture/presentation/resources/strings_manager.dart';
import 'package:clean_achitecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../app/app_prefs.dart';
import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = instance<LoginViewModel>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  _bind() {
    _viewModel.start();
    _userNameController
        .addListener(() => _viewModel.setUserName(_userNameController.text));
    _userPasswordController.addListener(
        () => _viewModel.setPassword(_userPasswordController.text));
    _viewModel.isUserLoggenInSuccefullyStreamController.stream
        .listen((isLogged) {
      if (isLogged) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: ((context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _viewModel.login();
              }) ??
              _getContentWidget();
        }),
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(
              height: AppSize.s100,
            ),
            Center(
              child: Image.asset(ImageAssets.splashLogo),
            ),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outIsUserNameValid,
                builder: ((context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _userNameController,
                    decoration: InputDecoration(
                      hintText: AppStrings.userName.tr(),
                      labelText: AppStrings.userName.tr(),
                      errorText: (snapshot.data ?? true)
                          ? null
                          : AppStrings.usernameError.tr(),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outIsPasswordValid,
                builder: ((context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _userPasswordController,
                    decoration: InputDecoration(
                      hintText: AppStrings.password.tr(),
                      labelText: AppStrings.password.tr(),
                      errorText: (snapshot.data ?? true)
                          ? null
                          : AppStrings.passwordError.tr(),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outAreAllInputValid,
                builder: ((context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                      onPressed: (snapshot.data ?? false)
                          ? () {
                              _viewModel.login();
                            }
                          : null,
                      child: const Text(AppStrings.login).tr(),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: AppPadding.p8,
                right: AppPadding.p10,
                left: AppPadding.p10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.forgotPasswordRoute);
                    },
                    child: Text(
                      AppStrings.forgotPpassword.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.registerRoute);
                    },
                    child: Text(
                      AppStrings.registerMassege.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
