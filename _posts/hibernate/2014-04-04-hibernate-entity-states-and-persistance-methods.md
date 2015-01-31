---
title: Hibernate Entity States and Persistance Methods
author: NC
category: hibernate
public: true
---


## Persistant Context

+ Both the `org.hibernate.Session` API and `javax.persistence.EntityManager` API represent a persistent context for dealing with persistent data.
+ Persistent data has a state in relation to both a persistence context and the underlying database.
+ Hibernate automatically detects changes when the data is associated with a persistence context, that is, bound to a particular `org.hibernate.Session`. Hibernate monitors any changes and executes SQL in a *write-behind* fashion.

### Flushing

+ The process of synchronizing the memory state with the database, usually only at the end of a unit of work, is called **flushing**. Flushing, occurs by default at the following points :
     + before some query executions.
     + from `org.hibernate.Transaction.commit()`.
     + from `Session.flush()`.
     + rollback of the database transaction.

+ An exception to flushing is that objects using native ID generation are inserted when they are saved.

+ Except when you explicitly `flush()`, there are absolutely no guarantees about when the Session executes the JDBC calls, only the order in which they are executed. However, Hibernate does guarantee that `query.list(..)` will never return stale or incorrect data.

+ **During flush, an exception might occur** (e.g. if a DML operation violates a constraint).

### New or Transient State

+ The entity has just been instantiated and is not associated with a persistence context. It has no persistent representation in the database and no identifier value has been assigned.

### Managed or Persistent State

+ The entity has an associated identifier and is associated with a persistence context.
+ If you change a property of an object after calling save on it, the change will be automatically reflected to database by Hibernate.
+ The last state of the object when `session.close()` is executed will be the state of the record in the database.
+ If there are multiple updates only one update that reflects the final state will be executed.

### Detached State

+ The entity has an associated identifier, but is no longer associated with a persistence context (usually because the persistence context was closed or the instance was evicted from the context).
+ The object has a corresponding entry in the database but it is not currently tracked by Hibernate.

### Removed State

+ The entity has an identifier and a persistence context, but it is scheduled for removal from database.






## Persistance Methods

Much of the `org.hibernate.Session` and `javax.persistence.EntityManager` methods deal with moving entities between these states.

### Making entities persistent

* If the entity has a *generated identifier*, the value is associated to the instance when `save()` or `persist()` is called.
* If the identifier is not automatically generated, the application-assigned (usually natural) key value has to be set on the instance before save or persist is called.

#### save - Hibernate

+ INSERT statement is executed instantly.
+ It returns an identifier.
+ Meant to work on transient objects.

#### persist - JPA and Hibernate

+ If X is a transient entity, it becomes persistent. The entity X will be entered into the database at or before transaction commit or as a result of the flush operation.
    + Therefore identifier assignment does not happen immediately unlike save method.
    + It does not return the identifier.
+ If X is a preexisting persistent entity, it is ignored. However, the persist operation is cascaded to entities referenced by X, if the relationships from X to these other entities are annotated with the `cascade=PERSIST` or `cascade=ALL` annotation element value.
+ If X is a removed entity, it becomes persistent.
+ If X is a detached object,
     + the `EntityExistsException` may be thrown when the persist operation is invoked, or
     + the `EntityExistsException` or another `PersistenceException` may be thrown at flush or commit time.
     + *This makes sure that you are inserting and not updating by mistake.*
+ For all entities Y referenced by a relationship from X, if the relationship to Y has been annotated with the cascade element value `cascade=PERSIST` or `cascade=ALL`, the persist operation is applied to Y.
+ `persist()` method doesn't guarantee that the identifier value will be assigned to the persistent instance immediately, the assignment might happen at flush time.

#### save vs persist

+ `persist()` guarantees that it will not execute an INSERT statement if it is called outside transaction boundaries. This is useful in long-running conversations with an extended session/persistence context.
+ `save()` does not guarantee the same, it returns an identifier, and if an INSERT has to be executed to get the identifier (e.g. "identity" generator, not "sequence"), this INSERT happens immediately, no matter if you are inside or outside of a transaction. This is not good in a long-running conversation with an extended session/persistence context.




### Deleting Entities

#### delete - Hibernate

+ The entity instance passed can be either in managed or detached state.

#### remove - JPA, Hibernate

+ The entity instance passed must be in managed state.





### Modifying managed/persistent state

+ Entities in managed/persistent state may be manipulated by the application and any changes will be automatically detected and persisted when the persistence context is flushed.
+ There is no need to call a particular method to make your modifications persistent.

### Working with detached data

+ Detached data can be manipulated, however the persistence context will no longer automatically know about these modifications and the application will need to intervene to make the changes persistent.

### update - Hibernate

+ Works on detached objects.
+ It persists and reattaches the object to the session.
+ It executes an update statement on the object even if the object hasn't changed (if `selectBeforeUpdate` is `false` (default)). Because Hibernate does not know if anything has changed.
+ SQL UPDATE is not immediately performed, it will be performed when the persistence context is flushed.

