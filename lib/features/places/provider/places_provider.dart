// coverage:ignore-file
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:parking_app/features/places/data/places_repository_impl.dart';
import 'package:parking_app/features/places/domain/places_interactor_impl.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_notifier.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_state.dart';

final placesRepository = PlacesRepositoryImpl(http.Client());

final placesInteractor = PlacesInteractorImpl(placesRepository);

final placesNotifierProvider =
    StateNotifierProvider<PlacesNotifier, PlacesState>((ref) {
  return PlacesNotifier(placesInteractor);
});
