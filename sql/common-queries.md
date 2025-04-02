# Common SQL queries

## table, match fields and range

```sql
SELECT * FROM yourDatabase.yourTable
where SystemID = "the-id"
AND Subsystem="the-subsystem"
AND GMPTime BETWEEN 1664582400 AND 1664841600;
```

## Count duplicates

```sql
SELECT Count(yourColumn) - Count(DISTINCT yourColumn)
FROM yourDatabase.yourTable;
```
