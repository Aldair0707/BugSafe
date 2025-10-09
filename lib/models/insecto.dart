class Insecto {
  final String nombreComun;
  final String nombreCientifico;
  final String descripcionLarga;
  final String habitad;
  final String alimentacion;
  final String nivelRiesgo;

  Insecto({
    required this.nombreComun,
    required this.nombreCientifico,
    required this.descripcionLarga,
    required this.habitad,
    required this.alimentacion,
    required this.nivelRiesgo,
  });

  factory Insecto.fromJson(Map<String, dynamic> json) {
    return Insecto(
      nombreComun: json['nombreComun'],
      nombreCientifico: json['nombreCientifico'],
      descripcionLarga: json['descripcionLarga'],
      habitad: json['habitad'],
      alimentacion: json['alimentacion'],
      nivelRiesgo: json['nivelRiesgo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreComun': nombreComun,
      'nombreCientifico': nombreCientifico,
      'descripcionLarga': descripcionLarga,
      'habitad': habitad,
      'alimentacion': alimentacion,
      'nivelRiesgo': nivelRiesgo,
    };
  }
}
