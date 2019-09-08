# Database design patterns

## Table inheritance

We show how to model a ```customer``` type with two mutually exclusive subtypes:  ```person``` and ```company```. 
We want to express the following data integrity constraints:

* A ```customer``` cannot simultaneously be both ```person``` and ```company```.
* A ```customer``` is always also a ```person``` or a ```company```.
* Any ```Person``` and any```company``` must also be a ```customer```.

We set up a conspiracy of primary keys, foreign keys, check constraints and uniqueness constraints, 
pulling together to achieve this goal.
