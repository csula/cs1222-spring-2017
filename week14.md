# Views (revisit)

> Well-designed applications generally expose a public interface while keeping implementation details private, thereby enabling future design changes without impacting end users.

- What is meant by this claim?

## What Are Views?

A view is simply a mechanism for **querying** data.
- Views do not involve data storage -- views will not filling up your disk space.

Other users can then use your view to access data just as though they were querying tables directly.

You create a view by assigning a name to a select statement, and then storing the query for others to use.

```sql
CREATE VIEW customer_vw (cust_id,
  fed_id, cust_type_cd, address, city, state, zipcode )
AS SELECT cust_id,
  concat('ends in ', substr(fed_id, 8, 4)) fed_id, cust_type_cd,
  address,
  city,
  state,
  postal_code FROM customer;
```

When the create view statement is executed, the database server simply stores the view definition for future use; the query is not executed, and no data is retrieved or stored.

## Why use views?

If you create a table and allow users to query it, they will be able to access every column and every row in the table. Tables may include some columns that contain sensitive data, such as identification numbers or credit card numbers


This query limites only query to business customers:

```sql
CREATE VIEW business_customer_vw (cust_id,
fed_id, cust_type_cd, address, city,
state,
zipcode )
AS
SELECT cust_id,
concat('ends in ', substr(fed_id, 8, 4)) fed_id, cust_type_cd,
address,
city,
state,
postal_code
FROM customer
WHERE cust_type_cd = 'B'
```

**Data Aggregation**

Reporting applications generally require aggregated data, and views are a great way to make it appear as though data is being pre-aggregated and stored in the database.


**Hiding Complexity**

One of the most common reasons for deploying views is to shield end users from complexity of queries.


**Joining Partitioned Data**

Some database designs break large tables into multiple pieces in order to improve performance.


# Modify Structure of database

The SQL ALTER TABLE command is used to add, delete or modify columns in an existing table. You would also use ALTER TABLE command to add and drop various constraints on an existing table.

Some examples:

```sql
ALTER TABLE table_name ADD column_name datatype;
ALTER TABLE table_name DROP COLUMN column_name;
ALTER TABLE table_name MODIFY COLUMN column_name datatype;
ALTER TABLE table_name MODIFY column_name datatype NOT NULL;
```

Enforcing uniqueness:

```sql
ALTER TABLE table_name
ADD CONSTRAINT MyUniqueConstraint UNIQUE(column1, column2...);
```

Adding primary keys:

```sql
ALTER TABLE table_name
ADD CONSTRAINT MyPrimaryKey PRIMARY KEY (column1, column2...);
```

Removing primary keys:

```sql
ALTER TABLE table_name
DROP PRIMARY KEY;
```

Clear data from a table:

```sql
TRUNCATE TABLE  table_name;
```
