import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groping_demo/model/data_model.dart';
import 'package:groping_demo/repository/data_repo.dart';
import 'package:groping_demo/screens/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _jsonLoad();
      },
    );
    super.initState();
  }

  _jsonLoad() async {
    await ref.read(dataRepoProvider).readJson();
  }

  DateTime _formatDate(String date) {
    List<String> dateParts = date.split("-");
    String formattedString = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
    return DateTime.parse(formattedString);
  }

  String _getMonthName(int month) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(dataRepoProvider).isLoading;
    List<DataModel>? dataList = ref.watch(dataRepoProvider).dataList;
    Map<String, Map<String, List<DataModel>>> yearMonthData = {};
    if (dataList != null) {
      for (var employee in dataList) {
        String year = _formatDate(employee.hireDt).year.toString();
        String month = _formatDate(employee.hireDt).month.toString();
        yearMonthData.putIfAbsent(year, () => {});
        yearMonthData[year]!.putIfAbsent(month, () => []);
        yearMonthData[year]![month]!.add(employee);
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Employee Data"),
          centerTitle: true,
        ),
        body: isLoading ? _lodingWidget() : _dataWidget(yearMonthData));
  }

  Widget _lodingWidget() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _dataWidget(Map<String, Map<String, List<DataModel>>> data) => Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                String year = data.keys.elementAt(index);
                Map<String, List<DataModel>> monthData = data[year]!;
                List<String> months = monthData.keys.toList();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.grey.shade200,
                    child: ExpansionTile(
                      title: Text(year),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      children: [
                        for (var month in months)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ExpansionTile(
                              title: Text(_getMonthName(int.parse(month))),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              children: [
                                for (var employee in monthData[month]!)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProfileScreen(employee: employee),
                                            ));
                                      },
                                      tileColor: Colors.grey,
                                      title: Text(employee.name),
                                      leading: employee.profilePic.isNotEmpty
                                          ? CircleAvatar(
                                              backgroundImage: FileImage(File(employee.profilePic)),
                                            )
                                          : const CircleAvatar(
                                              backgroundImage: CachedNetworkImageProvider(
                                                  "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                                            ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Email : ${employee.email}"),
                                          Text("Hire Dt : ${employee.hireDt}"),
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
}
