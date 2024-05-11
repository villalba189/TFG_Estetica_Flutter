import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';
import 'package:brand_repository/brand_repository.dart';

import '../../../../../class/bloc_events_class.dart';

enum ProductPageEventsType {
  getProducts,
  getProductById,
  addProduct,
  deleteProduct,
  updateProduct,
  addImagenStorage,
  filterByBrand,
  filterByName,
}

enum ProductPageErrorsType {
  productNameNoValido,
  productPriceNoValido,
  productDescriptionNoValido,
}

class ProductPageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ProductRepo _productRepository;
  final BrandRepo _brandRepository;
  List<ProductModel> productsBack = [];
  List<ProductModel> products = [];
  List<ProductModel> productsFiltered = [];
  List<BrandModel> marcas = [];
  String marcaActual = 'Todas';

  String nameError = '';
  String priceError = '';
  String descriptionError = '';

  bool nameErrorVisible = false;
  bool priceErrorVisible = false;
  bool descriptionErrorVisible = false;

  String imagePath = '';
  ProductPageBloc(this._productRepository, this._brandRepository)
      : super(Event(ProductPageEventsType.getProducts)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ProductPageEventsType.filterByName:
          marcaActual = 'Todas';
          emit.call(Loading(event.eventType));
          if (event.data == '') {
            productsFiltered = products;
          }
          try {
            productsFiltered = products
                .where((element) => element.name!
                    .toLowerCase()
                    .contains((event.data as String).toLowerCase()))
                .toList();

            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.filterByBrand:
          emit.call(Loading(event.eventType));
          if (event.data == 'Todas') {
            productsFiltered = products;
            marcaActual = 'Todas';
            emit.call(Success(event.eventType));
            return;
          }
          try {
            productsFiltered = products
                .where((element) => element.brand == event.data)
                .toList();
            marcaActual = event.data as String;
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.getProducts:
          emit.call(Loading(event.eventType));

          marcaActual = 'Todas';
          try {
            productsBack = await _productRepository.getProducts();
            marcas = await _brandRepository.getBrands();
            marcas.insert(0, BrandModel(id: 'Todas', name: 'Todas'));
            products = productsBack;
            productsFiltered = products;
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.addProduct:
          emit.call(Loading(event.eventType));
          try {
            _productRepository.addProduct(event.data as ProductModel);
            products.add(event.data as ProductModel);

            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.deleteProduct:
          emit.call(Loading(event.eventType));
          ProductModel product = event.data as ProductModel;
          try {
            _productRepository.deleteProduct(product.productId!);
            _productRepository.deleteImagenStorage(product);
            products.removeWhere(
                (element) => element.productId == product.productId);

            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.updateProduct:
          emit.call(Loading(event.eventType));
          try {
            _productRepository.updateProduct(event.data as ProductModel);
            products.removeWhere((element) =>
                element.productId == (event.data as ProductModel).productId);
            products.add(event.data as ProductModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.addImagenStorage:
          emit.call(Loading(event.eventType));
          try {
            String imageData = event.data[2];
            imagePath = imageData == ''
                ? ''
                : await _productRepository.addImagenStorage(
                    event.data[0] as String,
                    event.data[1] as String,
                    event.data[2] as String);
            (event.data[3] as Function)(imagePath);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
      }
      switch (event.eventType) {
        case ProductPageErrorsType.productNameNoValido:
          String name = event.data as String;
          final nameRegex = RegExp(
              r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s-]{2,}$'); // Aceptar solo letras, espacios y guiones, mínimo 2 caracteres
          bool isValidName = nameRegex.hasMatch(name);
          if (name.isEmpty) {
            emit.call(Failure(event.eventType));
            nameError = 'Name is required';
            nameErrorVisible = true;
            return;
          } else if (!isValidName) {
            emit.call(Failure(event.eventType));
            nameError = 'Invalid name';
            nameErrorVisible = true;
            return;
          } else {
            nameErrorVisible = false;
            nameError = '';
            emit.call(Success(event.eventType));
          }
          break;
        case ProductPageErrorsType.productPriceNoValido:
          double? price = double.tryParse(event.data as String);
          String priceString = price.toString();
          int dotIndex = priceString.indexOf('.');
          if (price == null) {
            emit.call(Failure(event.eventType));
            priceError = 'Precio es equerido';
            priceErrorVisible = true;
          } else if (price.isNegative || price == 0) {
            emit.call(Failure(event.eventType));
            priceError = 'El precio no puede ser negativo o 0';
            priceErrorVisible = true;
          } else if (dotIndex != -1 &&
              priceString.substring(dotIndex + 1).length > 2) {
            emit.call(Failure(event.eventType));
            priceError = 'El precio no puede tener mas de 2 decimales';
            priceErrorVisible = true;
          } else {
            priceErrorVisible = false;
            priceError = '';
            emit.call(Success(event.eventType));
          }

          break;
        case ProductPageErrorsType.productDescriptionNoValido:
          String description = event.data as String;
          if (description.isEmpty) {
            descriptionErrorVisible = false;
            descriptionError = '';
            emit.call(Success(event.eventType));
          } else if (description.length < 5) {
            emit.call(Failure(event.eventType));
            descriptionError = 'Descripcion no valida';
            descriptionErrorVisible = true;
          } else {
            descriptionErrorVisible = false;
            descriptionError = '';
            emit.call(Success(event.eventType));
          }
          break;
      }
    });
  }
}
