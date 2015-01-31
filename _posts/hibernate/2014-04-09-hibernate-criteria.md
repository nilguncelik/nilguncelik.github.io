---
title: Hibernate Criteria
author: NC
category: hibernate
public: true
---

## CriteriaQuery

+ `org.hibernate.Criteria` API is deprecated. Eventually, Hibernate-specific criteria features will be ported as extensions to the JPA `javax.persistence.criteria.CriteriaQuery`.

+ You will need an `EntityManager` to create a `CriteriaQuery`:

```java
EntityManager em = ...;
CriteriaBuilder cb = em.getCriteriaBuilder();
CriteriaQuery<Pet> cq = cb.createQuery(Pet.class);
Root<Pet> pet = cq.from(Pet.class);
cq.select(pet);
```

## Criteria

+ Parameters and constraints grow and becomes hard to maintain when using HQL.

```java
Criteria criteria = session.createCriteria(Class);  // all condition applied here will apply for Class table.
criteria.add( Restrictions.like("name", "Fritz%") );
criteria.add(Restrictions.or(Restrictions.eq(“”,),Restrictions.between(“”,,)));
criteria.setMaxResults(50);
criteria.add( Restrictions.disjunction()
             .add( Restrictions.isNull("age") )
             .add( Restrictions.eq("age", new Integer(0) ) )
             .add( Restrictions.eq("age", new Integer(1) ) )
             .add( Restrictions.eq("age", new Integer(2) ) )
         ));
criteria.add( Restrictions.sqlRestriction("lower({alias}.name) like lower(?)", "Fritz%", Hibernate.STRING)); // The {alias} placeholder will be replaced by the row alias of the queried entity.
criteria.add( Property.forName("name").in( new String[] { "Fritz", "Izi", "Pk" } ) );
criteria.addOrder( Order.asc("name") );
criteria.addOrder( Order.desc("age") );
criteria.addOrder( Property.forName("name").asc() );
criteria.addOrder( Property.forName("age").desc() );
criteria.setFetchMode("mate", FetchMode.EAGER) // will fetch mate by outer join
// Use createCriteria with collection name to restrict collections with entities and components. Essentially we create a Criteria object against the collection property and restrict the entity or component properties using that instance.
criteria.createCriteria("kittens”)
    .add( Restrictions.like("name", "F%”) );  // The second createCriteria() returns a new instance of Criteria that refers to the elements of the kittens collection.
criteria.createAlias("kittens", "kt”)
    .createAlias("mate", "mt”)     // (createAlias() does not create a new instance of Criteria.)
    .add( Restrictions.eqProperty("kt.name", "mt.name") )
    .setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP) // For querying a collection of basic values, we still create the Criteria object against the collection, but to reference the value, we use the special property "elements". For an indexed collection, we can also reference the index property using the special property "indices".
    .createCriteria("nickNames")
    .add(Restrictions.eq("elements", "BadBoy"));
criteria.list();
```

+  If you want to retrieve just the kittens that match the criteria, you must use a `ResultTransformer`.

```java
List cats = sess.createCriteria(Cat.class)
                 .createCriteria("kittens", "kt").add( Restrictions.eq("name", "F%") ).setResultTransformer(Criteria.ALIAS_TO_ENTITY_MAP)
                 .list();
Iterator iter = cats.iterator();
while ( iter.hasNext() ) {
    Map map = (Map) iter.next();
    Cat cat = (Cat) map.get(Criteria.ROOT_ALIAS);
    Cat kitten = (Cat) map.get("kt");
}
```

+  You may manipulate the result set using a left outer join:

```java
 List cats = session.createCriteria( Cat.class )
            .createAlias("mate", "mt", Criteria.LEFT_JOIN, Restrictions.like("mt.name", "good%") )
            .addOrder(Order.asc("mt.age"))
            .list();
```

+ This will return all of the Cats with a mate whose name starts with "good" ordered by their mate's age, and all cats who do not have a mate. This is useful when there is a need to order or limit in the database prior to returning complex/large result sets, and removes many instances where multiple queries would have to be performed and the results unioned by java in memory.
+ Without this feature, first all of the cats without a mate would need to be loaded in one query.
+ A second query would need to retreive the cats with mates who's name started with "good" sorted by the mates age.
+ Thirdly, in memory; the lists would need to be joined manually.


## Projections

+ Used to implement aggregation functions. ex. max, min, count, grouping.

```
criteria.setProjection(Projections.property(“userId”))    // return type will not be list of class
criteria.setProjection(Projections.max(“userId”))
criteria.setProjection(Projections.rowCount())
criteria..setProjection( Projections.projectionList()
        .add( Projections.rowCount() )
        .add( Projections.avg("weight") )
        .add( Projections.max("weight") )
        .add( Projections.groupProperty("color") )
    )
```
+ <http://stackoverflow.com/questions/5196243/using-hibernates-criteria-and-projections-to-select-multiple-distinct-columns/5196296#5196296>

### Adding Order

```
criteria.addOrder(Order.desc("userId"));
criteria.addOrder(Order.asc("userId"));
```

### Query By Example

```
Use exampleUser = new User();
exampleUser.setUserName(“User 1%")
Example example = Example.create(exampleUser).enableLike();
criteria.add(example);
// it ignores null properties and PK.
```

## Detached Criteria

+ The `DetachedCriteria` class allows you to create a query outside the scope of a session and then execute it using an arbitrary `Session`.
+ A `DetachedCriteria` can also be used to express a subquery. Criterion instances involving subqueries can be obtained via Subqueries or Property.

```java
DetachedCriteria avgWeight = DetachedCriteria.forClass(Cat.class)
                            .setProjection( Property.forName("weight").avg() );
session.createCriteria(Cat.class)
       .add( Property.forName("weight").gt(avgWeight) )
       .list();

DetachedCriteria weights = DetachedCriteria.forClass(Cat.class)
                           .setProjection( Property.forName("weight") );
session.createCriteria(Cat.class)
       .add( Subqueries.geAll("weight", weights) )
       .list();

// Correlated subqueries are also possible:

DetachedCriteria avgWeightForSex = DetachedCriteria.forClass(Cat.class, "cat2")
                                   .setProjection( Property.forName("weight").avg() )
                                   .add( Property.forName("cat2.sex").eqProperty("cat.sex") );
session.createCriteria(Cat.class, "cat")
       .add( Property.forName("weight").gt(avgWeightForSex) )
       .list();
```

**References**

- [Java Brains]( http://javabrains.koushik.org/hibernate.html)
- [Hibernate Documentation](http://docs.jboss.org/hibernate/orm/4.1/devguide/en-US/html_single/)
