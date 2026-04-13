import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/features/auction/model/models/category_attribute_model.dart';
import 'package:safqaseller/features/auction/model/models/category_model.dart';
import 'package:safqaseller/features/auction/model/models/create_auction_request_model.dart';
import 'package:safqaseller/features/auction/model/repositories/auction_repository.dart';
import 'package:safqaseller/features/auction/view_model/create_auction/create_auction_view_model_state.dart';

class CreateAuctionViewModel extends Cubit<CreateAuctionViewModelState> {
  final AuctionRepository auctionRepository;

  CreateAuctionViewModel(this.auctionRepository)
    : super(CreateAuctionInitial());

  List<CategoryModel> categories = const [];
  final Map<int, List<CategoryAttributeModel>> _attributesByItemIndex = {};
  final Map<int, String> _attributeErrorsByItemIndex = {};
  CreateAuctionRequestModel? draftRequest;

  List<CategoryAttributeModel> attributesForItem(int itemIndex) {
    return _attributesByItemIndex[itemIndex] ?? const [];
  }

  String? attributeErrorForItem(int itemIndex) {
    return _attributeErrorsByItemIndex[itemIndex];
  }

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      categories = await auctionRepository.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CreateAuctionFailure(_clean(e)));
    }
  }

  Future<void> loadAttributes({
    required int itemIndex,
    required int categoryId,
  }) async {
    emit(AttributesLoading(itemIndex: itemIndex, categoryId: categoryId));
    try {
      final attributes = await auctionRepository.getAttributes(categoryId);
      _attributesByItemIndex[itemIndex] = attributes;
      _attributeErrorsByItemIndex.remove(itemIndex);
      emit(
        AttributesLoaded(
          itemIndex: itemIndex,
          categoryId: categoryId,
          attributes: attributes,
        ),
      );
    } catch (e) {
      final message = _clean(e);
      _attributesByItemIndex[itemIndex] = const [];
      _attributeErrorsByItemIndex[itemIndex] = message;
      emit(
        AttributesUnavailable(
          itemIndex: itemIndex,
          categoryId: categoryId,
          message: message,
        ),
      );
    }
  }

  void clearItemAttributes(int itemIndex) {
    _attributesByItemIndex.remove(itemIndex);
    _attributeErrorsByItemIndex.remove(itemIndex);
  }

  void setDraftRequest(CreateAuctionRequestModel request) {
    draftRequest = request;
  }

  Future<void> submitAuction({
    required double startingPrice,
    required int bidIncrement,
    required int durationInDays,
  }) async {
    final request = draftRequest;
    if (request == null) {
      emit(CreateAuctionFailure('Auction draft is missing.'));
      return;
    }

    final updatedRequest = request.copyWith(
      startingPrice: startingPrice,
      bidIncrement: bidIncrement,
      durationInDays: durationInDays,
    );

    emit(CreateAuctionSubmitting());
    try {
      await auctionRepository.createAuction(
        title: updatedRequest.title,
        description: updatedRequest.description,
        startingPrice: updatedRequest.startingPrice,
        bidIncrement: updatedRequest.bidIncrement,
        durationInDays: updatedRequest.durationInDays,
        headImage: updatedRequest.headImage,
        items: updatedRequest.items,
      );
      draftRequest = updatedRequest;
      emit(CreateAuctionSubmitSuccess());
    } catch (e) {
      emit(CreateAuctionFailure(_clean(e)));
    }
  }

  String _clean(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }
    return message;
  }
}