#### `@org.hibernate.annotations.Entity(selectBeforeUpdate=true)`

+ `update()` will first make a select and see if there are any changes. If there are no changes Hibernate will not execute any update statement and but it will change the state of the object to persistant again.
+ If it is highly likely that the object has changed before the update then setting `selectbeforeupdate=true` is inefficient.

#### NonUniqueObjectException

+ If we modify a detached object and want to update it, we have to reattach the object. During that reattachment process, Hibernate will check to see if there are any other copies of the same object. If it finds any, it has to tell us it doesn't know what the "real" copy is any more. Perhaps other changes were made to those other copies that we expect to be saved, but Hibernate doesn't know about them, because it wasn't managing them at the time.
+ Rather than save possibly bad data, Hibernate tells us about the problem via the `NonUniqueObjectException`. <http://www.stevideter.com/2008/12/07/saveorupdate-versus-merge-in-hibernate/>
+ A possible scenario would be: you obtain a detached object via a post handler. You fetch the persistent object for validation. Then you try to persist the detached object using `update()` or `saveorupdate()`.
+ ? sesion.merge will work fine and will not throw exception in this situation.

### saveOrUpdate - Hibernate

+ So long as you are not trying to use instances from one session in another new session, you should not need to use `update()` or `saveOrUpdate()`. Some whole applications will never use either of these methods.
+ Usually `update()` or `saveOrUpdate()` are used in the following scenario:
     + the application loads an object in the first session.
     + the object is passed up to the UI tier.
     + some modifications are made to the object.
     + the object is passed back down to the business logic tier.
     + the application persists these modifications by calling `update()` in a second session.

+ `saveOrUpdate()` does the following:
     + If the object is already persistent in this session, do nothing.
     + If another object associated with the session has the same identifier, throw an exception.
     + If the object has no identifier property, `save()` it.
     + If the object's identifier has the value assigned to a newly instantiated object, save() it.
     + If the object is versioned (by a <version> or <timestamp>), and the version property value is the same value assigned to a newly instantiated object, `save()` it.
     + Otherwise `update()` the object.

### merge (formerly saveOrUpdateCopy) - JPA, Hibernate

+ Merging is the process of taking an incoming entity instance that is in detached state and copying its data over onto a new instance that is in managed state.
+ If X is a detached entity,
     + If there is a persistent instance with the same identifier currently associated with the session, copy the state of the given object onto the persistent instance.
     + If there is no persistent instance currently associated with the session, try to load it from the database.
     + It does not alter X. (it remains detached)
     + The persistent entity is returned.
+ If X is a transient entity instance, a new managed entity instance X' is created and the state of X is copied into the new persisted entity instance X'.
     + It does not alter X. (it remains detached)
     + X' is returned.
+ If X is a removed entity instance, an IllegalArgumentException will be thrown (or the transaction commit will fail).
+ If X is a persistent entity, it is ignored by the merge operation, however, the merge operation is cascaded to entities referenced by relationships from X if these relationships have been annotated with the cascade element value `cascade=MERGE` or `cascade=ALL` annotation.
     + X is the same object as X'.
+ For all entities Y referenced by relationships from X having the cascade element value `cascade=MERGE` or `cascade=ALL`, Y is merged recursively as Y'. For all such Y referenced by X, X' is set to reference Y'. + If X is an entity merged to X', with a reference to another entity Y, where `cascade=MERGE` or `cascade=ALL` is not specified, then navigation of the same association from X' yields a reference to a managed object Y' with the same persistent identity as Y.
+ Considerations
    + *Merge may be inefficient in some scenerios as it may require an **additional select** or **duplication of the object.***
    + Be aware that merge does not persist the argument you pass to it, rather returns a new persistent entity.

### Checking persistent state

+ An application can verify the state of entities and collections in relation to the persistence context.

```
session.contains( cat );
Hibernate.initialize(cat);
Hibernate.isInitialized( customer.getOrders()) );
Hibernate.isPropertyInitialized( customer, "detailedBio” );

entityManager.contains( cat );
javax.persistence.PersistenceUnitUtil jpaUtil = entityManager.getEntityManagerFactory().getPersistenceUnitUtil();
jpaUtil.isLoaded( customer.getOrders());
jpaUtil.isLoaded( customer, "detailedBio" );
```

### `get(Class,PK)`

+ selects the object with the PK.






**References**

- [Java Brains]( http://javabrains.koushik.org/hibernate.html)
- [Hibernate Manual](http://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/)
- [JPA Specification](https://www.jcp.org/en/jsr/detail?id=317)
- <http://stackoverflow.com/questions/4509086/what-is-the-difference-between-persist-and-merge-in-hibernate>
- <http://stackoverflow.com/questions/170962/nhibernate-difference-between-session-merge-and-session-saveorupdate>
- <http://stackoverflow.com/questions/161224/what-are-the-differences-between-the-different-saving-methods-in-hibernate>
