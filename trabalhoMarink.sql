-- Criação do banco de dados
CREATE DATABASE bd_restaurante;
USE bd_restaurante;

-- Tabela de Mesas
CREATE TABLE mesa (
    id_mesa INT PRIMARY KEY AUTO_INCREMENT,
    status_mesa ENUM("Livre", "Ocupada", "Sobremesa", "Ocupada-Ociosa") NOT NULL
);

-- Tabela de Funcionários
CREATE TABLE funcionario (
    id_funcionario INT PRIMARY KEY AUTO_INCREMENT,
    nome_funcionario VARCHAR(50) NOT NULL
);

-- Tabela de Clientes
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    cpf VARCHAR(15) UNIQUE NOT NULL,
    id_mesa INT,
    id_funcionario INT,
    FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa),
    FOREIGN KEY (id_funcionario) REFERENCES funcionario(id_funcionario)
);

-- Tabela de Produtos 
CREATE TABLE produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    preco FLOAT NOT NULL,
    tipo ENUM("Prato", "Bebida") NOT NULL,
    estoque_minimo INT NOT NULL,
    marca VARCHAR(255)
);

-- Tabela de Pedidos 
CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    id_produto INT,
    quantidade INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);

-- Tabela de Pagamentos
CREATE TABLE pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    totalPagamento FLOAT NOT NULL,
    formaDePagamento ENUM("Dinheiro", "Cartão", "Pix") NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- inserts:
-- Populando a tabela de Mesas
INSERT INTO mesa (status_mesa) VALUES 
('Livre'),
('Ocupada'),
('Sobremesa'),
('Ocupada-Ociosa'),
('Livre'),
('Ocupada');

-- Populando a tabela de Funcionários
INSERT INTO funcionario (nome_funcionario) VALUES 
('João Silva'),
('Maria Oliveira'),
('Carlos Costa'),
('Ana Paula'),
('Pedro Santos');

-- Populando a tabela de Clientes
INSERT INTO cliente (nome, cpf, id_mesa, id_funcionario) VALUES 
('Ana Silva', '123.456.789-00', 2, 1),       
('Carlos Pereira', '987.654.321-00', 2, 2),  
('Mariana Souza', '111.222.333-44', 3, 3),   
('Bruno Lima', '555.666.777-88', 4, 4),     
('Luciana Mendes', '999.888.777-66', 6, 5),  
('Fernando Costa', '444.333.222-11', 1, 3), 
('Sofia Gomes', '222.111.000-99', 3, 1);    

-- Populando a tabela de Produtos (Pratos e Bebidas)
INSERT INTO produto (nome_produto, preco, tipo, estoque_minimo, marca) VALUES 
('Pizza Margherita', 35.00, 'Prato', 5, 'Itália'),
('Refrigerante Cola', 5.00, 'Bebida', 10, 'Coca-Cola'),
('Lasanha Bolonhesa', 45.00, 'Prato', 3, 'Bella Italia'),
('Suco de Laranja', 6.50, 'Bebida', 8, 'Natural One'),
('Espaguete Carbonara', 40.00, 'Prato', 4, 'Pasta House'),
('Água Mineral', 3.00, 'Bebida', 15, 'Crystal');

-- Populando a tabela de Pedidos
INSERT INTO pedido (id_cliente, id_produto, quantidade) VALUES 
(1, 1, 2),  
(1, 2, 3),  
(2, 3, 1),  
(3, 4, 2),  
(4, 5, 1),  
(5, 6, 2),  
(6, 1, 1),  
(7, 2, 2);  

-- Populando a tabela de Pagamentos
INSERT INTO pagamento (id_cliente, totalPagamento, formaDePagamento) VALUES 
(1, 115.00, 'Cartão'),     
(2, 45.00, 'Pix'),        
(3, 13.00, 'Dinheiro'),   
(4, 40.00, 'Cartão'),      
(5, 6.00, 'Pix'),          
(6, 35.00, 'Dinheiro'),    
(7, 10.00, 'Cartão');      

-- querys
-- Faça um código SQL que exiba as vendas por funcionário, incluindo todas as mesas atendidas por ele e o valor total gasto pelos clientes (com 3 colunas no resultado).
SELECT f.nome_funcionario AS 'Nome do Funcionário', m.id_mesa AS 'Mesa Atendida', SUM(p.totalPagamento) AS 'Total Gasto pelo Cliente' FROM funcionario f
JOIN cliente c ON f.id_funcionario = c.id_funcionario
JOIN mesa m ON c.id_mesa = m.id_mesa
JOIN pagamento p ON c.id_cliente = p.id_cliente
GROUP BY f.nome_funcionario, m.id_mesa;
    
-- Faça um código SQL que exiba todos os produtos, que uma determinada mesa (Pediu/Consumiu).
SELECT p.nome_produto AS 'Produto Consumido', pd.quantidade AS 'Quantidade', p.preco AS 'Preço Unitário', (pd.quantidade * p.preco) AS 'Total Gasto' FROM mesa m
JOIN cliente c ON m.id_mesa = c.id_mesa
JOIN pedido pd ON c.id_cliente = pd.id_cliente
JOIN produto p ON pd.id_produto = p.id_produto
WHERE m.id_mesa = 1; -- Inserir o id da mesa desejada marink

-- Implemente uma store procedure que exiba redefina o status de uma Mesa para o Status "Livre".
DELIMITER $$

CREATE PROCEDURE RedefinirStatusMesa(LID_MESA INT)
BEGIN
    UPDATE mesa
    SET status_mesa = 'Livre'
    WHERE id_mesa = LID_MESA;
END $$

DELIMITER ;
 -- Chamada da PROCEDURE
CALL RedefinirStatusMesa(2);
SELECT id_mesa, status_mesa FROM mesa WHERE id_mesa = 2;



