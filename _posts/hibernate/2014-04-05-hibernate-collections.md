---
title: Hibernate Collections
author: NC
category: hibernate
public: true
---


## Collections

### Collection Semantics

1. Bag Semantic: List
2. Bag Semantic with Id: List
3. List Semantic: List
4. Set Semantic: Set
5. Map Semantic: Map


+ Multi-valued associations are represented in Hibernate by one of the Java Collection Framework contracts: List, Set, Map, Queue, Collection, SortedSet, SortedMap
+ When you make the instance persistent, by calling persist(), Hibernate will actually replace the HashSet with an instance of Hibernate's own implementation of Set. Be aware of the following error:

```
@Entity
public class Cat{
  @OneToMany
  @JoinColumn(name=“KITTEN_ID")
  private Set<Cat> kittens = new HashSet<Cat>();
}

Cat cat = new DomesticCat();
Cat kitten = new DomesticCat();
....
Set kittens = new HashSet();
kittens.add(kitten);
cat.setKittens(kittens);
session.persist(cat);

kittens = cat.getKittens(); // Okay, kittens collection is a Set
(HashSet) cat.getKittens(); // Error!
```

### Sets

+ `java.util.Set`: Can be chosen if the collection will not contain duplicate elements and the ordering is not relevant.

### Implementing equals() and hashCode()

+ You have to override the equals() and hashCode() methods if you:
     + intend to put instances of persistent classes in a Set (the recommended way to represent many-valued associations); and
     + intend to use reattachment of detached instances

+ Hibernate guarantees equivalence of persistent identity (database row) and Java identity only inside a particular session scope. When you mix instances retrieved in different sessions, you must implement equals() and hashCode() if you wish to have meaningful semantics for Sets.

+ The most obvious way is to implement equals()/hashCode() by comparing the identifier value of both objects. If the value is the same, both must be the same database row, because they are equal. If both are added to a Set, you will only have one element in the Set). Unfortunately, you cannot use that approach with generated identifiers. Hibernate will only assign identifier values to objects that are persistent; a newly created instance will not have any identifier value. Furthermore, if an instance is unsaved and currently in a Set, saving it will assign an identifier value to the object. If equals() and hashCode() are based on the identifier value, the hash code would change, breaking the contract of the Set. See the Hibernate website for a full discussion of this problem. This is not a Hibernate issue, but normal Java semantics of object identity and equality.

+ It is recommended that you implement equals() and hashCode() using Business key equality. Business key equality means that the equals() method compares only the properties that form the business key. It is a key that would identify our instance in the real world (a natural candidate key):

```
public class Cat {
    ...
    public boolean equals(Object other) {
        if (this == other) return true;
        if ( !(other instanceof Cat) ) return false;

        final Cat cat = (Cat) other;

        if ( !cat.getLitterId().equals( getLitterId() ) ) return false;
        if ( !cat.getMother().equals( getMother() ) ) return false;

        return true;
    }

    public int hashCode() {
        int result;
        result = getMother().hashCode();
        result = 29 * result + getLitterId();
        return result;
    }
}
```

+ A business key does not have to be as solid as a database primary key candidate. Immutable or unique properties are usually good candidates for a business key.

### Bags

A bag is an unordered, unindexed collection which can contain the same element multiple times. The Java collections framework lacks a Bag interface (though you can emulate it with a List). Hibernate lets you map properties of type List or Collection with the<bag> element. Note that bag semantics are not really part of the Collection contract and they actually conflict with the semantics of List.

#### Lists

+ Lists can be mapped in two different ways:
     + as ordered lists, where the order is not materialized in the database
     + as indexed lists, where the order is materialized in the database
+ `@javax.persistence.OrderBy` : orders lists in memory

```
@Entity
public class Customer {
  @Id @GeneratedValue
  private Integer id;

  @OneToMany(mappedBy="customer")
  @OrderBy("number")
  private List<Order> orders;
}
```
+ `@javax.persistence.OrderColumn`: describes the column name and attributes of the column keeping the index value.

