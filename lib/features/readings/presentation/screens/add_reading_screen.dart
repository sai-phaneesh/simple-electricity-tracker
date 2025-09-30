import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/features/readings/presentation/form/add_reading_form_model.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

class AddReadingScreen extends StatefulWidget {
  final String houseId;
  final String? cycleId;
  final String houseName;
  final double? defaultPricePerUnit;

  const AddReadingScreen({
    super.key,
    required this.houseId,
    this.cycleId,
    required this.houseName,
    this.defaultPricePerUnit,
  });

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _meterReadingController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final formModel = context.read<AddReadingFormModel>();
    _pricePerUnitController.text = formModel.pricePerUnit.toString();
  }

  @override
  void dispose() {
    _meterReadingController.dispose();
    _pricePerUnitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Reading'),
            Text(
              widget.houseName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Consumer<AddReadingFormModel>(
            builder: (context, formModel, child) {
              return TextButton(
                onPressed: formModel.isValid && !formModel.isLoading
                    ? _saveReading
                    : null,
                child: formModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Reading'),
            Text(
              widget.houseName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Consumer<AddReadingFormModel>(
            builder: (context, formModel, child) {
              return ElevatedButton.icon(
                onPressed: formModel.isValid && !formModel.isLoading
                    ? _saveReading
                    : null,
                icon: formModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Save Reading'),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(16),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Reading'),
            Text(
              widget.houseName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Consumer<AddReadingFormModel>(
            builder: (context, formModel, child) {
              return ElevatedButton.icon(
                onPressed: formModel.isValid && !formModel.isLoading
                    ? _saveReading
                    : null,
                icon: formModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Save Reading'),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(24),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reading Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.electric_meter,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Reading Details',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Date Field
                    Consumer<AddReadingFormModel>(
                      builder: (context, formModel, child) {
                        return _buildDateField(formModel);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Meter Reading Field
                    Consumer<AddReadingFormModel>(
                      builder: (context, formModel, child) {
                        return _buildMeterReadingField(formModel);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Price Per Unit Field
                    Consumer<AddReadingFormModel>(
                      builder: (context, formModel, child) {
                        return _buildPricePerUnitField(formModel);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Notes Field
                    _buildNotesField(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Preview Card
            Consumer<AddReadingFormModel>(
              builder: (context, formModel, child) {
                return _buildPreviewCard(formModel);
              },
            ),

            const SizedBox(height: 32),

            // Action Buttons (Mobile)
            if (MediaQuery.of(context).size.width < 600) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Consumer<AddReadingFormModel>(
                      builder: (context, formModel, child) {
                        return ElevatedButton(
                          onPressed: formModel.isValid && !formModel.isLoading
                              ? _saveReading
                              : null,
                          child: formModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Save Reading'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(AddReadingFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reading Date',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(formModel),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  _formatDate(formModel.date),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Spacer(),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMeterReadingField(AddReadingFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meter Reading',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _meterReadingController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Enter current meter reading',
            prefixIcon: const Icon(Icons.electric_meter),
            border: const OutlineInputBorder(),
            errorText: formModel.meterReadingError,
          ),
          onChanged: formModel.setMeterReading,
        ),
      ],
    );
  }

  Widget _buildPricePerUnitField(AddReadingFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Per Unit (₹)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _pricePerUnitController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'Enter price per unit',
            prefixIcon: const Icon(Icons.currency_rupee),
            border: const OutlineInputBorder(),
            errorText: formModel.pricePerUnitError,
          ),
          onChanged: formModel.setPricePerUnit,
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Consumer<AddReadingFormModel>(
          builder: (context, formModel, child) {
            return TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any notes about this reading...',
                prefixIcon: Icon(Icons.note),
                border: OutlineInputBorder(),
              ),
              onChanged: formModel.setNotes,
            );
          },
        ),
      ],
    );
  }

  Widget _buildPreviewCard(AddReadingFormModel formModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.preview,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Reading Preview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPreviewItem(
                    'Meter Reading',
                    formModel.meterReading?.toString() ?? '-',
                    Icons.electric_meter,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPreviewItem(
                    'Units Consumed',
                    '${formModel.unitsConsumed}',
                    Icons.bolt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPreviewItem(
                    'Total Cost',
                    '₹${formModel.totalCost.toStringAsFixed(2)}',
                    Icons.currency_rupee,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate(AddReadingFormModel formModel) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: formModel.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      formModel.setDate(selectedDate);
    }
  }

  Future<void> _saveReading() async {
    final formModel = context.read<AddReadingFormModel>();

    if (!formModel.isValid) {
      FlutterToastX.error('Please fill in all required fields');
      return;
    }

    try {
      formModel.setLoading(true);

      // TODO: Implement actual saving logic with repository
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      FlutterToastX.success('Reading added successfully!');

      if (mounted) {
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      FlutterToastX.error('Failed to save reading: ${e.toString()}');
    } finally {
      if (mounted) {
        formModel.setLoading(false);
      }
    }
  }
}
