CREATE SCHEMA IF NOT EXISTS `Oficina` DEFAULT CHARACTER SET utf8;
USE `Oficina`;

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS `Oficina`.`Cliente` (
  `idCliente` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `CPF` VARCHAR(45) NOT NULL UNIQUE,
  `Endereço` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCliente`));

-- Tabela Mecânico
CREATE TABLE IF NOT EXISTS `Oficina`.`Mecânico` (
  `idMecânico` INT NOT NULL,
  `Nome` VARCHAR(45) NOT NULL,
  `Especialidade` VARCHAR(45) NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idMecânico`));

-- Tabela Equipe de mecânicos
CREATE TABLE IF NOT EXISTS `Oficina`.`Equipe de mecânicos` (
  `idEquipe` INT NOT NULL,
  `idMecânico` INT NOT NULL,
  PRIMARY KEY (`idEquipe`, `idMecânico`),
  CONSTRAINT `fk_Equipe de mecânicos_Mecânico1`
    FOREIGN KEY (`idMecânico`)
    REFERENCES `Oficina`.`Mecânico` (`idMecânico`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Veículo
CREATE TABLE IF NOT EXISTS `Oficina`.`Veículo` (
  `Chassi` VARCHAR(45) NOT NULL UNIQUE,
  `idCliente` INT NOT NULL,
  `idEquipe` INT NOT NULL,
  PRIMARY KEY (`Chassi`),
  CONSTRAINT `fk_Veículo_Cliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Oficina`.`Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Veículo_Equipe de mecânicos1`
    FOREIGN KEY (`idEquipe`)
    REFERENCES `Oficina`.`Equipe de mecânicos` (`idEquipe`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Ordem de Serviço
CREATE TABLE IF NOT EXISTS `Oficina`.`Ordem de Serviço` (
  `idOS` INT NOT NULL,
  `Data_emissão` DATE NOT NULL,
  `Valor` FLOAT NOT NULL,
  `Status` ENUM('Autorizado', 'em execução', 'concluído') NOT NULL,
  `Data_conclusão` DATE NOT NULL,
  `Veículo_Chassi` VARCHAR(45) NOT NULL,
  `idEquipe` INT NOT NULL,
  PRIMARY KEY (`idOS`),
  CONSTRAINT `fk_Ordem de Serviço_Veículo1`
    FOREIGN KEY (`Veículo_Chassi`)
    REFERENCES `Oficina`.`Veículo` (`Chassi`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Ordem de Serviço_Equipe de mecânicos1`
    FOREIGN KEY (`idEquipe`)
    REFERENCES `Oficina`.`Equipe de mecânicos` (`idEquipe`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Serviço
CREATE TABLE IF NOT EXISTS `Oficina`.`Serviço` (
  `idServiço` INT NOT NULL,
  `Descrição` VARCHAR(45) NOT NULL,
  `Valor` FLOAT NOT NULL,
  PRIMARY KEY (`idServiço`));

-- Tabela Peça
CREATE TABLE IF NOT EXISTS `Oficina`.`Peça` (
  `idPeça` INT NOT NULL,
  `Descrição` VARCHAR(45) NOT NULL,
  `Valor` FLOAT NOT NULL,
  PRIMARY KEY (`idPeça`));

-- Tabela Serviço/OS
CREATE TABLE IF NOT EXISTS `Oficina`.`Serviço/OS` (
  `idOS` INT NOT NULL,
  `idServiço` INT NOT NULL,
  PRIMARY KEY (`idOS`, `idServiço`),
  CONSTRAINT `fk_Ordem de Serviço_has_Serviço_Ordem de Serviço1`
    FOREIGN KEY (`idOS`)
    REFERENCES `Oficina`.`Ordem de Serviço` (`idOS`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Ordem de Serviço_has_Serviço_Serviço1`
    FOREIGN KEY (`idServiço`)
    REFERENCES `Oficina`.`Serviço` (`idServiço`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Peça/OS
CREATE TABLE IF NOT EXISTS `Oficina`.`Peça/OS` (
  `idPeça` INT NOT NULL,
  `idOS` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`idPeça`, `idOS`),
  CONSTRAINT `fk_Peça_has_Ordem de Serviço_Peça1`
    FOREIGN KEY (`idPeça`)
    REFERENCES `Oficina`.`Peça` (`idPeça`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Peça_has_Ordem de Serviço_Ordem de Serviço1`
    FOREIGN KEY (`idOS`)
    REFERENCES `Oficina`.`Ordem de Serviço` (`idOS`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
    
-- inserções
-- Clientes
insert into Cliente (idCliente, Nome, CPF, Endereço) values (1, 'Bryna Slocket', '923.895.989-01', '68606 Sheridan Junction');
insert into Cliente (idCliente, Nome, CPF, Endereço) values (2, 'Ertha Gladwell', '719.769.787-43', '78132 Village Green Park');
insert into Cliente (idCliente, Nome, CPF, Endereço) values (3, 'Josias Longhurst', '441.695.294-50', '32931 Dayton Alley');
insert into Cliente (idCliente, Nome, CPF, Endereço) values (4, 'Celestina Filipychev', '305.727.045-53', '04681 Columbus Lane');
insert into Cliente (idCliente, Nome, CPF, Endereço) values (5, 'Selie Loughman', '103.616.327-34', '1 Ridgeview Avenue');

-- Mecânicos
insert into Mecânico (idMecânico, Nome, Especialidade, Endereço) values (1, 'Maren Hellikes', 'Suzuki', '474 Burning Wood Terrace');
insert into Mecânico (idMecânico, Nome, Especialidade, Endereço) values (2, 'Eduard Phear', 'Mercury', '4508 Sommers Point');
insert into Mecânico (idMecânico, Nome, Especialidade, Endereço) values (3, 'Marielle Turvey', 'Toyota', '90 Kim Way');
insert into Mecânico (idMecânico, Nome, Especialidade, Endereço) values (4, 'Clara Elwin', 'Aston Martin', '8 Rigney Plaza');
insert into Mecânico (idMecânico, Nome, Especialidade, Endereço) values (5, 'Winn Scarlin', 'Ford', '23 Saint Paul Crossing');
insert into Mecânico (idMecânico, Nome, Especialidade, Endereço) values (6, 'Freda Asals', 'Pontiac', '46 Hallows Road');

-- Equipes
insert into `Equipe de mecânicos` (idEquipe, idMecânico) values (1, 1);
insert into `Equipe de mecânicos` (idEquipe, idMecânico) values (1, 2);
insert into `Equipe de mecânicos` (idEquipe, idMecânico) values (2, 3);
insert into `Equipe de mecânicos` (idEquipe, idMecânico) values (2, 4);
insert into `Equipe de mecânicos` (idEquipe, idMecânico) values (2, 5);
insert into `Equipe de mecânicos` (idEquipe, idMecânico) values (1, 6);

-- Veículos
insert into Veículo (Chassi, idCliente, idEquipe) values ('7KELWTY821799', 1, 2);
insert into Veículo (Chassi, idCliente, idEquipe) values ('9CEUTNI352117', 2, 1);
insert into Veículo (Chassi, idCliente, idEquipe) values ('7EQOHYJ048696', 3, 2);
insert into Veículo (Chassi, idCliente, idEquipe) values ('3AZDPOK220934', 4, 1);
insert into Veículo (Chassi, idCliente, idEquipe) values ('5ZPYVEC115621', 5, 1);
insert into Veículo (Chassi, idCliente, idEquipe) values ('5HTYLJZ336926', 1, 2);

-- OS
insert into `Ordem de Serviço` (idOS, Data_emissão, Valor, Status, Data_conclusão, Veículo_Chassi, idEquipe) values (1, '2021-10-27', 5022.82, 'concluído', '2022-12-12', '7KELWTY821799', 1);
insert into `Ordem de Serviço` (idOS, Data_emissão, Valor, Status, Data_conclusão, Veículo_Chassi, idEquipe) values (2, '2022-08-14', 7783.92, 'concluído', '2022-12-12', '9CEUTNI352117', 1);
insert into `Ordem de Serviço` (idOS, Data_emissão, Valor, Status, Data_conclusão, Veículo_Chassi, idEquipe) values (3, '2022-09-02', 9700.2, 'em execução', '2023-02-06', '7EQOHYJ048696', 2);
insert into `Ordem de Serviço` (idOS, Data_emissão, Valor, Status, Data_conclusão, Veículo_Chassi, idEquipe) values (4, '2022-01-09', 8014.93, 'Autorizado', '2023-05-10', '3AZDPOK220934', 2);
insert into `Ordem de Serviço` (idOS, Data_emissão, Valor, Status, Data_conclusão, Veículo_Chassi, idEquipe) values (5, '2022-06-16', 2925.99, 'em execução', '2023-09-10', '5ZPYVEC115621', 2);
insert into `Ordem de Serviço` (idOS, Data_emissão, Valor, Status, Data_conclusão, Veículo_Chassi, idEquipe) values (6, '2022-02-22', 8710.63, 'em execução', '2022-12-12', '5HTYLJZ336926', 1);

-- Serviços
insert into Serviço (idServiço, Descrição, Valor) values (1, 'Revisão básica', 234.71);
insert into Serviço (idServiço, Descrição, Valor) values (2, 'Revisão completa', 526.42);
insert into Serviço (idServiço, Descrição, Valor) values (3, 'Troca de óleo', 20.33);
insert into Serviço (idServiço, Descrição, Valor) values (4, 'Manutenção da embreagem', 85.02);
insert into Serviço (idServiço, Descrição, Valor) values (5, 'Alinhamento e balanceamento', 190.54);
insert into Serviço (idServiço, Descrição, Valor) values (6, 'Checagem do nível de água no radiador', 26.86);
insert into Serviço (idServiço, Descrição, Valor) values (7, 'Revisão dos componentes de freio', 69.65);

-- Peças
insert into Peça (idPeça, Descrição, Valor) values (1, 'Embreagem', 203.46);
insert into Peça (idPeça, Descrição, Valor) values (2, 'Caixa de direção hidráulica', 285.4);
insert into Peça (idPeça, Descrição, Valor) values (3, 'Freios', 616.2);
insert into Peça (idPeça, Descrição, Valor) values (4, 'Amortecedores', 483.56);
insert into Peça (idPeça, Descrição, Valor) values (5, 'Filtros', 939.86);
insert into Peça (idPeça, Descrição, Valor) values (6, 'Coxim de motor', 231.11);

-- Serviço/OS
insert into `Serviço/OS` (idOS, idServiço) values (1, 1);
insert into `Serviço/OS` (idOS, idServiço) values (2, 2);
insert into `Serviço/OS` (idOS, idServiço) values (3, 6);
insert into `Serviço/OS` (idOS, idServiço) values (4, 4);
insert into `Serviço/OS` (idOS, idServiço) values (5, 6);
insert into `Serviço/OS` (idOS, idServiço) values (6, 1);

-- Peça/OS
insert into `Peça/OS` (idPeça, idOS, Quantidade) values (1, 1, 1);
insert into `Peça/OS` (idPeça, idOS, Quantidade) values (6, 2, 4);
insert into `Peça/OS` (idPeça, idOS, Quantidade) values (1, 3, 1);
insert into `Peça/OS` (idPeça, idOS, Quantidade) values (2, 4, 1);
insert into `Peça/OS` (idPeça, idOS, Quantidade) values (1, 5, 1);
insert into `Peça/OS` (idPeça, idOS, Quantidade) values (5, 6, 2);


-- Queries
-- nome dos clientes que tiveram suas OS concluídas e chassi de seus veículos
SELECT 
    nome, Veículo_Chassi Carro
FROM
    `Ordem de Serviço`
        JOIN
    Veículo ON Veículo_Chassi = Chassi
        JOIN
    Cliente USING (idCliente)
WHERE
    Status = 'concluído';
    
-- Relação peça quantidade de peça e veículo
SELECT 
    Descrição, pos.Quantidade, Veículo_Chassi
FROM
    `Ordem de Serviço`
        JOIN
    `Peça/OS` pos USING (idOS)
        JOIN
    Peça USING (idPeça);