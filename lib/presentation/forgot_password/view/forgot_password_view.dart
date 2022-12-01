import 'package:clean_achitecture/app/di.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:clean_achitecture/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../resources/assets_manager.dart';
import '../../resources/color_manager.dart';
import '../../resources/strings_manager.dart';
import '../../resources/values_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordViewModel _passwordViewModel =
      instance<ForgotPasswordViewModel>();
  final TextEditingController _emailEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bind() {
    _passwordViewModel.start();
    _emailEditingController.addListener(() {
      _passwordViewModel.setEmail(_emailEditingController.text);
    });
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _passwordViewModel.outputState,
        builder: ((context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _passwordViewModel.forgotPassword();
              }) ??
              _getContentWidget();
        }),
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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
                stream: _passwordViewModel.outIsEmailValid,
                builder: ((context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailEditingController,
                    decoration: InputDecoration(
                      hintText: AppStrings.email.tr(),
                      labelText: AppStrings.email.tr(),
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
            const SizedBox(
              height: AppSize.s28,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _passwordViewModel.outputIsAllInputValid,
                builder: ((context, snapshot) {
                  return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _passwordViewModel.forgotPassword();
                              }
                            : null,
                        child: const Text(
                          AppStrings.resetPpassword,
                        ).tr(),
                      ));
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
