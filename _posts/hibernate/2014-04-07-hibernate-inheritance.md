---
title: Hibernate Inheritance
author: NC
category: hibernate
public: true
---


- Vehicle
  - TwoWheeler:Vehicle
  - FourWheeler:Vehicle

1. Which table will vehicles property refer to?

    ```
     class User{
       List<Vehicle> vehicles;
     }
    ```
2. If you add a property to base class (Vehicle) it will not be propagated to subclasses. You have to do it manually for db. (TODO: why?)

### Single Table Strategy (default)

```
Vehicle ->@Entity @Inheritance(strategy=InheritanceType.SINGLE_TABLE)
TwoWheeler:Vehicle ->@Entity
FourWheeler:Vehicle ->@Entity
```
+ Single Table will be created with following columns:
  + DTYPE, all vehicle properties, TwoWheeler properties, FourWheeler properties
  + DType: Vehicle, TwoWheeler,FourWheeler
  + All FourWheeler properties will be empty for TwoWheeler objects.
  + All TwoWheeler properties will be empty for FourWheeler objects.
  + All TwoWheeler and FourWheeler properties will be empty for Vehicle objects.

```
@DiscriminatorColumn(name=“vehicle_type”,discriminatorType=DiscriminatorType.STRING)
@DiscriminatorValue(“Bike”) -> Instead of "TwoWheeler” DType column will have "Bike" value.
```

### Table Per Class Strategy

```
Vehicle ->@Entity @Inheritance(strategy=InheritanceType.TABLE_PER_CLASS)
```
+ Pro: You have normalised tables which don’t have extra columns

### Joined Strategy

```
Vehicle ->@Entity @Inheritance(strategy=InheritanceType.JOINED)
```

+ Columns inheriting from base class stay in the base class table.
+ Subclasses own properties + subclass id are stored in the subclass table.
+ Full subclass record can be accessed by joining base class and subclass table.

**References**

- [Java Brains]( http://javabrains.koushik.org/hibernate.html)
- [Hibernate Documentation](http://docs.jboss.org/hibernate/orm/4.1/devguide/en-US/html_single/)
