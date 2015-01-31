---
title: Hibernate Filters
author: NC
category: hibernate
public: true
---


+ Hibernate has the ability to pre-define filter criteria and attach those filters at both a class level and a collection level.
+ A filter criteria allows you to define a restriction clause similar to the existing "where" attribute available on the class and various collection elements.

+ One advantage of filters over Criteria is that they can handle partial retrieval of child collections:
     + Assume you have a parent entity and child entity collection. You can use filters to fetch the parent entity with a partial collection that *ONLY* contains child entities specified with an id list.
     + Note that this partial retrieval can cause problems on updates, because Hibernate then think the filtered items have been removed and would update the database to reflect that change, actually removing the items from the Collection.


**References**

- <http://stackoverflow.com/questions/6102152/hibernate-criteria-api-filtering-collection-property/>
