-- Primer Select
SELECT 
    CONCAT(p.firstName, ' ', p.lastName) AS nombre_completo,
    cip.value AS email,
    pc.name AS pais,
    SUM(pp.amount) AS total_pagado_crc
FROM 
    Payment_Users u
JOIN 
    Payment_Personas p ON u.personID = p.personID
LEFT JOIN 
    Payment_ContactInfoPerson cip ON p.personID = cip.personID AND cip.contacInfoTypeId = 1
LEFT JOIN 
    Payment_UserAdresses ua ON u.userid = ua.userid
LEFT JOIN 
    Payment_Adresses a ON ua.adressid = a.adressid
LEFT JOIN 
    Payment_Cities ci ON a.cityid = ci.cityid
LEFT JOIN 
    Payment_States s ON ci.stateid = s.stateid
LEFT JOIN 
    Payment_Countries pc ON s.countryid = pc.countryid
JOIN 
    Payment_PlanPerEntity ppe ON u.userid = ppe.userid
JOIN 
    Payment_PlanPrices pp ON ppe.planPriceid = pp.planPriceid
WHERE 
    u.enabled = 1
    AND ppe.adquisitionDate >= '2024-01-01'
    AND ppe.adquisitionDate <= CURDATE()
GROUP BY 
    p.personID, nombre_completo, email, pais
HAVING 
    COUNT(ppe.planPerPersonid) > 0
ORDER BY 
    total_pagado_crc DESC;

--Resultados
--nombre_completo,email,pais,total_pagado_crc
--"Kimberly Thompson",kimberly.thompson@example.com,Japón,129.96
--"Kimberly Thompson",kimberly.thompson@example.com,Francia,129.96
--"Patricia Allen",patricia.allen@example.com,"Reino Unido",109.97
--"Charles Gonzalez",charles.gonzalez14@example.com,"Costa Rica",99.98
--"Linda Martin",linda.martin@example.com,"Costa Rica",99.96
--"Thomas Perez",thomas.perez@example.com,"Reino Unido",99.95
--"Thomas Perez",user17@example.com,"Reino Unido",99.95
--"Joseph Moore",user13@example.com,Japón,69.98
--"Joseph Moore",user13@example.com,"Costa Rica",69.98
--"Joseph Moore",joseph.moore79@example.com,Japón,69.98
--"Joseph Moore",joseph.moore79@example.com,"Costa Rica",69.98
--"Susan Martin",susan.martin39@example.com,Japón,49.99
--"Steven Lopez",steven.lopez4@example.com,"Costa Rica",49.99
--"Michelle Wilson",michelle.wilson25@example.com,España,49.99
--"Nancy Wilson",nancy.wilson@example.com,"Costa Rica",49.99
--"Michelle Flores",michelle.flores@example.com,"Reino Unido",39.98
--"Michelle Flores",michelle.flores@example.com,"Costa Rica",39.98
--"Donna Thompson",donna.thompson22@example.com,España,39.98
--"Richard Wright",richard.wright85@example.com,España,29.98
--"Richard Wright",user15@example.com,España,29.98
--"James Miller",james.miller10@example.com,"Estados Unidos",19.99
--"Steven King",steven.king@example.com,"Estados Unidos",19.99
--"James Robinson",james.robinson24@example.com,"Costa Rica",19.99
--"Mark Wright",mark.wright68@example.com,"Reino Unido",9.99
--"Sandra Wright",sandra.wright43@example.com,España,9.99
--"Sandra Gonzalez",sandra.gonzalez28@example.com,Japón,0.00


-- Segundo select
SELECT 
    CONCAT(p.firstName, ' ', p.lastName) AS nombre_completo,
    cip.value AS email,
    s.description AS suscripcion,
    ppe.expirationDate AS fecha_expiracion,
    DATEDIFF(ppe.expirationDate, CURDATE()) AS dias_restantes
FROM 
    Payment_PlanPerEntity ppe
JOIN 
    Payment_Users u ON ppe.userid = u.userid
JOIN 
    Payment_Personas p ON u.personID = p.personID
LEFT JOIN 
    Payment_ContactInfoPerson cip ON p.personID = cip.personID AND cip.contacInfoTypeId = 1
