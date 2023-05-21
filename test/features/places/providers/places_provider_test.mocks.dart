// Mocks generated by Mockito 5.4.0 from annotations
// in parking_app/test/features/places/providers/places_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:parking_app/features/places/data/models/parking_place.dart'
    as _i4;
import 'package:parking_app/features/places/domain/places_interactor.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [PlacesInteractor].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlacesInteractor extends _i1.Mock implements _i2.PlacesInteractor {
  MockPlacesInteractor() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.ParkingPlace>> searchParkingPlaces(
    double? latitude,
    double? longitude,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchParkingPlaces,
          [
            latitude,
            longitude,
          ],
        ),
        returnValue:
            _i3.Future<List<_i4.ParkingPlace>>.value(<_i4.ParkingPlace>[]),
      ) as _i3.Future<List<_i4.ParkingPlace>>);
}