```
@Entity
public class Customer {
  @Id @GeneratedValue
  private Integer id;

  @OneToMany(mappedBy="customer")
  @OrderColumn(name="orders_index")
  private List<Order> orders;
}
```
+ The distinction between value and reference semantics is in this context very important. An object in a collection might be handled with "value" semantics (its life cycle fully depends on the collection owner), or it might be a reference to another entity with its own life cycle.

## Taxonomy

+ Hibernate defines three basic kinds of collections:
     1. collections of values
     2. one-to-many associations
     3. many-to-many associations

+ This classification distinguishes the various table and foreign key relationships but does not tell us quite everything we need to know about the relational model. To fully understand the relational structure and performance characteristics, we must also consider the structure of the primary key that is used by Hibernate to update or delete collection rows. This suggests the following classification:
     1. indexed collections
     2. sets
     3. bags

+ All indexed collections (maps, lists, and arrays) have a primary key consisting of the <key> and <index> columns. In this case, collection updates are extremely efficient. The primary key can be efficiently indexed and a particular row can be efficiently located when Hibernate tries to update or delete it.

+ Sets have a primary key consisting of <key> and element columns. This can be less efficient for some types of collection element, particularly composite elements or large text or binary fields, as the database may not be able to index a complex primary key as efficiently. However, for one-to-many or many-to-many associations, particularly in the case of synthetic identifiers, it is likely to be just as efficient. If you want SchemaExport to actually create the primary key of a <set>, you must declare all columns as `not-null="true"`.

+ <idbag> mappings define a surrogate key, so they are efficient to update. In fact, they are the best case.

+ Bags are the worst case since they permit duplicate element values and, as they have no index column, no primary key can be defined. Hibernate has no way of distinguishing between duplicate rows. Hibernate resolves this problem by completely removing in a single DELETE and recreating the collection whenever it changes. This can be inefficient.

+ For a one-to-many association, the "primary key" may not be the physical primary key of the database table. Even in this case, the above classification is still useful. It reflects how Hibernate "locates" individual rows of the collection.

### Lists, maps, idbags and sets are the most efficient collections to update

+ From the discussion above, it should be clear that indexed collections and sets allow the most efficient operation in terms of adding, removing and updating elements.

+ There is, arguably, one more advantage that indexed collections have over sets for many-to-many associations or collections of values. Because of the structure of a Set, Hibernate does not UPDATE a row when an element is "changed". Changes to a Set always work via INSERT and DELETE of individual rows. Once again, this consideration does not apply to one-to-many associations.

+ After observing that arrays cannot be lazy, you can conclude that lists, maps and idbags are the most performant (non-inverse) collection types, with sets not far behind. You can expect sets to be the most common kind of collection in Hibernate applications. This is because the "set" semantics are most natural in the relational model.

+ However, in well-designed Hibernate domain models, most collections are in fact one-to-many associations with inverse="true". For these associations, the update is handled by the many-to-one end of the association, and so considerations of collection update performance simply do not apply.

### Bags and lists are the most efficient inverse collections

+ There is a particular case, however, in which bags, and also lists, are much more performant than sets. For a collection with `inverse="true"`, the standard bidirectional one-to-many relationship idiom, for example, we can add elements to a bag or list without needing to initialize (fetch) the bag elements. This is because, unlike a set, `Collection.add()` or `Collection.addAll()` must always return true for a bag or List. This can make the following common code much faster:

```java
Parent p = (Parent) sess.load(Parent.class, id);
Child c = new Child();
c.setParent(p);
p.getChildren().add(c);  //no need to fetch the collection!
sess.flush();
```

### One shot delete

+ Deleting collection elements one by one can sometimes be extremely inefficient. Hibernate knows not to do that in the case of an newly-empty collection (if you called `list.clear()`, for example). In this case, Hibernate will issue a single DELETE.

+ Suppose you added a single element to a collection of size twenty and then remove two elements. Hibernate will issue one INSERT statement and two DELETE statements, unless the collection is a bag. This is certainly desirable.

+ However, suppose that we remove eighteen elements, leaving two and then add thee new elements. There are two possible ways to proceed
     + delete eighteen rows one by one and then insert three rows
     + remove the whole collection in one SQL DELETE and insert all five current elements one by one

