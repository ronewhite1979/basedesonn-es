-- Création de la base de données
CREATE DATABASE cinema;

-- Utilisation de la base de données
USE cinema;

-- Création de la table Cinema
CREATE TABLE Cinema (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(255) NOT NULL
);

-- Création de la table Salle
CREATE TABLE Salle (
  id INT PRIMARY KEY AUTO_INCREMENT,
  numero INT NOT NULL,
  capacite INT NOT NULL,
  cinema_id INT,
  FOREIGN KEY (cinema_id) REFERENCES Cinema(id)
);

-- Création de la table Film
CREATE TABLE Film (
  id INT PRIMARY KEY AUTO_INCREMENT,
  titre VARCHAR(255) NOT NULL,
  duree_minutes INT NOT NULL
);

-- Création de la table Utilisateur
CREATE TABLE Utilisateur (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(255) NOT NULL,
  prenom VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  mot_de_passe VARCHAR(255) NOT NULL,
  role ENUM('client', 'admin', 'cinema') NOT NULL
);

-- Création de la table Seance
CREATE TABLE Seance (
  id INT PRIMARY KEY AUTO_INCREMENT,
  horaire DATETIME NOT NULL,
  salle_id INT,
  film_id INT,
  utilisateur_id INT,
  FOREIGN KEY (salle_id) REFERENCES Salle(id),
  FOREIGN KEY (film_id) REFERENCES Film(id),
  FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id)
);

-- Création de la table Tarif
CREATE TABLE Tarif (
  id INT PRIMARY KEY AUTO_INCREMENT,
  categorie VARCHAR(255) NOT NULL,
  prix DECIMAL(5,2) NOT NULL
);

-- Création de la table Reservation
CREATE TABLE Reservation (
  id INT PRIMARY KEY AUTO_INCREMENT,
  seance_id INT,
  utilisateur_id INT,
  tarif_id INT,
  nombre_de_places INT NOT NULL,
  FOREIGN KEY (seance_id) REFERENCES Seance(id),
  FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
  FOREIGN KEY (tarif_id) REFERENCES Tarif(id)
);

------------------------------------------------------------------------------------------------

-- Ajout des contraintes pour la table Cinema
ALTER TABLE Cinema
ADD CONSTRAINT pk_cinema_id PRIMARY KEY (id);

-- Ajout des contraintes pour la table Salle
ALTER TABLE Salle
ADD CONSTRAINT pk_salle_id PRIMARY KEY (id),
ADD CONSTRAINT fk_salle_cinema_id FOREIGN KEY (cinema_id) REFERENCES Cinema(id),
ADD CONSTRAINT chk_salle_capacite CHECK (capacite > 0);

-- Ajout des contraintes pour la table Film
ALTER TABLE Film
ADD CONSTRAINT pk_film_id PRIMARY KEY (id),
ADD CONSTRAINT chk_film_duree_minutes CHECK (duree_minutes > 0);

-- Ajout des contraintes pour la table Utilisateur
ALTER TABLE Utilisateur
ADD CONSTRAINT pk_utilisateur_id PRIMARY KEY (id),
ADD CONSTRAINT chk_utilisateur_role CHECK (role IN ('admin', 'cinema', 'client')),
ADD CONSTRAINT uq_utilisateur_email UNIQUE (email);

-- Ajout des contraintes pour la table Tarif
ALTER TABLE Tarif
ADD CONSTRAINT pk_tarif_id PRIMARY KEY (id),
ADD CONSTRAINT chk_tarif_prix CHECK (prix > 0);

-- Ajout des contraintes pour la table Seance
ALTER TABLE Seance
ADD CONSTRAINT pk_seance_id PRIMARY KEY (id),
ADD CONSTRAINT fk_seance_salle_id FOREIGN KEY (salle_id) REFERENCES Salle(id),
ADD CONSTRAINT fk_seance_film_id FOREIGN KEY (film_id) REFERENCES Film(id),
ADD CONSTRAINT fk_seance_utilisateur_id FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
ADD CONSTRAINT uq_seance_salle_id_horaire UNIQUE (salle_id, horaire);

