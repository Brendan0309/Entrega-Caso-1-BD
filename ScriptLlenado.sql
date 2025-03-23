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
	



