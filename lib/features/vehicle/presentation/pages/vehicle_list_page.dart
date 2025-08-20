import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:parking_app_assignment/features/vehicle/presentation/pages/vehicle_form_page.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';

class VehicleListPage extends StatefulWidget {
  const VehicleListPage({super.key});

  @override
  State<VehicleListPage> createState() => _VehicleListPageState();
}

class _VehicleListPageState extends State<VehicleListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  bool _isLoadingMore = false;
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
    context.read<VehicleBloc>().add(LoadVehicles(limit: 5, skip: 0));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) _searchDebounce!.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      context.read<VehicleBloc>().add(
            LoadVehicles(
              limit: 5,
              skip: 0,
              searchText: _searchController.text,
            ),
          );
    });
  }

  String _formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _onScroll() {
    if (_isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final state = context.read<VehicleBloc>().state;
    if (currentScroll >= maxScroll * 0.9 &&
        state is VehicleSuccess &&
        state.hasMore) {
      _isLoadingMore = true;
      context.read<VehicleBloc>().add(
            LoadVehicles(
              limit: 5,
              skip: state.vehicles.length,
              searchText: _searchController.text,
            ),
          );
      _isLoadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search vehicles...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleInitial ||
                    (state is VehicleLoading && _searchController.text.isEmpty)) {
                  return const Center(child: CircularProgressIndicator());
                }
    
                if (state is VehicleFailure) {
                  return Center(child: Text(state.error));
                }
    
                if (state is VehicleSuccess) {
                  if (state.vehicles.isEmpty) {
                    return const Center(child: Text('No vehicles found'));
                  }
    
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<VehicleBloc>().add(
                            LoadVehicles(
                              limit: 5,
                              skip: 0,
                              searchText: _searchController.text,
                            ),
                          );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: state.vehicles.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.vehicles.length) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        }
    
                        final vehicle = state.vehicles[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 8.h),
                          child: ListTile(
                            title: Text(vehicle.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vehicle Number: ${vehicle.number}'),
                                Text('Color: ${vehicle.color}'),
                                Text('Model: ${vehicle.model}'),
                                Text(
                                  'Created: ${_formatDateTime(vehicle.createdAt)}',
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VehicleFormPage(vehicle: vehicle),
                                      ),
                                    );
                                    break;
                                  case 'delete':
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Vehicle'),
                                        content: const Text(
                                          'Are you sure you want to delete this vehicle?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<VehicleBloc>()
                                                  .add(DeleteVehicle(vehicle.id));
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
    
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VehicleFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
