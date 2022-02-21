// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/repositories/banners/banners_repository.dart';
part 'banners_event.dart';
part 'banners_state.dart';

class BannersBloc extends Bloc<BannersEvent, BannersState> {
  final BannersRepository _BannersRepository;
  StreamSubscription? _BannersSubscription;
  BannersBloc({required BannersRepository BannersRepository})
      : _BannersRepository = BannersRepository,
        super(BannersLoading());
  @override
  Stream<BannersState> mapEventToState(
    BannersEvent event,
  ) async* {
    if (event is LoadBanners) {
      yield* _mapLoadCategoriesToState();
    }
    if (event is UpdateBanners) {
      yield* _mapUpdateCategoriesToState(event);
    }
  }

  Stream<BannersState> _mapLoadCategoriesToState() async* {
    _BannersSubscription?.cancel();
    _BannersSubscription = _BannersRepository.getAllBanners().listen(
      (items) => add(
        UpdateBanners(items),
      ),
    );
  }

  Stream<BannersState> _mapUpdateCategoriesToState(UpdateBanners event) async* {
    yield BannersLoaded(banners: event.banners);
  }
}
