import 'package:flutter/material.dart';

enum NotificationCategory {
  dailyAstrology,
  offer,
  survey,
  newLaunch,
  missedActivity,
  spiritualCheckIn,
  criticalAlert,
  remedy,
  aiIntuition,
  specialOccasion,
  rewards,
  emotional,
  payment,
  appUpdate,
}

class NotificationItem {
  final String id;
  final NotificationCategory category;
  final String title;
  final String body;
  final DateTime time;
  final bool isRead;
  final IconData icon;
  final Color color;

  const NotificationItem({
    required this.id,
    required this.category,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
  });

  String get categoryLabel {
    switch (category) {
      case NotificationCategory.dailyAstrology:
        return 'Daily Astrology';
      case NotificationCategory.offer:
        return 'BrahmaBazaar Offer';
      case NotificationCategory.survey:
        return 'Feedback';
      case NotificationCategory.newLaunch:
        return 'New Launch';
      case NotificationCategory.missedActivity:
        return 'Gentle Reminder';
      case NotificationCategory.spiritualCheckIn:
        return 'Spiritual Check-In';
      case NotificationCategory.criticalAlert:
        return 'Important Alert';
      case NotificationCategory.remedy:
        return 'Remedy Alert';
      case NotificationCategory.aiIntuition:
        return 'AI Intuition';
      case NotificationCategory.specialOccasion:
        return 'Special Occasion';
      case NotificationCategory.rewards:
        return 'Brahma Rewards';
      case NotificationCategory.emotional:
        return 'Companion';
      case NotificationCategory.payment:
        return 'Payment';
      case NotificationCategory.appUpdate:
        return 'App Update';
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
