import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:ones_llm/controller/model.dart';

class ModelSelectWindow extends StatelessWidget {

  const ModelSelectWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ModelController>(
      initState: (state) {
        state.controller?.getAvailableProviderModels();
      },
      builder: (controller) {
      return SingleChildScrollView(
        child: Column(
          children: controller.modelProviderMap.values.map((provider) {
            return ExpandablePanel(
              header: ListTile(
                title: Text(provider.name),
                subtitle: Text("已选择: ${provider.getSelectedModelName().length} / ${provider.modelMap.length}"),
              ),
              collapsed: const SizedBox(),
              expanded: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 5.0,
                  children: provider.modelMap.values.isNotEmpty?
                  provider.modelMap.values.map((model) {
                    return ElevatedButton(
                      onPressed: ()=>controller.toggleSelectModel(model),
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              model.selected
                                  ? Colors.blue
                                  : Colors.grey),
                          shadowColor: const MaterialStatePropertyAll(
                              Colors.transparent), 
                          elevation: const MaterialStatePropertyAll(0), 
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          padding: const MaterialStatePropertyAll(
                              EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8))),
                      child: Text(model.name,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    );
                  }).toList():[Container(alignment: Alignment.center, child: const Text('noAvilableModels'),)],
                ),
              ),
              theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center),
            );
          }).toList(),
        ),
      );
    });
  }
}