+ Hibernate cannot know that the second option is probably quicker. It would probably be undesirable for Hibernate to be that intuitive as such behavior might confuse database triggers, etc.

+ Fortunately, you can force this behavior (i.e. the second strategy) at any time by discarding (i.e. dereferencing) the original collection and returning a newly instantiated collection with all the current elements.

+ One-shot-delete does not apply to collections mapped `inverse="true"`.

## `@ElementCollection`

+ It means that the collection is not a collection of entities, but a collection of value objects.
+ It also means that the elements are completely owned by the containing entities: they're modified when he entity is modified, deleted when the entity is deleted, etc. They can't have their own lifecycle. <http://stackoverflow.com/questions/8969059/difference-between-onetomany-and-elementcollection>
+ Such an embeddable object cannot contain a collection itself.
+ Creates table: Entity_propertyName.
+ It contains Entity.id and fields of Embeddable objects.

### `@CollectionId`

+ Adds PK to ElementCollection.
+ Type of the collection should support this addition.
+ Collections and lists support whereas sets do not.

```
@GenericGenerator(name=“hilo-gen”,strategy=“hilo”)
@CollectionId(columns={ @Column(name=“ADDRESS_ID") },  generator=“hilo-gen”,  type=@Type(type=“long")  )
@ElementCollection Collection<Embeddable> propertyName;
```

+ `@CollectionId` tells that the collection should have an identifier. Since the embeddable does not have an identifier `@CollectionId` define what the identifier should be.
+ `@Column(name=“ADDRESS_ID”)` is the index for the collection. And it is the primary key for the join table.

## `@OneToOne` Relation

### `@OneToOne Entity propertyName;`

+ Creates column: Entity_pk-field in the entity table having the annotation.
   + To configure this column use @JoinColumn.

## `@OneToMany` and `@ManyToOne` Relations

### `@OneToMany Set<Entity> propertyName;`
### `@OneToMany Collection<Entity> propertyName;`

+ Creates table: Entity_propertyName.
+ It contains Entity.id and Property Entity.id.

### `@ManyToOne Entity2 propertyName;`

+ Useful to access from children object(many) to parent object(one).

### `@MappedBy`

+ Mapping is done without separate table

```java
//parent entity
@OneToMany(mappedBy=“Entity”)
Collection<Entity> propertyName;
//child entity
@ManyToOne @JoinColumn(name=“parent_entity_id”)
Entity2 propertyName;
```
+ This creates a join column inside the child object table instead of creating a join table.

## `@ManyToMany` Relation

```java
// entity1
@ManyToMany
Collection<Entity2> propertyName1;
// entity2
@ManyToMany(mappedBy=“propertyName1”)
Collection<Entity1> propertyName2;
```
+ If you don’t include mappedBy on entity2, 2 separate tables are created.




## `@JoinTable`

```java
@JoinTable(name=“Entity_Entity2”, joinColumns=@JoinColumn(name=“user_id”), inverseJoinColumns=@JoinColumn(name=“vehicle_id”))
```
+ Updates join table name and entity pk field name.




## `@JoinColumn`

```
@JoinColumn(name="COMP_ID”)
```
+ The default value(s) is the concatenation of the name of the relationship in the owner side, _ (underscore), and the name of the primary key column in the owned side.




## Persisting Children while updating parent



### Persisting ElementCollection with `@OrderColumn`

+ The JPA 2.0 specification does not provide a way to define the Id in the Embeddable.
+ However, to delete or update a element of the ElementCollection mapping, some unique key is normally required. Otherwise, **on every update the JPA provider would need to delete everything from the CollectionTable for the Entity, and then insert the values back.**
+ So, the JPA provider will most likely assume that the combination of all of the fields in the Embeddable are unique, in combination with the foreign key (JoinColunm(s)). This however could be inefficient, or just not feasible if the Embeddable is big, or complex.

```java
@Entity
public class Person {
    @ElementCollection
    @CollectionTable(name = "PERSON_LOCATIONS", joinColumns = @JoinColumn(name = "PERSON_ID"))
    private List<Location> locations;
    ...
}
@Embeddable
public class Location {
    ...
}
```

