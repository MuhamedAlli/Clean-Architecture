import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_achitecture/app/di.dart';
import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:clean_achitecture/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:clean_achitecture/presentation/resources/color_manager.dart';
import 'package:clean_achitecture/presentation/resources/routes_manager.dart';
import 'package:clean_achitecture/presentation/resources/strings_manager.dart';
import 'package:clean_achitecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = instance<HomeViewModel>();
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
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<FlowState>(
          stream: _viewModel.outputState,
          builder: ((context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _viewModel.start();
                }) ??
                _getContentWidget();
          }),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return StreamBuilder<HomeData>(
        stream: _viewModel.outputHomeObject,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getBannerWidget(snapshot.data?.banners),
              _getSection(AppStrings.services.tr()),
              _getServicesWidget(snapshot.data?.services),
              _getSection(AppStrings.stores.tr()),
              _getStoreWidget(snapshot.data?.stores)
            ],
          );
        });
  }

/*  Widget _getBannersCarousel() {
    return StreamBuilder<List<BannerAd>>(
        stream: _viewModel.outputBanners,
        builder: ((context, snapshot) {
          return _getBannerWidget(snapshot.data);
        }));
  }
*/
  Widget _getBannerWidget(List<BannerAd>? banners) {
    if (banners != null) {
      return CarouselSlider(
          items: banners
              .map((banner) => SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: AppSize.s1_5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          side: BorderSide(
                              color: ColorManager.primary, width: AppSize.s1)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        child: Image.network(
                          banner.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
              height: AppSize.s190,
              autoPlay: true,
              enableInfiniteScroll: true,
              enlargeCenterPage: true));
    } else {
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppPadding.p12,
          left: AppPadding.p12,
          right: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }

  /* Widget _getServices() {
    return StreamBuilder<List<Serives>>(
        stream: _viewModel.outputServices,
        builder: ((context, snapshot) {
          return _getServicesWidget(snapshot.data);
        }));
  }
*/
  Widget _getServicesWidget(List<Serives>? services) {
    if (services != null) {
      return Padding(
        padding:
            const EdgeInsets.only(left: AppPadding.p12, right: AppPadding.p12),
        child: Container(
          height: AppSize.s160,
          margin: const EdgeInsets.symmetric(vertical: AppMargin.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: services
                .map(
                  (serive) => Card(
                    elevation: AppSize.s4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.s12),
                        side: BorderSide(
                            color: ColorManager.white, width: AppSize.s1)),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.s12),
                          child: Image.network(
                            serive.image,
                            fit: BoxFit.cover,
                            width: AppSize.s120,
                            height: AppSize.s120,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: AppPadding.p8),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                serive.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.labelLarge,
                              )),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  /* Widget _getStores() {
    return StreamBuilder<List<Store>>(
        stream: _viewModel.outputStores,
        builder: ((context, snapshot) {
          return _getStoreWidget(snapshot.data);
        }));
  }
*/
  Widget _getStoreWidget(List<Store>? store) {
    if (store != null) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppPadding.p12, right: AppPadding.p12, top: AppPadding.p12),
        child: Flex(
          direction: Axis.vertical,
          children: [
            GridView.count(
              crossAxisCount: AppSize.s2,
              crossAxisSpacing: AppSize.s8,
              mainAxisSpacing: AppSize.s8,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              children: List.generate(store.length, (index) {
                return InkWell(
                  onTap: (() {
                    Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                  }),
                  child: Card(
                    elevation: AppSize.s4,
                    child: Image.network(
                      store[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
