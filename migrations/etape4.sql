
-- ============================================
-- ETAPE 1 : CREATION DE LA TABLE PLATS
-- ============================================

CREATE TABLE plats (
    id NUMBER(10) PRIMARY KEY,
    nom VARCHAR2(255) NOT NULL,
    prix NUMBER(10) NOT NULL,
    categorie VARCHAR2(100)
);

CREATE SEQUENCE seq_plats
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_plats_id
BEFORE INSERT ON plats
FOR EACH ROW
WHEN (NEW.id IS NULL)
BEGIN
    SELECT seq_plats.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
/

-- ============================================
-- ETAPE 2 : INSERTION DES PLATS
-- ============================================

INSERT INTO plats (nom, prix, categorie) VALUES
('Romazava', 7000, 'Plat malagasy');

INSERT INTO plats (nom, prix, categorie) VALUES
('Ravitoto sy henakisoa', 8000, 'Plat malagasy');

INSERT INTO plats (nom, prix, categorie) VALUES
('Akoho sy voanio', 8500, 'Plat malagasy');

INSERT INTO plats (nom, prix, categorie) VALUES
('Mi sao', 6000, 'Plat chinois');

INSERT INTO plats (nom, prix, categorie) VALUES
('Soupe chinoise', 5000, 'Soupe');

INSERT INTO plats (nom, prix, categorie) VALUES
('Mofo gasy (les 4)', 1000, 'Dessert et goûter');

INSERT INTO plats (nom, prix, categorie) VALUES
('Ranon''ampango', 500, 'Boisson');


-- ============================================
-- ETAPE 3 : CREATION DE LA TABLE CATEGORIES
-- ============================================

CREATE TABLE categories (
    id NUMBER(10) PRIMARY KEY,
    nom VARCHAR2(100) NOT NULL
);

CREATE SEQUENCE seq_categories
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_categories_id
BEFORE INSERT ON categories
FOR EACH ROW
WHEN (NEW.id IS NULL)
BEGIN
    SELECT seq_categories.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
/

-- ============================================
-- ETAPE 4 : INSERTION DES CATEGORIES
-- ============================================

INSERT INTO categories (nom) VALUES ('Plat malagasy');
INSERT INTO categories (nom) VALUES ('Plat chinois');
INSERT INTO categories (nom) VALUES ('Soupe');
INSERT INTO categories (nom) VALUES ('Dessert et goûter');
INSERT INTO categories (nom) VALUES ('Boisson');
INSERT INTO categories (nom) VALUES ('Plat japonais');


-- ============================================
-- ETAPE 5 : AJOUT DE LA COLONNE CATEGORIE_ID
-- ET DE LA CLE ETRANGERE
-- ============================================

ALTER TABLE plats
ADD (categorie_id NUMBER(10));

ALTER TABLE plats
ADD CONSTRAINT fk_plats_categories
FOREIGN KEY (categorie_id)
REFERENCES categories(id);


-- ============================================
-- ETAPE 6 : MISE A JOUR DES CATEGORIES
-- ============================================

UPDATE plats
SET categorie_id = (
    SELECT id
    FROM categories
    WHERE categories.nom = plats.categorie
);

COMMIT;


-- ============================================
-- ETAPE 7 : SUPPRESSION DE L'ANCIENNE COLONNE
-- ============================================

ALTER TABLE plats
DROP COLUMN categorie;


-- ============================================
-- ETAPE 8 : CREATION DE LA TABLE COMMANDES
-- ============================================

CREATE TABLE commandes (
    id NUMBER(10) PRIMARY KEY,
    total NUMBER(10) NOT NULL,
    date_commande DATE NOT NULL
);

CREATE SEQUENCE seq_commandes
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_commandes_id
BEFORE INSERT ON commandes
FOR EACH ROW
WHEN (NEW.id IS NULL)
BEGIN
    SELECT seq_commandes.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
/


-- ============================================
-- ETAPE 9 : CREATION DE LA TABLE COMMANDE_DETAILS
-- ============================================

CREATE TABLE commande_details (
    id NUMBER(10) PRIMARY KEY,
    commande_id NUMBER(10),
    plat_id NUMBER(10),
    quantite NUMBER(10) NOT NULL,
    prix_unitaire NUMBER(10) NOT NULL,
    montant NUMBER(10) NOT NULL,

    CONSTRAINT fk_details_commandes
        FOREIGN KEY (commande_id)
        REFERENCES commandes(id),

    CONSTRAINT fk_details_plats
        FOREIGN KEY (plat_id)
        REFERENCES plats(id)
);

CREATE SEQUENCE seq_commande_details
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_commande_details_id
BEFORE INSERT ON commande_details
FOR EACH ROW
WHEN (NEW.id IS NULL)
BEGIN
    SELECT seq_commande_details.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;

INSERT INTO commandes(total, date_commande) VALUES (0, SYSDATE);

INSERT INTO commande_details (commande_id, plat_id, quantite, prix_unitaire, montant)
VALUES (1, 1, 2, 7000, 14000);
INSERT INTO commande_details (commande_id, plat_id, quantite, prix_unitaire, montant)
VALUES (1, 2, 1, 8000, 8000);

UPDATE commandes c
SET c.total = (
    SELECT SUM(cd.montant)
    FROM commande_details cd
    WHERE cd.commande_id = c.id
)
WHERE c.id = 1;
/


-- ============================================
-- ETAPE 10 : CREATION DE LA TABLE CLIENTS
-- ============================================

CREATE TABLE clients (
    id NUMBER(10) PRIMARY KEY,
    nom VARCHAR2(255) NOT NULL,
    email VARCHAR2(255) NOT NULL UNIQUE,
    telephone VARCHAR2(20) NOT NULL
);

CREATE SEQUENCE seq_clients
START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_clients_id
BEFORE INSERT ON clients
FOR EACH ROW
WHEN (NEW.id IS NULL)
BEGIN
    SELECT seq_clients.NEXTVAL
    INTO :NEW.id
    FROM dual;
END;
/

COMMIT;
