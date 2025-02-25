import 'package:flutter/material.dart';
import 'package:llm_based_sat_app/theme/app_colours.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:llm_based_sat_app/firebase/firebase_helpers.dart';
import 'package:llm_based_sat_app/screens/auth/sign_in_page.dart';
import 'package:llm_based_sat_app/utils/user_provider.dart';
import 'package:provider/provider.dart';

class CourseCard extends StatefulWidget {
  final String imageUrl;
  final String courseType;
  final String courseTitle;
  final String duration;
  final double rating;
  final int ratingsCount;
  final void Function(BuildContext) onButtonPress;
  final bool isLocked; //True if the course is for premium users only

  const CourseCard({
    super.key,
    required this.imageUrl,
    required this.courseType,
    required this.courseTitle,
    required this.duration,
    required this.rating,
    required this.ratingsCount,
    required this.onButtonPress,
    required this.isLocked,
  });

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool _isLocked = true;
  var userProvider;
  late String uid;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context);
    uid = userProvider.getUid();
    _checkUserTier();
  }

  Future<void> _checkUserTier() async {
    String tier = await getTier(uid);
    if (tier == 'monthly' || tier == 'yearly') {
      setState(() {
        _isLocked = false;
      });
    } else {
      setState(() {
        _isLocked = widget.isLocked;
      });
    }
  }

  void _showPremiumMessage(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("This course is for premium users only."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLocked ? () => _showPremiumMessage(context) : () => widget.onButtonPress(context),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColours.brandBlueMinusFour,
              borderRadius: BorderRadius.circular(12),
              border: _isLocked ? Border.all(color: Colors.grey.shade400, width: 1.5) : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.courseType,
                        style: TextStyle(
                          fontSize: 14,
                          color: _isLocked ? Colors.grey.shade600 : AppColours.supportingYellowMain,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.courseTitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: _isLocked ? Colors.grey.shade700 : AppColours.brandBluePlusTwo,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Duration: ${widget.duration}',
                        style: TextStyle(
                          fontSize: 14,
                          color: _isLocked ? Colors.grey.shade600 : AppColours.supportingGreenMinusOne,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${widget.rating}',
                            style: TextStyle(
                              fontSize: 14,
                              color: _isLocked ? Colors.grey.shade500 : AppColours.brandBlueMinusOne,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.star, size: 16, color: _isLocked ? Colors.grey.shade400 : Colors.amber),
                          const SizedBox(width: 8),
                          Text(
                            '${widget.ratingsCount} ratings',
                            style: TextStyle(
                              fontSize: 14,
                              color: _isLocked ? Colors.grey.shade500 : AppColours.brandBlueMinusOne,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLocked)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, size: 40, color: Colors.white),
                      const SizedBox(height: 8),
                      const Text(
                        "Premium Course",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Upgrade to access",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}



