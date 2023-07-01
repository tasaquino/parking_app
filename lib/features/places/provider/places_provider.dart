// coverage:ignore-file
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/features/places/data/places_repository_impl.dart';
import 'package:parking_app/features/places/domain/places_interactor.dart';
import 'package:parking_app/features/places/domain/places_interactor_impl.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_notifier.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_state.dart';

final placesRepositoryProvider = Provider((_) {
  return PlacesRepositoryImpl(http.Client());
});

final placesInteractorProvider = Provider<PlacesInteractor>((ref) {
  final repository = ref.watch(placesRepositoryProvider);
  final interactor = PlacesInteractorImpl(repository);

  return interactor;
});

final placesNotifierProvider =
    StateNotifierProvider<PlacesNotifier, PlacesState>((ref) {
  final interactor = ref.watch(placesInteractorProvider);
  return PlacesNotifier(interactor);
});
