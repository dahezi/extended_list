import 'dart:math';

import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:extended_list/extended_list.dart';
import 'package:flutter/scheduler.dart';

///
///  create by zmtzawqlp on 2019/11/23
///

@FFRoute(
  name: 'fluttercandies://chatlist',
  routeName: 'ChatList',
  description:
      'how to build layout(reverse=true) close to trailing when children are not full of viewport.',
)
class ChatListDemo extends StatefulWidget {
  @override
  _ChatListDemoState createState() => _ChatListDemoState();
}

class _ChatListDemoState extends State<ChatListDemo> {
  ScrollController controller = ScrollController();
  final List<Color> colors = <Color>[];
  final List<String> sessions = <String>[
    // 'I\'m session',
    // 'I\'m session',
    // 'I\'m session'
  ];
  @override
  Widget build(BuildContext context) {
    const double topPadding = 60;
    var list = ExtendedListView.builder(
      //itemExtent: 50.0,
      reverse: true,
      controller: controller,
      /// when reverse property of List is true, layout is as following.
      /// it likes chat list, and new session will insert to zero index
      /// but it's not right when items are not full of viewport.
      ///
      ///      trailing
      /// -----------------
      /// |               |
      /// |               |
      /// |     item2     |
      /// |     item1     |
      /// |     item0     |
      /// -----------------
      ///      leading
      ///
      /// to solve it, you could set closeToTrailing to true, layout is as following.
      /// support [ExtendedGridView],[ExtendedList],[WaterfallFlow]
      /// it works not only reverse is true.
      ///
      ///      trailing
      /// -----------------
      /// |     item2     |
      /// |     item1     |
      /// |     item0     |
      /// |               |
      /// |               |
      /// -----------------
      ///      leading
      ///
      extendedListDelegate: ExtendedListDelegate(
        closeToTrailing: true,
        reverseTopPadding: topPadding,
        viewportBuilder: (int firstIndex, int lastIndex) {
          print("viewport : [$firstIndex ,$lastIndex]");
        },
      ),
      padding: const EdgeInsets.only(top: topPadding),
      //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext c, int index) {
        final Color color = getRandomColor(index);
        List<Widget> children = <Widget>[
          Expanded(
            flex: 5,
            child: Container(
              height: 50.0 + index,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: getRandomColor(sessions.length - index - 1)),
              alignment: Alignment.center,
              child: Text(
                '${sessions[index]} index $index',
                style: TextStyle(
                    color: color.computeLuminance() < 0.5
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
          Expanded(flex: 2, child: Container()),
        ];
        if (index % 2 == 0) {
          // children = children.reversed.toList();
        }
        return GestureDetector(
          child: Row(children: children),
          onTap: () {
            print('click$index');
          },
        );
      },
      itemCount: sessions.length,
    );

    var body = Column(
      children: [
        Expanded(child: list)
        ,
        Container(
          height: 140,
          child: Wrap(
            children: [
              GestureDetector(
                child: const Text('go top'),
                onTap: () => controller.jumpTo(controller.position.maxScrollExtent),
              )
            ],
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatList'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            sessions.insert(0, 'data ${sessions.length}');
          });
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            controller.jumpTo(0);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Color getRandomColor(int index) {
    if (index >= colors.length) {
      colors.add(Color.fromARGB(255, Random.secure().nextInt(255),
          Random.secure().nextInt(255), Random.secure().nextInt(255)));
    }

    return colors[index];
  }
}
