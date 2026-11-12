-- =====================================================================
-- Banco de Dados I - Lista de exercícios: DQL Parte I
-- SELECT, WHERE, agregações e GROUP BY
-- Base: mercado_dql.sql (database "mercado")
-- =====================================================================


-- Questão 01
-- Linhas de fato_vendas sem cliente identificado.
SELECT COUNT(*) AS qtd_vendas_sem_cliente
FROM fato_vendas
WHERE id_cliente IS NULL;


-- Questão 02
-- Clientes diferentes que aparecem em fato_vendas (COUNT DISTINCT ignora NULL).
SELECT COUNT(DISTINCT id_cliente) AS qtd_clientes_distintos
FROM fato_vendas;


-- Questão 03
-- Faturamento total de 2025.
SELECT SUM(valor_total) AS faturamento_2025
FROM fato_vendas
WHERE data_venda BETWEEN '2025-01-01' AND '2025-12-31';


-- Questão 04
-- Marcas (sem repetição, A–Z) dos produtos da categoria Higiene.
SELECT DISTINCT marca
FROM dim_produto
WHERE categoria = 'Higiene'
ORDER BY marca;


-- Questão 05
-- Valor médio de valor_total no canal Aplicativo.
SELECT ROUND(AVG(valor_total), 2) AS media_valor_aplicativo
FROM fato_vendas
WHERE canal = 'Aplicativo';


-- Questão 06
-- Produtos de Bebidas com preço de tabela acima de R$ 10,00.
SELECT COUNT(*) AS qtd_bebidas_acima_10
FROM dim_produto
WHERE categoria = 'Bebidas'
  AND preco_tabela > 10;


-- Questão 07
-- Produto mais caro do catálogo (empate: primeiro nome em ordem alfabética).
SELECT nome_produto, marca, preco_tabela
FROM dim_produto
ORDER BY preco_tabela DESC, nome_produto ASC
LIMIT 1;


-- Questão 08
-- Quantidade de produtos por categoria.
SELECT categoria, COUNT(*) AS qtd_produtos
FROM dim_produto
GROUP BY categoria
ORDER BY qtd_produtos DESC, categoria ASC;


-- Questão 09
-- Preço médio de tabela por categoria.
SELECT categoria, ROUND(AVG(preco_tabela), 2) AS preco_medio
FROM dim_produto
GROUP BY categoria
ORDER BY preco_medio DESC;


-- Questão 10
-- Clientes por cidade, apenas cidades com pelo menos 60 clientes.
SELECT cidade, COUNT(*) AS qtd_clientes
FROM dim_cliente
GROUP BY cidade
HAVING COUNT(*) >= 60
ORDER BY qtd_clientes DESC, cidade ASC;


-- Questão 11
-- Clientes que não informaram e-mail.
SELECT COUNT(*) AS qtd_sem_email
FROM dim_cliente
WHERE email IS NULL;


-- Questão 12
-- Clientes do sexo feminino nascidas entre 01/01/1990 e 31/12/1999.
SELECT COUNT(*) AS qtd_clientes_f_anos_90
FROM dim_cliente
WHERE sexo = 'F'
  AND data_nascimento BETWEEN '1990-01-01' AND '1999-12-31';


-- Questão 13
-- Clientes com "Ana" como primeiro nome (o espaço após "Ana" exclui Analu, Anabela etc.).
SELECT COUNT(*) AS qtd_clientes_ana
FROM dim_cliente
WHERE nome LIKE 'Ana %';


-- Questão 14
-- Lojas por UF, apenas UFs com mais de 3 lojas.
SELECT uf, COUNT(*) AS qtd_lojas
FROM dim_loja
GROUP BY uf
HAVING COUNT(*) > 3
ORDER BY qtd_lojas DESC;


-- Questão 15
-- Lojas inauguradas antes de 01/01/2007, da mais antiga para a mais recente.
SELECT nome_loja, cidade, data_inauguracao
FROM dim_loja
WHERE data_inauguracao < '2007-01-01'
ORDER BY data_inauguracao ASC;


-- Questão 16
-- Faturamento de cada canal em 2025.
SELECT canal, SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE data_venda BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY canal
ORDER BY faturamento DESC;


-- Questão 17
-- Canal Loja física: linhas de venda e faturamento por forma de pagamento.
SELECT forma_pagamento,
       COUNT(*)         AS qtd_linhas,
       SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE canal = 'Loja física'
GROUP BY forma_pagamento
ORDER BY faturamento DESC;


-- Questão 18
-- Top 10 produtos por unidades vendidas (empate: menor id_produto).
SELECT id_produto, SUM(quantidade) AS unidades_vendidas
FROM fato_vendas
GROUP BY id_produto
ORDER BY unidades_vendidas DESC, id_produto ASC
LIMIT 10;


-- Questão 19
-- Top 5 lojas por faturamento em 2024.
SELECT id_loja, SUM(valor_total) AS faturamento_2024
FROM fato_vendas
WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY id_loja
ORDER BY faturamento_2024 DESC
LIMIT 5;


-- Questão 20
-- Linhas de venda por loja, apenas lojas com mais de 300 linhas.
SELECT id_loja, COUNT(*) AS qtd_linhas
FROM fato_vendas
GROUP BY id_loja
HAVING COUNT(*) > 300
ORDER BY qtd_linhas DESC;


-- Questão 21
-- Clientes com 70 ou mais linhas de venda (desconsiderando vendas sem cliente).
SELECT id_cliente, COUNT(*) AS qtd_linhas
FROM fato_vendas
WHERE id_cliente IS NOT NULL
GROUP BY id_cliente
HAVING COUNT(*) >= 70
ORDER BY qtd_linhas DESC, id_cliente ASC;


-- Questão 22
-- Linhas com desconto (> 0) e valor médio desse desconto (2 casas decimais).
SELECT COUNT(*)                AS qtd_linhas_com_desconto,
       ROUND(AVG(desconto), 2) AS desconto_medio
FROM fato_vendas
WHERE desconto > 0;


-- Questão 23
-- Menor e maior valor_total de uma linha de venda em dezembro de 2025.
SELECT MIN(valor_total) AS menor_valor,
       MAX(valor_total) AS maior_valor
FROM fato_vendas
WHERE data_venda BETWEEN '2025-12-01' AND '2025-12-31';


-- Questão 24
-- Linhas de venda e faturamento do dia 24/12/2025.
SELECT COUNT(*)         AS qtd_linhas,
       SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE data_venda = '2025-12-24';


-- Questão 25
-- Canal Site, 2025, com desconto: valor bruto e percentual de desconto.
-- Ordena do maior percentual para o menor (empate: menor id_venda), 10 primeiras linhas.
-- O percentual é exibido com 2 casas, mas a ordenação usa o valor exato,
-- para que o arredondamento não crie empates artificiais.
SELECT id_venda,
       quantidade * preco_unitario AS valor_bruto,
       desconto,
       valor_total,
       ROUND(desconto * 100.0 / (quantidade * preco_unitario), 2) AS percentual_desconto
FROM fato_vendas
WHERE canal = 'Site'
  AND data_venda BETWEEN '2025-01-01' AND '2025-12-31'
  AND desconto > 0
ORDER BY desconto / (quantidade * preco_unitario) DESC, id_venda ASC
LIMIT 10;
