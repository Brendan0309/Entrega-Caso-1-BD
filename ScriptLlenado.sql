DELIMITER //
CREATE PROCEDURE PopulatePeople()
BEGIN
    SET @numberRows = 40;
    SET @firstname = "";
    SET @lastname = "";
    SET  @birthdate = NULL;
    SET @consumerid = 0;
    WHILE @numberRows > 0 DO
	SET @birthdate =  DATE_ADD('1980-01-01', INTERVAL FLOOR(RAND() * DATEDIFF('2025-12-31', '1980-01-01')) DAY);
        SET @firstname = ELT(FLOOR(1 + RAND() * 40),
			'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda', 'William', 'Elizabeth',
			'David', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica', 'Thomas', 'Sarah', 'Charles', 'Karen',
			'Christopher', 'Nancy', 'Daniel', 'Lisa', 'Matthew', 'Margaret', 'Anthony', 'Betty', 'Mark', 'Sandra',
			'Donald', 'Ashley', 'Steven', 'Kimberly', 'Paul', 'Emily', 'Andrew', 'Donna', 'Joshua', 'Michelle');
        SET @lastname = ELT(FLOOR(1 + RAND() * 40),
			'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
			'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
			'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson',
			'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores');
        SET @consumerid = @consumerid+1;
        INSERT INTO Payment_Personas (firstname, lastname, birthdate, consumersId)
        VALUES (@firstname, @lastname, @birthdate, @consumerid);
        SET @numberRows = @numberRows-1;
	END WHILE;
END //
DELIMITER ;
CALL PopulatePeople();


DELIMITER //
CREATE PROCEDURE PopulateUsers()
BEGIN
    SET @numberRows = 40;
    WHILE @numberRows > 0 DO
	SET @password = sha2(@numberRows, 512);
        SET @personid = @numberRows;
        INSERT INTO Payment_Users(password, enabled, userCompanyId, personID)
        VALUES (@password, 1, null, @personid);
        SET @numberRows = @numberRows-1;
	END WHILE;
    SET @numberDisabled = 15;
    WHILE @numberDisabled > 0 DO
	SET @disabledid = FLOOR(1+RAND()*40);
        UPDATE Payment_Users SET enabled = 0 WHERE userid = @disabledid;
        SET @numberDisabled = @numberDisabled-1;
	END WHILE;
END//
DELIMITER ;
CALL PopulateUsers();

INSERT INTO `PaymentAsistant`.`Payment_ContactInfoTypes` (`name`) VALUES
('Correo'),
('Telefono'),
('Fax');

INSERT INTO `PaymentAsistant`. `payment_MetodosDePago` (`name`, apiURL, secretKey, `key`, logoIconURL, enabled, templateJSON)
VALUES 
('PayPal', 'https://api.paypal.com', UNHEX('A1B2C3D4E5F6'), UNHEX('F6E5D4C3B2A1'), 'paypal.png', 1, '{"config": "sample"}'),
('Stripe', 'https://api.stripe.com', UNHEX('123456789ABC'), UNHEX('ABC987654321'), 'stripe.png', 1, '{"currency": "USD"}');

DELIMITER //

