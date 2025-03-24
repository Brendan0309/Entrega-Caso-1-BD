# Entrega-Caso-1-BD

Nombre de los integrantes:

-Julián Castro Barrantes

-Brendan Ramírez Campos


Diseño Actualizado de la base de datos: [AvanceFinal.pdf](./AvanceFinal.pdf)<br>
Script de Creación de la base de datos:<br>
	- ARCHIVO .MD: [ScriptCreacion.md](./ScriptCreacion.md)<br>
 	- ARCHIVO .SQL: [ScriptCreacion.sql](./ScriptCreacion.sql)<br>

Script para Llenar la base de datos:<br>
	-ARCHIVO .MD: [ScriptLlenado.md](./ScriptLlenado.md)<br>
	-ARCHIVO .SQL: [ScriptLlenado.md](./ScriptLlenado.sql)<br>


**Lista de Entidades** (Actualizada)
- Personas
- Usuarios
	- Contraseña
	- Habilitado
	- Compañías (Opcional)
- Información de contacto del usuario 
	- Tipo (correo, teléfono, fax)
	- Última actualización
- Países
- States
	- Código Postal
	- Posición geográfica
- Ciudades
- Tipo de usuario de la conexión (usuario, compañía)
- Módulos
	- nombre
	- lenguaje
- Suscripciones
	- Precio
	- Detalles
	- Características
		- Nombre
		- Límites
- Pagos registrados
- Fecha de Vencimiento del pago
- Nombre
- Fecha de expiración
- Monto
- Habilitado
- Moneda utilizada
- Bancos 
- Configurar cuenta Bancaria de Origen
- Nombre del Banco
- Número de Cuenta
- Logo
- Dirección
- Tipo servicio
- Servicios de Pago
- Vinculación de APIs (PayPal, Apple Pay)
	- Tokens (De acceso y de autenticación)
	- Tiempo de expiración
	- Código de Status
- Métodos de Pago
- Pagos
	- Medio
	- Monto
	- Moneda Utilizada
	- Ritmo de Conversión
	- Fecha
- Tipo de autenticación (Push o SMS)
- Confirmación (Confirmada/Rechazada)
- Notificar fallo
- Recordatorios pagos
	- Notificaciones
		- Titulo
		- Descripción
		- Status
		- destinatario
		- remitente (usuarios ficticios del sistema)
		- Fecha de envío		
- Recordatorios adicionales
- SMS autorizaciones de pagos 
- Transacción
	- Fecha
	- Fecha de posteo
	- Fondos virtuales
- Tipo de Transacción 
- Estado (Exitosa/Fallida)
- Detalle
- Monto
- Fechas (tanto para pagos como para historial, cobros y notificaciones)
- Cantidad de Pagos
- Cantidad de Transferencias.
- Confirmación pagos	
- Compañías
- Roles (compañía, usuarios)
- Permisos
- Subscripciones
- Moneda
- Símbolos
- Alias
- Nombre
- Símbolo
- Conversiones
	- Fecha
	- Es la actual
	- Monto de cambio
- Historial (captura detalles del servicio entre otros datos además de la frecuencia y algún tipo de preferencia)
- Logs
	- Tipo
	- Referencias 1 y 2
	- Valores de la referencia
	- Fuente
	- Severidad
- Media (fotos, audios, pdf, pdf de los transcripts)
	- Tipo
		- Nombre
		- Reproductor
	- Archivos
		- URL (para fotos y videos)
		- Borrado
		- Usuario perteneciente
		- Fecha de generación
- Horarios
	- Nombre
	- Recurrencia
	- Posibles repeticiones (cada lunes, cada semana, cada mes)
	- Posible siguiente ejecución
- Idioma
- Traduccion
- Slangs
- Nombre
- ScreenRecorder
- ScreenEvents
- AudioRecorder
- Audio Transcripts 
- AudioEvents
- SyncScreenAudio
- CuePoints
- Transcriptions
- Transcription Task
- IA
- IA Conection
- IA Responses
- IA ProcessingLogs
- Transcript Files
- Recording Files
- User Preferenses

**Documetación General del Proyecto**
Documentación sobre entidades principales
-> Las APIs
Para los campos en la tabla de APIs se tomó como referencia APIs como la de PayPal y Stripe.

Los links de referencia utilizados son:
https://developer.paypal.com/api/rest/
![image](https://github.com/user-attachments/assets/3bd88132-4f0d-41f7-8410-3f0d04611cb7)
![image](https://github.com/user-attachments/assets/26b75785-167c-4bec-82d3-303d1100c220)
https://docs.stripe.com/api
![image](https://github.com/user-attachments/assets/6c009655-2a94-44fd-93a8-c8b670809fa5)

De ahí se tomaron campos como el código de respuesta y los tokens necesarios para el correcto funcionamiento de las APIs.

Campos obtenidos:
-	Los tokens
-	El código de 3 dígitos de status
-	Tiempo de expiración
-	El nonce
-	etc

-> Modelo para las Compañías
Para las compañías se tomó la idea de utilizarlas bajo la suposición de que las empresas tienen convenios con la aplicación donde le compran paquetes especiales a sus empleados para que les facilite sus pagos cotidianos.
Por este motivo a las compañías se les dio un énfasis hacia el área de las subscripciones y los pagos.

En las compañías se guarda el nombre, se relacionan con las direcciones y su fecha de creación. 

Además, en su relación con los usuarios también se guarda su rol dentro de las compañías. Mientras que en las tablas de roles se guardan los roles dentro de la cuenta (owner, partner, client, admin, system, etc) en el rol de la compañía se guarda la profesión. Esta profesión se guarda con el propósito de hacer analíticas y estadísticas para saber la profesión general de los clientes y poder mejorar los convenios y otros aspectos de la aplicación.

-> Audios
La implementación por voz de la aplicación se maneja mediante transcripciones de los audios que son guardados en la nube. A partir de la interpretación de la transcripción se interpreta el comando.

-> Algunos otros puntos de referencia:
Calendario de Google (modelado de horarios y agendas)
![image](https://github.com/user-attachments/assets/c3c8f4a9-6368-4946-a624-a82429f01b4a)

Aplicaciones webs basados en subscripciones tales como Disney+, HBO Max, Netflix, Spotify, etc. (modelado de las subscripciones y los features)
![image](https://github.com/user-attachments/assets/10c7d4ea-da7f-4b91-8ac4-ee1cf70dc733)

Ejemplos que se usaron como ayuda 
![image](https://github.com/user-attachments/assets/7b634dd2-e7c5-4a79-8f77-09b93e1459e1)

![image](https://github.com/user-attachments/assets/1b0e5935-367c-4331-ba72-a440885823fc)

![image](https://github.com/user-attachments/assets/3b6126e4-777a-4174-9ef4-64a5c5a82218)

-> Otros modelos
Las principales decisiones de diseño para todos los modelos fueron tomadas en base a los modelos vistos en clase y la asistencia del profesor.

Diagrama de la base de datos:

[AvanceFinal.pdf](https://github.com/user-attachments/files/19258716/AvanceFinal.pdf)