JOIN 
    Payment_PlanPrices pp ON ppe.planPriceid = pp.planPriceid
JOIN 
    Payment_Subscriptions s ON pp.subscriptionid = s.subscriptionid
WHERE 
    ppe.expirationDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 15 DAY)
    AND ppe.enabled = 1
ORDER BY 
    dias_restantes ASC;
--Resultados
--nombre_completo,email,suscripcion,fecha_expiracion,dias_restantes
--"Kimberly Thompson",kimberly.thompson@example.com,"Suscripción Gratis","2025-03-25 00:00:00",1
--"Patricia Allen",patricia.allen@example.com,Empresarial,"2025-03-25 00:00:00",1
--"James Miller",james.miller10@example.com,"Suscripción Gratis","2025-03-25 00:00:00",1
--"Richard Wright",user15@example.com,Personal,"2025-03-25 00:00:00",1
--"Richard Wright",richard.wright85@example.com,Personal,"2025-03-25 00:00:00",1
--"Donald Perez",donald.perez71@example.com,Familiar,"2025-03-26 00:00:00",2
--"Thomas Perez",user17@example.com,Empresarial,"2025-03-26 00:00:00",2
--"Thomas Perez",thomas.perez@example.com,Empresarial,"2025-03-26 00:00:00",2
--"Margaret Torres",user19@example.com,"Suscripción Gratis","2025-03-28 00:00:00",4
--"Margaret Torres",margaret.torres54@example.com,"Suscripción Gratis","2025-03-28 00:00:00",4
--"Nancy Wilson",nancy.wilson@example.com,Familiar,"2025-03-28 00:00:00",4
--"James Miller",james.miller10@example.com,Familiar,"2025-03-29 00:00:00",5
--"Thomas Perez",user17@example.com,Familiar,"2025-03-29 00:00:00",5
--"Thomas Perez",thomas.perez@example.com,Familiar,"2025-03-29 00:00:00",5
--"Mark Wright",mark.wright68@example.com,"Suscripción Gratis","2025-03-30 00:00:00",6
--"Linda Martin",linda.martin@example.com,Familiar,"2025-03-30 00:00:00",6
--"Patricia Allen",patricia.allen@example.com,Personal,"2025-03-31 00:00:00",7
--"Donald Perez",donald.perez71@example.com,Personal,"2025-03-31 00:00:00",7
--"Susan Martin",susan.martin39@example.com,"Suscripción Gratis","2025-03-31 00:00:00",7
--"Kimberly Thompson",kimberly.thompson@example.com,Empresarial,"2025-04-01 00:00:00",8
--"Steven King",steven.king@example.com,"Suscripción Gratis","2025-04-01 00:00:00",8
--"Michelle Wilson",michelle.wilson25@example.com,Empresarial,"2025-04-01 00:00:00",8
--"Michelle Flores",michelle.flores@example.com,Familiar,"2025-04-01 00:00:00",8
--"Linda Martin",linda.martin@example.com,Empresarial,"2025-04-02 00:00:00",9
--"Steven Lopez",steven.lopez4@example.com,"Suscripción Gratis","2025-04-02 00:00:00",9
--"Richard Wright",user15@example.com,Familiar,"2025-04-02 00:00:00",9
--"Richard Wright",richard.wright85@example.com,Familiar,"2025-04-02 00:00:00",9
--"Linda Martin",linda.martin@example.com,Familiar,"2025-04-03 00:00:00",10
--"Kimberly Thompson",kimberly.thompson@example.com,Empresarial,"2025-04-03 00:00:00",10
--"Margaret Torres",user19@example.com,Personal,"2025-04-03 00:00:00",10
--"Margaret Torres",margaret.torres54@example.com,Personal,"2025-04-03 00:00:00",10
--"Mark Wright",mark.wright68@example.com,Personal,"2025-04-03 00:00:00",10
--"Linda Martin",linda.martin@example.com,Personal,"2025-04-03 00:00:00",10
--"Steven Lopez",steven.lopez4@example.com,Empresarial,"2025-04-04 00:00:00",11
--"Thomas Perez",user17@example.com,Personal,"2025-04-05 00:00:00",12
--"Thomas Perez",thomas.perez@example.com,Personal,"2025-04-05 00:00:00",12
--"Joseph Moore",user13@example.com,Familiar,"2025-04-05 00:00:00",12
--"Joseph Moore",joseph.moore79@example.com,Familiar,"2025-04-05 00:00:00",12
--"Robert Gonzalez",robert.gonzalez@example.com,Empresarial,"2025-04-06 00:00:00",13
--"Karen Lee",karen.lee68@example.com,Empresarial,"2025-04-07 00:00:00",14

    
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

