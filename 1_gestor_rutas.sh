#!/bin/bash

CONFIG_FILE="$HOME/ExamenFinal/config/rutas_backup.conf"

# Aseguramos que el archivo de configuración exista, sino se crea uno de cero
touch "$CONFIG_FILE"

# FUnción para agregar la ruta
agregar_ruta() {
echo ""
read -p "Ingresar la ruta del directorio a respaldar (ej. $HOME/ExamenFInal/datos_rrhh): " nueva_ruta

# Validamos si el directorio existe en el siste,a
if [ ! -d "$nueva_ruta" ]; then
echo "¡¡¡ERROR!!! El directorio '$nueva_ruta' no existe. Operación cancelada."
return
fi

# Validamos si la ruta ya se ingresó anteriormente para evitar duplicidad
if grep -q "^$nueva_ruta$" "$CONFIG_FILE"; then
echo "¡¡¡ADVERTENCIA!!! Esa ruta ya está en la lista de backups."
else
echo "$nueva_ruta" >> "$CONFIG_FILE"
echo "¡¡¡ÉXITO!!! Ruta agregada correctamente."
fi
}

# FUnción para listar las rutas agregadas
listar_rutas() {
echo ""
echo "--- Directorios configurados para Backup ---"
if [ ! -s "$CONFIG_FILE" ]; then
echo "(La lista está vacía)"
else
# Mostramos el contenido enumerado
cat -n "$CONFIG_FILE"
fi
echo "------------------------------"
}

# Función para eliminar algún archivo que agregamos por error
limpiar_rutas() {
> "$CONFIG_FILE"
echo ""
echo "¡¡¡ÉXITO!!! La lista de rutas ha sido limpiada."
}

# Bucle del menú principal 
while true; do
echo ""
echo "------------------------------"
echo "GESTOR DE COPIAS DE SEGURIDAD"
echo "------------------------------"
echo "1) Agregar nuevo directorio"
echo "2) Ver directorios configurados"
echo "3) Limpiar toda la lista"
echo "4) Salir"
read -p "Elige una opción [1-4]: " opcion

# Case para manejar las decisiones
case $opcion in
1) agregar_ruta ;;
2) listar_rutas ;;
3) limpiar_rutas ;;
4) echo "Saliendo del gestor..."; exit 0 ;;
*) echo "¡¡¡ERROR!!! Opción no válida." ;;
esac
done
