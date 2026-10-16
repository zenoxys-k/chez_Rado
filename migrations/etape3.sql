CREATE DATABASE if NOT EXISTS chez_Rado;
USE chez_Rado;

CREATE TABLE IF NOT EXISTS plats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prix INT NOT NULL,
    categorie VARCHAR(100)
);

INSERT INTO plats (nom, prix, categorie) VALUES
('Romazava', 7000, 'Plat malagasy'),
('Ravitoto sy henakisoa', 8000, 'Plat malagasy'),
('Akoho sy voanio', 8500, 'Plat malagasy'),
('Mi sao', 6000, 'Plat chinois'),
('Soupe chinoise', 5000, 'Soupe'),
('Mofo gasy (les 4)', 1000, 'Dessert et goûter'),
('Ranon''ampango', 500, 'Boisson');

CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

INSERT INTO categories (nom) VALUES
('Plat malagasy'),
('Plat chinois'),
('Soupe'),
('Dessert et goûter'),
('Boisson'),
('Plat japonais');

ALTER TABLE plats ADD COLUMN categorie_id INT,
ADD CONSTRAINT fk_plats_categories,
FOREIGN KEY REFERENCES categories(id);

UPDATE plats SET categorie_id = (SELECT id FROM categories WHERE nom = plats.categorie);

ALTER TABLE plats DROP COLUMN categorie;

CREATE TABLE IF NOT EXISTS commandes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    total INT NOT NULL,
    date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS commande_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commande_id INT,
    plat_id INT,
    quantite INT NOT NULL,
    prix_unitaire INT NOT NULL,
    montant INT NOT NULL,
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (plat_id) REFERENCES plats(id)
);