
// 지도에 표시될 시설의 정보를 담는 데이터 모델  ex) 보건소 , 구청

class Facility {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type;  // '보건소', '구청' 등
  final String operatingHours;
  final bool isOpen;

  Facility({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.operatingHours,
    this.isOpen = true,
  });
  
}