CREATE PROCEDURE PopulateContactInfoPerson()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_personas INT;
    DECLARE contact_type INT;
    DECLARE is_enabled BIT;
    DECLARE metodo_pago INT;
    DECLARE contact_value VARCHAR(100);
    
    SELECT COUNT(*) INTO max_personas FROM Payment_Personas;
    
    WHILE i <= max_personas DO
        -- Insertar EMAIL
        SET contact_type = 1; -- Correo
        SET is_enabled = IF(RAND() > 0.3, 1, 0); 
        SET metodo_pago = IF(RAND() > 0.5, 1, 2); 
        
        SELECT CONCAT(
            LOWER(REPLACE(p.firstName, ' ', '')), 
            '.', 
            LOWER(REPLACE(p.lastName, ' ', '')), 
            IF(RAND() > 0.7, '', FLOOR(RAND() * 100)), 
            '@example.com'
        ) INTO contact_value
        FROM Payment_Personas p
        WHERE p.personID = i;
        
        IF contact_value IS NULL THEN
            SET contact_value = CONCAT('user', i, '@example.com');
        END IF;
        
        -- Insertar registro de email
        INSERT INTO Payment_ContactInfoPerson (`value`, enabled, lastUpdate, contacInfoTypeId, personID, metodoId)
        VALUES (contact_value, is_enabled, NOW(), contact_type, i, metodo_pago);
        
        -- Insertar TELÉFONO 
        IF RAND() > 0.2 THEN
            SET contact_type = 2; -- Teléfono
            SET is_enabled = IF(RAND() > 0.4, 1, 0);
            SET metodo_pago = IF(RAND() > 0.5, 1, 2); 
            
            -- Generar número de teléfono aleatorio
            SET contact_value = CONCAT(
                '6', 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                ' ', 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                ' ', 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9)
            );
            
            -- Insertar registro de teléfono
            INSERT INTO Payment_ContactInfoPerson (`value`, enabled, lastUpdate, contacInfoTypeId, personID, metodoId)
            VALUES (contact_value, is_enabled, NOW(), contact_type, i, metodo_pago);
        END IF;
        
        -- Insertar FAX 
        IF RAND() > 0.8 THEN
            SET contact_type = 3; -- Fax
            SET is_enabled = IF(RAND() > 0.5, 1, 0); 
            SET metodo_pago = IF(RAND() > 0.5, 1, 2); 
            
            -- Generar número de fax aleatorio
            SET contact_value = CONCAT(
                '9', 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                ' ', 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                ' ', 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9), 
                FLOOR(RAND() * 9)
            );
            
            -- Insertar registro de fax
            INSERT INTO Payment_ContactInfoPerson (`value`, enabled, lastUpdate, contacInfoTypeId, personID, metodoId)
            VALUES (contact_value, is_enabled, NOW(), contact_type, i, metodo_pago);
        END IF;
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;


CALL PopulateContactInfoPerson();

INSERT INTO `PaymentAsistant`.`Payment_Currencies` (`name`, acronym, symbol) VALUES
('Dólar Estadounidense', 'USD', '$'),
('Euro', 'EUR', '€'),
('Colón', 'CRC', '₡'),
('Libra Esterlina', 'GBP', '£'),
('Yen Japonés', 'JPY', '¥');

INSERT INTO PaymentAsistant.Payment_CurrencyConversions (
    startdate, enddate, exchangeRate, enabled, currentExchangeRate, currencyid_source, currencyid_destiny
) VALUES 
    ('2023-10-01', '2023-10-31', 0.001333, 1, 1, 3, 1),
    ('2023-10-01', '2023-10-31', 0.001200, 1, 1, 3, 2),
    ('2023-10-01', '2023-10-31', 0.001100, 1, 1, 3, 4),
    ('2023-10-01', '2023-10-31', 0.150000, 1, 1, 3, 5),
    ('2023-10-01', '2023-10-31', 750.000000, 1, 1, 1, 3),
    ('2023-10-01', '2023-10-31', 830.000000, 1, 1, 2, 3),    
    ('2023-10-01', '2023-10-31', 900.000000, 1, 1, 4, 3),
    ('2023-10-01', '2023-10-31', 6.666667, 1, 1, 5, 3); 

INSERT INTO `PaymentAsistant`.`Payment_Countries`(`name`, currencyid) VALUES
('Estados Unidos', 1),
('Costa Rica', 3),
('Reino Unido', 4),
('Japón', 5),
('España', 2),
('Francia', 2);

INSERT INTO `PaymentAsistant`.`Payment_States`(`name`, countryId) VALUES
('New York', 1),
('San Jose', 2),
('Liverpool', 3),
('Tokio', 4),
('Madrid', 5),
('Paris', 6);

INSERT INTO `PaymentAsistant`.`Payment_Cities`(`name`, stateid) VALUES
('Harlem', 1),
('Tibas', 2),
('Anfield', 3),
('Shibuya', 4),
('Barajas', 5),
('Isla dla Cité', 6);

DELIMITER //

