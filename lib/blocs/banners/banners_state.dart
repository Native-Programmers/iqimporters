part of 'banners_bloc.dart';

abstract class BannersState extends Equatable {
  const BannersState();

  @override
  List<Object> get props => [];
}

class BannersLoading extends BannersState {}

class BannersLoaded extends BannersState {
  final List<Banners> banners;

  const BannersLoaded({this.banners = const <Banners>[]});

  @override
  List<Object> get props => [banners];
}

class CategoryError extends BannersState {}
