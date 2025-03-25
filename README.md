# Entrega-Caso-1-BD

Nombre de los integrantes:

-Julián Castro Barrantes

-Brendan Ramírez Campos
<hr>

Diseño Actualizado de la base de datos: [AvanceFinal.pdf](./AvanceFinal.pdf)<br>
Script de Creación de la base de datos:<br>
	- ARCHIVO .MD: [ScriptCreacion.md](./ScriptCreacion.md)<br>
 	- ARCHIVO .SQL: [ScriptCreacion.sql](./ScriptCreacion.sql)<br><br>

Script para Llenar la base de datos:<br>
	- ARCHIVO .SQL: [ScriptLlenado.sql](./ScriptLlenado.sql)<br><br>
 Script para las consultas solicitadas:<br>
 	- ARCHIVO .SQL: [ScriptSelects.sql](./'ScriptSelects'.sql)<br><br>
  <hr>

  
# Consultas Solicitadas:
## 1. Listar todos los usuarios de la plataforma que esten activos con su nombre completo, email, país de procedencia, y el total de cuánto han pagado en subscripciones desde el 2024 hasta el día de hoy, dicho monto debe ser en colones (20+ registros)

**Código MySQL**:
```sql
SELECT 
    CONCAT(PS.firstname, ' ', PS.lastname) AS 'Nombre Completo',
    CT.name 'Pais de Origen',
    CIP.value Correo,
    PPE.adquisitionDate 'Fecha de inscripcion',
    PTS.description Subscripcion,
    PP.amount Precio,
    CASE
        WHEN PP.recurrencyType = 1 THEN 'Mensual'
        WHEN PP.recurrencyType = 2 THEN 'Anual'
        WHEN PP.recurrencyType = 3 THEN 'Permanente' 
    END 'Frecuencia de Cobro',
    CASE
        WHEN PP.recurrencyType = 1 THEN TIMESTAMPDIFF(MONTH, PPE.adquisitionDate, NOW())*PP.amount
        WHEN PP.recurrencyType = 2 THEN TIMESTAMPDIFF(YEAR, PPE.adquisitionDate, NOW())*PP.amount
        WHEN PP.recurrencyType = 3 THEN PP.amount 
    END 'Total Pagado'
FROM Payment_Users PU
INNER JOIN Payment_Personas PS ON PU.personID = PS.personID
INNER JOIN Payment_ContactInfoPerson CIP ON (PS.personID = CIP.personID AND CIP.contacInfoTypeID = 1)
INNER JOIN Payment_UserAdresses UA ON PU.userid = UA.userid
INNER JOIN Payment_Adresses AD ON UA.adressid = AD.adressid
INNER JOIN Payment_Cities CY ON CY.cityid = AD.cityid
INNER JOIN Payment_States ST ON ST.stateid = CY.cityid
INNER JOIN Payment_Countries CT ON CT.countryid = ST.countryid
INNER JOIN Payment_PlanPerEntity PPE ON PPE.userid = PU.userid
INNER JOIN Payment_PlanPrices PP ON PPE.planPriceid = PP.planPriceid
INNER JOIN Payment_Subscriptions PTS ON PP.subscriptionid = PTS.subscriptionid
WHERE PU.enabled = 1;
```

**Datatable Obtenido**:

