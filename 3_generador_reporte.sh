#!/bin/bash

LOG="$HOME/ExamenFinal/reportes/backup_crudo.log"
REPORTE_FINAL="$HOME/ExamenFinal/reportes/reporte_diario.txt"

# Validamos si el archivo .log existe
if [! -f "$LOG"]; then
echo "Error: No existe el archivo de log."
exit 1
fi

# Usamos el awk para contabilizar ya sea (EXITO) o (ERROR) e imprimir un total
TOTAL_EXITOS=$(awk '/EXITO/ {count++} END {print count+0}' "$LOG")
TOTAL_ERRORES=$(awk '/ERROR/ {count++} END {print count+0}' "$LOG")

# Creamos el archivo reporte
echo ""
echo "------------------------------" >> $REPORTE_FINAL
echo "REPORTE DIARIO DE COPIAS DE SEGURIDAD" >> $REPORTE_FINAL
echo "" >> $REPORTE_FINAL
echo "Fecha de generación: $(date)" >> $REPORTE_FINAL
echo "" >> $REPORTE_FINAL
echo "Resumen Estadístico:" >> $REPORTE_FINAL
echo "-Copias exitosas: $TOTAL_EXITOS" >> $REPORTE_FINAL
echo "-Copias fallidas: $TOTAL_ERRORES" >> $REPORTE_FINAL
echo "" >> $REPORTE_FINAL

# SI hay al menos un error mostramos el detalle del mismo
if [ "$TOTAL_ERRORES" -gt 0 ]; then
echo "Detalle de Errores:" >> $REPORTE_FINAL
grep "ERROR" "$LOG" | sed 's/.*| ERROR | / -> /' >> $REPORTE_FINAL
else
echo "No se detectaron errores en la ejecución de hoy." >> $REPORTE_FINAL
fi

echo "------------------------------" >> $REPORTE_FINAL

# Mensaje final de término
echo "Reporte generado exitosamente en: $REPORTE_FINAL"

