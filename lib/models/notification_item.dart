class NotificationItem {
  final String id;
  final String title;
  final String time;
  bool read;
  final String icon;
  final String iconBg;

  NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    this.read = false,
    required this.icon,
    required this.iconBg,
  });

  static List<NotificationItem> getDefaultNotifications() {
    return [
      NotificationItem(id: 'n1', title: 'Está na hora de regar sua Ficus Lyrata', time: 'Agora', read: false, icon: 'droplet', iconBg: 'blue'),
      NotificationItem(id: 'n2', title: 'Sua Calathea precisa de mais umidade', time: 'há 10 min', read: false, icon: 'cloud', iconBg: 'warn'),
      NotificationItem(id: 'n3', title: 'Você completou sua rotina de ontem!', time: 'há 5 h', read: true, icon: 'check', iconBg: 'green'),
    ];
  }
}
