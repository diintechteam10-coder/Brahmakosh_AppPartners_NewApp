import 'dart:ui';

import 'package:brahmakoshpartners/core/const/assets.dart';
import 'package:brahmakoshpartners/core/const/colours.dart';
import 'package:brahmakoshpartners/features/call/pages/call_screen.dart';
import 'package:brahmakoshpartners/features/conversations/views/conversation_list_screen.dart';
import 'package:brahmakoshpartners/features/earning/pages/earning_screen.dart';
import 'package:brahmakoshpartners/features/home/pages/home_screen.dart';
import 'package:brahmakoshpartners/features/profile/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool _isDialogOpen = false;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      HomeScreen(
        isDialogOpen: _isDialogOpen,
        onDialogVisibilityChanged: (isOpen) {
          setState(() => _isDialogOpen = isOpen);
        },
      ),

      const ConversationScreen(),
      const CallScreen(),
      const EarningScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: Stack(
        children: [
          BottomNav(
            currentIndex: _currentIndex,
            onTap: _isDialogOpen
                ? (_) {} // block taps
                : (index) {
                    setState(() => _currentIndex = index);
                  },
          ),

          if (_isDialogOpen)
            Positioned.fill(
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(color: Colors.black.withOpacity(0.25)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colours.blue020617,
        border: Border(top: BorderSide(color: Colours.blue151E30, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 8.h),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colours.orangeFF9F07,
            unselectedItemColor: Colours.grey667993,
            selectedFontSize: 14.sp,
            unselectedFontSize: 12.sp,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icHome,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.grey667993,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icHome,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.orangeFF9F07,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Request',
              ),

              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icChat,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.grey667993,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icChat,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.orangeFF9F07,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Chat',
              ),

              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icCallIcon,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.grey667993,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icCallIcon,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.orangeFF9F07,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Call',
              ),

              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icEarning,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.grey667993,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icTraining,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.orangeFF9F07,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Earning',
              ),

              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  Assets.icProfile,
                  width: 22.w,
                  height: 22.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.grey667993,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  Assets.icProfile,
                  width: 24.w,
                  height: 24.w,
                  colorFilter: const ColorFilter.mode(
                    Colours.orangeFF9F07,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
