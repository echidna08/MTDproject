// 지도에 표시될 시설의 정보를 담는 데이터 모델  ex) 보건소 , 구청

class Facility {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String type; // '보건소', '구청' 등
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

Facility geumjeongDistrictOffice = Facility(
  id: '1', // 고유 ID
  name: '금정구청',
  address: '부산광역시 금정구 중앙대로 1777', // 실제 주소
  latitude: 35.2429, // 금정구청 위도
  longitude: 129.0895, // 금정구청 경도
  type: '구청',
  operatingHours: '09:00 - 17:00', // 실제 운영 시간
  isOpen: true, // 현재 운영 여부
);
