const String contactsTable = "cached_contact";

class CachedContactsFields {
  static final List<String> values = [
    /// Add all fields
    id, fullName, phone
  ];
  static const String id = "_id";
  static const String fullName = "full_name";
  static const String phone = "phone";
}

class CachedContact {
  final int? id;
  final String fullName;
  final String phone;

  CachedContact({
    this.id,
    required this.fullName,
    required this.phone,
  });

  //TODO 1 Create toJSon and fromJson, and copyWith

  CachedContact copyWith({
    int? id,
    String? fullName,
    String? phone,
  }) =>
      CachedContact(
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        id: id ?? this.id,
      );

  static CachedContact fromJson(Map<String, Object?> json) => CachedContact(
        id: json[CachedContactsFields.id] as int?,
        phone: json[CachedContactsFields.phone] as String,
        fullName: json[CachedContactsFields.fullName] as String,
      );

  Map<String, Object?> toJson() => {
        CachedContactsFields.id: id,
        CachedContactsFields.phone: phone,
        CachedContactsFields.fullName: fullName,
      };

  @override
  String toString() => '''
        ID: $id 
        FULL NAME $fullName
        PHONE $phone
      ''';
}
