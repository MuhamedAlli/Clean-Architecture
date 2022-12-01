import 'dart:async';

import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/presentation/base/baseviewmodel.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

class OnBoardingViewModle extends BaseViewModel
    with OnBoardingViewModleInputs, OnBoardingViewModleOutputs {
  final StreamController _streamController =
      StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentIndex = 0;
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    _postDataToView();
  }

  //from View to ViewModel
  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  //Stream Controller Inputs
  @override
  Sink get inputSliderViewObject => _streamController.sink;

  //Stream Controller Outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);
  //Private Funtions
  List<SliderObject> _getSliderData() {
    return [
      SliderObject(AppStrings.onBoardingTitle1.tr(),
          AppStrings.onBoardingSubTitle1.tr(), ImageAssets.onboarding_logo1),
      SliderObject(AppStrings.onBoardingTitle2.tr(),
          AppStrings.onBoardingSubTitle2.tr(), ImageAssets.onboarding_logo2),
      SliderObject(AppStrings.onBoardingTitle3.tr(),
          AppStrings.onBoardingSubTitle3.tr(), ImageAssets.onboarding_logo3),
      SliderObject(AppStrings.onBoardingTitle4.tr(),
          AppStrings.onBoardingSubTitle4.tr(), ImageAssets.onboarding_logo4),
    ];
  }

  void _postDataToView() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
}

abstract class OnBoardingViewModleInputs {
  int goNext();
  int goPrevious();
  void onPageChanged(int index);
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModleOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}
