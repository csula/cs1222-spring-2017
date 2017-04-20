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


