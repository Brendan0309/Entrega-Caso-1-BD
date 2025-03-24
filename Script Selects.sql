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