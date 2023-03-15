#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

function GET_ELEMENT_RESULTS {
  ATOMIC_NUMBER=$1

  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
  else
    # get results from elements table
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    # get results from properties table
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    # print results
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

# if there is no first argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT=$1
  # if arg is an integer
  if [[ $ELEMENT =~ ^[0-9]+$ ]]
  then
    GET_ELEMENT_RESULTS $ELEMENT
  # if arg is a symbol
  elif [[ $ELEMENT =~ ^[a-zA-Z]{1,2}$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT'")
    GET_ELEMENT_RESULTS $ELEMENT
  # if arg is the full name
  else
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name='$ELEMENT'")
    GET_ELEMENT_RESULTS $ELEMENT
  fi
fi
