# Conditional Logic

Purpose: SQL logic to branch in one direction or another depending on the values of certain columns or expressions. Take different paths in a query depending on the value of the column.

Example: when querying customer information, want to retrieve either the fname/lname columns from the individual table or the name column from the business table depending on what type of customer is encountered.


### CASE Expressions

```
CASE 
  WHEN x1 THEN y2
  WHEN x2 THEN y2
  ELSE default
END
```

Recall from last time with outer joins:

```
SELECT c.cust_id, c.fed_id, c.cust_type_cd, 
  CONCAT(i.fname, ' ', i.lname) indiv_name, b.name business_name
FROM customer c 
   LEFT OUTER JOIN individual i 
      ON c.cust_id = i.cust_id
   LEFT OUTER JOIN business b 
      ON c.cust_id = b.cust_id;
```

So now we can do it slightly smarter (to avoid the `NULL`):

```
SELECT c.cust_id, c.fed_id,
  CASE
     WHEN c.cust_type_cd = 'I'
        THEN CONCAT(i.fname, ' ', i.lname)
     WHEN c.cust_type_cd = 'B'
        THEN b.name
     ELSE 'unknown'
  END name
  FROM customer c 
    LEFT OUTER JOIN individual i 
       ON c.cust_id = i.cust_id
    LEFT OUTER JOIN business b 
       ON c.cust_id = b.cust_id;
```

### Revisiting Subqueries

Consider the following correlated subquery that does not use out joins to acchieve the same goal:

```
SELECT c.cust_id, c.fed_id, 
  CASE
    WHEN c.cust_type_cd = 'I' THEN 
      (SELECT CONCAT(i.fname, ' ', i.lname)
       FROM individual i
       WHERE i.cust_id = c.cust_id) 
    WHEN c.cust_type_cd = 'B' THEN
      (SELECT b.name
       FROM business b
       WHERE b.cust_id = c.cust_id)
    ELSE 'Unknown' 
  END name
  FROM customer c;
```

### Simple CASE Expression

```
CASE x
   WHEN x1 THEN y1
   WHEN x2 THEN y2
   ELSE default
END
```

This is definitely less flexible -- however syntax is simpler (and presumably) shorter therefore easier to understand and follow:

```
CASE customer.cust_type_cd 
  WHEN 'I' THEN 
    (SELECT CONCAT(i.fname, ' ', i.lname) 
     FROM individual I
     WHERE i.cust_id = customer.cust_id)
   WHEN 'B' THEN 
    (SELECT b.name
     FROM business b
     WHERE b.cust_id = customer.cust_id) 
   ELSE 'Unknown Customer Type'
END
```

Exercise: plug this back into the original query from above.

### Pivot or Rotation

Suppose that we need to rotate row results into columns.

```
SELECT YEAR(open_date) year, COUNT(*) how_many
  FROM account
    WHERE open_date > '1999-12-31' AND open_date < '2006-01-01' 
  GROUP BY YEAR(open_date);
```

Now let's rotate the solution into columns:

```
SELECT 
   SUM(CASE
         WHEN EXTRACT(YEAR FROM open_date) = 2000 THEN 1
         ELSE 0
       END) year_2000,
   SUM(CASE
         WHEN EXTRACT(YEAR FROM open_date) = 2001 THEN 1 
         ELSE 0
       END) year_2001, 
   SUM(CASE
   ...
   END) year_2005
   FROM account
   WHERE open_date > '1999-12-31' AND open_date < '2006-01-01';
```

Exercise: fill in the `...`

### Check EXISTS

If we need to determine whether a relationship exists between two entities without regard for the quantity.  Let's go back to our example from earlier:

Question: determine if a customer has a check account, and a savings account.  Answer `Y` or `N` for the two columns.

```
SELECT c.cust_id, c.fed_id, c.cust_type_cd, 
  CASE
     WHEN EXISTS (SELECT 1 FROM account a 
                  WHERE a.cust_id = c.cust_id AND a.product_cd = 'CHK') 
          THEN 'Y' 
     ELSE 'N'
  END has_checking, 
  CASE
     WHEN EXISTS (SELECT 1 FROM account a 
                  WHERE a.cust_id = c.cust_id AND a.product_cd = 'SAV') 
     THEN 'Y' 
     ELSE 'N'
  END has_savings
FROM customer c;
```

Exercise:  Use a simple case expression to count the number of accounts for each customer, and then returns either `None`, `1`, `2`, or `3+`.

You can also test for `NULL` using CASE with 

```
SELECT emp_id, fname, lname, CASE
   WHEN title IS NULL THEN 'Unknown'
   ELSE title END
FROM employee;
```


## LAB

Rewrite the following query so that the result set contains a single row with four columns (one for each branch). Name the four columns branch_1 through branch_4.

```
SELECT open_branch_id, COUNT(*)
  FROM account
  GROUP BY open_branch_id;
```

Rewrite the following query, which uses a simple case expression, so that the same results are achieved using a searched case expression. Try to use as few when clauses as possible.

```
SELECT emp_id, 
  CASE title
    WHEN 'President' THEN 'Management'
    WHEN 'Vice President' THEN 'Management' 
    WHEN 'Treasurer' THEN 'Management'
    WHEN 'Loan Manager' THEN 'Management'
    WHEN 'Operations Manager' THEN 'Operations' 
    WHEN 'Head Teller' THEN 'Operations'
    WHEN 'Teller' THEN 'Operations'
    ELSE 'Unknown'
  END
FROM employee;
```


