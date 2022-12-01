import 'package:clean_achitecture/data/network/failure.dart';
import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/domain/repository/repository.dart';
import 'package:clean_achitecture/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class HomeUseCase implements BaseUseCase<void, HomeObject> {
  final Repository _repository;
  HomeUseCase(this._repository);
  @override
  Future<Either<Failure, HomeObject>> execute(void input) async {
    return await _repository.getHomeData();
  }
}
