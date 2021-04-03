class NotificationModel {
  int userId;
  int notificationsSleep;
  int notificationsExercise;
  int notificationsMealDiary;

  NotificationModel();

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'notificationsSleep': notificationsSleep,
    'notificationsExercise': notificationsExercise,
    'notificationsMealDiary': notificationsMealDiary
  };

  NotificationModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        notificationsSleep = json['notificationsSleep'],
        notificationsExercise = json['notificationsExercise'],
        notificationsMealDiary = json['notificationsMealDiary'];
}