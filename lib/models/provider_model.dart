class Provider {
  final int? id;
  final String name;
  final String lastName;
  final String email;
  final String? state;

  Provider({
    this.id,
    required this.name,
    required this.lastName,
    required this.email,
    this.state = "Activo"
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      id: json['provider_id'],
      name: json['provider_name'],
      lastName: json['provider_last_name'],
      email: json['provider_mail'],
      state: json['provider_state'] ?? "Activo"
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['provider_id'] = id;
    }
    data['provider_name'] = name;
    data['provider_last_name'] = lastName;
    data['provider_mail'] = email;
    if (state != null) {
      data['provider_state'] = state;
    }
    return data;
  }

  // For adding a new provider (without ID)
  Map<String, dynamic> toAddJson() {
    return {
      'provider_name': name,
      'provider_last_name': lastName,
      'provider_mail': email,
      'provider_state': 'Activo'
    };
  }

  // For deleting a provider (only ID)
  Map<String, dynamic> toDeleteJson() {
    return {
      'provider_id': id
    };
  }
}
