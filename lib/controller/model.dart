import 'package:get/get.dart';

import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/configs/variables.dart';

class Model {
  bool _selected = false;

  final String name;

  Model({required this.name}) {
    _selected = selected;
  }

  bool get selected => _selected;

  void toggleSelected() {
    _selected = !_selected;
  }
}

class ModelProvider {
  final String name;
  // bool requireApikey;
  final Map<String, Model> modelMap = {};
  
  ModelProvider({required this.name});

  List<String> getSelectedModelName() {
    return modelMap.values.where((model) => model.selected).map((model) => model.name).toList();
  }
}

class ModelController extends GetxController {
  final modelProviderMap = <String, ModelProvider>{}.obs;

  final ApiService api = Get.find();

  @override
  void onInit() {
    super.onInit();
    getAllProviders();
  }

  void getAllProviders() async {
    final modelData = await api.getAllProviders();
    for (var elements in modelData) {
      modelProviderMap[elements] ??= ModelProvider(name: elements);
    }
    final keysToRemove = modelProviderMap.keys
        .where((providerKey) => !modelData.contains(providerKey))
        .toList();
    for (final key in keysToRemove) {
      modelProviderMap.remove(key);
    }
    update();
  }

  void getAvailableProviderModels() async {
    final modelData = await api.getAvailableProviderModels();
    modelData.forEach((key, elements) {
      modelProviderMap[key] ??= ModelProvider(name: key);

      final existingNames = modelProviderMap[key]!.modelMap.keys.toSet();
      final uniqueElements = elements.toSet().difference(existingNames);
      final removedNames = existingNames.difference(elements.toSet());

      for (final element in uniqueElements) {
        modelProviderMap[key]!.modelMap[element] =
            Model(name: element);
      }

      for (final modelName in removedNames) {
        modelProviderMap[key]!.modelMap.remove(modelName);
      }
    });
    update();
  }

  void toggleSelectModel(Model model) {
    model.toggleSelected();
    update();
  }

  Map<String, List<String>> getSelectedMap() {
    if(singleModelMode) return {singleProviderName: [singleModelName]};
    final selectedMap = {
      for (final provider in modelProviderMap.values)
      provider.name: provider.getSelectedModelName()
    };
    selectedMap.removeWhere((k, v) => v.isEmpty);
    return selectedMap;
  }
}
