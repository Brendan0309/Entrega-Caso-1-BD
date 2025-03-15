# Entrega-Caso-1-BD

Nombre de los integrantes:
Julián Castro Barrantes
Brendan Ramírez Campos

**Lista de Entidades**
- Personas
- Usuarios
	- Contraseña
	- Habilitado
	- Compañías (Opcional)
- Información de contacto del usuario 
	- Tipo (correo, teléfono, etc)
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
- Vinculación de APIs (PayPal, Apple Pay, etc)
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
- Fechas (pagos, historial, cobros, notificaciones, etc)
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
- Media (fotos, audios, pdf, etc)
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
	- Posibles repeticiones (cada lunes, cada semana, etc)
	- Posible siguiente ejecución
- Idioma
- Traduccion
- Slangs
- Nombre

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

Ejemplos que se usaron como ayuda 
![image](https://github.com/user-attachments/assets/7b634dd2-e7c5-4a79-8f77-09b93e1459e1)

![image](https://github.com/user-attachments/assets/1b0e5935-367c-4331-ba72-a440885823fc)

![image](https://github.com/user-attachments/assets/3b6126e4-777a-4174-9ef4-64a5c5a82218)

Diagrama de la base de datos
[AvanceFinal.pdf](https://github.com/user-attachments/files/19257779/AvanceFinal.pdf)
