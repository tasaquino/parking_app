import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/vehicles/data/models/vehicle.dart';
import 'package:parking_app/features/vehicles/presentation/providers/list/vehicle_list_provider.dart';
import 'package:parking_app/features/vehicles/presentation/screens/vehicle_detail.dart';

enum MenuOptions { select, edit, delete }

class VehiclesList extends ConsumerStatefulWidget {
  const VehiclesList({super.key});

  @override
  ConsumerState<VehiclesList> createState() => _VehiclesListState();
}

class _VehiclesListState extends ConsumerState<VehiclesList> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadVehicles();
    });
  }

  void loadVehicles() async {
    ref.read(vehiclesNotifierProvider.notifier).fetchVehicles();
  }

  void setSelected(Vehicle vehicle) {
    ref.read(vehiclesNotifierProvider.notifier).setSelected(vehicle);
  }

  void deleteVehicle(Vehicle vehicle) {
    ref.read(vehiclesNotifierProvider.notifier).delete(vehicle);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vehiclesNotifierProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 5),
          child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const VehicleDetailScreen();
                })).then((value) => loadVehicles());
              },
              child: const Text('Add new vehicle')),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: state.vehicles.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                      title: Text(state.vehicles[index].name),
                      subtitle: Text(state.vehicles[index].registrationNumber),
                      leading: Icon(
                        Icons.car_crash_outlined,
                        color: state.vehicles[index].selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground,
                      ),
                      trailing: PopupMenuButton(onSelected: (value) {
                        switch (value) {
                          case MenuOptions.select:
                            setSelected(state.vehicles[index]);
                            break;
                          case MenuOptions.delete:
                            deleteVehicle(state.vehicles[index]);
                            break;

                          case MenuOptions.edit:
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
                              return VehicleDetailScreen(
                                vehicle: state.vehicles[index],
                              );
                            })).then((value) => loadVehicles());
                            break;
                          default:
                            break;
                        }
                      }, itemBuilder: (ctx) {
                        return <PopupMenuEntry<MenuOptions>>[
                          PopupMenuItem<MenuOptions>(
                            value: MenuOptions.select,
                            child: state.vehicles[index].selected
                                ? const Text('Deselect')
                                : const Text('Select'),
                          ),
                          const PopupMenuItem<MenuOptions>(
                            value: MenuOptions.edit,
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<MenuOptions>(
                            value: MenuOptions.delete,
                            child: Text('Delete'),
                          ),
                        ];
                      }));
                })),
      ],
    );
  }
}
