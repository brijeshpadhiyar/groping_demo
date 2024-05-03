import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groping_demo/model/data_model.dart';

final dataRepoProvider = ChangeNotifierProvider<DataRepoNotifier>((ref) {
  return DataRepoNotifier();
});

class DataRepoNotifier extends ChangeNotifier {
  List<DataModel>? _dataList;
  List<DataModel>? get dataList => _dataList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updateEmployeeData(DataModel updateEmployee) {
    int index = _dataList!.indexWhere((employee) => employee.id == updateEmployee.id);
    if (index != -1) {
      _dataList![index] = updateEmployee;
    }
    notifyListeners();
  }

  Future readJson() async {
    _isLoading = true;
    String res = await rootBundle.loadString("assets/json/data.json");
    List<dynamic> data = await jsonDecode(res) as List<dynamic>;
    _dataList = data.map((json) => DataModel.fromMap(json)).toList();
    _isLoading = false;
    notifyListeners();
  }
}
