import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking_app/features/places/data/models/parking_place.dart';
import 'package:parking_app/features/places/domain/places_interactor.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_notifier.dart';
import 'package:parking_app/features/places/presentation/notifiers/places_state.dart';
import 'package:test/test.dart';
import 'package:state_notifier_test/state_notifier_test.dart';

import 'places_provider_test.mocks.dart';

//flutter pub run build_runner build - run it to generate mock files

@GenerateMocks([PlacesInteractor])
void main() {
  late PlacesInteractor interactor;
  late PlacesNotifier notifier;
  const initialState = PlacesState(state: PlacesPossibleStates.initial);
  const places = [ParkingPlace(id: "id")];
  setUpAll(() {
    interactor = MockPlacesInteractor();
  });
  stateNotifierTest<PlacesNotifier, PlacesState>(
    'Should present proper states when searching for parking places',
    build: () {
      notifier = PlacesNotifier(interactor);
      return notifier;
    },
    setUp: () {
      when(interactor.searchParkingPlaces(0.0, 0.0))
          .thenAnswer((realInvocation) async => [const ParkingPlace(id: "id")]);
    },
    actions: (notifier) async {
      notifier.setInitialState();
      await notifier.searchPlaces(0.0, 0.0);
      await notifier.setPlaceSelected(places[0]);
    },
    expect: () => [
      initialState.copyWith(state: PlacesPossibleStates.loading),
      initialState.copyWith(
        state: PlacesPossibleStates.loaded,
        places: places,
      ),
      initialState.copyWith(
          state: PlacesPossibleStates.loaded,
          places: places,
          selectedPlace: places[0]),
    ],
  );
}