CREATE PROCEDURE PopulateAdresses()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_cities INT;
    DECLARE random_city INT;
    DECLARE line2_text VARCHAR(50);
    DECLARE lat FLOAT;
    DECLARE lon FLOAT;
    
    SELECT COUNT(*) INTO max_cities FROM Payment_Cities;
    

    WHILE i <= 20 DO
        SET random_city = FLOOR(1 + RAND() * max_cities);
        
        IF RAND() > 0.3 THEN
            SET line2_text = CONCAT('Apt ', FLOOR(100 + RAND() * 900));
        ELSE
            SET line2_text = NULL;
        END IF;
        
        SET lat = 37.0 + RAND() * 20;  
        SET lon = -122.0 - RAND() * 60;
        

        INSERT INTO Payment_Adresses (line1, line2, zipcode, geoposition, cityid)
        VALUES (
            CONCAT('Calle ', FLOOR(1 + RAND() * 100)),
            line2_text,
            CONCAT('1', FLOOR(1000 + RAND() * 9000)), 
            POINT(lat, lon),
            random_city
        );
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;


CALL PopulateAdresses();

DELIMITER //

CREATE PROCEDURE PopulateUserAdresses()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_users INT;
    DECLARE max_adresses INT;
    DECLARE user_id INT;
    DECLARE adress_id INT;
    DECLARE attempts INT;
    
    SELECT COUNT(*) INTO max_users FROM Payment_Users;
    SELECT COUNT(*) INTO max_adresses FROM Payment_Adresses;
    
    SET i = 1;
    REPEAT

        IF NOT EXISTS (SELECT 1 FROM Payment_UserAdresses WHERE userid = i AND adressid = i) THEN

            INSERT INTO Payment_UserAdresses (enabled, userid, adressid)
            VALUES (1, i, i);
        END IF;
        
        SET i = i + 1;
    UNTIL i > LEAST(max_users, max_adresses) END REPEAT;
    
    SET i = 1;
    WHILE i <= max_users AND max_adresses > max_users DO
        IF RAND() > 0.8 THEN 
            SET attempts = 0;
            
            REPEAT
                SET adress_id = FLOOR(1 + RAND() * max_adresses);
                SET attempts = attempts + 1;
                
            UNTIL NOT EXISTS (SELECT 1 FROM Payment_UserAdresses WHERE userid = i AND adressid = adress_id) 
                  OR attempts > 10 END REPEAT;
            
            IF attempts <= 10 THEN
                INSERT INTO Payment_UserAdresses (enabled, userid, adressid)
                VALUES (1, i, adress_id);
            END IF;
        END IF;
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;


CALL PopulateUserAdresses();

INSERT INTO PaymentAsistant.Payment_Subscriptions (subscriptionId, `description`, periodStart, periodEND, enabled, imgURL) 
VALUES
(1, 'Suscripción Gratis', CURDATE(), NULL, 1, 'https://example.com/gratis.png'),
(2, 'Personal', CURDATE(), CURDATE() + INTERVAL 30 DAY, 1, 'https://example.com/humano.png'),
(3, 'Familiar', CURDATE(), CURDATE() + INTERVAL 30 DAY, 1, 'https://example.com/familia.png'),
(4, 'Empresarial', CURDATE(), CURDATE() + INTERVAL 30 DAY, 1, 'https://example.com/empresas.png');

ALTER TABLE PaymentAsistant.Payment_PlanPrices 
MODIFY COLUMN endDate DATE NULL;

INSERT INTO `PaymentAsistant`.`Payment_PlanPrices` (planPriceId, amount, recurrencyType, postTime, endDate, `current`, subscriptionid) VALUES
(1, 0, 1, CURDATE(), NULL , 1, 1),  -- Gratis
(2, 9.99, 1, CURDATE(), CURDATE() + INTERVAL 30 DAY, 0, 2),  -- personal
(3, 19.99, 1, CURDATE(), CURDATE() + INTERVAL 30 DAY, 0, 3),  -- familiar
(4, 49.99, 1, CURDATE(), CURDATE() + INTERVAL 30 DAY, 1, 4);  -- empresarial

DELIMITER //

