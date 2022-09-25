-- Schema E-commerce
drop schema `E-commerce`;
CREATE SCHEMA IF NOT EXISTS `E-commerce` DEFAULT CHARACTER SET utf8 ;
USE `E-commerce` ;

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS `E-commerce`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(45) NOT NULL,
  `documento` ENUM('CNPJ', 'CPF') NOT NULL,
  `nro_documento` VARCHAR(25) NOT NULL,
  `endereço` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCliente`));

-- Tabela Cartão
CREATE TABLE IF NOT EXISTS `E-commerce`.`Cartão` (
  `idCartão` INT NOT NULL AUTO_INCREMENT,
  `Num_cartão` VARCHAR(16) NOT NULL,
  `Nome_titular` VARCHAR(45) NOT NULL,
  `Vencimento` DATE NOT NULL,
  `CVV` CHAR(3) NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idCartão`),
  CONSTRAINT `fk_Cartão_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `E-commerce`.`Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Forma_Pagamento
CREATE TABLE IF NOT EXISTS `E-commerce`.`Forma_Pagamento` (
  `idForma_Pagamento` INT NOT NULL AUTO_INCREMENT,
  `Tipo` ENUM('Cartão de crédito', 'Cartão de débito', 'Pix', 'Paypal', 'Boleto') NOT NULL,
  `Valor_total` FLOAT NOT NULL,
  `Parcelas` INT NOT NULL,
  `Valor_parcelas` FLOAT NOT NULL,
  `Vencimento_parcela` DATETIME NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  `Cartão_idCartão` INT NULL,
  PRIMARY KEY (`idForma_Pagamento`, `Cliente_idCliente`),
  CONSTRAINT `fk_Forma_Pagamento_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `E-commerce`.`Cliente` (`idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Forma_Pagamento_Cartão1`
    FOREIGN KEY (`Cartão_idCartão`)
    REFERENCES `E-commerce`.`Cartão` (`idCartão`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Entrega
CREATE TABLE IF NOT EXISTS `E-commerce`.`Entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `cod_rastreio` CHAR(13) NOT NULL UNIQUE,
  `Status` ENUM('Em transporte', 'Entregue', 'Cancelado') NOT NULL,
  PRIMARY KEY (`idEntrega`));


-- Tabela Pedido
CREATE TABLE IF NOT EXISTS `E-commerce`.`Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `Status_pedido` ENUM('Em processamento', 'Confirmado', 'Cancelado') NOT NULL,
  `descrição` VARCHAR(45) NOT NULL,
  `Frete` DECIMAL(4,2) NOT NULL DEFAULT 0,
  `idPagamento` INT NOT NULL,
  `idCliente` INT NOT NULL,
  `Cod_Entrega` INT NOT NULL,
  PRIMARY KEY (`idPedido`, `idPagamento`, `idCliente`),
  CONSTRAINT `fk_Pedido_Forma_Pagamento1`
    FOREIGN KEY (`idPagamento` , `idCliente`)
    REFERENCES `E-commerce`.`Forma_Pagamento` (`idForma_Pagamento` , `Cliente_idCliente`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Pedido_Entrega1`
    FOREIGN KEY (`Cod_Entrega`)
    REFERENCES `E-commerce`.`Entrega` (`idEntrega`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Produto
CREATE TABLE IF NOT EXISTS `E-commerce`.`Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Categoria` ENUM('Eletrônico', 'Roupa', 'Alimento', 'Brinquedo', 'Móvel') NOT NULL,
  `Descrição` VARCHAR(45) NOT NULL,
  `Valor` DECIMAL(6,2) NOT NULL,
  `Avaliação` FLOAT NULL DEFAULT 0,
  `Dimensão` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`idProduto`));

-- Tabela Fornecedor
CREATE TABLE IF NOT EXISTS `E-commerce`.`Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Nome_fantasia` VARCHAR(45) NULL,
  `Razão_Social` VARCHAR(45) NOT NULL,
  `CNPJ` VARCHAR(25) NOT NULL UNIQUE,
  `Contato` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idFornecedor`)
);

-- Tabela Fornece_Produto
CREATE TABLE IF NOT EXISTS `E-commerce`.`Fornece_Produto` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `E-commerce`.`Fornecedor` (`idFornecedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `E-commerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Estoque
CREATE TABLE IF NOT EXISTS `E-commerce`.`Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Local` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEstoque`));

