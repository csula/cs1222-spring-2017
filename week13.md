# Transactions (continued)

Let's do an exercise:

```sql
SET AUTOCOMMIT=0;
START TRANSACTION
SAVEPOINT beforefoolishness;

UPDATE ... ETC

ROLLBACK TO SAVEPOINT beforefoolishness;
COMMIT;
```

# Indexes and Constraints

When inserting data into a database,  database server does not attempt to put the data in any particular location within the table.

 -- This is inefficient!

We can speed this up with Index creation.  For example:

```SQL
ALTER TABLE department
ADD INDEX dept_name_idx (name);
```

To see index on a table:

```SQL
SHOW INDEX FROM department
```

- `PRIMARY` index is created automatically with `PRIMARY KEY`

```SQL
CREATE TABLE department
  (dept_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(20) NOT NULL,
  CONSTRAINT pk_department PRIMARY KEY (dept_id) );
```

To change the index: `ALTER TABLE department DROP INDEX dept_name_idx;`

You can also enforce unique INDEX with `ALTER TABLE department ADD UNIQUE dept_name_idx (name);`


### Multicolumn Indexes

For example

```sql
ALTER TABLE employee
ADD INDEX emp_names_idx (lname, fname);
```

Note that this is will be useful for queries that specify the first and last names or just the last name, but you cannot use it for queries that specify only the employee’s first name.

### B-tree Indexes

![b-tree)(resources/images/b-tree.png)

### Bitmap Indexes

For columns that contain only a small number of values across a large number of rows (known as low-cardinality data), a different indexing strategy is needed.

![b-tree)(resources/images/bitmap.png)

### Text Indexes

If your database stores documents, you may need to allow users to search for words or phrases in the documents. You certainly don’t want the server to open each document and scan for the desired text each time a search is requested, but traditional indexing strategies don’t work for this situation.


# Index In Depth

Consider the following query:

```SQL
SELECT emp_id, fname, lname
FROM employee
WHERE emp_id IN (1, 3, 9, 15);

```

For this query, the server can use the primary key index on the `emp_id` column to locate employee IDs 1, 3, 9, and 15 in the `employee` table, and then visit each of the four rows to retrieve the first and last name columns.

Index Optimized:

```SQL
SELECT cust_id, SUM(avail_balance) tot_bal
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id;
```

We can try the `EXPLAIN` command:

```sql
EXPLAIN SELECT cust_id, SUM(avail_balance) tot_bal 
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id;
```

We will see:

```
*************************** 1. row ***************************
              id: 1 
     select_type: SIMPLE
           table: account 
            type: index
   possible_keys: fk_a_cust_id 
             key: fk_a_cust_id
         key_len: 4 
             ref: NULL
            rows: 24
           Extra: Using where
1 row in set (0.00 sec)
```
- The `fk_a_cust_id` index is used to find rows for the `where`
- After reading the the index, the server expects to read all 24 rows from `account` table to get balance.

Improvements:

```sql
ALTER TABLE account
ADD INDEX acc_bal_idx (cust_id, avail_balance);
```

```sql
EXPLAIN SELECT cust_id, SUM(avail_balance) tot_bal 
FROM account
WHERE cust_id IN (1, 5, 9, 11)
GROUP BY cust_id;
```

```
*************************** 1. row ***************************
            id: 1 select_type: SIMPLE
         table: account type: range
 possible_keys: acc_bal_idx key: acc_bal_idx
key_len: 4 ref: NULL
          rows: 8
         Extra: Using where; Using index
1 row in set (0.01 sec)
```

- The optimizer is using the new `acc_bal_idx` index instead of the `fk_a_cust_id` index.
- The optimizer anticipates needing only eight rows instead of 24.

## Downside of Indexes

- every time a row is added to or removed from a table, all indexes on that table must be modified.
- Indexes also require disk space as well as care and feeding


