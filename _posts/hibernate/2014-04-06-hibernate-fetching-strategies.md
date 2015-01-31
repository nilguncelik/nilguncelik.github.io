---
title: Hibernate Fetching Strategies
author: NC
category: hibernate
public: true
---


+ We have two orthogonal notions here: when is the association fetched and how is it fetched. It is important that you do not confuse them. We use fetch to tune performance. We can use lazy to define a contract for what data is always available in any detached instance of a particular class.

+ How: join, select, subselect, batch
+ When: immediate(eager), lazy collection, extra-lazy collection, proxy, no-proxy, lazy attribute


### Proxy Objects

+ Hibernate uses a proxy object to simulate lazy fetching.
+ Instead of returning the actual object, it gives you a proxy object that implement the named interface. The persistent object will load when a method of the proxy is invoked. The proxy is a dynamic subclass of your actual object.

+ ? By default, **single point associations** are eagerly fetched in JPA 2. You can mark it as lazily fetched by using `@ManyToOne(fetch=FetchType.LAZY)` in which case Hibernate will proxy the association and load it when the state of the associated entity is reached.
+ ? You can force Hibernate not to use a proxy by using `@LazyToOne(NO_PROXY)`. In this case, the property is fetched lazily when the instance variable is first accessed. This requires build-time bytecode instrumentation.

#### Single-ended association proxies

+ Lazy fetching for collections is implemented using Hibernate's own implementation of persistent collections. However, a different mechanism is needed for lazy behavior in single-ended associations. The target entity of the association must be proxied. Hibernate implements lazy initializing proxies for persistent objects using runtime bytecode enhancement which is accessed via the CGLIB library.

+ At startup, Hibernate3 generates proxies by default for all persistent classes and uses them to enable lazy fetching of many-to-one and one-to-one associations.

+ The mapping file may declare an interface to use as the proxy interface for that class, with the proxy attribute. By default, Hibernate uses a subclass of the class. The proxied class must implement a default constructor with at least package visibility. This constructor is recommended for all persistent classes.


## HOW data should be fetched?

+ Fetch strategies can be declared in the O/R mapping metadata, or over-ridden by a particular HQL or Criteria query.
+ Hibernate has 4 fetch starategies: SELECT, JOIN, SUBSELECT, BATCH

+ The fetch strategy defined in the mapping document affects:
     + retrieval via get() or load()
     + retrieval that happens implicitly when an association is navigated
     + Criteria queries
     + HQL queries if subselect fetching is used

### `@Fetch(FetchMode.SELECT)`

+ This is the default setting.
+ This method suffers from 1+N select problem. <http://stackoverflow.com/questions/97197/what-is-the-n1-selects-issue>

```java
// It takes Select fetch mode as a default
Query query = session.createQuery( "from Product p");
List list = query.list();
// Supplier is being accessed
displayProductsListWithSupplierName(results);

select ... various field names ... from PRODUCT
select ... various field names ... from SUPPLIER where SUPPLIER.id=?
select ... various field names ... from SUPPLIER where SUPPLIER.id=?
select ... various field names ... from SUPPLIER where SUPPLIER.id=?
```
+ if you specify lazy=false on the collection, the N selects will be executed at call time.

### `@Fetch(FetchMode.JOIN)`

+ With `fetch="join"` on a collection or single-valued association mapping, you will actually avoid the second SELECT (hence making the collection non-lazy), by using just one "bigger" join SELECT to get both the owning entity and the referenced entity or collection. This bigger join is an outer join.
+ If you use `fetch="join"` for more than one collection role for a particular entity instance (in "parallel"), you create a Cartesian product (also called cross join) and two (lazy or non-lazy) SELECT would probably be faster.
+ JOIN overrides any lazy attribute (an association loaded through a JOIN strategy cannot be lazy).

+ ? Annotating two collections with FetchMode.JOIN sometimes causes an exception. This should be further tested with elementcollections/onetomany/list/set.
     + Hibernate 2.x does not support outer join fetching of more than one many-valued association in the same query. Hibernate 3.x allows you to create Cartesian products, even if they are slower than two separate queries.