-- Tabela Produto_em_Estoque
CREATE TABLE IF NOT EXISTS `E-commerce`.`Produto_em_Estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `E-commerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `E-commerce`.`Estoque` (`idEstoque`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Produto_Pedido
CREATE TABLE IF NOT EXISTS `E-commerce`.`Produto_Pedido` (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `E-commerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `E-commerce`.`Pedido` (`idPedido`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

-- Tabela Terceiro_vendedor
CREATE TABLE IF NOT EXISTS `E-commerce`.`Terceiro_vendedor` (
  `idTerceiro` INT NOT NULL AUTO_INCREMENT,
  `Nome_fantasia` VARCHAR(45) NULL,
  `Razão_Social` VARCHAR(45) NOT NULL,
  `Local` VARCHAR(45) NOT NULL,
  `Contato` VARCHAR(25) NOT NULL,
  `Documento` ENUM('CNPJ', 'CPF') NOT NULL,
  `nro_documento` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`idTerceiro - vendedor`));

-- Tabela Produto_vendedor-(terceiro)
alter table `Produto_vendedor-(terceiro)` change `Terceiro - vendedor_idTerceiro - vendedor` `idTerceiro-vendedor` INT NOT NULL;
CREATE TABLE IF NOT EXISTS `E-commerce`.`Produto_vendedor-(terceiro)` (
  `idTerceiro-vendedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NOT NULL,
  PRIMARY KEY (`Terceiro - vendedor_idTerceiro - vendedor`, `Produto_idProduto`),
  CONSTRAINT `fk_Terceiro - vendedor_has_Produto_Terceiro - vendedor1`
    FOREIGN KEY (`Terceiro - vendedor_idTerceiro - vendedor`)
    REFERENCES `E-commerce`.`Terceiro_vendedor` (`idTerceiro - vendedor`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Terceiro - vendedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `E-commerce`.`Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);


-- inserção de dados

-- Clientes
insert into Cliente (idCliente, nome, sobrenome, documento, nro_documento, endereço) values (1, 'Elysee', 'Waud', 'CNPJ', '65.845.354/0001-11', '819 Sunbrook Lane'),
											    (2, 'Magnum', 'Skamell', 'CPF', '987.215.962-52', '08393 Kenwood Street'),
											    (3, 'Jana', 'Comusso', 'CPF', '514.875.985-47', '60089 Northridge Circle'),
											    (4, 'Hermie', 'Veelers', 'CPF', '651.845.321-58', '6 Jackson Alley'),
											    (5, 'Tiffy', 'Alekseicik', 'CPF', '654.357.984-63', '3 Banding Lane'),
											    (6, 'Phillip', 'Simkin', 'CPF', '653.874.512-56', '75 Northport Crossing');


-- Cartões
select * from Cartão;
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (1, '8583637703042744', 'Phillip Simkin', '2022-04-20', 666, 6);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (2, '2925217139017891', 'Elysee Waud', '2021-10-05', 200, 1);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (3, '1722542410443693', 'Jana Comusso', '2022-09-19', 403, 3);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (4, '9822739552132887', 'Tiffy Alekseicik', '2021-09-26', 656, 5);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (5, '5411325927196359', 'Hermie Veelers', '2022-07-07', 523, 4);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (6, '0510843156632732', 'Jana Comusso', '2021-10-04', 996, 3);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (7, '0491229928090705', 'Jana Comusso', '2022-04-22', 203, 3);
insert into Cartão  (idCartão, Num_cartão, Nome_titular, Vencimento, CVV, Cliente_idCliente) values (8, '7772158391890115', 'Magnum Skamell', '2022-05-28', 277, 2);


-- Formas de pagamento
select * from Forma_Pagamento;
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (1, 'Cartão de crédito', 8350.27, 12, 695.85, '2022-01-07', 4, 5);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (2, 'Paypal', 95.09, 1, 95.09, '2022-06-23', 3, null);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (3, 'Paypal', 38.38, 1, 38.38, '2021-11-19', 5, null);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (4, 'Pix', 89.58, 1, 89.58, '2022-05-19', 3, null);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (5, 'Cartão de crédito', 864.53, 10, 86.45, '2021-09-26', 6, 7);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (6, 'Paypal', 21.38, 1, 21.38, '2022-02-28', 1, null);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (7, 'Cartão de débito', 244.80, 1, 244.80, '2022-04-25', 1, 2);
insert into Forma_Pagamento (idForma_Pagamento, Tipo, Valor_Total, Parcelas, Valor_Parcelas, Vencimento_Parcela, Cliente_idCliente, Cartão_idCartão) values (8, 'Pix', 35.49, 1, 35.49, '2022-03-08', 1, null);


-- Entregas
insert into Entrega (idEntrega, cod_rastreio, Status) values (1, 'BR639937863BR', 'Entregue');
insert into Entrega (idEntrega, cod_rastreio, Status) values (2, 'BR178954937BR', 'Entregue');
insert into Entrega (idEntrega, cod_rastreio, Status) values (3, 'BR216981356BR', 'Em transporte');
insert into Entrega (idEntrega, cod_rastreio, Status) values (4, 'BR036342688BR', 'Entregue');
insert into Entrega (idEntrega, cod_rastreio, Status) values (5, 'BR987334455BR', 'Cancelado');
insert into Entrega (idEntrega, cod_rastreio, Status) values (6, 'BR023942763BR', 'Cancelado');
insert into Entrega (idEntrega, cod_rastreio, Status) values (7, 'BR101090900BR', 'Em transporte');
insert into Entrega (idEntrega, cod_rastreio, Status) values (8, 'BR179550403BR', 'Cancelado');

-- Pedidos
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (1, 'Confirmado', 'Distributed eco-centric superstructure', 28.11, 1, 4, 1);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (2, 'Confirmado', 'Progressive reciprocal installation', 19.58, 2, 3, 2);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (3, 'Confirmado', 'Automated dedicated policy', 38.33, 3, 5, 3);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (4, 'Confirmado', 'Customizable bi-directional projection', 81.91, 4, 3, 4);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (5, 'Cancelado', 'Pre-emptive asynchronous strategy', 38.61, 5, 6, 5);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (6, 'Cancelado', 'Open-architected secondary leverage', 63.2, 6, 1, 6);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (7, 'Confirmado', 'Business-focused optimizing installation', 61.21, 7, 1, 7);
insert into Pedido (idPedido, Status_pedido, descrição, Frete, idPagamento, idCliente, Cod_Entrega) values (8, 'Cancelado', 'Implemented 5th generation middleware', 62.97, 8, 1, 8);

-- Produtos
select * from Produto;
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (1, 'Móvel', 'Armário 6 portas', 8149.68, '1.3', '68x68x44 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (2, 'Eletrônico', 'Notebook Lenovo L340 gaming', 4418.02, '8.9', '12x21x34 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (3, 'Roupa', 'Camiseta nike', 86.26, null, '77x45x4 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (4, 'Móvel', 'Mesa de janter 6 cadeiras', 379.40, '4.9', '84x15x6 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (5, 'Móvel', 'Hack para TV', 299.05, null, '87x85x96 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (6, 'Eletrônico', 'TV 50"', 2383.07, null, '98x0x7 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (7, 'Alimento', 'Snacks', 84.20, null, '95x8x7 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (8, 'Móvel', 'Sofá 4 lugares', 530.70, null, '1x66x62 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (9, 'Eletrônico', 'Tablet 7"', 1105.76, '4.0', '26x36x52 cm');
insert into Produto (idProduto, Categoria, Descrição, Valor, Avaliação, Dimensão) values (10, 'Roupa', 'Calça jeans', 123.17, '4.8', '7x5x1 cm');

-- Fornecedor
select * from Fornecedor;
insert into Fornecedor (idFornecedor, Nome_fantasia, Razão_Social, CNPJ, Contato) values (1, 'Dextera', 'Dextera Inc.', '67.960.349/1767-62', '+55 (17) 96517-4215');
insert into Fornecedor (idFornecedor, Nome_fantasia, Razão_Social, CNPJ, Contato) values (2, null, 'DXP Enterprises, Inc.', '08.333.376/5921-12', '+55 (11) 92721-8788');
insert into Fornecedor (idFornecedor, Nome_fantasia, Razão_Social, CNPJ, Contato) values (3, 'Seneca', 'Seneca Foods Corp.', '74.966.672/2148-28', '+55 (51) 98212-0665');
insert into Fornecedor (idFornecedor, Nome_fantasia, Razão_Social, CNPJ, Contato) values (4, 'Universal Electronics', 'Universal Electronics Inc.', '85.841.958/7285-50', '+55 (61) 90388-5026');
insert into Fornecedor (idFornecedor, Nome_fantasia, Razão_Social, CNPJ, Contato) values (5, null, 'Eletronic Holdings Inc.', '23.756.971/5112-61', '+55 (68) 97437-4582');

-- Fornece_Produto
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (1, 1);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (4, 2);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (2, 3);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (1, 4);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (1, 5);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (4, 6);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (3, 7);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (1, 8);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (5, 9);
insert into Fornece_Produto (Fornecedor_idFornecedor, Produto_idProduto) values (2, 10);

-- Estoque
insert into Estoque (idEstoque, Local) values (1, '2986 Moland Court');
insert into Estoque (idEstoque, Local) values (2, '140 Lukken Pass');
insert into Estoque (idEstoque, Local) values (3, '43438 Elgar Alley');
insert into Estoque (idEstoque, Local) values (4, '88 Duke Park');

-- Produto_em_Estoque
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (1, 1, 97);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (2, 2, 92);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (3, 3, 32);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (4, 1, 90);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (5, 1, 23);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (6, 2, 14);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (7, 4, 56);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (8, 1, 8);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (9, 2, 45);
insert into Produto_em_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) values (10, 3, 23);

-- Produto_Pedido
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (4, 1, 2);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (9, 2, 10);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (4, 3, 10);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (5, 4, 1);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (10, 5, 4);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (9, 6, 4);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (3, 7, 5);
insert into Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) values (2, 8, 8);

-- Terceiros
insert into Terceiro_vendedor (idTerceiro, Nome_fantasia, Razão_Social, Local, Contato, Documento, nro_documento) values (1, null, 'Robert Half', '2436 Main Center', '55 08 96974-6663', 'CPF', '667.983.040-23');
insert into Terceiro_vendedor (idTerceiro, Nome_fantasia, Razão_Social, Local, Contato, Documento, nro_documento) values (2, null, 'Annie Leonheart', '203 Pennsylvania Terrace', '55 57 96740-9577', 'CPF', '073.509.431-48');
insert into Terceiro_vendedor (idTerceiro, Nome_fantasia, Razão_Social, Local, Contato, Documento, nro_documento) values (3, 'Westamerica', 'Westamerica Bancorporation', '5259 Buhler Court', '55 96 95826-2567', 'CNPJ', '27.143.246/2006-87');
insert into Terceiro_vendedor (idTerceiro, Nome_fantasia, Razão_Social, Local, Contato, Documento, nro_documento) values (4, 'Cardiome', 'Cardiome Corporation', '776 Namekagon Parkway', '55 23 90545-8413', 'CNPJ', '49.697.852/0258-58');

-- Produto_vendedor-(terceiro)
insert into `Produto_vendedor-(terceiro)` (`idTerceiro-vendedor`, Produto_idProduto, Quantidade) values (1, 6, 28);
insert into `Produto_vendedor-(terceiro)` (`idTerceiro-vendedor`, Produto_idProduto, Quantidade) values (2, 9, 35);
insert into `Produto_vendedor-(terceiro)` (`idTerceiro-vendedor`, Produto_idProduto, Quantidade) values (3, 3, 44);
insert into `Produto_vendedor-(terceiro)` (`idTerceiro-vendedor`, Produto_idProduto, Quantidade) values (4, 3, 22);


-- consultas
-- Quantos pedidos foram feitos por cada cliente?
SELECT 
    idCliente,
    CONCAT(nome, ' ', sobrenome) Cliente,
    COUNT(idPedido) pedidos
FROM
    Pedido
        JOIN
    Cliente USING (idCliente)
GROUP BY idCliente;

-- Algum vendedor também é fornecedor?
SELECT 
    idTerceiro, t.Razão_Social
FROM
    Terceiro_vendedor t
        JOIN
    Fornecedor USING (Razão_Social);

-- Relação de produtos, fornecedores e estoques;
SELECT 
    p.Descrição, f.Razão_Social, idEstoque, e.Local
FROM
    Produto p
        JOIN
    Produto_em_Estoque pe ON idProduto = pe.Produto_idProduto
        JOIN
    Estoque e ON idEstoque = pe.Estoque_idEstoque
        JOIN
    Fornece_Produto fp ON idProduto = fp.Produto_idProduto
        JOIN
    Fornecedor f ON fp.Fornecedor_idFornecedor = f.idFornecedor;

-- Relação de nomes dos fornecedores e nomes dos produtos;
SELECT 
    f.Razão_Social, p.Descrição
FROM
    Produto p
        JOIN
    Fornece_Produto fp ON idProduto = fp.Produto_idProduto
        JOIN
    Fornecedor f ON fp.Fornecedor_idFornecedor = f.idFornecedor;
