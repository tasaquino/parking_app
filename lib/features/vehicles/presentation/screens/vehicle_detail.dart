import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_notifier.dart';
import 'package:parking_app/features/vehicles/presentation/providers/detail/vehicle_detail_provider.dart';
import 'package:uuid/uuid.dart';

class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key, this.vehicle});
  final Vehicle? vehicle;

  @override
  ConsumerState<VehicleDetailScreen> createState() =>
      _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends ConsumerState<VehicleDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  var selected = false;
  var registrationNumberController = TextEditingController();
  var nameController = TextEditingController();
  Vehicle? vehicle;
  late VehicleDetailNotifier notifier;

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      vehicle = widget.vehicle;
      registrationNumberController.text = vehicle?.registrationNumber ?? "";
      nameController.text = vehicle?.name ?? "";
      selected = vehicle?.selected ?? false;
    }

    notifier = ref.read(vehicleDetailNotifierProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.setInitialState();
    });
  }

  void save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool saved = false;
      if (vehicle == null) {
        saved = await createVehicle();
      } else {
        saved = await updateVehicle();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(saved ? "Saved" : "Oops, something went wrong"),
        ));
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<bool> createVehicle() async {
    vehicle = Vehicle(
        id: const Uuid().v4(),
        selected: selected,
        registrationNumber: registrationNumberController.text,
        name: nameController.text);

    if (vehicle != null) {
      notifier.save(vehicle!);
    }

    return false;
  }

  Future<bool> updateVehicle() async {
    if (vehicle != null) {
      notifier.update(
          vehicleID: vehicle?.id ?? "",
          selected: selected,
          name: nameController.text,
          registerNumber: registrationNumberController.text);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: OutlinedButton(
                  onPressed: () {
                    save();
                  },
                  child: const Text('Save')),
            )
          ],
          title: Text(
            'Add new vehicle',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          )),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: registrationNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Registration Number'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please inform a registration number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please inform a name';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    const Text('Selected: '),
                    Switch(
                      value: selected,
                      onChanged: ((value) {
                        setState(() {
                          selected = value;
                        });
                      }),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
