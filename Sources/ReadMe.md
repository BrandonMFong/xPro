# xPro c++ coding standard


## Functions
CamelCased names
Boolean Types: 'Is{Function}'

## Variables
camelCased names
Boolean names: 'is{Variable Name}'

## Directory names in Tools folder
The directory must be all lowercased 

## define Heders
Use #ifdef

## Global Variables
append variable with g, i.e. int gMyVar;

## Code
Define and/or initialize all variables at the beginning of the function

## Classes
Use getters and setters 

public, protected and private sections should be in said order 

members are always private and start with '_' 

Class names should start with x, i.e. xClassName

Only inherity from one other class

## Return types
if function affects in class variables, use void

## References
https://developer.lsst.io/v/DM-5063/docs/cpp_docs.html
https://gist.github.com/derofim/df604f2bf65a506223464e3ffd96a78a 