CREATE TABLE IF NOT EXISTS schedule (
    id BIGSERIAL PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, --Fecha de creación del registro
    hora TIMESTAMP NOT NULL, --Hora exacta de la cita
    cliente VARCHAR(100) NOT NULL, --Nombre del cliente
    comentarios TEXT DEFAULT NULL, --Comentarios adicionales
    responsable VARCHAR(100) NOT NULL, -- Persona responsable de la cita
    departamento VARCHAR(100), --Departamento asociado (e.g., Ventas, Soporte, Administración)
    fecha_programada DATE NOT NULL, --Fecha programada para la cita
    hora_programada TIME NOT NULL, --Hora programada para la cita
    estado VARCHAR(50) NOT NULL, --Estado de la cita (e.g., Agendado, Reagendado, Sin Llamar ,Cancelado, Completado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Fecha de creación del registro
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --Fecha de última actualización del registro
    deleted_at TIMESTAMP NULL --Fecha de eliminación del registro
);

--- Trigger to update the updated_at column on row update
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$ -- Función para actualizar la columna updated_at
BEGIN 
    NEW.updated_at = CURRENT_TIMESTAMP; -- Actualiza la columna updated_at con la fecha y hora actuales
    RETURN NEW; -- Devuelve la nueva fila con la columna actualizada
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at -- Trigger para actualizar updated_at antes de cada actualización
BEFORE UPDATE ON schedule -- Se ejecuta antes de cada actualización en la tabla schedule
FOR EACH ROW -- Por cada fila afectada
EXECUTE FUNCTION update_updated_at_column(); -- Ejecuta la función definida anteriormente


CREATE TABLE IF NOT EXISTS schedule_history (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL REFERENCES schedule(id) ON DELETE CASCADE, --Referencia a la tabla schedule
    comentario TEXT DEFAULT NULL, --Comentarios adicionales
    accion VARCHAR(50) NOT NULL, --Tipo de acción realizada (e.g., Creación, Actualización, Comentario, Eliminación)
    usuario VARCHAR(100) NOT NULL, --Persona que realizó el cambio
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP --Fecha y hora del cambio
);