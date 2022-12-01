import 'package:clean_achitecture/app/constants.dart';
import 'package:clean_achitecture/data/responses/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;
  @POST("/customers/login")
  Future<AuthenticationResponse> login(
      @Field("email") email, @Field("password") password);
  @POST("/customers/forgotPassword")
  Future<ForgotPasswordResponse> forgotPassword(@Field("email") String email);
  @POST("/customers/register")
  Future<AuthenticationResponse> register(
      @Field("user_name") userName,
      @Field("country_mobile_code") countryMobileCode,
      @Field("mobile_number") mobileNumber,
      @Field("email") email,
      @Field("password") password,
      @Field("profile_picture") profilPicture);
  @GET("/home")
  Future<HomeResponse> getHomeData();
  @GET("/storeDatails/1")
  Future<DetailsResponse> getDetailsData();
}
