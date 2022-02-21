part of 'banners_bloc.dart';

abstract class BannersEvent extends Equatable {
  const BannersEvent();

  @override
  List<Object> get props => [];
}

class LoadBanners extends BannersEvent {}

class UpdateBanners extends BannersEvent {
  final List<Banners> banners;
  const UpdateBanners(this.banners);

  @override
  List<Object> get props => [banners];
}