CREATE PROCEDURE PopulatePlanPerEntity()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE user_count INT;
    DECLARE plan_count INT;
    DECLARE random_user INT;
    DECLARE random_plan INT;
    DECLARE random_days INT;
    DECLARE adq_date DATE;
    DECLARE exp_date DATE;
    DECLARE schedule_id INT;
    
    SELECT COUNT(*) INTO user_count FROM Payment_Users WHERE enabled = 1;
    SELECT COUNT(*) INTO plan_count FROM Payment_PlanPrices;
    
    INSERT INTO Payment_Schedules (`name`, recurrencyType, `repeat`, endType, repetitions, endDate)
    VALUES 
        ('Mensual', 1, 1, 1, NULL, NULL),
        ('Anual', 2, 1, 1, NULL, NULL),
        ('Trimestral', 3, 1, 1, NULL, NULL);
    
    SET schedule_id = LAST_INSERT_ID();
    
    WHILE i <= 40 DO
        SET random_user = FLOOR(1 + RAND() * user_count);
        SET random_plan = FLOOR(1 + RAND() * plan_count);
        SET random_days = FLOOR(1 + RAND() * 365);
        
        SET adq_date = DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND() * 800) DAY);
        
        IF i % 3 = 0 THEN
            SET exp_date = DATE_ADD(CURDATE(), INTERVAL FLOOR(1 + RAND() * 14) DAY);
        ELSE
            SET exp_date = DATE_ADD(adq_date, INTERVAL 
                CASE 
                    WHEN random_plan % 3 = 0 THEN 30  
                    WHEN random_plan % 3 = 1 THEN 365  
                    ELSE 90                         
                END DAY);
        END IF;
        
       
        INSERT INTO Payment_PlanPerEntity (
            adquisitionDate, 
            enabled, 
            planPriceid, 
            scheduleid, 
            userid, 
            companyid, 
            expirationDate
        ) VALUES (
            adq_date,
            1,
            random_plan,
            FLOOR(1 + RAND() * 3), 
            random_user,
            NULL,
            exp_date
        );
        
        SET i = i + 1;
    END WHILE;
    
END //

DELIMITER;
CALL PopulatePlanPerEntity();

INSERT INTO `PaymentAsistant`. `Payment_Languages` (`name`, culture, countryid)
VALUES 
('Español Costa Rica', 'CRC', 2),
('Frances', 'FR',  6),
('Japones','JP', 4);

INSERT INTO `PaymentAsistant`.`Payment_MediosDisponibles`
    (`name`, token, expTokenDate, maskAccount, callbackURLget, 
    callbackPost, callbackredirect, personID, metodoId, configurationJSON) 
VALUES 
    ('Visa', UNHEX('A1B2C3D4E5F6'), '2025-12-31', '**** **** **** 1234', 'https://example.com/getVisa', 
    'https://example.com/postVisa', 'https://example.com/redirectVisa', 11, 1, '{"currency": "CRC"}'),
    ('MasterCard', UNHEX('1234567890ABCDEF'), '2026-11-30', '**** **** **** 5678', 'https://example.com/getMC',
    'https://example.com/postMC', 'https://example.com/redirectMC', 12, 2, '{"currency": "USD"}'),
    ('PayPal', UNHEX('ABCDEF1234567890'), '2025-10-15', 'paypal_user_01', 'https://example.com/getPP', 
    'https://example.com/postPP', 'https://example.com/redirectPP', 10, 1, '{"email": "user@example.com"}');

INSERT INTO `PaymentAsistant`.`Payment_Modules`(`name`, languageId) VALUES
('Menu Principal', 1),
('Registrar Pago', 1),
('Registrar Metodo Pago', 1),
('Agendar Pago', 1);

DELIMITER //

