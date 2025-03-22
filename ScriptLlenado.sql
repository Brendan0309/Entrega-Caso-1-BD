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

DROP PROCEDURE PopulateUsers;
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

call PopulatePeople();
call PopulateUsers();
