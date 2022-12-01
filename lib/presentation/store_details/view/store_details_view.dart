import 'package:clean_achitecture/app/di.dart';
import 'package:clean_achitecture/presentation/resources/strings_manager.dart';
import 'package:clean_achitecture/presentation/resources/values_manager.dart';
import 'package:clean_achitecture/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/color_manager.dart';
import '../../resources/routes_manager.dart';

class StoreDetailsView extends StatefulWidget {
  const StoreDetailsView({super.key});

  @override
  State<StoreDetailsView> createState() => _StoreDetailsViewState();
}

class _StoreDetailsViewState extends State<StoreDetailsView> {
  final DetailsViewModel _viewModel = instance<DetailsViewModel>();
  _bind() {
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: ColorManager.white,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
          },
        ),
        backgroundColor: ColorManager.primary,
        title: Text(AppStrings.storeDetails.tr(),
            style: Theme.of(context).textTheme.titleSmall),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: StreamBuilder<FlowState>(
            stream: _viewModel.outputState,
            builder: ((context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _viewModel.start();
                  }) ??
                  _getContentWidget();
            }),
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder(
      stream: _viewModel.outputDetailsData,
      builder: ((context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(
            left: AppPadding.p12,
            right: AppPadding.p12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getImage(snapshot.data?.image),
              _getSection(AppStrings.details.tr()),
              _getSectionDetails(snapshot.data?.details),
              _getSection(AppStrings.services.tr()),
              _getSectionDetails(snapshot.data?.services),
              _getSection(AppStrings.aboutStore.tr()),
              _getSectionDetails(snapshot.data?.about),
            ],
          ),
        );
      }),
    );
  }

  Widget _getImage(String? image) {
    if (image != null) {
      return Padding(
        padding: const EdgeInsets.only(top: AppPadding.p12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSize.s12),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getSection(String? sectionName) {
    if (sectionName != null) {
      return Padding(
        padding: const EdgeInsets.only(top: AppPadding.p12),
        child: Text(
          sectionName,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _getSectionDetails(String? sectionDetails) {
    if (sectionDetails != null) {
      return Padding(
        padding: const EdgeInsets.only(top: AppPadding.p12),
        child: Text(
          sectionDetails,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      );
    } else {
      return Container();
    }
  }
}
