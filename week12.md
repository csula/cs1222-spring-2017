# Transactions

Key point: **concurrency**.  We need the infrastructure to execute multiple SQL statements concurrently.

## Multiuser Database

While one user write (or `insert`) data, can another user read (or `select`) data?  This can potentially cause problem.  At best wrong answer, at worst corrup the database.

### Locking

When some portion of the database is locked, any other users wishing to modify (or possibly read) that data must wait until the lock has been released.

1. Database writers must request and receive from the server a **write lock** to modify data, and database readers must request and receive from the server a read lock to query data.

2. Database writers must request and receive from the server a write lock to modify data, but readers do not need any type of lock to query data.

Discussion: what are the pros and cons for each approach?

### Granularities

- Table locks
- Page locks
- Row locks

## Transaction

Let's talk about **atomic** which states:

> grouping together multiple SQL statements such that either all or none of the statements succeed

- Grouping statements together
- Commit the statements
- Rollback if needed


Transaction can be created in one of two ways:

- An active transaction is always associated with a database session, so there is no need or method to explicitly begin a transaction. When the current transaction ends, the server automatically begins a new transaction for your session. (Oracle)

- Unless you explicitly begin a transaction, individual SQL statements are automattically committed independently of one another. To begin a transaction, you must first issue a command. (MySQL and SQL Server)

Need to shut off `auto-commit` feature.

```SQL
SET AUTOCOMMIT = 0
```

### Terminating Transactions

You can finish transaction with one of two possible commands:

- `commit` or
- `rollback`

It's possible for the system to finish the transaction without your consent.  This happens under one of four scenarios:

- Server shutsdown while transaction is taking place.  When the system comes up again it automatically roll back.

- Modify schema (with the `alter`) command before transaction completes.

- Start another transaction before the current transaction completes.

- The server prematurely ends your transaction because the server detects a dead-lock and decides that your transaction is the culprit.