CREATE PROCEDURE PopulatePagos()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE success BOOLEAN;
    
    WHILE i <= 200 DO
        SET success = FALSE;
        
        WHILE NOT success DO
            BEGIN
                DECLARE random_person INT;
                DECLARE random_medio INT;
                DECLARE random_metodo INT;
                DECLARE random_currency INT;
                DECLARE pago_monto DECIMAL(10,2);
                
                SELECT personID INTO random_person FROM Payment_Personas 
                ORDER BY RAND() LIMIT 1;
                
                SELECT pagoMedioId INTO random_medio FROM Payment_MediosDisponibles 
                ORDER BY RAND() LIMIT 1;
                
                SELECT metodoId INTO random_metodo FROM payment_MetodosDePago 
                ORDER BY RAND() LIMIT 1;
                
                SELECT currencyid INTO random_currency FROM Payment_Currencies 
                ORDER BY RAND() LIMIT 1;
                
                -- Generar monto aleatorio
                SET pago_monto = ROUND(10 + (RAND() * 1990), 2);
                
                --  insertar
                INSERT INTO Payment_Pagos (
                    pagoMedioId, metodoId, personID, monto, actualMonto, 
                    result, auth, chargetoken, descripcion, `error`, 
                    fecha, `checksum`, exchangeRate, convertedAmount, currencyid
                ) VALUES (
                    random_medio, random_metodo, random_person, pago_monto, pago_monto,
                    CONCAT('result', i), CONCAT('auth', i), CONCAT('token', i),
                    CASE 
                        WHEN RAND() > 0.7 THEN 'Compra online'
                        WHEN RAND() > 0.5 THEN 'Pago de servicio'
                        WHEN RAND() > 0.3 THEN 'Compra en tienda'
                        ELSE 'Pago de suscripción'
                    END,
                    IF(RAND() > 0.9, 'Error simulado', NULL),
                    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 180) DAY),
                    SHA2(CONCAT(random_person, random_medio, pago_monto, NOW()), 256),
                    1.0, 
                    pago_monto, 
                    random_currency
                );
                
                SET success = TRUE;
            END;
        END WHILE;
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

CALL PopulatePagos();

DELIMITER //

CREATE PROCEDURE PopulatePaymentLog()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_users INT;
    DECLARE random_user INT;
    DECLARE log_date DATETIME;
    DECLARE action_type INT;
    DECLARE user_fullname VARCHAR(100);
    
    SELECT COUNT(*) INTO max_users FROM Payment_Users;
    
    WHILE i <= 60 DO
        SET random_user = FLOOR(1 + RAND() * max_users);
        
        SELECT CONCAT(p.firstName, ' ', p.lastName) INTO user_fullname
        FROM Payment_Users u
        JOIN Payment_Personas p ON u.personID = p.personID
        WHERE u.userid = random_user;
        
        -- Fecha aleatoria en los últimos 3 meses
        SET log_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 90) DAY);
        SET log_date = DATE_ADD(log_date, INTERVAL FLOOR(RAND() * 24) HOUR);
        SET log_date = DATE_ADD(log_date, INTERVAL FLOOR(RAND() * 60) MINUTE);
        
        SET action_type = FLOOR(1 + RAND() * 4);
        
        INSERT INTO Payment_Log (`description`, postTime, computer, username, trace, referenceid1, referenceid2, value1, value2, `checksum`)
        VALUES (
            CASE 
                WHEN action_type = 1 THEN 'Inicio de sesión'
                WHEN action_type = 2 THEN 'Realización de pago'
                WHEN action_type = 3 THEN 'Cierre de sesión'
                ELSE 'Error en operación'
            END,
            log_date,
            CONCAT('PC-', FLOOR(1 + RAND() * 10)),
            user_fullname, 
            CONCAT('trace', i),
            random_user, -- referenceid1 = userid
            FLOOR(1 + RAND() * 100),
            FLOOR(1 + RAND() * 100),
            FLOOR(1 + RAND() * 100),
            SHA2(CONCAT(random_user, log_date, i), 256)
        );
        
        SET i = i + 1;
    END WHILE;
    
    SET i = 1;
    WHILE i <= 15 DO
        SET random_user = i; 
        
        SELECT CONCAT(p.firstName, ' ', p.lastName) INTO user_fullname
        FROM Payment_Users u
        JOIN Payment_Personas p ON u.personID = p.personID
        WHERE u.userid = random_user;
        
        SET @j = 1;
        WHILE @j <= 5 DO
            SET log_date = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY);
            SET log_date = DATE_ADD(log_date, INTERVAL FLOOR(RAND() * 24) HOUR);
            SET log_date = DATE_ADD(log_date, INTERVAL FLOOR(RAND() * 60) MINUTE);
            
            INSERT INTO Payment_Log (`description`, postTime, computer, username, trace, referenceid1, referenceid2, value1, value2, `checksum`)
            VALUES (
                CONCAT('Acción adicional ', @j),
                log_date,
                CONCAT('PC-', FLOOR(1 + RAND() * 5)),
                user_fullname, 
                CONCAT('trace-extra-', i, '-', @j),
                random_user, 
                FLOOR(1 + RAND() * 50),
                FLOOR(1 + RAND() * 50),
                FLOOR(1 + RAND() * 50),
                SHA2(CONCAT(random_user, log_date, i, @j), 256)
            );
            
            SET @j = @j + 1;
        END WHILE;
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
CALL PopulatePaymentLog();

