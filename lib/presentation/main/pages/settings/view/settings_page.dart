import 'package:clean_achitecture/app/app_prefs.dart';
import 'package:clean_achitecture/app/di.dart';
import 'package:clean_achitecture/data/data_source/local_data_source.dart';
import 'package:clean_achitecture/presentation/resources/assets_manager.dart';
import 'package:clean_achitecture/presentation/resources/language_manager.dart';
import 'package:clean_achitecture/presentation/resources/routes_manager.dart';
import 'package:clean_achitecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import '../../../../resources/strings_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPadding.p8),
        children: [
          ListTile(
              leading: SvgPicture.asset(ImageAssets.change_lang_ic),
              title: Text(AppStrings.changeLanguage.tr(),
                  style: Theme.of(context).textTheme.bodyLarge),
              trailing: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_isRtl() ? math.pi : 0),
                child: SvgPicture.asset(ImageAssets.settings_right_arrow_ic),
              ),
              onTap: () {
                _changeLanguage();
              }),
          ListTile(
              leading: SvgPicture.asset(ImageAssets.contact_us_ic),
              title: Text(AppStrings.contactUs.tr(),
                  style: Theme.of(context).textTheme.bodyLarge),
              trailing: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_isRtl() ? math.pi : 0),
                child: SvgPicture.asset(ImageAssets.settings_right_arrow_ic),
              ),
              onTap: () {
                _contactUs();
              }),
          ListTile(
              leading: SvgPicture.asset(ImageAssets.invite_friends_ic),
              title: Text(AppStrings.inviteYourFriends.tr(),
                  style: Theme.of(context).textTheme.bodyLarge),
              trailing: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_isRtl() ? math.pi : 0),
                child: SvgPicture.asset(ImageAssets.settings_right_arrow_ic),
              ),
              onTap: () {
                _inviteFriends();
              }),
          ListTile(
            leading: SvgPicture.asset(ImageAssets.logout_ic),
            title: Text(AppStrings.logout.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(_isRtl() ? math.pi : 0),
              child: SvgPicture.asset(ImageAssets.settings_right_arrow_ic),
            ),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  bool _isRtl() {
    return context.locale == ARABIC_LOCAL;
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  _contactUs() {
    //task for me!!
  }
  _inviteFriends() {
    //task for me!!
  }
  _logout() {
    //app pref make user logged out
    _appPreferences.setUserLoggedOut();
    //clear cache of logged out user
    _localDataSource.clearCache();
    //navigate to login Screen
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}
