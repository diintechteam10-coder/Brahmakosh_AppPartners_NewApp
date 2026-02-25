import 'package:flutter/material.dart';
import 'package:brahmakoshpartners/features/notifications/models/notification_model.dart';

/// Dummy notification data covering all 14 categories.
/// Spread across Today, This Week, and Earlier timeframes.
final List<NotificationItem> dummyNotifications = [
  // ──────── TODAY ────────

  // 🔮 Daily Astrology
  NotificationItem(
    id: '1',
    category: NotificationCategory.dailyAstrology,
    title: 'Daily Numerology Insight',
    body:
        'Your ruling number today is 7 — a day of deep reflection, wisdom, and spiritual clarity. Trust your inner voice.',
    time: DateTime.now().subtract(const Duration(minutes: 12)),
    isRead: false,
    icon: Icons.auto_awesome,
    color: const Color(0xFF7C3AED),
  ),
  NotificationItem(
    id: '2',
    category: NotificationCategory.dailyAstrology,
    title: 'Panchang Summary',
    body:
        'Tithi: Shukla Navami | Nakshatra: Pushya | Yoga: Siddhi — An auspicious day for new beginnings.',
    time: DateTime.now().subtract(const Duration(minutes: 35)),
    isRead: false,
    icon: Icons.wb_sunny_rounded,
    color: const Color(0xFFDE8E0C),
  ),
  NotificationItem(
    id: '3',
    category: NotificationCategory.dailyAstrology,
    title: 'Lucky Color for Today',
    body:
        'Your lucky color today is Emerald Green 💚 — Wear it to attract positive energy and harmony.',
    time: DateTime.now().subtract(const Duration(hours: 1)),
    isRead: true,
    icon: Icons.palette_rounded,
    color: const Color(0xFF2CB780),
  ),

  // 🟣 Spiritual Check-In
  NotificationItem(
    id: '4',
    category: NotificationCategory.spiritualCheckIn,
    title: 'Daily Check-In Reminder',
    body:
        'Take a moment to check in with yourself today. How is your energy feeling? 🧘',
    time: DateTime.now().subtract(const Duration(hours: 2)),
    isRead: false,
    icon: Icons.self_improvement,
    color: const Color(0xFF9333EA),
  ),

  // 🤖 AI Intuition
  NotificationItem(
    id: '5',
    category: NotificationCategory.aiIntuition,
    title: 'New Insight Based on Your Pattern',
    body:
        'Based on your recent check-ins, we noticed a rising trend in your mental clarity. Keep nurturing it! ✨',
    time: DateTime.now().subtract(const Duration(hours: 3)),
    isRead: false,
    icon: Icons.psychology_alt,
    color: const Color(0xFF06B6D4),
  ),

  // 💛 Emotional / Companion
  NotificationItem(
    id: '6',
    category: NotificationCategory.emotional,
    title: 'You are not alone.',
    body:
        'The universe is always supporting you, even in moments of silence. Take a deep breath and feel the connection. 🙏',
    time: DateTime.now().subtract(const Duration(hours: 4)),
    isRead: true,
    icon: Icons.favorite_rounded,
    color: const Color(0xFFF59E0B),
  ),

  // ──────── THIS WEEK ────────

  // 🟡 Offer (BrahmaBazaar)
  NotificationItem(
    id: '7',
    category: NotificationCategory.offer,
    title: 'Festival-Based Offer 🎉',
    body:
        'Maha Shivaratri Special — Get 30% off on all spiritual products in BrahmaBazaar. Offer valid till Sunday.',
    time: DateTime.now().subtract(const Duration(days: 1)),
    isRead: false,
    icon: Icons.local_offer_rounded,
    color: const Color(0xFFEAB308),
  ),

  // 🪔 Remedy Alert
  NotificationItem(
    id: '8',
    category: NotificationCategory.remedy,
    title: "Today's Suggested Remedy",
    body:
        'Light a ghee diya near Tulsi plant this evening for peace and harmony in the household. 🪔',
    time: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    isRead: true,
    icon: Icons.local_fire_department_rounded,
    color: const Color(0xFFEF4444),
  ),

  // 🟢 Survey / Feedback
  NotificationItem(
    id: '9',
    category: NotificationCategory.survey,
    title: 'Session Feedback Request',
    body:
        'How was your recent consultation with Pandit Sharma Ji? Your feedback helps us serve you better. ⭐',
    time: DateTime.now().subtract(const Duration(days: 2)),
    isRead: false,
    icon: Icons.rate_review_rounded,
    color: const Color(0xFF22C55E),
  ),

  // 🔵 New Launch
  NotificationItem(
    id: '10',
    category: NotificationCategory.newLaunch,
    title: 'New Feature Launch 🚀',
    body:
        'Introducing Brahmakosh AI Intuition — Get personalized spiritual insights powered by your journey data.',
    time: DateTime.now().subtract(const Duration(days: 2, hours: 8)),
    isRead: false,
    icon: Icons.rocket_launch_rounded,
    color: const Color(0xFF3B82F6),
  ),

  // 🟠 Missed Activity
  NotificationItem(
    id: '11',
    category: NotificationCategory.missedActivity,
    title: "We Miss You 🌸",
    body:
        "It's been a while since your last visit. Your spiritual journey is waiting — come back and continue growing.",
    time: DateTime.now().subtract(const Duration(days: 3)),
    isRead: true,
    icon: Icons.emoji_nature_rounded,
    color: const Color(0xFFF97316),
  ),

  // 🟣 Spiritual Check-In — Streak
  NotificationItem(
    id: '12',
    category: NotificationCategory.spiritualCheckIn,
    title: 'Streak Milestone — 21 Days! 🔥',
    body:
        'Amazing! You have completed 21 consecutive days of spiritual check-ins. Your energy alignment is at its peak.',
    time: DateTime.now().subtract(const Duration(days: 3, hours: 6)),
    isRead: true,
    icon: Icons.local_fire_department_rounded,
    color: const Color(0xFF9333EA),
  ),

  // 🎁 Rewards
  NotificationItem(
    id: '13',
    category: NotificationCategory.rewards,
    title: 'Brahma Rewards Earned 🎁',
    body:
        'You earned 50 Brahma Points for completing your daily check-in streak. Redeem them in BrahmaBazaar!',
    time: DateTime.now().subtract(const Duration(days: 4)),
    isRead: false,
    icon: Icons.card_giftcard_rounded,
    color: const Color(0xFFA855F7),
  ),

  // ──────── EARLIER ────────

  // 🔴 Critical Alert
  NotificationItem(
    id: '14',
    category: NotificationCategory.criticalAlert,
    title: 'Major Planetary Transit',
    body:
        'Saturn is transitioning into Pisces — A significant period of transformation. Stay grounded and embrace the change calmly.',
    time: DateTime.now().subtract(const Duration(days: 8)),
    isRead: true,
    icon: Icons.warning_amber_rounded,
    color: const Color(0xFFDC2626),
  ),

  // 🌸 Special Occasion
  NotificationItem(
    id: '15',
    category: NotificationCategory.specialOccasion,
    title: 'Birthday Spiritual Message 🎂',
    body:
        'Happy Birthday! May this new year of your life bring abundant blessings, wisdom, and inner peace. 🙏✨',
    time: DateTime.now().subtract(const Duration(days: 10)),
    isRead: true,
    icon: Icons.cake_rounded,
    color: const Color(0xFFEC4899),
  ),

  // 💳 Payment
  NotificationItem(
    id: '16',
    category: NotificationCategory.payment,
    title: 'Transaction Confirmation',
    body:
        'Payment of ₹499 for your consultation session with Acharya Verma has been successfully processed.',
    time: DateTime.now().subtract(const Duration(days: 12)),
    isRead: true,
    icon: Icons.receipt_long_rounded,
    color: const Color(0xFF8B5CF6),
  ),

  // 🔐 App Update
  NotificationItem(
    id: '17',
    category: NotificationCategory.appUpdate,
    title: 'New Version Available',
    body:
        'Brahmakosh v3.2 is available with performance improvements and new spiritual content. Update now!',
    time: DateTime.now().subtract(const Duration(days: 14)),
    isRead: true,
    icon: Icons.system_update_rounded,
    color: const Color(0xFF64748B),
  ),

  // 🤖 AI Intuition — Reflection
  NotificationItem(
    id: '18',
    category: NotificationCategory.aiIntuition,
    title: 'Reflection Prompt',
    body:
        '"What intention are you setting for this week?" — Take a moment to write it down and revisit at the end of the week.',
    time: DateTime.now().subtract(const Duration(days: 15)),
    isRead: true,
    icon: Icons.lightbulb_rounded,
    color: const Color(0xFF06B6D4),
  ),

  // 🪔 Remedy Completion
  NotificationItem(
    id: '19',
    category: NotificationCategory.remedy,
    title: 'Remedy Cycle Complete ✅',
    body:
        'You have successfully completed the 7-day Surya Namaskar remedy cycle. Well done on your dedication!',
    time: DateTime.now().subtract(const Duration(days: 18)),
    isRead: true,
    icon: Icons.check_circle_rounded,
    color: const Color(0xFFEF4444),
  ),

  // 💛 Emotional — Meditation
  NotificationItem(
    id: '20',
    category: NotificationCategory.emotional,
    title: 'Meditation Suggestion 🧘',
    body:
        'Try a 10-minute guided breathing meditation tonight. It can help calm the mind and prepare you for deep, restful sleep.',
    time: DateTime.now().subtract(const Duration(days: 20)),
    isRead: true,
    icon: Icons.spa_rounded,
    color: const Color(0xFFF59E0B),
  ),

  // Daily Astrology — Do's & Don'ts
  NotificationItem(
    id: '21',
    category: NotificationCategory.dailyAstrology,
    title: "Do's & Don'ts for Today",
    body:
        "Do: Begin your morning with gratitude. Don't: Avoid starting new financial decisions after sunset. Stay positive and aligned.",
    time: DateTime.now().subtract(const Duration(days: 22)),
    isRead: true,
    icon: Icons.checklist_rounded,
    color: const Color(0xFF7C3AED),
  ),

  // 🎁 Seva Contribution
  NotificationItem(
    id: '22',
    category: NotificationCategory.rewards,
    title: 'Seva Contribution Update',
    body:
        'Your Seva contribution has benefited 12 families this month. Thank you for spreading kindness. 🙏',
    time: DateTime.now().subtract(const Duration(days: 25)),
    isRead: true,
    icon: Icons.volunteer_activism_rounded,
    color: const Color(0xFFA855F7),
  ),
];
