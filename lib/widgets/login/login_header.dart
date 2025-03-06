import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../theme/app_color.dart';

class LoginHeader extends StatelessWidget {
  final bool isBackButtonEnabled;
  final VoidCallback? onBackButtonPressed;

  const LoginHeader({
    Key? key,
    this.isBackButtonEnabled = true,
    this.onBackButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          color: AppColors.blueColor,
          child: Stack(
            children: [
              const Center(
                child: Text(
                  "DYSCHOOL",
                  style: TextStyle(
                    fontFamily: 'OpenDyslexic',
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isBackButtonEnabled)
                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: onBackButtonPressed ?? () {
                      Get.back();
                    },
                  ),
                ),
            ],
          ),
        ),
        SvgPicture.asset(
          'assets/svg/wave.svg',
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}