import 'package:either_dart/either.dart';
import 'package:fake_store_get_request/core/errors/failures.dart';
import 'package:fake_store_get_request/data/models/cart.dart';
import 'package:fake_store_get_request/data/models/login_response.dart';
import 'package:fake_store_get_request/data/models/product.dart';
import 'package:fake_store_get_request/domain/usecases/get_categories.dart';
import 'package:fake_store_get_request/domain/usecases/get_product_by_category.dart';
import 'package:fake_store_get_request/domain/usecases/get_product_detail.dart';
import 'package:fake_store_get_request/domain/usecases/get_products.dart';
import 'package:fake_store_get_request/domain/usecases/get_user_cart.dart';
import 'package:fake_store_get_request/domain/usecases/login.dart';
import 'package:fake_store_get_request/services/fake_store_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';


@GenerateMocks([
  GetProducts,
  GetProductDetail,
  Login,
  GetCategories,
  GetProductByCategory,
  GetUserCart,
])
import 'fake_store_service_test.mocks.dart';

void main() {
  late FakeStoreService service;
  late MockGetProducts mockGetProducts;
  late MockGetProductDetail mockGetProductDetail;
  late MockLogin mockLogin;
  late MockGetCategories mockGetCategories;
  late MockGetProductByCategory mockGetProductByCategory;
  late MockGetUserCart mockGetUserCart;

  setUpAll(() {
    provideDummy<Either<Failure, List<Product>>>(Right([]));
    provideDummy<Either<Failure, Product>>(
      Right(Product(id: 0, title: '', price: 0)),
    );
    provideDummy<Either<Failure, LoginResponse>>(
      Right(LoginResponse(token: '')),
    );
    provideDummy<Either<Failure, List<String>>>(Right([]));
    provideDummy<Either<Failure, Cart>>(
      Right(Cart(id: 0, userId: 0, products: [])),
    );
  });

  setUp(() {
    mockGetProducts = MockGetProducts();
    mockGetProductDetail = MockGetProductDetail();
    mockLogin = MockLogin();
    mockGetCategories = MockGetCategories();
    mockGetProductByCategory = MockGetProductByCategory();
    mockGetUserCart = MockGetUserCart();

    service = FakeStoreService.test(
      getProductsUsecase: mockGetProducts,
      getProductDetailUsecase: mockGetProductDetail,
      loginUsecase: mockLogin,
      getCategoriesUsecase: mockGetCategories,
      getProductsByCategoryUsecase: mockGetProductByCategory,
      getUserCartUsecase: mockGetUserCart,
    );
  });

  test('getProducts devuelve lista de productos', () async {
    final products = [Product(id: 1, title: 'Test', price: 10.0)];
    when(mockGetProducts()).thenAnswer((_) async => Right(products));

    final result = await service.getProducts();

    expect(result, products);
    verify(mockGetProducts()).called(1);
  });

  test('getProductDetail devuelve un producto', () async {
    final product = Product(id: 1, title: 'Detail', price: 20.0);
    when(mockGetProductDetail(1)).thenAnswer((_) async => Right(product));

    final result = await service.getProductDetail(1);

    expect(result, product);
    verify(mockGetProductDetail(1)).called(1);
  });

  test('login devuelve LoginResponse', () async {
    final loginResponse = LoginResponse(token: 'abc123');
    when(mockLogin('user', 'pass'))
        .thenAnswer((_) async => Right(loginResponse));

    final result = await service.login('user', 'pass');

    expect(result, loginResponse);
    verify(mockLogin('user', 'pass')).called(1);
  });

  test('getCategories devuelve lista de categorías', () async {
    final categories = ['electronics', 'clothing'];
    when(mockGetCategories()).thenAnswer((_) async => Right(categories));

    final result = await service.getCategories();

    expect(result, categories);
    verify(mockGetCategories()).called(1);
  });

  test('getProductsByCategory devuelve lista de productos', () async {
    final products = [Product(id: 2, title: 'Shoes', price: 50.0)];
    when(mockGetProductByCategory('fashion'))
        .thenAnswer((_) async => Right(products));

    final result = await service.getProductsByCategory('fashion');

    expect(result, products);
    verify(mockGetProductByCategory('fashion')).called(1);
  });

  test('getUserCart devuelve un carrito', () async {
    final cart = Cart(id: 1, userId: 1, products: []);
    when(mockGetUserCart(1)).thenAnswer((_) async => Right(cart));

    final result = await service.getUserCart(1);

    expect(result, cart);
    verify(mockGetUserCart(1)).called(1);
  });

  test('handleEither lanza excepción en caso de fallo', () {
    expect(
      () => service.handleEither(Left(ServerFailure(400))),
      throwsA(isA<Exception>()),
    );
  });
}
