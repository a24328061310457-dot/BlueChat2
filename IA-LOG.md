```markdown
# IA-LOG - Proyecto BlueChat

Este documento registra las interacciones más relevantes con la IA (ChatGPT) durante el desarrollo de la aplicación.

---

### Prompt 1
**Pregunta:**  
¿Cómo puedo construir una interfaz de chat en Flutter?

**Respuesta (resumida):**  
La IA explicó cómo usar `ListView.builder` para mostrar mensajes y un `TextField` con un `IconButton` para enviar.

**Aprendizaje:**  
Con esta guía construimos la interfaz principal del chat, aplicando estilos y manejo de estado con listas dinámicas.

---

### Prompt 2
**Pregunta:**  
¿Qué permisos necesito para usar Bluetooth en Android 12 o superior?

**Respuesta (resumida):**  
La IA indicó que debíamos agregar los permisos `BLUETOOTH_CONNECT`, `BLUETOOTH_SCAN` y `ACCESS_FINE_LOCATION` al AndroidManifest.

**Aprendizaje:**  
Pudimos hacer que la app detectara y conectara dispositivos sin errores de permisos.

---

### Prompt 3
**Pregunta:**  
¿Cómo establezco una conexión Bluetooth entre dos dispositivos con flutter_bluetooth_serial?

**Respuesta (resumida):**  
Nos mostró el uso de `BluetoothConnection.toAddress()` para conectar y `connection.input.listen()` para recibir datos.

**Aprendizaje:**  
Implementamos correctamente la conexión y envío de mensajes entre los dos teléfonos.

---

### Prompt 4
**Pregunta:**  
¿Cómo puedo mostrar la hora en que se envía cada mensaje?

**Respuesta (resumida):**  
Recomendó usar el paquete `intl` y `DateFormat('hh:mm a')`.

**Aprendizaje:**  
Agregamos el formato de hora a cada mensaje en la UI, mejorando la presentación del chat.

---

### Prompt 5
**Pregunta:**  
¿Cómo diferencio visualmente mis mensajes de los recibidos?

**Respuesta (resumida):**  
La IA sugirió usar `Align` y `Container` con colores distintos dependiendo de quién envía el mensaje.

**Aprendizaje:**  
Se aplicó un diseño más intuitivo, con burbujas verdes para el usuario y grises para los mensajes recibidos.

---

## Conclusión
El uso de la IA permitió:
- Resolver errores de permisos Bluetooth.
- Aprender sobre la estructura de una app Flutter.
- Implementar la lógica de comunicación en tiempo real.
- Mejorar la experiencia visual y funcional del chat.