| Nombre Completo      | País         | Email                                | Fecha de Registro       | Tipo de Suscripción | Monto   | Frecuencia | Total Pagado |
|----------------------|--------------|--------------------------------------|-------------------------|---------------------|---------|------------|--------------|
| Kimberly Walker      | España       | kimberly.walker12@example.com        | 2023-01-02 00:00:00     | Suscripción Gratis  | 0.00    | Mensual    | 0.00         |
| Sandra Lewis         | Estados Unidos | sandra.lewis62@example.com          | 2025-01-12 00:00:00     | Suscripción Gratis  | 0.00    | Mensual    | 0.00         |
| Joseph Martin        | España       | joseph.martin61@example.com          | 2023-07-28 00:00:00     | Suscripción Gratis  | 0.00    | Mensual    | 0.00         |
| Nancy Perez          | Francia      | nancy.perez89@example.com            | 2025-01-27 00:00:00     | Suscripción Gratis  | 0.00    | Mensual    | 0.00         |
| David Rodriguez      | Francia      | david.rodriguez@example.com          | 2024-02-07 00:00:00     | Personal            | 5500.00 | Mensual    | 71500.00     |
| Charles Davis        | Estados Unidos | charles.davis96@example.com         | 2024-02-29 00:00:00     | Personal            | 5500.00 | Mensual    | 66000.00     |
| Patricia Lopez       | Costa Rica   | patricia.lopez77@example.com         | 2024-03-18 00:00:00     | Personal            | 5500.00 | Mensual    | 66000.00     |
| Ashley Brown         | Japón        | ashley.brown@example.com             | 2023-06-07 00:00:00     | Personal            | 5500.00 | Mensual    | 115500.00    |
| Donald Young         | Reino Unido  | donald.young8@example.com            | 2024-06-18 00:00:00     | Personal            | 5500.00 | Mensual    | 49500.00     |
| Michelle Lee         | Estados Unidos | michelle.lee40@example.com          | 2024-11-20 00:00:00     | Personal            | 5500.00 | Mensual    | 22000.00     |
| Margaret Nguyen      | España       | margaret.nguyen45@example.com        | 2023-06-21 00:00:00     | Personal            | 5500.00 | Mensual    | 115500.00    |
| Christopher Thomas   | Japón        | christopher.thomas61@example.com     | 2023-03-25 00:00:00     | Personal            | 5500.00 | Mensual    | 126500.00    |
| Charles Lopez        | Reino Unido  | charles.lopez93@example.com          | 2024-05-13 00:00:00     | Personal            | 5500.00 | Mensual    | 55000.00     |
| Linda Miller         | España       | linda.miller22@example.com           | 2023-02-16 00:00:00     | Personal            | 5500.00 | Mensual    | 137500.00    |
| John Anderson        | Costa Rica   | john.anderson0@example.com           | 2023-09-01 00:00:00     | Personal            | 5500.00 | Mensual    | 99000.00     |
| Joseph Hernandez     | Estados Unidos | joseph.hernandez@example.com        | 2024-10-14 00:00:00     | Familiar            | 10500.00 | Mensual    | 52500.00     |
| Paul Nguyen          | Estados Unidos | paul.nguyen77@example.com           | 2023-10-19 00:00:00     | Familiar            | 10500.00 | Mensual    | 178500.00    |
| Donald Nguyen        | Costa Rica   | donald.nguyen25@example.com          | 2023-05-24 00:00:00     | Familiar            | 10500.00 | Mensual    | 231000.00    |
| Mark Young           | Francia      | mark.young32@example.com             | 2024-02-03 00:00:00     | Empresarial         | 25500.00 | Mensual    | 331500.00    |
| Karen Williams       | España       | karen.williams92@example.com         | 2024-01-22 00:00:00     | Empresarial         | 25500.00 | Mensual    | 357000.00    |
| Jessica Young        | Francia      | jessica.young11@example.com          | 2023-05-14 00:00:00     | Empresarial         | 25500.00 | Mensual    | 561000.00    |
| James Walker         | Reino Unido  | james.walker31@example.com           | 2023-02-19 00:00:00     | Empresarial         | 25500.00 | Mensual    | 637500.00    |
| Richard Harris       | Estados Unidos | richard.harris24@example.com        | 2023-08-16 00:00:00     | Empresarial         | 25500.00 | Mensual    | 484500.00    |
| Patricia Thompson    | Costa Rica   | patricia.thompson@example.com        | 2023-01-18 00:00:00     | Empresarial         | 25500.00 | Mensual    | 663000.00    |
| Ashley Robinson      | Estados Unidos | ashley.robinson23@example.com       | 2023-12-25 00:00:00     | Empresarial         | 25500.00 | Mensual    | 357000.00    |
| Donna Thompson       | Reino Unido  | donna.thompson81@example.com         | 2024-04-01 00:00:00     | Empresarial         | 25500.00 | Mensual    | 280500.00    |
| William Jones        | España       | william.jones28@example.com          | 2023-03-16 00:00:00     | Empresarial         | 25500.00 | Mensual    | 612000.00    |
## 2. Listar todas las personas con su nombre completo e email, los cuales le queden menos de 15 días para tener que volver a pagar una nueva subscripción (13+ registros)

**Código MySQL**:
```sql
SELECT 
    CONCAT(p.firstName, ' ', p.lastName) AS 'Nombre Completo',
    cip.value AS Email,
    s.description AS Suscripcion,
    ppe.expirationDate AS 'Fecha de Expiracion',
    DATEDIFF(ppe.expirationDate, CURDATE()) AS 'Dias Restantes'
FROM 
    Payment_PlanPerEntity ppe
INNER JOIN 
    Payment_Users u ON ppe.userid = u.userid
INNER JOIN 
    Payment_Personas p ON u.personID = p.personID
INNER JOIN 
    Payment_ContactInfoPerson cip ON p.personID = cip.personID AND cip.contacInfoTypeId = 1
INNER JOIN 
    Payment_PlanPrices pp ON ppe.planPriceid = pp.planPriceid
INNER JOIN 
    Payment_Subscriptions s ON pp.subscriptionid = s.subscriptionid
WHERE 
    ppe.expirationDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 15 DAY)
    AND ppe.enabled = 1
ORDER BY 
    'Dias Restantes' ASC;
```

