# Fake Store Get Request

## Features

Este paquete proporciona una interfaz sencilla para interactuar con la API Fake Store(https://fakestoreapi.com) desde una aplicaciones Flutter.

## Instalación

```yaml
fake_store_get_request: ^0.0.2
```

### Usage

```dart
final service = FakeStoreService();
final Future<List<Product>> products = service.getProducts();

ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.title),
              ),
               },
                );

```

Revisar el example para una mejor comprensión