+ <http://stackoverflow.com/questions/3742897/hibernate-elementcollection-strange-delete-insert-behavior>

+ This is what happens here: Hibernate doesn't generate a primary key for the collection table and has no way to detect what element of the collection changed and will delete the old content from the table to insert the new content.

+ Solution: define an `@OrderColumn`
    + it specifies a column used to maintain the persistent order of a list - which would make sense since you're using a List)
    + Hibernate will create a primary key (made of the order column and the join column) and will be able to update the collection table without deleting the whole content.

```
@Entity
public class Person {
    ...
    @ElementCollection
    @CollectionTable(name = "PERSON_LOCATIONS", joinColumns = @JoinColumn(name = "PERSON_ID"))
    @OrderColumn
    private List<Location> locations;
    ...
}
```

### Persisting detached collections

+ If you merge a detached entity which doesn't have the child collection initialised you're telling Hibernate: here's the new state of the entity, which doesn't contain any object anymore.
+ So Hibernate will delete the association between the entity and the objects previously contained in the list.
+ Instead of constructing a new entity instance and passing it to `merge()`, get the entity from the session, modify it, and then pass that instance to `merge()`.
+ >http://stackoverflow.com/questions/11098266/hibernate-prevent-delete-orphan-when-using-merge>

+ Other use cases:
    + If a lazy-loading relationship was not triggered on an entity before it became detached, that relationship will be deleted when the entity is merged.
    + If the relationship was triggered while managed and then set to null while the entity was detached, the managed version of the entity will likewise have the relationship cleared during the merge.

## Cascade / Transitive persistence

+ If the children in a parent/child relationship would be value typed (e.g. a collection of addresses or strings), their life cycle would depend on the parent and no further action would be required for convenient "cascading" of state changes.
     + When the parent is saved, the value-typed child objects are saved and when the parent is deleted, the children will be deleted, etc.
     + This works for operations such as the removal of a child from the collection. Since value-typed objects cannot have shared references, Hibernate will detect this and delete the child from the database.

+ Now consider the same scenario with parent and child objects being entities, not value-types.
     + Entities have their own life cycle and support shared references. Removing an entity from the collection does not mean it can be deleted), and there is by default no cascading of state from one entity to any other associated entities. Hibernate does not implement persistence by reachability by default.

+ Setting a value of the cascade attribute will propagate certain operations to the associated object.

    ```
     @OneToMany(cascade = CascadeType.)
     @ManyToOne(cascade = CascadeType.)
     @ManyToMany(cascade = CascadeType.)
    ```
+ The meaningful values are divided into three categories:
     1. persist, merge, delete, save-update, evict, replicate, lock and refresh
     2. delete-orphan or all
     3. cascade="persist,merge,evict” or cascade="all,delete-orphan"

+ You can use `cascade="all"` to specify that all operations should be cascaded along the association. The default `cascade="none"` specifies that no operations are to be cascaded.

+ The cascade concept in JPA is very is similar to the transitive persistence and cascading of operations as described above, but with slightly different semantics and cascading types:
     + CascadeType.PERSIST: cascades the persist (create) operation to associated entities persist() is called or if the entity is managed
     + CascadeType.MERGE: cascades the merge operation to associated entities if merge() is called or if the entity is managed
     + CascadeType.REMOVE: cascades the remove operation to associated entities if delete() is called
     + CascadeType.REFRESH: cascades the refresh operation to associated entities if refresh() is called
     + CascadeType.DETACH: cascades the detach operation to associated entities if detach() is called
     + CascadeType.ALL: all of the above (it also covers Hibernate specific operations like save-update, lock etc.)

+ Cascading of operations can be applied to an object graph at call time or at flush time.
     + All operations, if enabled, are cascaded to associated entities reachable when the operation is executed.
     + However **save-update and delete-orphan are transitive for all associated entities reachable during flush of the Session**.

### Delete-orphan

