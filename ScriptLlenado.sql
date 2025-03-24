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
INSERT INTO Payment_AudioEvent(name, enabled) VALUES
('Payment Registration', 1),
('New Transaction', 1),
('Action Cancelation', 1),
('Clarification', 1),
('Payment Confirmation',1),
('Source Provided',1),
('Destination Provided',1),
('IBAN Acccount Provided', 1),
('Card Number Provided', 1),
('Prompt repetition', 1),
('Unknown Response', 1);
DELIMITER //
CREATE PROCEDURE PopulateCuePoints()
BEGIN
    SET @rowNumbers = 100;
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
	SET @rowNumbers = 100;
	WHILE @rowNumbers > 0 DO
		SET @userid = FLOOR(1+RAND()*40);
        SET @audioId = FLOOR(1+RAND()*300);
        SET @audioEvent = FLOOR(1+RAND()*11);
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
    SET @rowNumbers = 100;
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
INSERT INTO Payment_Currencies (name, acronym, symbol) VALUES
('Dólar Estadounidense', 'USD', '$'),
('Euro', 'EUR', '€'),
('Colón', 'CRC', '₡'),
('Libra Esterlina', 'GBP', '£'),
('Yen Japonés', 'JPY', '¥');
INSERT INTO Payment_Countries(name, currencyid) VALUES
('Estados Unidos', 1),
('Costa Rica', 3),
('Reino Unido', 4),
('Japón', 5),
('España', 2),
('Francia', 2);
INSERT INTO Payment_Languages (name, culture, countryid)
VALUES 
('English USA', 'EN', 1),
('English UK', 'EN-UK', 3),
('Español Costa Rica', 'CRC', 2),
('Frances', 'FR',  6),
('Japones','JP', 4);
INSERT INTO Payment_Modules(name, languageId) VALUES
('Menu Principal', 3),
('Registrar Pago', 3),
('Registrar Metodo Pago', 3),
('Agendar Pago', 3);
DROP PROCEDURE PopulateScreenRecordings;
DELIMITER //
CREATE PROCEDURE PopulateScreenRecordings()
BEGIN
    SET @rowNumber = 100;
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

	



