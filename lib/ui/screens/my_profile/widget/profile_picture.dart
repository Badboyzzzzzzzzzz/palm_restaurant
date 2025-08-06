import 'package:flutter/material.dart';
import 'package:palm_ecommerce_app/ui/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to avoid context issues during initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthenticationProvider>(context, listen: false).getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final profileImage = authProvider.user.data?.profileImage;
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: profileImage != null
                ? NetworkImage(profileImage)
                : const AssetImage("assets/palmlogo.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: Image.asset("assets/camera-outline.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
