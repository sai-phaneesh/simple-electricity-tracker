// class CycleSelector extends StatelessWidget {
//   const CycleSelector({super.key});

//   static final DateFormat _formatter = DateFormat('dd/MM/yyyy');

//   @override
//   Widget build(BuildContext context) {
//     final cycles = context.select((CycleBloc bloc) => bloc.cycles).reversed;

//     // final selectedCycle = context.watch<CycleBloc>().selectedCycle;
//     final selectedCycle =
//         context.select((CycleBloc bloc) => bloc.selectedCycle);

//     return BlocListener<CycleBloc, CycleState>(
//       listener: (context, state) {
//         if (state is UpdateSelectedCycleSuccess) {
//           if (state.selectedCycle?.consumptions == null) return;
//           context
//               .read<ConsumptionsBloc>()
//               .add(FetchConsumptions(cycleId: state.selectedCycle!.id));
//           return;
//         }
//       },
//       child: GestureDetector(
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             useSafeArea: true,
//             constraints: const BoxConstraints(maxHeight: 500),
//             builder: (context) {
//               if (cycles.isEmpty) {
//                 return Container(
//                   constraints: const BoxConstraints(minHeight: 200),
//                   child: Center(
//                     child: FilledButton.icon(
//                       onPressed: () {
//                         final user = context.read<UsersBloc>().selectedUser;
//                         if (user == null) return;
//                         context.pop();
//                         context.push(AddCycleScreen(user: user));
//                       },
//                       label: const Text('Create a new cycle'),
//                       icon: const Icon(Icons.add),
//                     ),
//                   ),
//                 );
//               }

//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                     child: Row(
//                       spacing: 20,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Select a cycle',
//                           style: context.theme.textTheme.titleLarge,
//                         ),
//                         IconButton(
//                           onPressed: context.pop,
//                           icon: const Icon(Icons.close),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   Flexible(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: cycles.length,
//                       itemBuilder: (context, index) {
//                         final cycle = cycles.elementAt(index);
//                         return ListTile(
//                           trailing: const Icon(Icons.keyboard_arrow_right),
//                           title: Text(cycle.name),
//                           subtitle: Text(
//                               '${_formatter.format(cycle.startDate)} - ${_formatter.format(cycle.endDate)}'),
//                           onTap: () {
//                             context
//                                 .read<CycleBloc>()
//                                 .add(UpdateSelectedCycle(cycle: cycle));
//                             context.pop();
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           );
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 10),
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: context.theme.colorScheme.onSurface.withValues(
//               alpha: 0.1,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             spacing: 20,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(selectedCycle?.name ?? 'Select a cycle'),
//               const Icon(Icons.keyboard_arrow_down),
//             ],
//           ),
//         ),
//       ),
//     );

//     // return DropdownButton<Cycle>(
//     //   isExpanded: true,
//     //   hint: const Text('Select a cycle'),
//     //   items: cycles
//     //       .map(
//     //         (e) => DropdownMenuItem(
//     //           value: e,
//     //           child: Text(e.name),
//     //         ),
//     //       )
//     //       .toList(),
//     //   value: cycles.firstWhereOrNull((e) => e.id == selectedCycle?.id),
//     //   onChanged: (value) {
//     //     if (value == null) return;
//     //     context.read<CycleBloc>().add(UpdateSelectedCycle(cycle: value));
//     //   },
//     // );
//   }
// }
