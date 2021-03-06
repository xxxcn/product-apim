--CREATE TABLE   UM_DOMAIN
IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_DOMAIN]') AND TYPE IN (N'U'))
CREATE TABLE UM_DOMAIN(
            UM_DOMAIN_ID INTEGER IDENTITY(1,1) NOT NULL,
            UM_DOMAIN_NAME VARCHAR(255),
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_DOMAIN_ID, UM_TENANT_ID)
);


--CREATE TABLE   UM_SYSTEM_USER
IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_SYSTEM_USER]') AND TYPE IN (N'U'))
CREATE TABLE UM_SYSTEM_USER ( 
             UM_ID INTEGER IDENTITY(1,1) NOT NULL, 
             UM_USER_NAME VARCHAR(255) NOT NULL, 
             UM_USER_PASSWORD VARCHAR(255) NOT NULL,
             UM_SALT_VALUE VARCHAR(31),
             UM_REQUIRE_CHANGE  BIT DEFAULT 0,
             UM_CHANGED_TIME DATETIME NOT NULL,
             UM_TENANT_ID INTEGER DEFAULT 0, 
             PRIMARY KEY (UM_ID, UM_TENANT_ID), 
             UNIQUE(UM_USER_NAME, UM_TENANT_ID)
); 


ALTER TABLE UM_ROLE ADD UM_SHARED_ROLE BIT DEFAULT 0;


--CREATES TABLE UM_MODULE
IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_MODULE]') AND TYPE IN (N'U'))
CREATE TABLE UM_MODULE(
	UM_ID INTEGER  IDENTITY(1,1) NOT NULL,
	UM_MODULE_NAME VARCHAR(100),
	UNIQUE(UM_MODULE_NAME),
	PRIMARY KEY(UM_ID)
);

IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_MODULE_ACTIONS]') AND TYPE IN (N'U'))
CREATE TABLE UM_MODULE_ACTIONS(
	UM_ACTION VARCHAR(255) NOT NULL,
	UM_MODULE_ID INTEGER NOT NULL,
	PRIMARY KEY(UM_ACTION, UM_MODULE_ID),
	FOREIGN KEY (UM_MODULE_ID) REFERENCES UM_MODULE(UM_ID) ON DELETE CASCADE
);

ALTER TABLE UM_PERMISSION ADD UM_MODULE_ID INTEGER DEFAULT 0;

ALTER TABLE UM_ROLE_PERMISSION ADD UM_DOMAIN_ID INTEGER;

declare @Command  nvarchar(1000);
select @Command = 
'ALTER TABLE UM_ROLE_PERMISSION DROP CONSTRAINT ' + k.name from sys.tables t join sys.key_constraints k on t.object_id = k.parent_object_id where t.name = 'UM_ROLE_PERMISSION' and k.name like 'UQ%';
EXECUTE(@command);

ALTER TABLE UM_ROLE_PERMISSION ADD CONSTRAINT UQ_UM_ROLE_PERMISSION UNIQUE (UM_PERMISSION_ID, UM_ROLE_NAME, UM_TENANT_ID, UM_DOMAIN_ID);
ALTER TABLE UM_ROLE_PERMISSION ADD CONSTRAINT UM_ROLE_PERMISSION_UM_DOMAIN FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE


INSERT INTO UM_DOMAIN (UM_DOMAIN_NAME, UM_TENANT_ID) VALUES ('PRIMARY', -1234);
INSERT INTO UM_DOMAIN (UM_DOMAIN_NAME, UM_TENANT_ID) VALUES ('SYSTEM', -1234);
INSERT INTO UM_DOMAIN (UM_DOMAIN_NAME, UM_TENANT_ID) VALUES ('INTERNAL', -1234);


INSERT INTO UM_DOMAIN (UM_TENANT_ID) SELECT UM_ID FROM UM_TENANT;
UPDATE UM_DOMAIN SET UM_DOMAIN_NAME = 'PRIMARY' WHERE UM_DOMAIN_NAME IS NULL AND UM_TENANT_ID IN (SELECT UM_ID FROM UM_TENANT);

INSERT INTO UM_DOMAIN (UM_TENANT_ID) SELECT UM_ID FROM UM_TENANT;
UPDATE UM_DOMAIN SET UM_DOMAIN_NAME = 'SYSTEM' WHERE UM_DOMAIN_NAME IS NULL AND UM_TENANT_ID IN (SELECT UM_ID FROM UM_TENANT);

INSERT INTO UM_DOMAIN (UM_TENANT_ID) SELECT UM_ID FROM UM_TENANT;
UPDATE UM_DOMAIN SET UM_DOMAIN_NAME = 'INTERNAL' WHERE UM_DOMAIN_NAME IS NULL AND UM_TENANT_ID IN (SELECT UM_ID FROM UM_TENANT);