INSERT INTO Payment_MediaTypes(name, playerImp) VALUES
('Invoice PDF', 'PDF Reader'),
('Transcript File', 'PDF Reader'),
('Audio File', 'MP3 Player'),
('Video File', 'MP4 Player'),
('Image', 'Image Visualizer');
DELIMITER //

	
CREATE PROCEDURE PopulateMediaFiles()
BEGIN
    SET @numberRows = 60;
    WHILE @numberRows > 0 DO
	SET @mediaType = FLOOR(1+RAND()*5);
	SET @genTime = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 800) DAY);
	SET @genTime = DATE_ADD(DATE(@genTime), INTERVAL FLOOR(5 + RAND() * 9) HOUR); 
	SET @genTime = DATE_ADD(@genTime, INTERVAL FLOOR(RAND() * 60) MINUTE);
        INSERT INTO Payment_MediaFiles(url, deleted, mediaTypeid, reference, generationDate)
        VALUES (CONCAT("https://www.filenumb",@numberRows,".com"), 0, @mediaType, CONCAT("ArchivoNum",@numberRows,"20251123675_0"), @genTime); 
	SET @numberRows = @numberRows-1; 
    END WHILE;
    SET @transcriptNumbers = 15;
    WHILE @transcriptNumbers > 0 DO
	SET @transcriptid = FLOOR(1+RAND()*60);
        UPDATE Payment_MediaFiles SET mediaTypeid = 2 WHERE mediaFileId = @transcriptid;
        SET @transcriptNumbers = @transcriptNumbers-1;
    END WHILE;
END//
DELIMITER ;
CALL PopulateMediaFiles();


DELIMITER //
CREATE PROCEDURE PopulateAudioEvents()
BEGIN
    SET @rowNumber = 40;
    WHILE @rowNumber > 0 DO
	SET @name = ELT(@rowNumber,
            'Error transcripción', 'Falsa detección voz', 'Ruido no filtrado', 'Desincronización AV', 'Corte de audio', 'Eco residual',
            'Micrófono saturado', 'Silencio erróneo', 'Omite palabras', 'Confunde homófonos', 'Fallo diarización', 'Latencia alta', 'Audio con artefactos', 'Sibilancia fuerte',
            'Clonación voz ilegal', 'Modelo sobreajustado', 'Muestreo incompatible', 'Metadatos erróneos', 'Sesgo en reconocimiento', 'Falso positivo', 'Timestamp incorrecto',
            'Transcripción incompleta', 'Interferencia eléctrica', 'Audio distorsionado', 'Voces solapadas', 'Idioma incorrecto', 'Volumen irregular', 'Pérdida de paquetes',
            'Procesamiento lento', 'Cancelación ruido falla', 'Modulación artificial', 'Error en tono', 'Frecuencia perdida', 'Armónicos falsos', 'Aliasing audio',
            'Cuantización mala', 'Normalización fallida', 'Rango dinámico pobre', 'Remuestreo defectuoso', 'Fase invertida', 'BPM incorrecto', 'Loop no detectado'
        );
        INSERT INTO Payment_AudioEvent (name, enabled) VALUES (@name, 1);
        SET @rowNumber = @rowNumber-1;
	END WHILE;
END //
DELIMITER ;
CALL PopulateAudioEvents();

	
CREATE PROCEDURE PopulateCuePoints()
BEGIN
    SET @rowNumbers = 200;
    WHILE @rowNumbers > 0 DO
	SET @startTimestamp = NOW() - INTERVAL FLOOR(RAND() * 365) DAY - INTERVAL FLOOR(RAND() * 24) HOUR - INTERVAL FLOOR(RAND() * 60) MINUTE - INTERVAL FLOOR(RAND() * 60) SECOND;
	SET @endTimestamp = DATE_ADD(@startTimestamp, INTERVAL FLOOR(1+RAND()*60) SECOND);
        SET @description = ELT(FLOOR(1+RAND()*5) , 'User started a command', 'User manually opened asistant', 'User called for asistant', 'User said a keyword', 'User pressed a key button');
        INSERT INTO Payment_CuePoints (description, startTime, endTime)
        VALUES (@description, @startTimestamp, @endTimestamp);
        SET @rowNumbers = @rowNumbers-1;
	END WHILE;
