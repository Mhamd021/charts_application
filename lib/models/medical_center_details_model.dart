class MedicalCenterDetailsModel {
  int? medicalCentersId;
  String? medicalCentersName;
  String? medicalCentersPhoneNumber;
  String? medicalCentersEmail;
  String? category;
  String? medicalCentersDescription;
  String? buildingName;
  int? floorNumber;
  String? unitNumber;
  String? managerUserId;
  String? facebookUrl;
  String? instagramUrl;
  String? twitterUrl;
  String? whatsAppNumber;
  double? latitude;
  double? longitude;
  String? logoImageUrl;
  String? coverImageUrl;
  bool? isOnlineBookingAvailable;
  bool? isActive;
  List<Doctor>? doctors;
  List<WorkingHour>? workingHours; 

  MedicalCenterDetailsModel({
    this.medicalCentersId,
    this.medicalCentersName,
    this.medicalCentersPhoneNumber,
    this.medicalCentersEmail,
    this.category,
    this.medicalCentersDescription,
    this.buildingName,
    this.floorNumber,
    this.unitNumber,
    this.managerUserId,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.whatsAppNumber,
    this.latitude,
    this.longitude,
    this.logoImageUrl,
    this.coverImageUrl,
    this.isOnlineBookingAvailable,
    this.isActive,
    this.doctors,
    this.workingHours,
  });

  factory MedicalCenterDetailsModel.fromJson(Map<String, dynamic> json) {
    return MedicalCenterDetailsModel(
      medicalCentersId: json['medicalCentersId'],
      medicalCentersName: json['medicalCentersName'],
      medicalCentersPhoneNumber: json['medicalCentersPhoneNumber'],
      medicalCentersEmail: json['medicalCentersEmail'],
      category: json['category'],
      medicalCentersDescription: json['medicalCentersDescription'],
      buildingName: json['buildingName'],
      floorNumber: json['floorNumber'],
      unitNumber: json['unitNumber'],
      managerUserId: json['managerUserId'],
      facebookUrl: json['facebookUrl'],
      instagramUrl: json['instagramUrl'],
      twitterUrl: json['twitterUrl'],
      whatsAppNumber: json['whatsAppNumber'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      logoImageUrl: json['logoImageUrl'],
      coverImageUrl: json['coverImageUrl'],
      isOnlineBookingAvailable: json['isOnlineBookingAvailable'],
      isActive: json['isActive'],
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((doctor) => Doctor.fromJson(doctor))
          .toList(),
      workingHours: (json['workingHours'] as List<dynamic>?)
          ?.map((hour) => WorkingHour.fromJson(hour))
          .toList(),
    );
  }
}

class WorkingHour {
  int? id;
  int? dayOfWeek;
  String? openingTime;
  String? closingTime;
  int? medicalCenterId;

  WorkingHour({
    this.id,
    this.dayOfWeek,
    this.openingTime,
    this.closingTime,
    this.medicalCenterId,
  });

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    return WorkingHour(
      id: json['id'],
      dayOfWeek: json['dayOfWeek'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      medicalCenterId: json['medicalCenterId'],
    );
  }
}


class Doctor {
  int? id;
  String? fullName;
  String? profileImageUrl;
  String? specialty;
  List<String>? spokenLanguages;
  String? bio;
  int? yearsOfExperience;
  String? email;
  bool? isAvailableForOnlineBooking;

  Doctor({
    this.id,
    this.fullName,
    this.profileImageUrl,
    this.specialty,
    this.spokenLanguages,
    this.bio,
    this.yearsOfExperience,
    this.email,
    this.isAvailableForOnlineBooking,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      fullName: json['fullName'],
      profileImageUrl: json['profileImageUrl'],
      specialty: json['specialty'],
      spokenLanguages: List<String>.from(json['spokenLanguages'] ?? []),
      bio: json['bio'],
      yearsOfExperience: json['yearsOfExperience'],
      email: json['email'],
      isAvailableForOnlineBooking: json['isAvailableForOnlineBooking'],
    );
  }
}