UPDATE UM_ROLE_PERMISSION SET UM_ROLE_PERMISSION.UM_DOMAIN_ID = UM_DOMAIN.UM_DOMAIN_ID FROM UM_ROLE_PERMISSION INNER JOIN UM_DOMAIN ON 
UM_DOMAIN.UM_TENANT_ID = UM_ROLE_PERMISSION.UM_TENANT_ID WHERE UM_ROLE_PERMISSION.UM_DOMAIN_ID IS NULL AND UM_DOMAIN.UM_DOMAIN_NAME = 'PRIMARY';


IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_SHARED_USER_ROLE]') AND TYPE IN (N'U'))
CREATE TABLE UM_SHARED_USER_ROLE(
    UM_ROLE_ID INTEGER NOT NULL,
    UM_USER_ID INTEGER NOT NULL,
    UM_USER_TENANT_ID INTEGER NOT NULL,
    UM_ROLE_TENANT_ID INTEGER NOT NULL,
    UNIQUE(UM_USER_ID,UM_ROLE_ID,UM_USER_TENANT_ID, UM_ROLE_TENANT_ID),
    FOREIGN KEY(UM_ROLE_ID,UM_ROLE_TENANT_ID) REFERENCES UM_ROLE(UM_ID,UM_TENANT_ID) ON DELETE CASCADE ,
    FOREIGN KEY(UM_USER_ID,UM_USER_TENANT_ID) REFERENCES UM_USER(UM_ID,UM_TENANT_ID) ON DELETE CASCADE
);

IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_ACCOUNT_MAPPING]') AND TYPE IN (N'U'))
CREATE TABLE UM_ACCOUNT_MAPPING(
	UM_ID INTEGER IDENTITY(1,1),
	UM_USER_NAME VARCHAR(255) NOT NULL,
	UM_TENANT_ID INTEGER NOT NULL,
	UM_USER_STORE_DOMAIN VARCHAR(100),
	UM_ACC_LINK_ID INTEGER NOT NULL,
	UNIQUE(UM_USER_NAME, UM_TENANT_ID, UM_USER_STORE_DOMAIN, UM_ACC_LINK_ID),
	FOREIGN KEY (UM_TENANT_ID) REFERENCES UM_TENANT(UM_ID) ON DELETE CASCADE,
	PRIMARY KEY (UM_ID)
);


ALTER TABLE UM_CLAIM ADD UM_MAPPED_ATTRIBUTE_DOMAIN VARCHAR(255);
ALTER TABLE UM_CLAIM ADD  UM_CHECKED_ATTRIBUTE SMALLINT;
ALTER TABLE UM_CLAIM ADD  UM_READ_ONLY SMALLINT;
ALTER TABLE UM_CLAIM ADD CONSTRAINT UQ_UM_CLAIM UNIQUE(UM_DIALECT_ID, UM_CLAIM_URI, UM_TENANT_ID,UM_MAPPED_ATTRIBUTE_DOMAIN);

declare @Command1  nvarchar(1000);
select @Command1 = 
'ALTER TABLE UM_HYBRID_USER_ROLE DROP CONSTRAINT ' + k.name from sys.tables t join sys.key_constraints k on t.object_id = k.parent_object_id where t.name = 'UM_HYBRID_USER_ROLE' and k.name like 'UQ%';
EXECUTE(@command1);

ALTER TABLE UM_HYBRID_USER_ROLE ADD  UM_DOMAIN_ID INTEGER;
ALTER TABLE UM_HYBRID_USER_ROLE ADD CONSTRAINT UM_HYBRID_USER_ROLE_UM_DOMAIN FOREIGN KEY (UM_DOMAIN_ID, UM_TENANT_ID) REFERENCES UM_DOMAIN(UM_DOMAIN_ID, UM_TENANT_ID) ON DELETE CASCADE;
ALTER TABLE UM_HYBRID_USER_ROLE ADD CONSTRAINT UQ_UM_HYBRID_USER_ROLE UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID, UM_DOMAIN_ID);


IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_SYSTEM_ROLE]') AND TYPE IN (N'U'))
CREATE TABLE UM_SYSTEM_ROLE(
            UM_ID INTEGER IDENTITY(1, 1) NOT NULL,
            UM_ROLE_NAME VARCHAR(255),
            UM_TENANT_ID INTEGER DEFAULT 0,
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
);

-- create table UM_SYSTEM_USER_ROLE
IF NOT EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[UM_SYSTEM_USER_ROLE]') AND TYPE IN (N'U'))
CREATE TABLE UM_SYSTEM_USER_ROLE(
            UM_ID INTEGER IDENTITY(1, 1),
            UM_USER_NAME VARCHAR(255),
            UM_ROLE_ID INTEGER NOT NULL,
            UM_TENANT_ID INTEGER DEFAULT 0,
            UNIQUE (UM_USER_NAME, UM_ROLE_ID, UM_TENANT_ID),
            FOREIGN KEY (UM_ROLE_ID, UM_TENANT_ID) REFERENCES UM_SYSTEM_ROLE(UM_ID, UM_TENANT_ID),
            PRIMARY KEY (UM_ID, UM_TENANT_ID)
);
