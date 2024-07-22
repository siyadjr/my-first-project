import 'package:flutter/material.dart';
import 'package:manager_app/db/model/event_model.dart';
import 'package:manager_app/db/model/functins/easy_access/colors.dart';

class AllEventContainers extends StatelessWidget {
  const AllEventContainers({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 100,
      margin: const EdgeInsets.only(right: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.getColor(AppColor.maincolor),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Text(
                event.title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.getColor(AppColor.secondaryColor),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
