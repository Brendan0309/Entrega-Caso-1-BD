-- Primer Select
SELECT CONCAT(PS.firstname, ' ', PS.lastname) AS 'Nombre Completo', CT.name 'Pais de Origen',CIP.value Correo, PPE.adquisitionDate 'Fecha de inscripcion', PTS.description Subscripcion, PP.amount Precio,
CASE
    WHEN PP.recurrencyType = 1 THEN 'Mensual'
    WHEN PP.recurrencyType = 2 THEN 'Anual'
    WHEN PP.recurrencyType = 3 THEN 'Permanente' END 'Frecuencia de Cobro',
CASE
    WHEN PP.recurrencyType = 1 THEN TIMESTAMPDIFF(MONTH, PPE.adquisitionDate, NOW())*PP.amount
    WHEN PP.recurrencyType = 2 THEN TIMESTAMPDIFF(YEAR, PPE.adquisitionDate, NOW())*PP.amount
    WHEN PP.recurrencyType = 3 THEN PP.amount END 'Total Pagado'
FROM Payment_Users PU
INNER JOIN Payment_Personas PS ON PU.personID= PS.personID
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

-- Segundo select
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
    
-- Tercer Select
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

-- Cuarto Select
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
