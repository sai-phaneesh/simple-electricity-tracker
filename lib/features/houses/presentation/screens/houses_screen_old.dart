// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:electricity/shared/widgets/responsive_layout.dart';
// import 'package:electricity/features/houses/presentation/bloc/houses_bloc.dart';
// import 'package:electricity/features/houses/presentation/widgets/house_card.dart';
// import 'package:electricity/features/houses/domain/entities/house.dart';

// /// Houses screen - Main screen showing list of houses
// class HousesScreen extends StatefulWidget {
//   const HousesScreen({super.key});

//   @override
//   State<HousesScreen> createState() => _HousesScreenState();
// }

// class _HousesScreenState extends State<HousesScreen> {
//   final _searchController = TextEditingController();
//   bool _showFilters = false;

//   static const List<String> _houseTypes = [
//     'All Types',
//     'Apartment',
//     'House',
//     'Townhouse',
//     'Condo',
//     'Studio',
//     'Villa',
//     'Other',
//   ];

//   static const List<String> _ownershipTypes = [
//     'All Ownership',
//     'Owned',
//     'Rented',
//     'Family Property',
//     'Shared',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     context.read<HousesBloc>().add(const LoadHouses());
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => HousesBloc()..add(const LoadHouses()),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('My Houses'),
//           actions: [
//             IconButton(
//               icon: Icon(
//                 _showFilters ? Icons.filter_list : Icons.filter_list_off,
//               ),
//               onPressed: () {
//                 setState(() => _showFilters = !_showFilters);
//               },
//             ),
//             if (!ResponsiveHelper.isMobile(context))
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () => context.push('/settings'),
//               ),
//           ],
//         ),
//         body: ResponsiveConstrainedBox(
//           child: ResponsiveLayout(
//             mobile: _buildMobileLayout(context),
//             tablet: _buildTabletLayout(context),
//             desktop: _buildDesktopLayout(context),
//           ),
//         ),
//         floatingActionButton: ResponsiveHelper.isMobile(context)
//             ? FloatingActionButton.extended(
//                 onPressed: _addHouse,
//                 icon: const Icon(Icons.add),
//                 label: const Text('Add House'),
//               )
//             : null,
//       ),
//     );
//   }

//   Widget _buildMobileLayout(BuildContext context) {
//     return BlocBuilder<HousesBloc, HousesState>(
//       builder: (context, state) {
//         return ResponsivePadding(
//           child: Column(
//             children: [
//               // Search bar
//               _buildSearchBar(context),

//               // Filters
//               if (_showFilters) _buildFilterRow(context),

//               const SizedBox(height: 16),

//               // Houses list
//               Expanded(child: _buildHousesList(context, state)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTabletLayout(BuildContext context) {
//     return BlocBuilder<HousesBloc, HousesState>(
//       builder: (context, state) {
//         return ResponsivePadding(
//           child: Column(
//             children: [
//               // Header section with search and add button
//               Row(
//                 children: [
//                   Expanded(child: _buildSearchBar(context)),
//                   const SizedBox(width: 16),
//                   ElevatedButton.icon(
//                     onPressed: _addHouse,
//                     icon: const Icon(Icons.add),
//                     label: const Text('Add House'),
//                   ),
//                 ],
//               ),

//               // Filters
//               if (_showFilters) _buildFilterRow(context),

//               const SizedBox(height: 24),

//               // Houses grid
//               Expanded(
//                 child: _buildHousesGrid(context, state, crossAxisCount: 2),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDesktopLayout(BuildContext context) {
//     return BlocBuilder<HousesBloc, HousesState>(
//       builder: (context, state) {
//         return ResponsivePadding(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Houses',
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(width: 300, child: _buildSearchBar(context)),
//                       const SizedBox(width: 16),
//                       ElevatedButton.icon(
//                         onPressed: _addHouse,
//                         icon: const Icon(Icons.add),
//                         label: const Text('Add House'),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(
//                         icon: const Icon(Icons.settings),
//                         onPressed: () => context.push('/settings'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               // Filters
//               if (_showFilters) _buildFilterRow(context),

//               const SizedBox(height: 24),

//               // Houses grid
//               Expanded(
//                 child: _buildHousesGrid(context, state, crossAxisCount: 3),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSearchBar(BuildContext context) {
//     return BlocBuilder<HousesBloc, HousesState>(
//       builder: (context, state) {
//         return SearchBar(
//           controller: _searchController,
//           hintText: 'Search houses...',
//           leading: const Icon(Icons.search),
//           trailing: state.searchQuery.isNotEmpty
//               ? [
//                   IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       _searchController.clear();
//                       context.read<HousesBloc>().add(const SearchHouses(''));
//                     },
//                   ),
//                 ]
//               : null,
//           onChanged: (query) {
//             context.read<HousesBloc>().add(SearchHouses(query));
//           },
//         );
//       },
//     );
//   }

