---
title: Hibernate Native SQL
author: NC
category: hibernate
public: true
---

```java
session.createSQLQuery("SELECT ID, NAME, BIRTHDATE FROM CATS").list();
```
+ This will return a `List` of `Object arrays` with scalar values for each column in the CATS table.
Hibernate will use `ResultSetMetadata` to deduce the actual order and types of the returned scalar values.

```
sess.createSQLQuery("SELECT * FROM CATS")
    .addScalar("ID", Hibernate.LONG)
    .addScalar("NAME")
    .addScalar("BIRTHDATE”)
    .list();
```
+ This will return `Object arrays`, but now it will not use `ResultSetMetadata` but will instead explicitly get the ID, NAME and BIRTHDATE column as respectively a `Long`, `String` and a `Short` from the underlying result set.

```
sess.createSQLQuery("SELECT c.ID, NAME, BIRTHDATE, DOG_ID, D_ID, D_NAME FROM CATS c, DOGS d WHERE c.DOG_ID = d.D_ID")
    .addEntity("cat", Cat.class)
    .addJoin("cat.dog”);
```
+ In this example, the returned Cat's will have their dog property fully initialized without any extra roundtrip to the database.

```
sess.createSQLQuery("SELECT ID, NAME, BIRTHDATE, D_ID, D_NAME, CAT_ID FROM CATS c, DOGS d WHERE c.ID = d.CAT_ID")
    .addEntity("cat", Cat.class)
    .addJoin("cat.dogs”);
```
+ In this example cat has a one-to-many relation to dog class.

+ Problems can arise when returning multiple entities of the same type or when the default alias/column names are not enough.

+ Until now, the result set column names are assumed to be the same as the column names specified in the mapping document. This can be problematic for SQL queries that join multiple tables, since the same column names can appear in more than one table.

```java
sess.createSQLQuery("SELECT c.*, m.*  FROM CATS c, CATS m WHERE c.MOTHER_ID = c.ID")
    .addEntity("cat", Cat.class)
    .addEntity("mother", Cat.class);
```

+ The query was intended to return two Cat instances per row: a cat and its mother. The query will, however, fail because there is a conflict of names; the instances are mapped to the same column names. Also, on some databases the returned column aliases will most likely be on the form "c.ID", "c.NAME", etc. which are not equal to the columns specified in the mappings ("ID" and "NAME").

```java
sess.createSQLQuery("SELECT {cat.*}, {m.*}  FROM CATS c, CATS m WHERE c.MOTHER_ID = m.ID")
    .addEntity("cat", Cat.class)
    .addEntity("mother", Cat.class);
```
+ This form is not vulnerable to column name duplication. Hibernate injects the SQL column aliases for each property.

+ It is possible to apply a `ResultTransformer` to native SQL queries, allowing it to return non-managed entities:

    ```java
    sess.createSQLQuery("SELECT NAME, BIRTHDATE FROM CATS")
        .setResultTransformer(Transformers.aliasToBean(CatDTO.class));
    ```

  + The above query will return a list of `CatDTO` which has been instantiated and injected the values of NAME and BIRTHNAME into its corresponding properties or fields.



**References**
