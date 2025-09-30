import 'package:electricity/features/houses/domain/entities/house.dart';
import 'package:electricity/features/houses/domain/usecases/add_house_usecase.dart';
import 'package:electricity/core/di/service_locator_new.dart';
import 'package:uuid/uuid.dart';

class DataSeeder {
  static const _uuid = Uuid();

  static Future<void> seedInitialData() async {
    final addHouseUseCase = getIt<AddHouseUseCase>();

    final now = DateTime.now();
    final sampleHouses = [
      House(
        id: _uuid.v4(),
        name: 'Green Valley Home',
        address: '123 Main Street, Springfield',
        houseType: 'Single Family',
        ownershipType: 'Owned',
        meterNumber: 'GVH-001',
        notes:
            'Beautiful home with solar panels and energy-efficient appliances',
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(days: 30)),
      ),
      House(
        id: _uuid.v4(),
        name: 'Downtown Apartment',
        address: '456 Oak Avenue, Unit 2B',
        houseType: 'Apartment',
        ownershipType: 'Rented',
        meterNumber: 'DA-002B',
        notes: 'Modern apartment in the city center',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 25)),
      ),
      House(
        id: _uuid.v4(),
        name: 'Suburban Townhouse',
        address: '789 Pine Street, Maplewood',
        houseType: 'Townhouse',
        ownershipType: 'Owned',
        meterNumber: 'ST-789',
        notes: 'Family-friendly neighborhood with good schools',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
      House(
        id: _uuid.v4(),
        name: 'Lake House Retreat',
        address: '321 Lakeside Drive, Blue Lake',
        houseType: 'Single Family',
        ownershipType: 'Owned',
        meterNumber: 'LHR-321',
        notes: 'Vacation home with lakefront views',
        createdAt: now.subtract(const Duration(days: 15)),
        updatedAt: now.subtract(const Duration(days: 15)),
      ),
      House(
        id: _uuid.v4(),
        name: 'City Condo',
        address: '654 High Street, Floor 15',
        houseType: 'Condo',
        ownershipType: 'Owned',
        meterNumber: 'CC-654-15',
        notes: 'High-rise condo with city views',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
    ];

    try {
      for (final house in sampleHouses) {
        await addHouseUseCase(house);
      }
      print('✅ Sample data seeded successfully!');
    } catch (e) {
      print('❌ Failed to seed sample data: $e');
    }
  }
}