+ `@Fetch(FetchMode.JOIN)` will be ignored if you use the Query interface (e.g.: `session.createQuery()`) but it will be properly used if you use the Criteria interface.
    + This is practically a bug in Hibernate which was never resolved. It is unfortunate because a lot of applications use the Query interface and cannot be migrated easily to the Criteria interface.
    + If you use the Query interface you always have to add JOIN FETCH statements into the HQL manually.
    + <http://stackoverflow.com/questions/18891789/fetchmode-join-makes-no-difference-for-manytomany-relations-in-spring-jpa-reposi>

### `@Fetch(FetchMode.SUBSELECT)`

+ Two SQLs are fired. One to retrieve all Parent and the second uses a SUBSELECT query in the WHERE clause to retrieve all child that has matching parent ids.
+ A second SELECT is used to retrieve the associated collections for all entities retrieved in a previous query or fetch.

### `@BatchSize(size=N)`

+ With batch-size="N" on a collection mapping you tell Hibernate to optimize the second SELECT (either lazy or non-lazy) by fetching up to N other collections (or entity instances) when you hit one in Java, depending on how many "owning" entities you expect to be in the Session already.
+ Hibernate retrieves a batch of entity instances or collections in a single SELECT by specifying a list of primary or foreign keys.
+ This is a blind-guess optimization technique, but very nice for nested tree node loading.
+ Number of children / batch size queries will be executed to fetch the children.


## WHEN data should be fetched?

### Immediate fetching (eager)
+ An association, collection or attribute is fetched immediately when the owner is loaded.

### Lazy collection fetching (default)
+ A collection is fetched when the application invokes an operation upon that collection. This is the default for collections.

### "Extra-lazy" collection fetching
+ Individual elements of the collection are accessed from the database as needed. Hibernate tries not to fetch the whole collection into memory unless absolutely needed. It is suitable for large collections.

### Proxy fetching
+ A single-valued association is fetched when a method other than the identifier getter is invoked upon the associated object.

### "No-proxy" fetching
+ A single-valued association is fetched when the instance variable is accessed. Compared to proxy fetching, this approach is less lazy; the association is fetched even when only the identifier is accessed. It is also more transparent, since no proxy is visible to the application. This approach requires buildtime bytecode instrumentation and is rarely necessary.

### Lazy attribute fetching
+ An attribute or single valued association is fetched when the instance variable is accessed. This approach requires buildtime bytecode instrumentation and is rarely necessary.


## Pagination

+ Row-based "limit" operations, such as `setFirstResult(5)` and `setMaxResults(10)`  do not work with eager fetch queries.
+ If you limit the resultset to a certain number of rows, you cut off data randomly.

+ `DISTINCT_ROOT_ENTITY`
    + It works only as long as you retrieve all the result items, not if you use `setFirstResult()` and/or `setMaxResults()`.
    + It is applied after the result limitation, which means that you may end up with far less result items than "maxResults".

+ Projection (2 queries)
     1. Use projection to get the ids.
        + `criteria.setProjection(Projections.distinct(Projections.property("id")));`
     2. Eagerly fetch actual entities.
        + [How to get distinct results in hibernate with joins and row-based limiting (paging)](http://stackoverflow.com/a/14502188/572380)
        + [Solving Hibernate Criteria's "Distinct Root Entity" limitation once and for all - including pagination](http://floledermann.blogspot.de/2007/10/solving-hibernate-criterias-distinct.html)

+ Detached criteria (1 query - subselect)
    + [How to get distinct results in hibernate with joins and row-based limiting (paging)](http://stackoverflow.com/a/7911803/572380)
    + [Sorting And Pagination With Hibernate Criteria - How It Can Go Wrong With Joins](http://blog.xebia.com/2008/12/11/sorting-and-pagination-with-hibernate-criteria-how-it-can-go-wrong-with-joins/)

```
    DetachedCriteria idsOnlyCriteria = DetachedCriteria.forClass(MyClass.class);

    //add other joins and query params here
    idsOnlyCriteria.setProjection(Projections.distinct(Projections.id()));

    Criteria criteria = getSession().createCriteria(myClass);
    criteria.add(Subqueries.propertyIn("id", idsOnlyCriteria));
    criteria.setFirstResult(0).setMaxResults(50);
    return criteria.list();
```


**References**

- [A Short Primer On Fetching Strategies](https://community.jboss.org/wiki/AShortPrimerOnFetchingStrategies)
