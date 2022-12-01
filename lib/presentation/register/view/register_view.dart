import 'dart:io';

import 'package:clean_achitecture/app/app_prefs.dart';
import 'package:clean_achitecture/app/constants.dart';
import 'package:clean_achitecture/app/di.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:clean_achitecture/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:clean_achitecture/presentation/resources/color_manager.dart';
import 'package:clean_achitecture/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/assets_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/strings_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  _bind() {
    _viewModel.start();
    _userNameTextEditingController.addListener(() {
      _viewModel.setUserName(_userNameTextEditingController.text);
    });
    _emailTextEditingController.addListener(() {
      _viewModel.setEmai(_emailTextEditingController.text);
    });
    _passwordTextEditingController.addListener(() {
      _viewModel.setPassword(_passwordTextEditingController.text);
    });
    _mobileNumberTextEditingController.addListener(() {
      _viewModel.setMobileNumber(_mobileNumberTextEditingController.text);
    });
    _viewModel.isUserRegisteredSuccefullyStreamController.stream
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
                _viewModel.register();
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
              height: AppSize.s28,
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
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorUserName,
                builder: ((context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _userNameTextEditingController,
                    decoration: InputDecoration(
                        hintText: AppStrings.userName.tr(),
                        labelText: AppStrings.userName.tr(),
                        errorText: snapshot.data),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  right: AppPadding.p28,
                  left: AppPadding.p28,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CountryCodePicker(
                        onChanged: (countryCode) {
                          _viewModel.setCountryCode(
                              countryCode.dialCode ?? Constants.token);
                        },
                        initialSelection: "+966",
                        favorite: const ["+966", "+20"],
                        showCountryOnly: true,
                        hideMainText: true,
                        showOnlyCountryWhenClosed: true,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: StreamBuilder<String?>(
                        stream: _viewModel.outputErorMobileNumber,
                        builder: ((context, snapshot) {
                          return TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _mobileNumberTextEditingController,
                            decoration: InputDecoration(
                                hintText: AppStrings.mobileNumber.tr(),
                                labelText: AppStrings.mobileNumber.tr(),
                                errorText: snapshot.data),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorEmail,
                builder: ((context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTextEditingController,
                    decoration: InputDecoration(
                      hintText: AppStrings.email.tr(),
                      labelText: AppStrings.email.tr(),
                      errorText: snapshot.data,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<String?>(
                stream: _viewModel.outputErrorPassword,
                builder: ((context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: _passwordTextEditingController,
                    decoration: InputDecoration(
                      hintText: AppStrings.password.tr(),
                      labelText: AppStrings.password.tr(),
                      errorText: snapshot.data,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: AppSize.s18,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: Container(
                height: AppSize.s40,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppSize.s8)),
                  border: Border.all(color: ColorManager.lightGray),
                ),
                child: GestureDetector(
                  child: getMediaWidget(),
                  onTap: () {
                    _showPicker(context);
                  },
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s40,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: AppPadding.p28,
                left: AppPadding.p28,
              ),
              child: StreamBuilder<bool>(
                stream: _viewModel.outputAllInputsValid,
                builder: ((context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(
                      onPressed: (snapshot.data ?? false)
                          ? () {
                              _viewModel.register();
                            }
                          : null,
                      child: const Text(AppStrings.register).tr(),
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
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppStrings.alreadyHaveAccount.tr(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: AppPadding.p8, right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: AppSize.s2,
              child: Text(
                AppStrings.profilePicture.tr(),
                maxLines: AppSize.ss1,
                style: Theme.of(context).textTheme.titleLarge,
              )),
          Flexible(
              flex: AppSize.ss1,
              child: StreamBuilder<File>(
                stream: _viewModel.outputProfilePicture,
                builder: (context, snapshot) {
                  return _imagePickerByUser(snapshot.data);
                },
              )),
          Flexible(
              flex: AppSize.s2,
              child: SvgPicture.asset(ImageAssets.photoCamera)),
        ],
      ),
    );
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: ((BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera),
                title: const Text(AppStrings.photoGallery).tr(),
                onTap: (() {
                  _imageFromGallery();
                  Navigator.of(context).pop();
                }),
              ),
              ListTile(
                trailing: const Icon(Icons.arrow_forward),
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text(AppStrings.photoCamera).tr(),
                onTap: (() {
                  _imageFromCamera();
                  Navigator.of(context).pop();
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  _imageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _viewModel.setProfilePicture(File(image?.path ?? ""));
  }

  Widget _imagePickerByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      //return image
      return Image.file(image);
    } else {
      return Container();
    }
  }
}
