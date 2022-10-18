#!/bin/bash

# VARIABLES
PSQL="psql --username=postgres --dbname=periodic_table -t --no-align -c"

GET_ELEMENT_BY_ATOMIC_NUMBER()
{
  GET_ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number=$1;")
  SET_MESSAGE $GET_ELEMENT
}

GET_ELEMENT_BY_SYMBOL_OR_NAME()
{
  GET_ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol LIKE '$1' OR name LIKE '$1';")
  SET_MESSAGE $GET_ELEMENT
}

SET_MESSAGE()
{
  if [[ -n $1 ]]
  then
  ECHO_ELEMENT $1
  else
  echo "I could not find that element in the database."
  fi
}

ECHO_ELEMENT()
{
  echo "$1" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE
  do
   echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
}

if [[ $1 =~ ^[0-9]+$ ]]
then
  GET_ELEMENT_BY_ATOMIC_NUMBER $1
elif [[ -n $1 ]]
then
  GET_ELEMENT_BY_SYMBOL_OR_NAME $1
else
 echo "Please provide an element as an argument."
fi