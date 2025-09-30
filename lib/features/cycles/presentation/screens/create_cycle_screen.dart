import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:electricity/features/cycles/presentation/form/create_cycle_form_model.dart';
import 'package:electricity/shared/widgets/responsive_layout.dart';
import 'package:electricity/core/widgets/flutter_toast_x.dart';

class CreateCycleScreen extends StatefulWidget {
  final String houseId;
  final String houseName;
  final double? defaultPricePerUnit;

  const CreateCycleScreen({
    super.key,
    required this.houseId,
    required this.houseName,
    this.defaultPricePerUnit,
  });

  @override
  State<CreateCycleScreen> createState() => _CreateCycleScreenState();
}

class _CreateCycleScreenState extends State<CreateCycleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _initialMeterReadingController = TextEditingController();
  final _maxUnitsController = TextEditingController();
  final _pricePerUnitController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final formModel = context.read<CreateCycleFormModel>();
    _nameController.text = formModel.name;
    _pricePerUnitController.text = formModel.pricePerUnit.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _initialMeterReadingController.dispose();
    _maxUnitsController.dispose();
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
            const Text('Create Cycle'),
            Text(
              widget.houseName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Consumer<CreateCycleFormModel>(
            builder: (context, formModel, child) {
              return TextButton(
                onPressed: formModel.isValid && !formModel.isLoading
                    ? _saveCycle
                    : null,
                child: formModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create'),
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
            const Text('Create Cycle'),
            Text(
              widget.houseName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Consumer<CreateCycleFormModel>(
            builder: (context, formModel, child) {
              return ElevatedButton.icon(
                onPressed: formModel.isValid && !formModel.isLoading
                    ? _saveCycle
                    : null,
                icon: formModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: const Text('Create Cycle'),
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
            const Text('Create Cycle'),
            Text(
              widget.houseName,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Consumer<CreateCycleFormModel>(
            builder: (context, formModel, child) {
              return ElevatedButton.icon(
                onPressed: formModel.isValid && !formModel.isLoading
                    ? _saveCycle
                    : null,
                icon: formModel.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: const Text('Create Cycle'),
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
            // Basic Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Cycle Information',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Cycle Name Field
                    Consumer<CreateCycleFormModel>(
                      builder: (context, formModel, child) {
                        return _buildNameField(formModel);
                      },
                    ),

                    const SizedBox(height: 16),

                    // Date Range Fields
                    Consumer<CreateCycleFormModel>(
                      builder: (context, formModel, child) {
                        return _buildDateRangeFields(formModel);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Meter & Units Card
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
                          'Meter & Units',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        // Initial Meter Reading Field
                        Expanded(
                          child: Consumer<CreateCycleFormModel>(
                            builder: (context, formModel, child) {
                              return _buildInitialMeterReadingField(formModel);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Max Units Field
                        Expanded(
                          child: Consumer<CreateCycleFormModel>(
                            builder: (context, formModel, child) {
                              return _buildMaxUnitsField(formModel);
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Price Per Unit Field
                    Consumer<CreateCycleFormModel>(
                      builder: (context, formModel, child) {
                        return _buildPricePerUnitField(formModel);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Notes Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.note,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Additional Notes',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildNotesField(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Preview Card
            Consumer<CreateCycleFormModel>(
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
                    child: Consumer<CreateCycleFormModel>(
                      builder: (context, formModel, child) {
                        return ElevatedButton(
                          onPressed: formModel.isValid && !formModel.isLoading
                              ? _saveCycle
                              : null,
                          child: formModel.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Create Cycle'),
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

  Widget _buildNameField(CreateCycleFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle Name',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'e.g., January 2025',
            prefixIcon: const Icon(Icons.label),
            border: const OutlineInputBorder(),
            errorText: formModel.nameError,
          ),
          onChanged: formModel.setName,
        ),
      ],
    );
  }

  Widget _buildDateRangeFields(CreateCycleFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle Period',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (formModel.dateError != null) ...[
          const SizedBox(height: 8),
          Text(
            formModel.dateError!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                'Start Date',
                formModel.startDate,
                (date) => formModel.setStartDate(date),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDateField(
                'End Date',
                formModel.endDate,
                (date) => formModel.setEndDate(date),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Duration: ${formModel.durationInDays} days',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    ValueChanged<DateTime> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _selectDate(date, onChanged),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  _formatDate(date),
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

  Widget _buildInitialMeterReadingField(CreateCycleFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Initial Reading',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _initialMeterReadingController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Starting meter reading',
            prefixIcon: const Icon(Icons.electric_meter),
            border: const OutlineInputBorder(),
            errorText: formModel.initialMeterReadingError,
          ),
          onChanged: formModel.setInitialMeterReading,
        ),
      ],
    );
  }

  Widget _buildMaxUnitsField(CreateCycleFormModel formModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Max Units',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _maxUnitsController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Expected max units',
            prefixIcon: const Icon(Icons.bolt),
            border: const OutlineInputBorder(),
            errorText: formModel.maxUnitsError,
          ),
          onChanged: formModel.setMaxUnits,
        ),
      ],
    );
  }

  Widget _buildPricePerUnitField(CreateCycleFormModel formModel) {
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
            hintText: 'Electricity rate for this cycle',
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
        Consumer<CreateCycleFormModel>(
          builder: (context, formModel, child) {
            return TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add any notes about this billing cycle...',
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

  Widget _buildPreviewCard(CreateCycleFormModel formModel) {
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
                  'Cycle Preview',
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
                    'Duration',
                    '${formModel.durationInDays} days',
                    Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPreviewItem(
                    'Max Units',
                    formModel.maxUnits?.toString() ?? '-',
                    Icons.bolt,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPreviewItem(
                    'Est. Cost',
                    '₹${formModel.estimatedCost.toStringAsFixed(2)}',
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

  Future<void> _selectDate(
    DateTime initialDate,
    ValueChanged<DateTime> onChanged,
  ) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  Future<void> _saveCycle() async {
    final formModel = context.read<CreateCycleFormModel>();

    if (!formModel.isValid) {
      FlutterToastX.error('Please fill in all required fields');
      return;
    }

    try {
      formModel.setLoading(true);

      // TODO: Implement actual saving logic with repository
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      FlutterToastX.success('Cycle created successfully!');

      if (mounted) {
        context.pop(true); // Return true to indicate success
      }
    } catch (e) {
      FlutterToastX.error('Failed to create cycle: ${e.toString()}');
    } finally {
      if (mounted) {
        formModel.setLoading(false);
      }
    }
  }
}
