---
title: Hibernate Entity and Value Objects
author: NC
category: hibernate
public: true
---

+ Hibernate understands both the Java and JDBC representations of application data.
+ The ability to read and write object data to a database is called **marshalling**, and is the function of a Hibernate type.
+ A Hibernate type describes various aspects of behavior of the Java type such as how to check for equality and how to clone values.
+ A Hibernate type is neither a Java type nor a SQL datatype. It provides information about both of these. When you encounter the term type in regards to Hibernate, it may refer to the Java type, the JDBC type, or the Hibernate type, depending on context.
+ Hibernate categorizes types into two high-level groups: *Value types* and *Entity Types*.

## Value Types

+ They have data which have to be saved in database but they do not define their own lifecycles. They are, in effect, owned by an Entity Type, which defines its lifecycle.
+ Objects of type custom classes, String, Double can be value objects.
+ Value types are further classified into three sub-categories
     + Basic Types
     + Composite Types
     + Collection Types

#### Basic Types

+ Basic value types usually map a single database value, or column, to a single, non-aggregated Java type.
+ Hibernate provides a number of built-in basic types, which follow the natural mappings recommended in the JDBC specifications.

| Hibernate type                 | Database type | JDBC type | Type registry            |
|--------------------------------|---------------|-----------|--------------------------|
|org.hibernate.type.StringType   | string        | VARCHAR   | string, java.lang.String |

+ You can override these mappings and provide and use alternative mappings.

#### `@Column`

```java
@Column(updatable = false, name = "flight_name", nullable = false, length=50)
private String name;
```
+ The name property is mapped to the flight_name column, which is not nullable, has a length of 50 and is not updatable (making the property immutable).

```
@Column(name= “property name", unique = false, nullable = true, insertable=true, updatable=true, columnDefinition = “sql DDL fragment”, table=“targeted table”,length=10,precision=0,scale=0)
```

#### `@Transient`

+ The property will not be persisted and ignored by hibernate.
+ Useful for example for static fields.

#### `@Temporal`

+ `@Temporal(TemporalType.Date)`
    + Hibernate will track only the date not the time.
+ `@Temporal(TemporalType.Time)`
    + Hibernate will track only the time not the date.

#### `@Enumerated(EnumType.STRING)`

+ Hibernate Annotations supports enum type mapping. It saves data into a ordinal column (saving the enum ordinal) by default.
+ `@Enumerated(EnumType.STRING)` is used to override this setting to use a string based column (saving the enum string representation).

#### `@Lob`

+ Large object.
+ Hibernate chooses between **clob** (character large object) and **blob** (binary large object) as the database column type.

#### `@NotNull`

+ TODO

#### `@Formula("obj_length * obj_height * obj_width")`

+ If you want the Database to do some computation for you, rather than in the JVM, you might also create some kind of virtual column. You can use a SQL fragment (e.g. formula) instead of mapping a property into a column.
+ This kind of property is read only (its value is calculated by your formula fragment).
+ The SQL fragment can be as complex as you want and even include subselects.

### Composite Types (Embedded Types or Components)

+ Components represent aggregations of values into a single Java type.
+ An example is an `Address` class, which aggregates street, city, state, and postal code.
+ Documentation is inconsistent about composite elements owning collections:
	+ They may include references to other application-specific classes, as well as to collections and simple JDK types. [Hibernate Manual - 6.1.2. Composite types](https://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/#types-value-composite)
	+ composite elements cannot own collections. [Hibernate Manual - 23.5. Conclusion](https://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/#example-parentchild-conclusion)
+ Value objects are marked with `@Embeddable` where they are declared.
+ They are annotated with `@Embedded` when they are defined as a property inside an entity.


### Collection Types

+ A collection type refers to the data type itself, not its contents.
+ A collection denotes a one-to-one or one-to-many relationship between tables of a database.

### `@AttributeOverride`

```
@Embedded
@AttributeOverrides{
    @AttributeOverride(name=“street”,column=@Column(name=“HOME_STREET”)),
    @AttributeOverride(name=“city”,column=@Column(name=“HOME_CITY”)),
    @AttributeOverride(name=“country”,column=@Column(name=“HOME_COUNTRY”))
}
```

+ It overrides attribute names of embedded objects.
+ This is useful when there are more than one embeddable object in an entity that are of same type.

## Entity Types

+ Entities are application-specific classes which correlate to rows in a table, using a unique identifier.
+ Because of the requirement for a unique identifier, entities exist independently and define their own lifecycle.
+ Entity objects are marked with `@Entity` where they are declared.

### @Entity(name=“new_name”)

+ Alters the entity name. HQL queries should use the altered name.

### @Table(name=“new_name”)

+ Does not alter the entity name. Only alters the table name.

### `@Immutable`

+ Some entities are not mutable. They cannot be updated by the application. This allows Hibernate to make some minor performance optimisations.
+ You can create an immutable class to query views in a database.

**References**

- [Java Brains]( http://javabrains.koushik.org/hibernate.html)
- [Hibernate Manual](http://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/)
