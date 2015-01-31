---
title: Hibernate HQL
author: NC
category: hibernate
public: true
---


##HQL

- TR - <http://levelup.lishman.com/hibernate/hql/projection.php>

### Pagination

```
Query query = session.createQuery(“select new map(userId,username) from UserDetails");
query.setFirstResult();
query.setMaxResults();
// will return List<Map>
```

### Parameter Binding

+ It is used instead of concatenating string user input to queries.

```
Query query = session.createQuery("from UserDetails where userId > " + userId);

Query query = session.createQuery("from UserDetails where userId > ? and userName= ?");
query.setInteger(0,Integer.parseInt(minUserId));
query.setInteger(1,userName);   // Hibernate handles injection

Query query = session.createQuery("from UserDetails where userId > :userId and userName= :userName");
query.setInteger("userId",Integer.parseInt(minUserId));
query.setInteger("userName",userName);
```


**References**

- [Java Brains](http://javabrains.koushik.org/hibernate.html)
- [Hibernate Documentation](http://docs.jboss.org/hibernate/orm/4.1/devguide/en-US/html_single/)
