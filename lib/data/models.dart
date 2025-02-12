class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String rol; // Administrador, Ingeniero, Operario

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });
}

class Proyecto {
  final String id;
  final String nombre;
  final String descripcion;
  final String estado; // En progreso, Completado
  final List<Tarea> tareas;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.estado,
    required this.tareas,
  });
}

class Tarea {
  final String id;
  final String nombre;
  final String encargadoId;
  final DateTime fechaAsignacion;
  final DateTime fechaVencimiento;
  final String prioridad;
  final String estado; // Por hacer, En progreso, Completada
  final String comentarios;

  Tarea({
    required this.id,
    required this.nombre,
    required this.encargadoId,
    required this.fechaAsignacion,
    required this.fechaVencimiento,
    required this.prioridad,
    required this.estado,
    required this.comentarios,
  });
}
