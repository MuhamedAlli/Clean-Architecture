import 'package:clean_achitecture/app/app_prefs.dart';
import 'package:clean_achitecture/data/data_source/local_data_source.dart';
import 'package:clean_achitecture/data/data_source/remote_data_source.dart';
import 'package:clean_achitecture/data/network/app_api.dart';
import 'package:clean_achitecture/data/network/dio_factory.dart';
import 'package:clean_achitecture/data/network/network_info.dart';
import 'package:clean_achitecture/data/repository/repository_impl.dart';
import 'package:clean_achitecture/domain/repository/repository.dart';
import 'package:clean_achitecture/domain/usecase/details_usecase.dart';
import 'package:clean_achitecture/domain/usecase/forgot_password_usecase.dart';
import 'package:clean_achitecture/domain/usecase/home_usecase.dart';
import 'package:clean_achitecture/domain/usecase/login_usecase.dart';
import 'package:clean_achitecture/domain/usecase/register_usecase.dart';
import 'package:clean_achitecture/presentation/forgot_password/viewmodel/forgot_password_viewmodel.dart';
import 'package:clean_achitecture/presentation/login/viewmodel/login_viewmodel.dart';
import 'package:clean_achitecture/presentation/main/pages/home/viewmodel/home_viewmodel.dart';
import 'package:clean_achitecture/presentation/register/viewmodel/register_viewmodel.dart';
import 'package:clean_achitecture/presentation/store_details/viewmodel/store_details_viewmodel.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final instance = GetIt.instance;
Future<void> initAppModule() async {
  //app module , where we put all generic dependencies
  //shared prefe instance
  final sharedPrefs = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  //app Prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
//network info  intance
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(InternetConnectionChecker()));
  //dio factory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));
  //Dio insance
  Dio dio = await instance<DioFactory>().getDio();
  //app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
  //Remote data Source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImpl(instance()));
  //Local data Source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());
  //repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance(), instance()));
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUsecase>()) {
    instance.registerFactory<ForgotPasswordUsecase>(
        () => ForgotPasswordUsecase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

initDetailsModule() {
  if (!GetIt.I.isRegistered<DetailsUseCase>()) {
    instance.registerFactory<DetailsUseCase>(() => DetailsUseCase(instance()));
    instance
        .registerFactory<DetailsViewModel>(() => DetailsViewModel(instance()));
  }
}