END //
DELIMITER ;
CALL PopulateCuePoints();


DELIMITER //
CREATE PROCEDURE PopulateAudioRecordings()
BEGIN
	SET @rowNumbers = 200;
	WHILE @rowNumbers > 0 DO
	SET @userid = FLOOR(1+RAND()*40);
        SET @audioId = FLOOR(1+RAND()*300);
       SET @audioEvent = CASE 
				WHEN @rowNumbers <= 30 THEN @rowNumbers%40
				ELSE FLOOR(1+RAND()*40) END;
        SET @cluster = ELT(FLOOR(1+RAND()*5),
			'{"clusterId": "cluster_006", "topic": "Cancel Subscription", "status": "Pending"}',
            '{"clusterId": "cluster_004", "topic": "Failed Transaction", "status": "Resolved"}',
            '{"clusterId": "cluster_005", "topic": "Password Reset", "status": "Resolved"}',
            '{"clusterId": "cluster_010", "topic": "New Feature Feedback", "status": "Closed"}',
            '{"clusterId": "cluster_011", "topic": "Account Security", "status": "Resolved"}');
		SET @corrections = ELT(FLOOR(1+RAND()*5),
			'{"correctionId": "correction_001", "type": "volumeAdjustment", "status": "Applied"}',
            '{"correctionId": "correction_002", "type": "noiseReduction", "status": "Pending"}',
            '{"correctionId": "correction_008", "type": "compression", "status": "Applied"}',
            '{"correctionId": "correction_009", "type": "reverbAdjustment", "status": "Pending"}',
            '{"correctionId": "correction_010", "type": "delayAdjustment", "status": "Applied"}'
        );
        INSERT INTO Payment_AudioRecordings (userid, audioId, communicationClusters, cuePointID, corrections, audioEventid)
        VALUES (@userid, @audioId, @cluster, @rowNumbers, @corrections, @audioEvent);
        SET @rowNumbers = @rowNumbers-1;
	END WHILE;
END//
DELIMITER ;
CALL PopulateAudioRecordings();

DELIMITER //
CREATE PROCEDURE PopulateAudioTranscripts()
BEGIN
    SET @rowNumbers = 200;
    WHILE @rowNumbers > 0 DO
	SET @genTime = DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 800) DAY);
	SET @genTime = DATE_ADD(DATE(@genTime), INTERVAL FLOOR(5 + RAND() * 9) HOUR); 
	SET @genTime = DATE_ADD(@genTime, INTERVAL FLOOR(RAND() * 60) MINUTE);
        SET @accuracy = 1+RAND()*99;
        SET @detectedKeywords = ELT(FLOOR(1 + RAND() * 10),
			'Confirm payment',          
			'Cancel transaction',       
			'Deny confirmation',        
			'Repeat',                   
			'Payment failed',           
			'Proceed',   
			'Reconfigure payment', 
			'Wrong information',  
			'Repeat account',            
			'Request refund'          
		);
        INSERT INTO Payment_AudioTranscripts (description, createdAt, audioId, audioRecordingsID, accuracy, detectedKeywords, value)
        VALUES ('Description unavailable', @genTime, @rowNumbers, @rowNumbers, @accuracy, @detectedKeywords, NULL);
        SET @rowNumbers = @rowNumbers-1;
	END WHILE;
END//
DELIMITER ;
CALL PopulateAudioTranscripts();

INSERT INTO Payment_ScreenEvents(name, enabled) VALUES
	('Screen Loaded', 1),
	('Payment Form Displayed', 1),
	('Transaction Summary Displayed', 1),
	('Cancel Button Clicked', 1),
	('Help Button Clicked', 1),
	('Confirmation Screen Displayed', 1),
	('Source Account Selected', 1),
	('Destination Account Selected', 1),
	('IBAN Entered', 1),
	('Card Number Entered', 1),
	('Error Message Displayed', 1),
	('Success Message Displayed', 1),
	('Back Button Clicked', 1),
	('Retry Button Clicked', 1),
	('Processing Screen Displayed', 1);

