import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

import '../../../../../class/bloc_events_class.dart';

enum ProductPageEventsType {
  getProducts,
  getProductById,
  addProduct,
  deleteProduct,
  updateProduct,
}

class ProductPageBloc extends Bloc<BlocEvent, BlocEvent> {
  final ProductRepo _productRepository;
  List<ProductModel> products = [];
  ProductPageBloc(this._productRepository)
      : super(Event(ProductPageEventsType.getProducts)) {
    on<Event>((event, emit) async {
      switch (event.eventType) {
        case ProductPageEventsType.getProducts:
          emit.call(Loading(event.eventType));
          try {
            _productRepository.getProducts().then((value) {
              products = value;
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.getProductById:
          emit.call(Loading(event.eventType));
          try {
            _productRepository
                .getProductbyId(event.data as String)
                .then((value) {
              emit(Event(ProductPageEventsType.getProductById, data: value));
            });
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.addProduct:
          emit.call(Loading(event.eventType));
          try {
            _productRepository.addProduct(event.data as ProductModel);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.deleteProduct:
          emit.call(Loading(event.eventType));
          try {
            _productRepository.deleteProduct(event.data as String);
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
          break;
        case ProductPageEventsType.updateProduct:
          emit.call(Loading(event.eventType));
          try {
            _productRepository.updateProduct(event.data as ProductModel);
            emit(Event(ProductPageEventsType.updateProduct));
            emit.call(Success(event.eventType));
          } catch (e) {
            emit.call(Failure(event.eventType, errorType: e.toString()));
          }
      }
    });
  }
}
