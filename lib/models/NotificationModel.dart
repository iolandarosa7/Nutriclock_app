class NotificationModel {
  int userId;
  bool notificationsSleep;
  bool notificationsExercise;
  bool notificationsMealDiary;
  bool notificationsBiometric;

  NotificationModel();

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'notificationsSleep': notificationsSleep,
    'notificationsExercise': notificationsExercise,
    'notificationsMealDiary': notificationsMealDiary,
    'notificationsBiometric': notificationsBiometric
  };

  NotificationModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        notificationsSleep = json['notificationsSleep'],
        notificationsExercise = json['notificationsExercise'],
        notificationsMealDiary = json['notificationsMealDiary'],
        notificationsBiometric = json['notificationsBiometric'];
}