class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String image;
  final String date;
  final String name;
  final String title2;
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
    required this.date,
    required this.name,
    required this.title2,
  });

factory NotificationModel.fromJson(Map<String,dynamic> json){
  return NotificationModel(
      id: json['id']??'',
      title: json['title']??'',
      body: json['body']??'',
      image: json['image']??'',
      date: json['date']??'',
      name: json['name']??'',
      title2: json['title2']??'',
  );
}


Map<String,dynamic> toJson(){

  final Map<String,dynamic> jsonData=<String,dynamic>{};
    jsonData['id']=id;
    jsonData['title']=title;
    jsonData['body']=body;
    jsonData['image']=image;
    jsonData['date']=date;
    jsonData['name']=name;
    jsonData['title2']=title2;

  return jsonData;

}

}
