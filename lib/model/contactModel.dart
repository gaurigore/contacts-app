class Contact {
  int? id;
  String name;
  String email;
  String phone;

  Contact(
      {this.id, required this.name, required this.email, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
    );
  }

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, email: $email, phone: $phone}';
  }
}