--Resultados
--Menos activos
--nombre_completo,userid,total_acciones,ultima_actividad,tipo_ranking
--"Linda Martin",20,2,"2025-01-06 18:36:25","Menos activo"
--"Sandra Gonzalez",17,3,"2025-03-01 00:29:25","Menos activo"
--"Emily King",39,3,"2025-03-17 11:21:25","Menos activo"
--"Michelle Hill",25,3,"2025-03-24 01:34:25","Menos activo"
--"Matthew Allen",31,3,"2025-02-15 17:32:25","Menos activo"
--"Joseph Moore",28,3,"2025-03-09 18:27:25","Menos activo"
--"Donna Lewis",18,4,"2025-03-21 20:14:25","Menos activo"
--"Daniel Perez",34,4,"2025-03-12 03:27:25","Menos activo"
--"Susan Martin",23,4,"2025-03-11 22:44:25","Menos activo"
--"Jennifer Robinson",40,5,"2025-03-14 12:23:25","Menos activo"
--"Margaret Torres",22,5,"2025-03-23 09:05:25","Menos activo"
--"Thomas Hernandez",32,5,"2025-02-17 11:37:25","Menos activo"
--"Joshua Sanchez",16,5,"2025-02-26 05:33:25","Menos activo"
--"Richard Wright",26,5,"2025-02-28 08:14:25","Menos activo"
--"Charles Thompson",37,5,"2025-03-14 18:53:25","Menos activo"

--Más activos 
--nombre_completo,userid,total_acciones,ultima_actividad,tipo_ranking
--"Margaret King",3,20,"2025-03-21 21:22:25","Más activo"
--"Mark Wright",8,18,"2025-03-25 19:15:25","Más activo"
--"James Miller",1,18,"2025-03-25 10:40:25","Más activo"
--"Richard Williams",7,17,"2025-03-22 06:17:25","Más activo"
--"Patricia Thompson",14,16,"2025-03-22 21:46:25","Más activo"
--"Donald Perez",4,16,"2025-03-25 11:54:25","Más activo"
--"Patricia Allen",13,15,"2025-03-22 13:58:25","Más activo"
--"Steven Lopez",2,15,"2025-03-22 20:10:25","Más activo"
--"Charles Gonzalez",6,14,"2025-03-24 13:02:25","Más activo"
--"James Robinson",9,13,"2025-03-23 06:18:25","Más activo"
--"Michelle Wilson",5,13,"2025-03-21 15:03:25","Más activo"
--"Sandra Wright",10,12,"2025-03-23 02:35:25","Más activo"
--"Michelle Flores",11,12,"2025-03-24 16:41:25","Más activo"
--"Nancy Wilson",12,12,"2025-03-25 15:44:25","Más activo"
--"Donna Thompson",15,12,"2025-03-24 20:24:25","Más activo"

-- Cuarto Select
SELECT COUNT(1) 'Casos Detectados', AE.name 
FROM Payment_AIProcessingLogs AP
INNER JOIN Payment_ScreenAudioSync SAS ON AP.syncID = SAS.syncID
INNER JOIN Payment_AudioTranscripts ATS ON SAS.transcriptionId = ATS.transcriptionId
INNER JOIN Payment_AudioRecordings AR ON ATS.audioRecordingsID = AR.audioRecordingsID
INNER JOIN Payment_AudioEvent AE ON AE.audioEventId = AR.audioEventId 
WHERE AP.status = 'FAILED'
AND AP.accuracyObtained < 70
AND AP.createdAt > '2022-01-01 00:00:00' -- Desde el 2022 hasta la actualidad
GROUP BY AE.name
ORDER BY COUNT(1) DESC;
