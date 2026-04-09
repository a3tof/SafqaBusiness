import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class ProfileViewModelState extends Equatable {
  const ProfileViewModelState();

  @override
  List<Object?> get props => [];
}

/// Initial / still loading state — skeleton shown while data fetches.
class ProfileInitial extends ProfileViewModelState {}

class ProfileLoaded extends ProfileViewModelState {
  final bool isProfileCompleted;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final int? countryId;
  final String? countryName;
  final int? cityId;
  final String? cityName;
  final String? description;

  /// Decoded logo bytes ready for `Image.memory`. Null when not yet loaded.
  final Uint8List? logoBytes;
  final String? rating;
  final String? followersCount;
  final String? auctionsCount;

  const ProfileLoaded({
    required this.isProfileCompleted,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.countryId,
    this.countryName,
    this.cityId,
    this.cityName,
    this.description,
    this.logoBytes,
    this.rating,
    this.followersCount,
    this.auctionsCount,
  });

  @override
  List<Object?> get props => [
    isProfileCompleted,
    fullName,
    email,
    phoneNumber,
    countryId,
    countryName,
    cityId,
    cityName,
    description,
    logoBytes,
    rating,
    followersCount,
    auctionsCount,
  ];
}

class ProfileError extends ProfileViewModelState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
