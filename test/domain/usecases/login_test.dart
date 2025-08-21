
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/domain/usecases/login.dart';

import 'get_products_test.mocks.dart';

import 'package:mockito/mockito.dart';
import 'package:either_dart/either.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/domain/repositories/fake_store_repository.dart';


@GenerateNiceMocks([MockSpec<FakeStoreRepository>()])

void main() {
  late Login usecase;
  late MockFakeStoreRepository mockRepository;

  
  final tLoginResponse = LoginResponse(
    token: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsInVzZXIiOiJqb2huZCIsImlhdCI6MTc1NTY1MjkyMX0.TDkYAEEmz-Jdet7NyuSObXdnmwlt2HOktqXvtgYJ8ls',
  );

  
  final tFailure = AuthFailure();

  setUp(() {
    
    provideDummy<Either<Failure, LoginResponse>>(Right(tLoginResponse));
    
    mockRepository = MockFakeStoreRepository();
    usecase = Login(mockRepository);
  });

  group('Login', () {
    test('debería ser una instancia de Login', () {
      
      expect(usecase, isA<Login>());
    });

    test('debería llamar al repository.login con las credenciales correctas', () async {
      
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(tLoginResponse));

      
      await usecase('testuser', 'testpass');

      
      verify(mockRepository.login('testuser', 'testpass')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('debería retornar LoginResponse cuando el login es exitoso', () async {
      
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Right(tLoginResponse));

      
      final result = await usecase('testuser', 'testpass');

      
      expect(result.isRight, true);
      expect(result, isA<Right<Failure, LoginResponse>>());
      
      result.fold(
        (failure) => fail('No debería retornar failure'),
        (loginResponse) {
          expect(loginResponse, tLoginResponse);
          expect(loginResponse.token, isNotEmpty);
          expect(loginResponse.token, contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'));
        },
      );
    });

    test('debería retornar AuthFailure cuando las credenciales son incorrectas', () async {
      
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => Left(tFailure));

      
      final result = await usecase('wronguser', 'wrongpass');

      
      expect(result.isLeft, true);
      expect(result, isA<Left<Failure, LoginResponse>>());
      
      result.fold(
        (failure) {
          expect(failure, tFailure);
          expect(failure, isA<AuthFailure>());
        },
        (loginResponse) => fail('No debería retornar login response'),
      );
    });



    test('debería funcionar con diferentes credenciales', () async {
      
      final testCredentials = [
        {'username': 'user1', 'password': 'pass1'},
        {'username': 'user2', 'password': 'pass2'},
        {'username': 'admin', 'password': 'admin123'},
      ];

      for (final credentials in testCredentials) {
        final username = credentials['username']!;
        final password = credentials['password']!;
        
        when(mockRepository.login(username, password))
            .thenAnswer((_) async => Right(tLoginResponse));

        
        final result = await usecase(username, password);

        
        expect(result.isRight, true);
        result.fold(
          (failure) => fail('No debería retornar failure para $username'),
          (loginResponse) {
            expect(loginResponse.token, isNotEmpty);
          },
        );

        
        
      }
    });


    test('debería manejar contraseña incorrecta', () async {
      
      final wrongPasswordFailure = AuthFailure();
      when(mockRepository.login('existinguser', 'wrongpass'))
          .thenAnswer((_) async => Left(wrongPasswordFailure));

      
      final result = await usecase('existinguser', 'wrongpass');

      
      expect(result.isLeft, true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
        },
        (loginResponse) => fail('No debería retornar login response con contraseña incorrecta'),
      );
    });

    test('debería manejar token vacío o inválido', () async {
      
      final emptyTokenResponse = LoginResponse(token: '');
      when(mockRepository.login('testuser', 'testpass'))
          .thenAnswer((_) async => Right(emptyTokenResponse));

      
      final result = await usecase('testuser', 'testpass');

      
      expect(result.isRight, true);
      result.fold(
        (failure) => fail('No debería retornar failure incluso con token vacío'),
        (loginResponse) {
          expect(loginResponse.token, isEmpty);
        },
      );
    });

    test('debería manejar errores de servidor durante el login', () async {
      
      final serverFailure = ServerFailure(401);
      when(mockRepository.login('testuser', 'testpass'))
          .thenAnswer((_) async => Left(serverFailure));

      
      final result = await usecase('testuser', 'testpass');

      
      expect(result.isLeft, true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (loginResponse) => fail('No debería retornar login response con error de servidor'),
      );
    });
  });
}