-- to call the procedures

SELECT * FROM products;
SELECT * FROM sales;

SELECT * FROM prod_params;
SELECT * FROM sale_params;

-- Calling the procedure without parameters 
CALL pr_buy_products();


-- Calling the procedure with parameters

-- When there is sufficient quantity in the store
CALL pr_buy_prods('Airpods Pro', 2);

-- When there is insufficient quantity in the store
CALL pr_buy_prods('iPad Air', 2);