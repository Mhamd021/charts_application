class MedicalCentersModel {
  int? medicalCentersId;
  double? latitude;  
  double? longitude; 

  MedicalCentersModel({this.medicalCentersId, this.latitude, this.longitude});

  MedicalCentersModel.fromJson(Map<String, dynamic> json) {
    medicalCentersId = json['medicalCentersId'];
    latitude = json['latitude']?.toDouble(); 
    longitude = json['longitude']?.toDouble();
  }
}
