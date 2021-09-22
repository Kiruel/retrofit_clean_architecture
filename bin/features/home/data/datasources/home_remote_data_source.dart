import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/home_client.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<List<Article>> getArticles();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({
    required this.homeClient,
  });

  HomeClient homeClient;

  @override
  Future<List<Article>> getArticles() async {
    try {
      return await homeClient.getArticles();
    } on DioError catch (_) {
      throw ServerException();
    }
  }
}