**Datatable Obtenido**:

| Nombre Completo      | Email                           | Suscripción        | Fecha de Expiración     | Días Restantes |
|----------------------|---------------------------------|--------------------|-------------------------|----------------|
| Sandra Johnson       | sandra.johnson@example.com      | Personal           | 2025-03-25 00:00:00     | 1              |
| John Anderson        | john.anderson0@example.com      | Personal           | 2025-03-25 00:00:00     | 1              |
| Jessica Williams     | jessica.williams26@example.com  | Personal           | 2025-03-25 00:00:00     | 1              |
| Charles Davis        | charles.davis96@example.com     | Personal           | 2025-03-25 00:00:00     | 1              |
| Karen Williams       | karen.williams92@example.com    | Empresarial        | 2025-03-28 00:00:00     | 4              |
| Donald Young         | donald.young8@example.com       | Personal           | 2025-03-28 00:00:00     | 4              |
| Michael King         | michael.king64@example.com      | Familiar           | 2025-03-29 00:00:00     | 5              |
| Donna Thompson       | donna.thompson81@example.com    | Empresarial        | 2025-04-01 00:00:00     | 8              |
| Sandra Lewis         | sandra.lewis62@example.com      | Suscripción Gratis | 2025-04-02 00:00:00     | 9              |
| Jessica Jackson      | jessica.jackson@example.com     | Personal           | 2025-04-02 00:00:00     | 9              |
| James Walker         | james.walker31@example.com      | Empresarial        | 2025-04-02 00:00:00     | 9              |
| Paul Young           | paul.young94@example.com        | Empresarial        | 2025-04-05 00:00:00     | 12             |
| Mark Young           | mark.young32@example.com        | Empresarial        | 2025-04-06 00:00:00     | 13             |
| Ashley Robinson      | ashley.robinson23@example.com   | Empresarial        | 2025-04-07 00:00:00     | 14             |

## 3. Un ranking del top 15 de usuarios que más uso le dan a la aplicación y el top 15 que menos uso le dan a la aplicación (15 y 15 registros)

### Top 15 usuarios más activos
**Código MySQL**:
```sql
-- Top 15 usuarios con más actividad 
SELECT   
    l.username AS nombre_completo,  
    l.referenceid1 AS userid,  
    COUNT(*) AS total_acciones,  
    MAX(l.postTime) AS ultima_actividad,  
    'Más activo' AS tipo_ranking  
FROM   
    Payment_Log l  
GROUP BY   
    l.username, l.referenceid1  
ORDER BY   
    total_acciones DESC  
LIMIT 15;
```

**Datatable Obtenido**:

| Nombre Completo     | User ID | Total Acciones | Última Actividad       | Tipo de Ranking |
|---------------------|---------|----------------|------------------------|-----------------|
| Joseph Hernandez    | 1       | 8              | 2025-03-25 23:02:29    | Más activo      |
| David Thompson      | 5       | 8              | 2025-03-24 17:45:30    | Más activo      |
| Donna Perez         | 10      | 8              | 2025-03-24 18:09:30    | Más activo      |
| Charles Davis       | 6       | 8              | 2025-03-21 02:20:30    | Más activo      |
| Sandra Johnson      | 9       | 8              | 2025-03-16 18:10:30    | Más activo      |
| Paul Nguyen         | 7       | 7              | 2025-03-20 12:24:30    | Más activo      |
| Donald Young        | 12      | 6              | 2025-03-25 04:05:30    | Más activo      |
| Jessica Jackson     | 15      | 6              | 2025-03-25 09:04:30    | Más activo      |
| Michelle Lee        | 13      | 6              | 2025-03-24 02:44:30    | Más activo      |
| Ashley Brown        | 11      | 6              | 2025-03-21 19:54:30    | Más activo      |
| Patricia Lopez      | 8       | 6              | 2025-03-19 05:47:30    | Más activo      |
| Mark Young          | 3       | 6              | 2025-03-15 09:10:30    | Más activo      |
| Ashley Clark        | 4       | 5              | 2025-03-25 11:44:30    | Más activo      |
| Charles Walker      | 14      | 5              | 2025-03-23 11:37:30    | Más activo      |
| Ashley Robinson     | 33      | 5              | 2025-03-04 16:11:29    | Más activo      |

---

