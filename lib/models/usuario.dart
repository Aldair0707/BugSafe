class Usuario {
  final String nombre;
  final String correo;
  final String contrasena;
  final String telefono;
  final String direccion;

  Usuario({
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.telefono,
    required this.direccion,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombre: json['nombre'],
      correo: json['correo'],
      contrasena: json['contrasena'],
      telefono: json['telefono'],
      direccion: json['direccion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': correo,
      'contrasena': contrasena,
      'telefono': telefono,
      'direccion': direccion,
    };
  }
}
