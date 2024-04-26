import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:moass/widgets/check_box.dart';
import 'package:moass/widgets/top_bar.dart';

import '../widgets/category_text.dart';
import '../widgets/schedule_box.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  String selectedSeatedState = 'here';

// 내상태 설정
// 자리비움으로 바꾸기
  void setStateNotHere() {
    setState(() {
      if (selectedSeatedState == 'here') {
        selectedSeatedState = 'notHere';
      }
    });
  }

// 착석으로 바꾸기
  void setStateHere() {
    setState(() {
      if (selectedSeatedState == 'notHere') {
        selectedSeatedState = 'here';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(title: '메인'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryText(
            text: '내 기기 상태',
          ),
          Expanded(
            child: Container(
                height: 800,
                decoration: const BoxDecoration(color: Colors.grey),
                child: const Center(child: CategoryText(text: '기기 이미지 들어갈 곳'))),
          ),
          const CategoryText(text: '내 상태 설정'),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: setStateHere,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xFF3DB887),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: selectedSeatedState == 'here'
                              ? Border.all(
                                  color: const Color(0xFF6ECEF5), width: 4.0)
                              : null),
                      child: const Center(
                          child: Text('착석 중',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  GestureDetector(
                    onTap: setStateNotHere,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFBC1F),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: selectedSeatedState == 'notHere'
                              ? Border.all(
                                  color: const Color(0xFF6ECEF5), width: 4.0)
                              : null),
                      child: const Center(
                          child: Text('자리 비움',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              ),
              Column(
                children: selectedSeatedState == 'notHere'
                    ? [
                        const Text('사유를 입력하세요'),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyStateSelector(state: '취업면담'),
                            MyStateSelector(state: '팀 미팅'),
                            MyStateSelector(state: '기타'),
                          ],
                        )
                      ]
                    : [],
              ),
            ],
          ),
          const CategoryText(text: '다음 일정'),
          const Center(
            child: Column(
              children: [
                ScheduleBox(title: '[Live] 생성형 AI 특강', time: '14:00-15:00'),
              ],
            ),
          ),
          const CategoryText(text: '할 일 목록'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: const Color(0xFF6ECEF5), width: 2.0)),
              child: const Column(
                children: [
                  Row(
                    children: [
                      CheckboxWidget(),
                      Text('현욱이 괴롭히기'),
                    ],
                  ),
                  Row(
                    children: [
                      CheckboxWidget(),
                      Text('끝장나게 자기'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_box_outlined),
                      Text('할 일 추가'),
                    ],
                  )
                ],
              ),
            ),
          ),
          const CategoryText(text: '오늘 내 예약'),
          const Center(
            child: Column(
              children: [
                ScheduleBox(title: '플립보드 1', time: '10:00 - 11:00'),
                ScheduleBox(title: '팀 미팅', time: '11:00 - 12:00'),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyStateSelector extends StatelessWidget {
  const MyStateSelector({
    super.key,
    required this.state,
  });

  final String state;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 80,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1.0, color: const Color(0xFF6ECEF5)),
          borderRadius: BorderRadius.circular(50)),
      child: Center(
          child: Text(
        state,
        style: const TextStyle(
          color: Color(0xFF6ECEF5),
        ),
      )),
    );
  }
}