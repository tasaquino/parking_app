// Mocks generated by Mockito 5.4.0 from annotations
// in parking_app/test/features/vehicles/presentation/providers/list/vehicle_list_notifier_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:parking_app/features/vehicles/data/models/vehicle.dart' as _i4;
import 'package:parking_app/features/vehicles/domain/vehicles_interactor.dart'
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

/// A class which mocks [VehiclesInteractor].
///
/// See the documentation for Mockito's code generation for more information.
class MockVehiclesInteractor extends _i1.Mock
    implements _i2.VehiclesInteractor {
  MockVehiclesInteractor() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<bool> saveVehicle(_i4.Vehicle? vehicle) => (super.noSuchMethod(
        Invocation.method(
          #saveVehicle,
          [vehicle],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  _i3.Future<bool> deleteVehicle(String? vehicleID) => (super.noSuchMethod(
        Invocation.method(
          #deleteVehicle,
          [vehicleID],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  _i3.Future<bool> updateVehicle({
    required String? vehicleID,
    String? name,
    String? registerNumber,
    bool? selected,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateVehicle,
          [],
          {
            #vehicleID: vehicleID,
            #name: name,
            #registerNumber: registerNumber,
            #selected: selected,
          },
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  _i3.Future<List<_i4.Vehicle>> fetchVehiclesForUser() => (super.noSuchMethod(
        Invocation.method(
          #fetchVehiclesForUser,
          [],
        ),
        returnValue: _i3.Future<List<_i4.Vehicle>>.value(<_i4.Vehicle>[]),
      ) as _i3.Future<List<_i4.Vehicle>>);
  @override
  _i3.Future<bool> selectVehicle(
    String? vehicleID,
    bool? select,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #selectVehicle,
          [
            vehicleID,
            select,
          ],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}