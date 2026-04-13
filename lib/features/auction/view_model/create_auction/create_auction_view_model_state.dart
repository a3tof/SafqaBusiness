import 'package:safqaseller/features/auction/model/models/category_attribute_model.dart';
import 'package:safqaseller/features/auction/model/models/category_model.dart';

abstract class CreateAuctionViewModelState {}

class CreateAuctionInitial extends CreateAuctionViewModelState {}

class CategoriesLoading extends CreateAuctionViewModelState {}

class CategoriesLoaded extends CreateAuctionViewModelState {
  final List<CategoryModel> categories;

  CategoriesLoaded(this.categories);
}

class AttributesLoading extends CreateAuctionViewModelState {
  final int itemIndex;
  final int categoryId;

  AttributesLoading({required this.itemIndex, required this.categoryId});
}

class AttributesLoaded extends CreateAuctionViewModelState {
  final int itemIndex;
  final int categoryId;
  final List<CategoryAttributeModel> attributes;

  AttributesLoaded({
    required this.itemIndex,
    required this.categoryId,
    required this.attributes,
  });
}

class AttributesUnavailable extends CreateAuctionViewModelState {
  final int itemIndex;
  final int categoryId;
  final String message;

  AttributesUnavailable({
    required this.itemIndex,
    required this.categoryId,
    required this.message,
  });
}

class CreateAuctionSubmitting extends CreateAuctionViewModelState {}

class CreateAuctionSubmitSuccess extends CreateAuctionViewModelState {}

class CreateAuctionFailure extends CreateAuctionViewModelState {
  final String message;

  CreateAuctionFailure(this.message);
}