+ delete-orphan cascade type indicates that the delete() operation should be applied to any child object that is removed from the association.
+ it applies only to one-to-many and one-to-one associations. @ManyToOne and @ManyToMany don’t offer a orphanRemoval attribute.
+ Using annotations there is no CascadeType.DELETE-ORPHAN equivalent. Instead you can use the attribute orphanRemoval.

```java
@Entity
public class Customer {
  private Set<Order> orders;

  @OneToMany(cascade=CascadeType.ALL, orphanRemoval=true)
  public Set<Order> getOrders() { return orders; }

  public void setOrders(Set<Order> orders) { this.orders = orders; }

  [...]
}

@Entity
public class Order { ... }

Customer customer = em.find(Customer.class, 1l);
Order order = em.find(Order.class, 1l);
customer.getOrders().remove(order); //order will be deleted by cascade
```
+ If an entity is removed from a `@OneToMany` collection or an associated entity is dereferenced from a @OneToOne association, this associated entity can be marked for deletion if orphanRemoval is set to true.
+ If the child object's lifespan is bounded by the lifespan of the parent object, make it a life cycle object by specifying `cascade="all,delete-orphan" (@OneToMany(cascade=CascadeType.ALL, orphanRemoval=true))`.

+ The precise semantics of cascading operations for a parent/child relationship are as follows:
     + If a parent is passed to `persist()`, all children are passed to `persist()`
     + If a parent is passed to `merge()`, all children are passed to `merge()`
     + If a parent is passed to `save()`, `update()` or `saveOrUpdate()`, all children are passed to `saveOrUpdate()`
     + If a transient or detached child becomes referenced by a persistent parent, it is passed to `saveOrUpdate()`
     + If a parent is deleted, all children are passed to `delete()`
     + If a child is dereferenced by a persistent parent, nothing special happens - the application should explicitly delete the child if necessary - unless `cascade="delete-orphan"`, in which case the "orphaned" child is deleted.






#### How does Hibernate distinguish between transient (i.e. newly instantiated) and detached objects?


+ Hibernate uses the version property, if there is one.
+ If not uses the identifier value. No identifier value means a new object. This does work only for Hibernate managed surrogate keys. Does not work for natural keys and assigned (i.e. not managed by Hibernate) surrogate keys.
+ Write your own strategy with `Interceptor.isUnsaved()`.

+ Suppose we loaded up a Parent in one Session, made some changes in a UI action and wanted to persist these changes in a new session by calling update(). The Parent will contain a collection of children and, since the cascading update is enabled, Hibernate needs to know which children are newly instantiated and which represent existing rows in the database. We will also assume that both Parent and Child have generated identifier properties of type Long. Hibernate will use the identifier and version/timestamp property value to determine which of the children are new.

+ The following code will update parent and child and insert newChild:
```
//parent and child were both loaded in a previous session
parent.addChild(child);
Child newChild = new Child();
parent.addChild(newChild);
session.update(parent);
session.flush();
```
+ This may be suitable for the case of a generated identifier, but what about assigned identifiers and composite identifiers? This is more difficult, since Hibernate cannot use the identifier property to distinguish between a newly instantiated object, with an identifier assigned by the user, and an object loaded in a previous session. In this case, Hibernate will either use the timestamp or version property, or will actually query the second-level cache or, worst case, the database, to see if the row exists.







#### `inverse=true (@mappedBy)`

+ <http://www.mkyong.com/hibernate/inverse-true-example-and-explanation/>







#### Why does Hibernate always initialize a collection when I only want to add or remove an element?

+ Unfortunately the collections API defines method return values that may only be computed by hitting the database. There are three exceptions to this: Hibernate can add to a <bag>, <idbag> or <list> declared with `inverse="true"` without initializing the collection; the return value must always be true.
If you want to avoid extra database traffic (ie. in performance critical code), refactor your model to use only many-to-one associations. This is almost always possible. Then use queries in place of collection access.







#### Hibernate keeps deleting and recreating my collection!

