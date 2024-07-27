import 'dart:math';

import 'package:flutter/material.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:get/get.dart';

import 'package:ones_llm/services/api.dart';
import 'package:ones_llm/components/chat/markdown.dart';

class SelectCard extends StatefulWidget {
  final List<Message> selectList;
  final void Function(Message) onSelect;
  final int displayNum;
  const SelectCard(
      {super.key,
      required this.selectList,
      required this.onSelect,
      required this.displayNum});

  @override
  SelectCardState createState() => SelectCardState();
}

class SelectCardState extends State<SelectCard> {
  int currentIndex = 0;
  late int displayNum;
  final maxDis = 2;
  bool scrolling = false;

  List<PageController> pageControllers = [];

  @override
  void initState() {
    currentIndex = 0;
    // displayNum = min(widget.selectList.length, widget.displayNum);
    displayNum = min(min(widget.selectList.length, max(((Get.size.width-300)/300).floor(), 1)), maxDis);
    pageControllers = [
      for (int i = 0; i < maxDis; i++) newPageController(i)
    ];
    super.initState();
  }

  PageController newPageController(pageNum) {
    final controller = PageController(initialPage: 0);
    controller.addListener(()=>_syncControllers(pageNum));
    return controller;
  }

  void _syncControllers(pageNum) {
    if (scrolling) return;
    for (int j = 0; j < displayNum; j++) {
      if (pageNum!=j) {
        pageControllers[j].jumpTo(pageControllers[pageNum].offset);
      }
    }
  }

  void nextPage() {
    currentIndex = pageControllers[0].page!.round();
    if (currentIndex < widget.selectList.length - displayNum) {
      scrolling = true;
      for (int i = 0; i < displayNum; i++) {
        pageControllers[i].nextPage(
            duration: const Duration(milliseconds: 250), curve: Curves.ease)
            .whenComplete(() => scrolling=false);
      }
      setState(() {
        currentIndex++;
      });
    }
  }

  void previousPage() {
    currentIndex = pageControllers[0].page!.round();
    if (currentIndex > 0) {
      scrolling = true;
      for (int i = 0; i < displayNum; i++) {
        pageControllers[i].previousPage(
            duration: const Duration(milliseconds: 250), curve: Curves.ease)
            .whenComplete(() => scrolling=false);
      }
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastD = displayNum;
    displayNum = min(min(widget.selectList.length, max(((Get.size.width-300)/300).floor(), 1)), maxDis);
    final overflow = currentIndex+displayNum-widget.selectList.length;
    if(overflow>0){
      currentIndex-=overflow;
      for (int i = 0; i < lastD; i++) {
        pageControllers[i].jumpToPage(currentIndex+i);
      }
    }
    for (int i = 0; i < displayNum; i++) {
      pageControllers[i] = newPageController(i);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (displayNum != widget.selectList.length)
          IconButton(
            padding: const EdgeInsets.only(top: 20),
            icon: const Icon(Icons.arrow_left),
            onPressed: () => previousPage(),
          ),
        ...[
          for (int i = 0; i < displayNum; i++)
            Expanded(
              child: ExpandablePageView.builder(
                controller: pageControllers[i],
                itemCount: widget.selectList.length-displayNum+1,
                itemBuilder: (context, index) {
                  index += i;
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Card(
                                // color: Theme.of(context).colorScheme.surfaceVariant.withAlpha(100),
                                elevation: 0,
                                child: Markdown(
                                    text: widget.selectList[index].text+(widget.selectList[index].sending?'_':''))),
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 20,
                        children: <Widget>[
                          Text(
                            widget.selectList[index].role,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${index + 1} / ${widget.selectList.length}",
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                widget.onSelect(widget.selectList[index]),
                            child: Text('selectResponse'.tr),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
        if (displayNum != widget.selectList.length)
          IconButton(
            padding: const EdgeInsets.only(top: 20),
            icon: const Icon(Icons.arrow_right),
            onPressed: () => nextPage(),
          ),
      ],
    );
  }
}
