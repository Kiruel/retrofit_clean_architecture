import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import '../../../../../bin/features/home/domain/entities/home_client.dart';
import '../../../../../bin/features/home/data/datasources/home_remote_data_source.dart';
import '../../../../fixtures_reader.dart';
import '../../../../../bin/core/errors/exceptions.dart';

class MockHomeClient extends Mock implements HomeClient {}

void main() {
  late HomeRemoteDataSourceImpl dataSource;

  final Article tArticle = Article.fromJson('article.json'.toFixture());
  final List<Article> tArticles = [
    tArticle,
  ];

  late MockHomeClient homeClient;

  setUp(() async {
    registerFallbackValue(Uri());

    homeClient = MockHomeClient();

    dataSource = HomeRemoteDataSourceImpl(homeClient: homeClient);
  });

  group('get articles', () {
    test(
      'should perform a GET request on /articles',
      () async {
        // arrange
        when(
          () => homeClient.getArticles(),
        ).thenAnswer(
          (_) async => tArticles,
        );

        // act
        dataSource.getArticles();
        // assert
        verify(() => homeClient.getArticles());
        verifyNoMoreInteractions(homeClient);
      },
    );

    test(
      'should return List<Articles> when the response is 200 (success)',
      () async {
        // arrange
        when(
          () => homeClient.getArticles(),
        ).thenAnswer(
          (_) async => tArticles,
        );
        // act
        final response = await dataSource.getArticles();
        // assert
        expect(response, tArticles);
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other (unsuccess)',
      () async {
        // arrange
        when(() => homeClient.getArticles()).thenThrow(
          DioError(
            response: Response(
              data: 'Something went wrong',
              statusCode: 404,
              requestOptions: RequestOptions(path: ''),
            ),
            requestOptions: RequestOptions(path: ''),
          ),
        );
        // act
        final call = dataSource.getArticles;
        // assert
        expect(
          () => call(),
          throwsA(const TypeMatcher<ServerException>()),
        );
      },
    );
  });
}