+ Unlike other Hibernate value types, Hibernate tracks actual collection instances using Java identity, ==. Your getter method should return the same collection instance as was assigned by Hibernate to the setter method (unless you don't mind the collection being removed and recreated every time the session is flushed).

+ This doesn't mean you shouldn't return a different collection if you really are replacing the current collection with a new collection with completely different elements. In certain cases, this behaviour can even be taken advantage of to increase performance.








#### How do a write a query that returns objects based upon a WHERE clause condition applied to their collection elements?


+ There are two possibilities:

```sql
select distinct parent from Parent parent join parent.children child where child.name = :name
from Parent parent where :childId in elements(parent.children)
```

+ The first query uses a table join; the second uses a subquery. The first query allows constraints to be applied to element properties; the second does not.
+ You may not need the distinct keyword in the first query.





#### Hibernate does not return distinct results for a query with outer join fetching enabled for a collection (even if I use the distinct keyword)?

+ <https://community.jboss.org/wiki/HibernateFAQ-AdvancedProblems#jive_content_id_Hibernate_does_not_return_distinct_results_for_a_query_with_outer_join_fetching_enabled_for_a_collection_even_if_I_use_the_distinct_keyword>
+ First, you need to understand SQL and how OUTER JOINs work in SQL.
+ Typical examples that might return duplicate references of the same Order object:
```java
    List result = session.createCriteria(Order.class)
                         .setFetchMode("lineItems", FetchMode.JOIN)
                         .list();
    List result = session.createCriteria(Order.class).list();
    List result = session.createQuery("select o from Order o left join fetch o.lineItems").list();
```

+ All of these examples produce the same SQL statement:
```sql
   SELECT o.*, l.* from ORDER o LEFT OUTER JOIN LINE_ITEMS l ON o.ID = l.ORDER_ID
```

+ Want to know why the duplicates are there? Look at the SQL resultset, Hibernate does not hide these duplicates on the left side of the outer joined result but returns all the duplicates of the driving table.
+ If you have 5 orders in the database, and each order has 3 line items, the resultset will be 15 rows. The Java result list of these queries will have 15 elements, all of type Order.
+ Only 5 Order instances will be created by Hibernate, but duplicates of the SQL resultset are preserved as duplicate references to these 5 instances.
+ (Why a left outer join? If you'd have an additional order with no line items, the result set would be 16 rows with NULL filling up the right side, where the line item data is for other order. You want orders even if they don't have line items, right? If not, use an inner join fetch in your HQL).
+ Hibernate does not filter out these duplicate references by default. How can you filter them out:
```java
    Collection result = new LinkedHashSet( session.create*(...).list() );
```
+ A LinkedHashSet filteres out duplicate references (it's a set) and it preserves insertion order (order of elements in your result).
+ You can do it in many different and more difficult ways:

```
    List result = session.createCriteria(Order.class)
                         .setFetchMode("lineItems", FetchMode.JOIN)
                         .setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY)
                         .list();
    List result = session.createCriteria(Order.class)
                         .setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY)
                         .list();
    List result = session.createQuery("select o from Order o left join fetch o.lineItems")
                       .setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY)
                       .list();
    List result = session.createQuery("select distinct o from Order o left join fetch o.lineItems").list();
```
+ The last one is special. It looks like you are using the SQL DISTINCT keyword here. But, his is not SQL, this is HQL. This distinct is just a shortcut for the result transformer, in this case.
+ Yes, in other cases an HQL distinct will translate straight into a SQL DISTINCT. Not in this case: you can not filter out duplicates at the SQL level, the very nature of a product/join forbids this - you want the duplicates or you don't get all the data you need.
+ All of this filtering of duplicates happens in-memory, when the resultset is marshalled into objects.





#### I can't EAGERly load more than one collection !? <https://community.jboss.org/wiki/HibernateFAQ-HibernateAnnotationsFAQ>

+ Yes you can, here are the solutions:
     1. do not use a bag semantic: use a Set or a List annotated with `@OrderColumn`
     2. use a `@CollectionId`
     3. use `@FetchMode(SELECT)` or `@FetchMode(SUBSELECT)`

+ The underlying reason is that **you cannot load more than one bag semantic collection in a given SQL query conceptually, so you won't find this feature in other products either**.


**References**

- [Java Brains]( http://javabrains.koushik.org/hibernate.html)
- [Hibernate Manual](http://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/)
