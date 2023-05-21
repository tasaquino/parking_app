import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parking_app/features/user/presentation/providers/user_notifier.dart';
import 'package:parking_app/features/user/presentation/providers/user_repository_provider.dart';
import 'package:parking_app/features/vehicles/presentation/widgets/vehicles_list.dart';

class MainDrawer extends ConsumerStatefulWidget {
  const MainDrawer({super.key});

  @override
  ConsumerState<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends ConsumerState<MainDrawer> {
  late UserNotifier notifier;

  @override
  void initState() {
    super.initState();
    notifier = ref.read(userNotifierProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userNotifierProvider);

    return Drawer(
      child: Column(children: [
        DrawerHeader(
            child: Column(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(state.user?.photoUrl ?? ""),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 10),
            Text(state.user?.name ?? ""),
            Text(state.user?.email ?? ""),
          ],
        )),
        ListTile(
          leading: const Icon(Icons.car_repair),
          title: const Text('My vehicles'),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return const VehiclesList();
                });
          },
        ),
        const ListTile(
          leading: Icon(Icons.local_parking),
          title: Text('My parkings'),
        ),
        const ListTile(
          leading: Icon(Icons.star),
          title: Text('My favorite places'),
        ),
        ListTile(
          onTap: () {
            notifier.logout();
          },
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
        )
      ]),
    );
  }
}
