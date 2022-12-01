import 'package:clean_achitecture/data/network/failure.dart';
import 'package:clean_achitecture/data/network/requests.dart';
import 'package:clean_achitecture/domain/model/models.dart';
import 'package:dartz/dartz.dart';

abstract class Repository {
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest);
  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest);
  Future<Either<Failure, HomeObject>> getHomeData();
  Future<Either<Failure, DetailsData>> getDetailsData();
}
