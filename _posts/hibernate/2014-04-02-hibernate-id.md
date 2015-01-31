---
title: Hibernate Id
author: NC
category: hibernate
public: true
---

### `@Id`

+ Identifies PK.
+ There are two types of PKs.
+ **Surrogate**: PK is specifically for the purpose of PK and it has no business use.
+ **Natural**: PK has a business use.

### `@GeneratedValue`

+ Hibernate generates a PK for a surrogate key.

#### `@GeneratedValue(strategy=)`

+ IDENTITY: some dbs have identity column feature.
+ SEQUENCE : uses db sequences.
+ TABLE :
+ AUTO : Hibernate decides.

#### Generated String ids with uuid

```
@GeneratedValue(generator = "uuid")
@GenericGenerator(name = "uuid", strategy = "uuid2”)
```

### NaturalId

+ A natural key is a property or combination of properties that is unique and non-null.
+ It is also immutable.
+ It is recommended that you implement `equals()` and `hashCode()` to compare the natural key properties of the entity.

### Composite PKs

+ The `@EmbeddedId` and `@IdClass` annotations are used to denote composite primary keys.
+ The primary key class must be serializable.
+ The primary key class must define equals and hashCode methods.
+ The documentation is confusing about using `@GeneratedValue` with composite keys: <http://stackoverflow.com/questions/4120414/how-can-i-use-generated-value-within-composite-keys>
     + <http://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/#components-compositeid>
          + You cannot use an IdentifierGenerator (`@GeneratedValue`) to generate composite keys. Instead the application must assign its own identifiers.
     + <https://developer.jboss.org/wiki/HibernateFAQ-AdvancedProblems#jive_content_id_I_have_a_composite_key_where_one_column_holds_a_generated_value__how_can_I_get_Hibernate_to_generate_and_assign_the_value>
          + I have a composite key where one column holds a generated value - how can I get Hibernate to generate and assign the value?
          + We regard this as an extremely strange thing to want to do. If you have a generated surrogate key, why not just make it be the primary key? However, if you must do this, you can do it by writing a `CompositeUserType` for the composite identifier class, and then defining a custom `IdentifierGenerator` that populates the generated value into the composite key class.

#### `@EmbeddedId`

+ `@EmbeddedId` communicates more clearly that the key is a composite key and makes sense when the combined PK is either a meaningful entity itself or it is reused in the code.

```java
@Embeddable
public class TimePK implements Serializable {
    protected Integer levelStation;
    protected Integer confPathID;

    public TimePK() {}

    public TimePK(Integer levelStation, String confPathID) {
        this.id = levelStation;
        this.name = confPathID;
    }
    // equals, hashCode
}

@Entity
class Time implements Serializable {
    @EmbeddedId
    private TimePK timePK;

    private String src;
    private String dst;
    private Integer distance;
    private Integer price;

    //…
}
```

#### `@IdClass`

+ `@IdClass` is useful to specify that some combination of fields is unique but these do not have a special meaning.

```java
public class TimePK implements Serializable {
    protected Integer levelStation;
    protected Integer confPathID;

    public TimePK() {}

    public TimePK(Integer levelStation, String confPathID) {
        this.id = levelStation;
        this.name = confPathID;
    }
    // equals, hashCode
}

@Entity
@IdClass(TimePK.class)
class Time implements Serializable {
    @Id
    private Integer levelStation;
    @Id
    private Integer confPathID;

    private String src;
    private String dst;
    private Integer distance;
    private Integer price;

    // getters, setters
}
```

**References**

- <http://stackoverflow.com/questions/3585034/how-to-map-a-composite-key-with-hibernate>
