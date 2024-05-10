import 'models/brand.dart';

abstract class BrandRepo {
  Future<List<BrandModel>> getBrands();
  Future<void> addNewBrand(BrandModel brand);
  Future<void> deleteBrand(BrandModel brand);
}