-- Ajout des contraintes pour la table Reservation
ALTER TABLE Reservation
ADD CONSTRAINT pk_reservation_id PRIMARY KEY (id),
ADD CONSTRAINT fk_reservation_seance_id FOREIGN KEY (seance_id) REFERENCES Seance(id),
ADD CONSTRAINT fk_reservation_utilisateur_id FOREIGN KEY (utilisateur_id) REFERENCES Utilisateur(id),
ADD CONSTRAINT fk_reservation_tarif_id FOREIGN KEY (tarif_id) REFERENCES Tarif(id),
ADD CONSTRAINT chk_reservation_nombre_de_places CHECK (nombre_de_places > 0);

-------------------------------------------------------------------------------------------------------

-- Insertion des données factices pour les Cinemas
INSERT INTO Cinema (nom) VALUES ('Cinema 1'), ('Cinema 2');

-- Insertion des données factices pour les Salles
INSERT INTO Salle (numero, capacite, cinema_id) VALUES
(1, 100, 1),
(2, 150, 1),
(1, 100, 2),
(2, 200, 2);

-- Insertion des données factices pour les Films
INSERT INTO Film (titre, duree_minutes) VALUES
('Film A', 120),
('Film B', 90),
('Film C', 140);

-- Insertion des données factices pour les Utilisateurs
INSERT INTO Utilisateur (nom, prenom, email, mot_de_passe, role) VALUES
('Admin', 'John', 'admin@cinema.com', 'password', 'admin'),
('Cinema1', 'Alice', 'cinema1@cinema.com', 'password', 'cinema'),
('Cinema2', 'Bob', 'cinema2@cinema.com', 'password', 'cinema'),
('Client', 'Emma', 'client@cinema.com', 'password', 'client');

-- Insertion des données factices pour les Tarifs
INSERT INTO Tarif (categorie, prix) VALUES
('Plein tarif', 9.20),
('Étudiant', 7.60),
('Moins de 14 ans', 5.90);

-- Insertion des données factices pour les Seances
INSERT INTO Seance (horaire, salle_id, film_id, utilisateur_id) VALUES
('2023-05-01 14:00:00', 1, 1, 2),
('2023-05-01 16:30:00', 2, 2, 2),
('2023-05-01 19:00:00', 1, 3, 2),
('2023-05-01 21:30:00', 1, 1, 3),
('2023-05-01 14:00:00', 2, 2, 3),
('2023-05-01 16:30:00', 1, 3, 3);

-- Insertion des données factices pour les Reservations
INSERT INTO Reservation (seance_id, utilisateur_id, tarif_id, nombre_de_places) VALUES
(1, 4, 1, 2),
(2, 4, 2, 1),
(3, 4, 3, 3),
(4, 4, 1, 4),
(5, 4, 2, 1),
(6, 4, 3, 2);

-------------------------------------------------------------------------------------------

-- Création d'un nouvel utilisateur 'cinema_admin' et attribution des privilèges
CREATE USER 'cinema_admin'@'localhost' IDENTIFIED BY 'MotDePasseAdmin';
GRANT ALL PRIVILEGES ON cinema.* TO 'cinema_admin'@'localhost';

-- Création d'un nouvel utilisateur 'cinema_manager' et attribution des privilèges
CREATE USER 'cinema_manager'@'localhost' IDENTIFIED BY 'MotDePasseGestionnaire';
GRANT SELECT, INSERT, UPDATE, DELETE ON cinema.Seance, cinema.Reservation TO 'cinema_manager'@'localhost';

-- Création d'un nouvel utilisateur 'cinema_client' et attribution des privilèges
CREATE USER 'cinema_client'@'localhost' IDENTIFIED BY 'MotDePasseClient';
GRANT SELECT ON cinema.Film, cinema.Seance, cinema.Salle, cinema.Cinema TO 'cinema_client'@'localhost';
GRANT INSERT, UPDATE, DELETE ON cinema.Reservation TO 'cinema_client'@'localhost' WHERE utilisateur_id = USER();

--------------------------------------------------------------------------------------------------------

-- Pour sauvegarder la base de données

mysqldump





