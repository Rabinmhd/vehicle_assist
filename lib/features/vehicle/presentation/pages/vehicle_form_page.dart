import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parking_app_assignment/features/vehicle/domain/models/vehiclerequest_model.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/di/injection.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../domain/models/vehicle.dart';
import '../bloc/vehicle_bloc.dart';
import '../bloc/vehicle_event.dart';
import '../bloc/vehicle_state.dart';

class VehicleFormPage extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormPage({super.key, this.vehicle});

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _colorController;
  late final TextEditingController _vehicleNumberController;
  late final TextEditingController _modelYearController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.vehicle?.name);
    _colorController = TextEditingController(text: widget.vehicle?.color);
    _vehicleNumberController =
        TextEditingController(text: widget.vehicle?.number);
    _modelYearController = TextEditingController(text: widget.vehicle?.model);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    _vehicleNumberController.dispose();
    _modelYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VehicleBloc(
        vehicleRepository: VehicleRepository(getIt<ApiClient>()),
      ),
      child: BlocListener<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state is VehicleActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is VehicleFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.vehicle == null ? 'Add Vehicle' : 'Edit Vehicle'),
            centerTitle: true,
          ),
          body: BlocBuilder<VehicleBloc, VehicleState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Name',
                          hintText: 'Enter vehicle name',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vehicle name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _vehicleNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Number',
                          hintText: 'Enter vehicle number (e.g., KL-01-AB-1234)',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vehicle number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _colorController,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Color',
                          hintText: 'Enter vehicle color',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vehicle color';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _modelYearController,
                        decoration: const InputDecoration(
                          labelText: 'Vehicle Model',
                          hintText: 'Enter vehicle model',
                          border: OutlineInputBorder(),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter vehicle model';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: state is VehicleLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    final vehicleRequestModel = VehicleRequestModel(
                                      name: _nameController.text,
                                      vehicleNumber: _vehicleNumberController.text,
                                      color: _colorController.text,
                                      model: _modelYearController.text,
                                    );

                                    if (widget.vehicle == null) {
                                      context
                                          .read<VehicleBloc>()
                                          .add(CreateVehicle(vehicleRequestModel));
                                    } else {
                                      context
                                          .read<VehicleBloc>()
                                          .add(UpdateVehicle(vehicleRequestModel));
                                    }
                                  }
                                },
                          child: state is VehicleLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  widget.vehicle == null ? 'Add Vehicle' : 'Update Vehicle',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
