class Log {
  final int id;
  final String mensaje;
  final DateTime fecha;
  final String tipo; // ejemplo: "INFO", "ERROR", "ADVERTENCIA"

  Log({
    required this.id,
    required this.mensaje,
    required this.fecha,
    required this.tipo,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      id: json['id'],
      mensaje: json['mensaje'],
      fecha: DateTime.parse(json['fecha']),
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mensaje': mensaje,
      'fecha': fecha.toIso8601String(),
      'tipo': tipo,
    };
  }
}
