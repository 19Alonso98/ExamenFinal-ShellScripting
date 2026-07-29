#!/bin/bash

CONFIG_FILE="$HOME/ExamenFinal/config/rutas_backup.conf"
DESTINO="$HOME/ExamenFinal/backups"
LOG="$HOME/ExamenFinal/reportes/backup_crudo.log"
FECHA=$(date +"%Y%m%d_%H%M%S")

# Validamos que exista el archivo .conf
if [ ! -f "$CONFIG_FILE" ] || [ ! -s "$CONFIG_FILE" ]; then
echo "$(date) | ERROR | No se encontró el archivo de rutas o está vacío." >> $LOG
exit 1
fi

# Iniciamos la operación en el log
echo "--- INICIO DE TAREA DE BACKUP: $(date) ---" >> $LOG

# Leemos las líneas del archivo .conf y lo guardamos en un array con el nombre RUTAS
mapfile -t RUTAS < "$CONFIG_FILE"

# Bucle para cada elemento del array
for ruta in "${RUTAS[@]}"; do
# Extraemos solo el nombre de la carpeta final para guardarlo asi en el zip
nombre_base=$(basename "$ruta")
archivo_salida="$DESTINO/backup_${nombre_base}_${FECHA}.tar.gz"

# Validamos si la ruta aun existe antes de proceder a comprimirla
if [ -d "$ruta" ]; then
# Comprimimos la carpeta y en caso hay error, se manda a un archivo temporal
tar -czf "$archivo_salida" "$ruta" 2> /tmp/error_tar.tmp

# Verificamos si el comando tar terminó correctamente
if [ $? -eq 0 ]; then
echo "$(date) | EXITO | Respaldado: $ruta" >> $LOG
else
# Capturamos el error real de tar para el reporte
MOTIVO=$(cat /tmp/error_tar.tmp)
echo "$(date) | ERROR | Fallo al comprimir $ruta ($MOTIVO)" >> $LOG
fi
else
echo "$(date) | ERROR | La ruta $ruta fue eliminada o no es accesible." >> $LOG
fi
done
echo "--- FIN DE TAREA ---" >> $LOG
