import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safqaseller/core/storage/cache_helper.dart';
import 'package:safqaseller/core/storage/cache_keys.dart';
import 'package:safqaseller/features/seller/model/repositories/seller_repository.dart';
import 'package:safqaseller/features/seller/view_model/seller_view_model_state.dart';
import 'package:safqaseller/core/service_locator.dart';
import 'package:safqaseller/features/auth/model/repositories/auth_repository.dart';
import 'package:safqaseller/features/auth/model/models/social_auth_models.dart';

class SellerViewModel extends Cubit<SellerViewModelState> {
  final SellerRepository sellerRepository;
  final CacheHelper cacheHelper;

  SellerViewModel({
    required this.sellerRepository,
    required this.cacheHelper,
  }) : super(SellerInitial());

  int? _sellerId;

  /// Returns the current sellerId (from memory or cache).
  int? get sellerId {
    _sellerId ??= cacheHelper.getData(key: CacheKeys.sellerId) as int?;
    return _sellerId;
  }

  // ── Step 1: Create Seller ─────────────────────────────────────────────────
  // POST /api/seller/CreateSeller

  Future<void> createSeller({
    required String storeName,
    required String phoneNumber,
    required int cityId,
    required int businessType,
    required String description,
    MultipartFile? logo,
  }) async {
    emit(SellerLoading());
    try {
      final response = await sellerRepository.createSeller(
        storeName: storeName,
        phoneNumber: phoneNumber,
        cityId: cityId,
        businessType: businessType,
        description: description,
        logo: logo,
      );

      final isMessageSuccess = response.message?.toLowerCase().contains('seller created successfully') == true;
      final sellerExists = response.errors.any((e) => e.toLowerCase().contains('seller already exists'));

      if ((response.isSuccess && response.sellerId != null) || isMessageSuccess || sellerExists) {
        if (response.sellerId != null) {
          _sellerId = response.sellerId;
          await cacheHelper.saveData(
            key: CacheKeys.sellerId,
            value: response.sellerId!,
          );
        }

        if (response.token != null && response.token!.isNotEmpty) {
          await cacheHelper.saveData(
            key: CacheKeys.token,
            value: response.token,
          );
        }

        // Force a token refresh so the backend signs the new JWT with "Seller" Role Claim
        // This is necessary to avoid 403 Forbidden on the subsequent Identity Verification screen.
        try {
          final refreshTokenStr = cacheHelper.getData(key: CacheKeys.refreshToken) as String?;
          if (refreshTokenStr != null) {
            final authRepo = getIt<AuthRepository>();
            await authRepo.refreshToken(RefreshTokenRequestModel(refreshToken: refreshTokenStr));
          }
        } catch (_) {
          // If refresh fails, we still proceed, though it may trigger 403 later
        }

        emit(SellerCreated(sellerId: response.sellerId ?? 0));
      } else {
        final errorMsg = response.errors.isNotEmpty
            ? response.errors.join(', ')
            : (response.message ?? 'Failed to create seller');
        emit(SellerError(errorMsg));
      }
    } catch (e) {
      final errorMsg = _clean(e);
      if (errorMsg.toLowerCase().contains('seller already exists')) {
        // Force a token refresh since the seller already exists and we need the role claim
        try {
          final refreshTokenStr = cacheHelper.getData(key: CacheKeys.refreshToken) as String?;
          if (refreshTokenStr != null) {
            final authRepo = getIt<AuthRepository>();
            await authRepo.refreshToken(RefreshTokenRequestModel(refreshToken: refreshTokenStr));
          }
        } catch (_) {}
        
        emit(const SellerCreated(sellerId: 0));
      } else {
        emit(SellerError(errorMsg));
      }
    }
  }

  // ── Step 2: Personal Verification ─────────────────────────────────────────
  // POST /api/seller/{sellerId}/personal-verification

  Future<void> uploadPersonalVerification({
    required MultipartFile nationalIdFront,
    required MultipartFile nationalIdBack,
    required MultipartFile selfieWithId,
  }) async {
    emit(SellerLoading());
    try {
      final response = await sellerRepository.personalVerification(
        nationalIdFront: nationalIdFront,
        nationalIdBack: nationalIdBack,
        selfieWithId: selfieWithId,
      );

      if (response.isSuccess) {
        emit(PersonalVerificationSuccess());
      } else {
        final errorMsg = response.errors.isNotEmpty
            ? response.errors.join(', ')
            : (response.message ?? 'Personal verification failed');
        emit(SellerError(errorMsg));
      }
    } catch (e) {
      emit(SellerError(_clean(e)));
    }
  }

  // ── Step 3: Business Verification ─────────────────────────────────────────
  // POST /api/seller/{sellerId}/business-verification

  Future<void> uploadBusinessVerification({
    required MultipartFile commercialRegister,
    required MultipartFile taxId,
    required MultipartFile ownerNationalIdFront,
    required MultipartFile ownerNationalIdBack,
    required String bankName,
    required String accountName,
    required String iban,
    String? localAccountNumber,
    int? instaPayNumber,
  }) async {
    final id = sellerId;
    if (id == null) {
      emit(const SellerError('Seller ID not found. Please create seller first.'));
      return;
    }

    emit(SellerLoading());
    try {
      final response = await sellerRepository.businessVerification(
        sellerId: id,
        commercialRegister: commercialRegister,
        taxId: taxId,
        ownerNationalIdFront: ownerNationalIdFront,
        ownerNationalIdBack: ownerNationalIdBack,
        bankName: bankName,
        accountName: accountName,
        iban: iban,
        localAccountNumber: localAccountNumber,
        instaPayNumber: instaPayNumber,
      );

      if (response.isSuccess) {
        emit(BusinessVerificationSuccess());
      } else {
        final errorMsg = response.errors.isNotEmpty
            ? response.errors.join(', ')
            : (response.message ?? 'Business verification failed');
        emit(SellerError(errorMsg));
      }
    } catch (e) {
      emit(SellerError(_clean(e)));
    }
  }

  // ── Seller Home ───────────────────────────────────────────────────────────
  // GET /api/seller/Home

  Future<void> getSellerHome() async {
    emit(SellerLoading());
    try {
      final response = await sellerRepository.getSellerHome();
      emit(SellerHomeLoaded(data: response));
    } catch (e) {
      emit(SellerError(_clean(e)));
    }
  }

  String _clean(Object e) {
    String msg = e.toString();
    if (msg.startsWith('Exception: ')) {
      msg = msg.replaceFirst('Exception: ', '');
    }
    return msg;
  }
}
