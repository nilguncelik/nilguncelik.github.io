---
title: Hibernate
author: NC
category: hibernate
public: true
---

+ Hibernate maps Java objects to relational data kept in relational databases.

+ It is tough to maintain object relationships and the object state together because what is happening on the relational side is completely different from what is happing on the object oriented side. Because we can not change the relational side (it has to end up in a relational set of data kept in **relational databases**), people tend to compromise on the **object oriented side** of it.

* Hibernate
     * helps you to remove or encapsulate vendor-specific SQL code.
     * helps with the common task of result set translation from a tabular representation to a graph of objects.
     * provides data query and retrieval facilities.

#### hibernate.cfg.xml

+ Hibernate configuration file:
    + db connection
    + connection pool
    + sql dialect
    + cache
    + show sql
    + schema generation (hbm2ddl)  create/update
    + mapping classes

#### Dialect

+ Although SQL is relatively standardized, each database vendor uses a subset of supported syntax. This is referred to as a dialect.

#### SessionFactory

+ It is an expensive-to-create, threadsafe object, intended to be shared by all application threads.
+ It is created once, usually on application startup, from a Configuration instance.

#### Session

+ A session is opened using the session factory.

+ The Hibernate *org.hibernate.Session* acts as a transaction-scoped cache providing repeatable reads for lookup by identifier and queries that result in loading entities.

+ It is an inexpensive, non-threadsafe object that should be used once and then discarded for: a single request, a conversation or a single unit of work.

+ A Session will not obtain a JDBC Connection, or a Datasource, unless it is needed.

+ A Session is not thread-safe. Things that work concurrently, like HTTP requests, session beans, or Swing workers, will cause race conditions if a Session instance is shared.

#### Transaction

+ The term transaction might refer to
     + the physical transaction with the database.
     + the logical notion of a transaction as related to a persistence context.

+ Hibernate supports JDBC, JTA, CMT and custom mechanisms for integrating with transactions and allowing applications to manage physical transactions.

+ A transaction is started on the session object.

+ To reduce lock contention in the database, the physical database transaction needs to be as short as possible. Long database transactions prevent your application from scaling to a highly-concurrent load. Do not hold a database transaction open during end-user-level work, but open it after the end-user-level work is finished. This is concept is referred to as **transactional write-behind**.

+ Database transactions are not optional. All communication with a database must be encapsulated by a transaction.

+ Do not use auto-commit mode, instead group your database calls into a planned sequence.
    + In auto-commit mode, JDBC drivers perform each call in an implicit transaction call. It is as if your application called commit after each and every JDBC call.

#### Object Identity

+ An application can concurrently access the same persistent state in two different Sessions. However, an instance of a persistent class is never shared between two Session instances. It is for this reason that there are two different notions of identity:
	1. Database Identity: `foo.getId().equals( bar.getId() )`
	2. JVM Identity: `foo==bar`

+ For objects attached to a particular Session (i.e., in the scope of a Session), the two notions are equivalent and JVM identity for database identity is guaranteed by Hibernate.

+ While the application might concurrently access the "same" (persistent identity) business object in two different sessions, the two instances will actually be "different" (JVM identity). Conflicts are resolved using an optimistic approach and automatic versioning at flush/commit time.

+ This approach leaves Hibernate and the database to worry about concurrency. It also provides the best scalability, since guaranteeing identity in single-threaded units of work means that it does not need expensive locking or other means of synchronization. The application does not need to synchronize on any business object, as long as it maintains a single thread per Session. Within a Session the application can safely use == to compare objects.

+ However, an application that uses == outside of a Session might produce unexpected results. This might occur even in some unexpected places. For example, if you put two detached instances into the same Set, both might have the same database identity (i.e., they represent the same row). JVM identity, however, is by definition not guaranteed for instances in a detached state. The developer has to override the equals() and hashCode()methods in persistent classes and implement their own notion of object equality.

+ There is one caveat: never use the database identifier to implement equality. Use a business key that is a combination of unique, usually immutable, attributes. The database identifier will change if a transient object is made persistent. If the transient instance (usually together with detached instances) is held in a Set, changing the hashcode breaks the contract of the Set. Attributes for business keys do not have to be as stable as database primary keys; you only have to guarantee stability as long as the objects are in the same Set. Please note that this is not a Hibernate issue, but simply how Java object identity and equality has to be implemented.

#### hibernate.current_session_context_class

+ Valid values : `jta`, `thread`, and `managed` or any class implementing `org.hibernate.context.spi.CurrentSessionContext` interface.
+ It maps a current session ( e.g. `SessionFactory.getCurrentSession()` ) to different contexts.

##### thread

+ To avoid creating too many sessions `ThreadLocal` class is used.
+ It returns the current session no matter how many times you make call to the currentSession() method.

```java
public class HibernateUtil {

     public static final ThreadLocal local = new ThreadLocal();

     public static Session currentSession() throws HibernateException {
          Session session = (Session) local.get();
          //open a new session if this thread has no session
          if(session == null) {
               session = sessionFactory.openSession();
               local.set(session);
          }
          return session;
     }
}
```


**References**

- [Java Brains]( http://javabrains.koushik.org/hibernate.html)
- [Hibernate Manual](http://docs.jboss.org/hibernate/orm/4.1/manual/en-US/html_single/)
- [Hibernate FAQ - Advanced Problems](https://community.jboss.org/wiki/HibernateFAQ-AdvancedProblems)
- [Hibernate FAQ - Common Problems](https://community.jboss.org/wiki/HibernateFAQ-CommonProblems)
- [Hibernate FAQ - Hibernate Annotations](https://community.jboss.org/wiki/HibernateFAQ-HibernateAnnotationsFAQ)
- [Hibernate DevGuide](http://docs.jboss.org/hibernate/orm/4.1/devguide/en-US/html_single/)
