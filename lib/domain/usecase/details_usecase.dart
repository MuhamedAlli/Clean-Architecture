import 'package:clean_achitecture/data/network/failure.dart';
import 'package:clean_achitecture/domain/model/models.dart';
import 'package:clean_achitecture/domain/repository/repository.dart';
import 'package:clean_achitecture/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class DetailsUseCase implements BaseUseCase<void, DetailsData> {
  final Repository _repository;
  DetailsUseCase(this._repository);
  @override
  Future<Either<Failure, DetailsData>> execute(void input) async {
    return await _repository.getDetailsData();
  }
}
