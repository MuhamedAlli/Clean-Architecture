import 'package:clean_achitecture/app/constants.dart';
import 'package:clean_achitecture/data/data_source/remote_data_source.dart';
import 'package:clean_achitecture/data/mapper/mapper.dart';
import 'package:clean_achitecture/data/network/error_handler.dart';
import 'package:clean_achitecture/data/network/network_info.dart';
import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/data/network/requests.dart';
import 'package:clean_achitecture/data/network/failure.dart';
import 'package:clean_achitecture/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

import '../data_source/local_data_source.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;

  final NetworkInfo _networkInfo;
  RepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);
  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //its connected to internet , it is safe to call API
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == 0) {
          //success
          //return data
          //return Either Right
          return Right(response.toDomain());
        } else {
          //failure --business erroe
          //return Either Lfet
          return Left(
              Failure(409, response.message ?? "business error message"));
        }
      } catch (error) {
        return left(ErrorHandler.handle(error).failure);
      }
    } else {
      //return internet connetc error
      //return Either Left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        //its connected to internet , it is safe to call API
        final response = await _remoteDataSource.forgotPassword(email);
        if (response.status == Constants.zero) {
          return Right(response.toDomain());
        } else {
          //failure --business erroe
          //return Either Lfet
          return Left(Failure(response.status ?? ResponseCode.DEFAULT,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        //its connected to internet , it is safe to call API
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == Constants.zero) {
          //success
          //return data
          //return Either Right
          return Right(response.toDomain());
        } else {
          //failure --business erroe
          //return Either Lfet
          return Left(
              Failure(409, response.message ?? "business error message"));
        }
      } catch (error) {
        return left(ErrorHandler.handle(error).failure);
      }
    } else {
      //return internet connetc error
      //return Either Left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      //get response from cache
      final response = await _localDataSource.getHomeData();
      return Right(response.toDomain());
    } catch (cacheError) {
      //cahce is not existing or is not valid
      //its the time to get response from API side
      if (await _networkInfo.isConnected) {
        try {
          //its connected to internet , it is safe to call API
          final response = await _remoteDataSource.getHomeData();
          if (response.status == Constants.zero) {
            //succes
            //return either right
            //save home response to the cache (Local data Source)
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            //failure --business erroe
            //return Either Lfet
            return Left(Failure(response.status ?? ResponseCode.DEFAULT,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }

  @override
  Future<Either<Failure, DetailsData>> getDetailsData() async {
    try {
      //get response from cache
      final response = await _localDataSource.getDetailsData();
      return Right(response.toDomain());
    } catch (error) {
      if (await _networkInfo.isConnected) {
        //internet connected
        try {
          //its connected to internet , it is safe to call API
          final response = await _remoteDataSource.getDetailsData();
          if (response.status == Constants.zero) {
            //succes
            //return either right
            //save details response to the cache (Local data Source)
            _localDataSource.saveDetailsToCache(response);
            return Right(response.toDomain());
          } else {
            //failure --business erroe
            //return Either Lfet
            return Left(Failure(response.status ?? ResponseCode.DEFAULT,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          //there is error from dio
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        //no Internet Connection!!!
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}