DELIMITER //
CREATE PROCEDURE PopulateScreenRecordings()
BEGIN
    SET @rowNumber = 200;
    WHILE @rowNumber > 0 DO
	SET @userid = FLOOR(1+RAND()*40);
	SET @moduleid = FLOOR(1+RAND()*4);
        SET @cuepoint = FLOOR(1+RAND()*100);
        SET @screenEvent = FLOOR(1+RAND()*14);
        INSERT INTO Payment_ScreenRecordings(userid, moduleid, taskDescription, objectName, timeline, tabActions, cuePointID, applicationid, value, screenEventid, uiPath)
        VALUES (@userid, @moduleid, '', '', '{}', '{}', @cuepoint, '', NULL, @screenEvent, NULL);
        SET @rowNumber = @rowNumber-1;
   END WHILE;
END //
DELIMITER ;
CALL PopulateScreenRecordings();


DELIMITER //
CREATE PROCEDURE PopulateScreenAudioSync()
BEGIN
    SET @rowNumbers = 200;
    WHILE @rowNumbers > 0 DO
		INSERT INTO Payment_ScreenAudioSync(screenRecordingsId, transcriptionId)
        VALUES (@rowNumbers, @rowNumbers);
        SET @rowNumbers = @rowNumbers-1;
	END WHILE;
END //
DELIMITER ;
CALL PopulateScreenAudioSync();


DELIMITER //
CREATE PROCEDURE PopulateAI()
BEGIN
    SET @rowNumbers = 400;
    WHILE @rowNumbers > 0 DO
	SET @processingTime = 1+RAND()*30;
        SET @createdTime = TIMESTAMPADD(SECOND,FLOOR(RAND() * TIMESTAMPDIFF(SECOND, '2022-01-01 00:00:00', '2025-12-31 23:59:59')),'2022-01-01 00:00:00');
	SET @apikey = SHA2('APIKEY',512);
        SET @accuracy = 1+RAND()*99;
        SET @status = CASE WHEN @accuracy > 70 THEN 'SUCCESS' ELSE 'FAILED' END;
        SET @generatedResponse = ELT(1+RAND()*30,
        	'I am sorry, could you repeat that', 'I cannot understand your instruction', 'Payment succesful', 'I am sorry, could you repeat that',
		'I cannot understand your instruction', 'Payment successful', 'Transaction failed due to insufficient funds', 'Your request has been processed',
		'Unable to complete the transaction', 'Please provide more details', 'Your balance is low', 'Transaction declined by the bank',
		'Payment processing, please wait', 'Invalid account number', 'Your payment has been refunded', 'Service temporarily unavailable',
		'Your request timed out', 'Please check your internet connection', 'Payment approved', 'Transaction completed successfully',
		'Your card has expired', 'Invalid security code', 'Payment declined', 'Your account has been locked', 'Please contact customer support',
		'Your transaction is pending', 'Payment method not supported', 'Your request has been queued', 'Transaction limit exceeded',
		'Your payment is being reviewed', 'Please verify your identity', 'Your subscription has been renewed', 'Payment failed due to technical issues',
		'AI system error: Unable to process request', 'Internal server error: Please try again later', 'AI model is currently unavailable',
		'Error: AI encountered a bug while processing', 'AI is experiencing high latency; please wait', 'Error: AI response generation failed',
		'AI is undergoing maintenance; try again later', 'Error: AI could not interpret your input', 'AI is overloaded; please reduce request frequency',
		'Error: AI service is temporarily down');
        INSERT INTO Payment_AIProcessingLogs(syncID, utilizedPrompt, processingTime, status, createdAt, api_key, iterationNumber, accuracyObtained, generatedResponse)
        VALUES (FLOOR(1+RAND()*200), 'Categorize the following user input into the next stage of program flow', @processingTime, @status, @createdTime, @apikey, 0, @accuracy, @generatedResponse);
        SET @rowNumbers = @rowNumbers-1;
	END WHILE;
END //
DELIMITER ;
CALL PopulateAI();

	