### Top 15 usuarios menos activos
**Código MySQL**:
```sql
-- Top 15 usuarios con menos actividad
SELECT   
    l.username AS nombre_completo,  
    l.referenceid1 AS userid,   
    COUNT(*) AS total_acciones,  
    MAX(l.postTime) AS ultima_actividad,  
    'Menos activo' AS tipo_ranking  
FROM   
    Payment_Log l  
GROUP BY   
    l.username, l.referenceid1  
ORDER BY   
    total_acciones ASC  
LIMIT 15;
```
**Datatable Obtenido**:
| Nombre Completo      | User ID | Acciones | Última Actividad       | Tipo de Ranking |
|----------------------|---------|----------|------------------------|-----------------|
| Joseph Martin        | 29      | 1        | 2025-03-19 03:50:29    | Menos activo    |
| James Walker         | 24      | 1        | 2025-02-17 05:16:29    | Menos activo    |
| Richard Harris       | 26      | 1        | 2025-02-05 17:22:29    | Menos activo    |
| Sandra Lewis         | 21      | 1        | 2025-02-02 08:08:29    | Menos activo    |
| Michael King         | 36      | 1        | 2025-03-21 12:51:29    | Menos activo    |
| Richard Thomas       | 22      | 1        | 2025-03-05 12:05:29    | Menos activo    |
| Donald Nguyen        | 19      | 1        | 2025-01-17 07:39:29    | Menos activo    |
| John Anderson        | 39      | 2        | 2025-03-24 04:06:29    | Menos activo    |
| Nancy Perez          | 34      | 2        | 2025-01-26 16:50:29    | Menos activo    |
| Patricia Thompson    | 28      | 2        | 2025-03-19 06:34:29    | Menos activo    |
| Jessica Williams     | 30      | 2        | 2025-03-13 09:55:29    | Menos activo    |
| Susan Lewis          | 16      | 2        | 2025-03-14 10:02:29    | Menos activo    |
| Karen Williams       | 18      | 2        | 2025-03-14 06:23:29    | Menos activo    |
| Christopher Thomas   | 31      | 2        | 2025-03-12 11:00:29    | Menos activo    |
| Charles Lopez        | 32      | 2        | 2025-01-20 04:01:29    | Menos activo    |

---

## 4. Determinar cuáles son los análisis donde más está fallando la AI, encontrar los casos, situaciones, interpretaciones, halucinaciones o errores donde el usuario está teniendo más problemas en hacer que la AI determine correctamente lo que se desea hacer, rankeando cada problema de mayor a menor cantidad de ocurrencias entre un rango de fechas (30+ registros)

**Código MySQL**:
```sql
SELECT COUNT(1) 'Casos Detectados', AE.name 
FROM Payment_AIProcessingLogs AP
INNER JOIN Payment_ScreenAudioSync SAS ON AP.syncID = SAS.syncID
INNER JOIN Payment_AudioTranscripts ATS ON SAS.transcriptionId = ATS.transcriptionId
INNER JOIN Payment_AudioRecordings AR ON ATS.audioRecordingsID = AR.audioRecordingsID
INNER JOIN Payment_AudioEvent AE ON AE.audioEventId = AR.audioEventId 
WHERE AP.status = 'FAILED'
AND AP.accuracyObtained < 70
AND AP.createdAt > '2022-01-01 00:00:00' -- Desde el 2022 hasta la actualidad, rango de fechas se puede ajustar aquí
GROUP BY AE.name
ORDER BY COUNT(1) DESC;
```

**Datatable Obtenido**:

| Casos Detectados | Nombre del Problema           |
|------------------|-------------------------------|
| 13               | Sesgo en reconocimiento       |
| 12               | Fase invertida                |
| 12               | Rango dinámico pobre          |
| 12               | Pérdida de paquetes          |
| 12               | Volumen irregular            |
| 11               | Voces solapadas              |
| 10               | Frecuencia perdida           |
| 9                | Sibilancia fuerte            |
| 8                | Micrófono saturado           |
| 8                | Desincronización AV          |
| 8                | Procesamiento lento          |
| 8                | Audio con artefactos         |
| 8                | Remuestreo defectuoso        |
| 7                | Silencio erróneo             |
| 7                | Armónicos falsos             |
| 7                | Muestreo incompatible        |
| 7                | Metadatos erróneos           |
| 7                | Modulación artificial        |
| 7                | Audio distorsionado          |
| 7                | Falso positivo               |
| 7                | Modelo sobreajustado         |
| 7                | Confunde homófonos           |
| 6                | Falsa detección voz          |
| 6                | Cancelación ruido falla      |
| 6                | Interferencia eléctrica      |
| 6                | Fallo diarización            |
| 5                | Ruido no filtrado            |
| 5                | Aliasing audio               |
| 5                | Eco residual                 |
| 5                | Timestamp incorrecto         |
| 5                | Transcripción incompleta     |
| 4                | Error en tono                |
| 4                | Latencia alta                |
| 4                | Error transcripción          |
| 3                | Normalización fallida        |
| 2                | Cuantización mala            |
| 1                | Corte de audio               |
| 1                | Clonación voz ilegal         |

---

<pre>
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
</pre>
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