//   Widget _buildFilterRow(BuildContext context) {
//     return BlocBuilder<HousesBloc, HousesState>(
//       builder: (context, state) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.filter_list, size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Filters',
//                       style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(),
//                     if (state.selectedHouseType != null ||
//                         state.selectedOwnershipType != null)
//                       TextButton(
//                         onPressed: () => context.read<HousesBloc>().add(
//                           const ClearFilters(),
//                         ),
//                         child: const Text('Clear All'),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 8,
//                   children: [
//                     // House type filter
//                     SizedBox(
//                       width: 200,
//                       child: DropdownButtonFormField<String>(
//                         value: state.selectedHouseType ?? 'All Types',
//                         decoration: const InputDecoration(
//                           labelText: 'House Type',
//                           isDense: true,
//                         ),
//                         items: _houseTypes.map((type) {
//                           return DropdownMenuItem(
//                             value: type == 'All Types' ? null : type,
//                             child: Text(type),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           context.read<HousesBloc>().add(
//                             FilterHouses(
//                               houseType: value,
//                               ownershipType: state.selectedOwnershipType,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     // Ownership type filter
//                     SizedBox(
//                       width: 200,
//                       child: DropdownButtonFormField<String>(
//                         value: state.selectedOwnershipType ?? 'All Ownership',
//                         decoration: const InputDecoration(
//                           labelText: 'Ownership',
//                           isDense: true,
//                         ),
//                         items: _ownershipTypes.map((type) {
//                           return DropdownMenuItem(
//                             value: type == 'All Ownership' ? null : type,
//                             child: Text(type),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           context.read<HousesBloc>().add(
//                             FilterHouses(
//                               houseType: state is HousesLoaded
//                                   ? state.selectedHouseType
//                                   : null,
//                               ownershipType: value,
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHousesList(BuildContext context, HousesState state) {
//     if (state.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (state.error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Error loading houses',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Text(state.error!),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () =>
//                   context.read<HousesBloc>().add(const LoadHouses()),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (state.filteredHouses.isEmpty) {
//       return _buildEmptyState(context);
//     }

//     return ListView.builder(
//       itemCount: state.filteredHouses.length,
//       itemBuilder: (context, index) {
//         final house = state.filteredHouses[index];
//         return HouseCard(
//           house: house,
//           onEdit: () => _editHouse(house),
//           onDelete: () => _deleteHouse(house),
//         );
//       },
//     );
//   }

//   Widget _buildHousesGrid(
//     BuildContext context,
//     HousesState state, {
//     required int crossAxisCount,
//   }) {
//     if (state.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (state.error != null) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: 16),
//             Text(
//               'Error loading houses',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Text(state.error!),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () =>
//                   context.read<HousesBloc>().add(const LoadHouses()),
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     if (state.filteredHouses.isEmpty) {
//       return _buildEmptyState(context);
//     }

//     return GridView.builder(
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 1.2,
//       ),
//       itemCount: state.filteredHouses.length,
//       itemBuilder: (context, index) {
//         final house = state.filteredHouses[index];
//         return HouseCard(
//           house: house,
//           onEdit: () => _editHouse(house),
//           onDelete: () => _deleteHouse(house),
//         );
//       },
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     final bloc = context.read<HousesBloc>();
//     final state = bloc.state;

//     final isFiltered =
//         state.searchQuery.isNotEmpty ||
//         state.selectedHouseType != null ||
//         state.selectedOwnershipType != null;

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             isFiltered ? Icons.search_off : Icons.home_outlined,
//             size: 80,
//             color: Colors.grey,
//           ),
//           const SizedBox(height: 16),
//           Text(
//             isFiltered ? 'No houses found' : 'No houses yet',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               color: Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             isFiltered
//                 ? 'Try adjusting your search or filters'
//                 : 'Add your first house to start tracking electricity consumption',
//             textAlign: TextAlign.center,
//             style: Theme.of(
//               context,
//             ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
//           ),
//           const SizedBox(height: 24),
//           if (isFiltered)
//             OutlinedButton(
//               onPressed: () {
//                 _searchController.clear();
//                 bloc.add(const ClearFilters());
//               },
//               child: const Text('Clear Filters'),
//             )
//           else
//             ElevatedButton.icon(
//               onPressed: _addHouse,
//               icon: const Icon(Icons.add),
//               label: const Text('Add Your First House'),
//             ),
//         ],
//       ),
//     );
//   }

//   void _addHouse() {
//     context.push('/houses/add');
//   }

//   void _editHouse(House house) {
//     context.push('/houses/edit/${house.id}');
//   }

//   void _deleteHouse(House house) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Row(
//           children: [
//             Icon(Icons.delete_forever, color: Colors.red),
//             SizedBox(width: 8),
//             Text('Delete House'),
//           ],
//         ),
//         content: Text(
//           'Are you sure you want to delete "${house.name}"? This will also delete all associated electricity cycles and readings. This action cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               context.read<HousesBloc>().add(DeleteHouse(house.id));
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: [
//                       const Icon(
//                         Icons.check_circle,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text('${house.name} deleted successfully'),
//                     ],
//                   ),
//                   backgroundColor: Colors.green,
//                   behavior: SnackBarBehavior.floating,
//                   margin: const EdgeInsets.all(16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }
// }
