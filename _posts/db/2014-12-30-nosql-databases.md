---
title: NOSQL Databases
author: NC
category: db
public: true
---

## History

- 1980s
  - Relational databases were commanly used.
    - Impedance Mismatch problem: matching objects/classess with tables. ORMs used to deal with this problem.
- 1990s
  - Object databases
    - Save objects directly in disks.
    - This approach didn't work out because sql databases became an integration mechanism. A lot of applications were integrated through sql databases (instead of web services like today). That made it very difficult for a new technology come in.

- Big internet sites with big data could not scale with central relational databases. Since vertical scaling is limited, they took the horizontal scaling approach. But SQL databases do not play well with clusters. As a result Google(Bigtable) and Amazon(Dynamo) came up with their own data stores. This started NOSQL movement.

## Characteristics of NoSQL

- non-relational
- cluster-friendly
- schema-less (you may still need to know the implicit schema to query the table)

## Data Model
- Document  
     - ex. MongoDB, CouchDB, ravenDB.
     - Each document is some complex data structure probably in json.
     - can be queried, partially retrieved, partially updated.
     - No shema - still you need to know the implicit schema to query the table.
     - Aggregate oriented.
- ColumnFamily
     - ex. Cassandra, HBas.e
     - Aggregate oriented.
- Key Value Store
     - ex. Risk, Redis, Voldemort.
     - Aggregate oriented.
- Graph
     - ex. neo4j.
     - Nodes and arcs.
     - Very good at handling moving across relationships between things.
          - relational databases are not good at jumping relationships; you have to set up foreign keys, do joins, probably too many joins. Not good for graph structures.
     - Has specialized query language.


### Aggregate oriented vs Graph Oriented

- Aggregate oriented takes a lot of stuff scattered around and put them together while graph oriented databases break things into smaller units and you play with those units more carefully.
- Impedance Mismatch problem is drastically reduced if you have natural aggregates.
- If you change your application structure you run map reduce jobs to rearrange your data to new aggregate form. Rearranging data with RDMS is easy but very hard with nosql. Being aggragate oriented is an advantage if most of the time you use the same aggregate to push data back and forth but it is a disadvantage if you if you slice and dice your data in different ways.
- If you work with same aggregates all the time, take aggragate oriented approach. If you break things and jump across lots of relationships in a complex structure take graph approach. If tabular structure works well for you take relational approach.

## Consistency

### Logical Consistency

- Dealing with lots of people trying to modify same data at the same time.
- If you have got a single unit of information and you want to split it across several tables what you don't wanna be caught in this position is that you only get to write half the data and then somebody else reads it. Or you get to write half the data and somebody gets the same order and writes a different half of the data and things get really messy.
- Relational databases handle this with atomic updates and transactions. Update atomicly so that you have a successor fail and nobody comes in the middle to mass things up.
- Aggregate oriented databases do not have ACID, but graph databases have.
- Aggregate oriented databases may not need transactions at all because they are a richer structure. Aggregates are transaction boundaries. Any aggregate update is atomic, it gonna be consistent within itself. If you happen to update multiple aggregates concurrency will be a problem but this happens very rarely.
- Even if you are using relational databases there are also issues to tackle with. Assume there are two clients:
     - client1 and client2 request data.
     - client1 updates data and post to server.
     - client2 updates data and post to server.
     - Normally you can expect client2 to get an error, since she is not updating the same version of data she got in the first place.
     - To do this, you need to use versioning. You need to version the initial data you sent(v101). And update the version when client1 updates data (v102). When you need to update data sent by client2 you will know that data has been changed and you can throw an error.


### Replication Consistency

- Assume a scenario where client1 and client2 want to make a hotel reservation and associated hotel room data is replicated on two different nodes.
- If the communication line between these replicated nodes is gone, there is a risk that database will accept both reservation on the same room. To prevent it, the system can throw an error if the communication between nodes is down. But this time your system will not be available to its users.
- Even if the network is up, there will be delay in response for the two nodes to communicate.
- The choice depends on your business rules. If the hotel can make other rooms available or you can send your users an apology letter than you can go with inconsistent way. Actually most business people select to have high availability.

#### Cap theorem
- consistency, availability, partitionTolerance : pick any 2.
- If you have partioning you can only have consistency or availability. But there are levels in the consistency and availability spectrum, It is not binary.
- Even if your network is up you can choose lower response time and sacrifice consistency to come up with solution later. Instead of being consistent you may wanna be quick.

- Other consistancy issues (TODO)
  - Relaxing durability
  - Eventual consistency
  - Quorums
  - Read-Your-Writes consistency



## Why should I use NOSQL?

- large scale data.
- easier development.

- Before applications were being integrated at the database level. This was a reason why object databases could not become popular. Now NOSQL databases are popular because applications are now preferably integrated with a web service layer and each application has its own database.

- In the future we will have polyglot persistence. When you are building an application you may be using lots different databases. You will choose an appropriate database for the nature of the problem you are working with.





**References**

[Introduction to NoSQL by Martin Fowler](https://www.youtube.com/watch?v=qI_g07C_Q5I)
