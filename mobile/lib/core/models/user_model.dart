import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String relationshipStatus;
  final String? coupleId;
  final String? partnerId;
  final String? partnerName;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.relationshipStatus,
    this.coupleId,
    this.partnerId,
    this.partnerName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? relationshipStatus,
    String? coupleId,
    String? partnerId,
    String? partnerName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      coupleId: coupleId ?? this.coupleId,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isConnected => relationshipStatus == 'connected';
  bool get isPending => relationshipStatus == 'pending';
  bool get hasPartner => partnerId != null;
}
