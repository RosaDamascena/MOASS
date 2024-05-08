import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moass/model/myprofile.dart';
import 'package:moass/model/user_info.dart';
import 'package:moass/services/myinfo_api.dart';
import 'package:moass/services/user_info_api.dart';
import 'package:moass/widgets/category_text.dart';
import 'package:moass/widgets/top_bar.dart';
import 'package:moass/widgets/user_box.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  bool isOpenedButtonWidget = false;

  openButtonWidget() {
    setState(() {
      isOpenedButtonWidget = !isOpenedButtonWidget;
    });
  }

  String? inputText;
  late Future<List<UserInfo>> searchedUserList =
      UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
          .fetchUserProfile(inputText);

  searchUser(value) {
    searchedUserList =
        UserInfoApi(dio: Dio(), storage: const FlutterSecureStorage())
            .fetchUserProfile(value);
  }

  late Future<List<List<UserInfo>>> myClass;

  @override
  Widget build(BuildContext context) {
    final myInfoApi =
        MyInfoApi(dio: Dio(), storage: const FlutterSecureStorage());

    return Scaffold(
        appBar: const TopBar(
          title: '좌석',
          icon: Icons.calendar_view_month_rounded,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상태 처리 및 DropdownButton 작업 해야함
              FutureBuilder(
                  future: myInfoApi.fetchUserProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      var userProfile = snapshot.data;
                      var currentClass = userProfile!.classCode.split('').last;

                      myClass = UserInfoApi(
                              dio: Dio(), storage: const FlutterSecureStorage())
                          .fetchMyClass(userProfile.classCode);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CategoryText(
                              text:
                                  '${userProfile.locationName}캠퍼스 $currentClass반'),
                          FutureBuilder(
                              future: myClass,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (snapshot.hasData) {
                                  List<List<UserInfo>>? currentClass =
                                      snapshot.data;
                                  return SizedBox(
                                    height: 400,
                                    width: double.infinity,
                                    child: InteractiveViewer(
                                      scaleEnabled: true,
                                      scaleFactor: 4.0,
                                      minScale: 0.1,
                                      maxScale: 3.0,
                                      child: Container(
                                          height: 800,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                              color: Colors.grey),
                                          child: Column(
                                            children: [
                                              for (var team in currentClass!)
                                                Container(
                                                    width: 200,
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Colors.white),
                                                    child: GridView.count(
                                                        shrinkWrap: true,
                                                        crossAxisCount: 2,
                                                        children: [
                                                          for (var user in team)
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      color: Colors
                                                                          .green),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                      user
                                                                          .teamCode,
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w600)),
                                                                  Text(
                                                                    user.userName,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w800),
                                                                  ),
                                                                  Container(
                                                                    margin:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            6.0),
                                                                    width: 80,
                                                                    height: 20,
                                                                    decoration: BoxDecoration(
                                                                        color: user.connectFlag == 1
                                                                            ? user.statusId == 1
                                                                                ? const Color(0xFF3DB887)
                                                                                : const Color(0xFFFFBC1F)
                                                                            : Colors.grey),
                                                                    child: user.connectFlag ==
                                                                            1
                                                                        ? user.statusId ==
                                                                                1
                                                                            ? const Center(
                                                                                child: Text('착석중'),
                                                                              )
                                                                            : const Center(
                                                                                child: Text('자리 비움'),
                                                                              )
                                                                        : const Text(
                                                                            ''),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                        ]))
                                            ],
                                          )),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: Text('No data available'));
                                }
                              }),
                        ],
                      );
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  }),

              const CategoryText(text: '교육생 조회'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SearchBar(
                  leading: const Icon(Icons.search),
                  hintText: "교육생 이름을 입력하세요",
                  onChanged: (value) {
                    setState(() {
                      inputText = value;
                    });
                    searchUser(inputText);
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: searchedUserList,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (snapshot.hasData) {
                              var userInfoList = snapshot.data;
                              print('유저 정보 : $userInfoList');
                              if (userInfoList!.isNotEmpty) {
                                return Column(
                                  children: [
                                    for (var userInfo in userInfoList)
                                      GestureDetector(
                                        onTap: () {
                                          openButtonWidget();
                                        },
                                        child: UserBox(
                                            username: userInfo.userName,
                                            team: userInfo.teamCode,
                                            role: userInfo.positionName,
                                            userstatus: userInfo.statusId),
                                      )
                                  ],
                                );
                              } else {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text('검색된 유저가 없습니다.'),
                                  ),
                                );
                              }
                            } else {
                              return const Center(
                                child: Text('검색어를 입력하세요'),
                              );
                            }
                          }),
                    ],
                  ),
                ),
              ),
              isOpenedButtonWidget
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: FloatingActionButton.extended(
                          backgroundColor: const Color(0xFF3DB887),
                          foregroundColor: Colors.white,
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_on),
                          label: const Text(
                            '호출',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ));
  }
}