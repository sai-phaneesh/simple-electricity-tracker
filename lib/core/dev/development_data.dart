import 'package:electricity/features/houses/domain/entities/house.dart';

/// Development utilities for testing and demo purposes
class DevelopmentData {
  /// Generate dummy houses for testing
  static List<House> generateDummyHouses() {
    return [
      House(
        id: 'house-1',
        name: 'Main Family House',
        address: '123 Oak Street, Springfield, IL 62701',
        houseType: 'House',
        ownershipType: 'Owned',
        notes: 'Primary residence with solar panels installed',
        meterNumber: 'MTR-001234',
        defaultPricePerUnit: 0.12,
        freeUnitsPerMonth: 100.0,
        warningLimitUnits: 1500.0,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      House(
        id: 'house-2',
        name: 'Downtown Apartment',
        address: '456 Elm Avenue, Apt 12B, Springfield, IL 62702',
        houseType: 'Apartment',
        ownershipType: 'Rented',
        notes: 'City apartment with high energy efficiency rating',
        meterNumber: 'MTR-005678',
        defaultPricePerUnit: 0.15,
        freeUnitsPerMonth: 50.0,
        warningLimitUnits: 800.0,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      House(
        id: 'house-3',
        name: 'Beach Villa',
        address: '789 Oceanview Drive, Malibu, CA 90265',
        houseType: 'Villa',
        ownershipType: 'Owned',
        notes: 'Vacation home with smart meter and pool heating',
        meterNumber: 'MTR-009876',
        defaultPricePerUnit: 0.22,
        freeUnitsPerMonth: 200.0,
        warningLimitUnits: 2500.0,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      House(
        id: 'house-4',
        name: 'Student Housing',
        address: '321 University Lane, College Town, TX 78701',
        houseType: 'Townhouse',
        ownershipType: 'Shared',
        notes: 'Shared with 3 other students, split electricity costs',
        meterNumber: 'MTR-112233',
        defaultPricePerUnit: 0.10,
        freeUnitsPerMonth: 75.0,
        warningLimitUnits: 1000.0,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      House(
        id: 'house-5',
        name: 'Grandparents House',
        address: '654 Maple Street, Hometown, OH 44101',
        houseType: 'House',
        ownershipType: 'Family Property',
        notes: 'Old family house, monitoring for elderly care',
        meterNumber: 'MTR-445566',
        defaultPricePerUnit: 0.11,
        freeUnitsPerMonth: 150.0,
        warningLimitUnits: 1200.0,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      House(
        id: 'house-6',
        name: 'Urban Condo',
        address: '987 City Center, Unit 45, Metro City, NY 10001',
        houseType: 'Condo',
        ownershipType: 'Owned',
        notes: 'High-rise condo with central air conditioning',
        meterNumber: 'MTR-778899',
        defaultPricePerUnit: 0.18,
        freeUnitsPerMonth: 80.0,
        warningLimitUnits: 900.0,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      House(
        id: 'house-7',
        name: 'Cottage Retreat',
        address: '159 Forest Road, Mountain View, CO 80424',
        houseType: 'House',
        ownershipType: 'Owned',
        notes: 'Weekend retreat cabin with electric heating',
        meterNumber: 'MTR-334455',
        defaultPricePerUnit: 0.14,
        freeUnitsPerMonth: 120.0,
        warningLimitUnits: 1800.0,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        updatedAt: DateTime.now().subtract(const Duration(days: 21)),
      ),
      House(
        id: 'house-8',
        name: 'Starter Apartment',
        address: '753 First Street, Apt 8A, Newtown, FL 33101',
        houseType: 'Apartment',
        ownershipType: 'Rented',
        notes: 'First apartment, learning to manage utilities',
        meterNumber: 'MTR-667788',
        defaultPricePerUnit: 0.13,
        freeUnitsPerMonth: 60.0,
        warningLimitUnits: 700.0,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  /// Add dummy data to the app (development only)
  static Future<void> addDummyDataIfEmpty() async {
    // This would be called during development initialization
    // Implementation would depend on your data source structure
    print('🏠 Development: Dummy houses data available for testing');
    print('   ${generateDummyHouses().length} sample houses created');
  }
}
