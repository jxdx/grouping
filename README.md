# Grouping

The goal of this exercise is to identify rows in a CSV file that may represent the same person based on a provided Matching Type (definition below).

The resulting program should allow us to test at least three matching types:

one that matches records with the same email address.
one that matches records with the same phone number.
one that matches records with the same email address OR the same phone number.

## Setup

```
./bin/setup
```

## Instructions

Open a ruby console with the following command:

```
bin/console
```

Start the program with the following command:

```
Grouper.start('spec/fixtures/input1.csv', 'phone')
```

The first parameter can be a path to any csv file with atleast name and phone columns.
The second parameter can be 'email', 'phone', or 'both'

Upon successful completion the output creates a new file as the input file with '\_grouping.csv' appended to it.
i.e `input1_grouping.csv`
