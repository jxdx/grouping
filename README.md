# Grouping

The goal of this exercise is to identify rows in a CSV file that may represent the same person based on a provided Matching Type (definition below).

The resulting program should allow us to test at least three matching types:

one that matches records with the same email address.
one that matches records with the same phone number.
one that matches records with the same email address OR the same phone number.

I am making the assumption that when a contact has multiple phone numbers, all phone numbers must match.
Otherwise, the person might live in the same household but not be the same person.
For example:
Jane Doe has phone1: 555-555-5555, phone2: 555-555-6666
John Doe has phone1: 555-555-5555, phone2: 555-555-7777

Jane and John are husband and wife and have the same main number but different cell numbers.

This can be easily changed if the business decision is that if any of the phone numbers match
then it is considered the same person.

I made the same assumption for contacts with multiple email addresses.

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

Upon successful completion the output creates a new file as the input file with `_grouping.csv` appended to it.
i.e `input1_grouping.csv`

## Tests

Run the following command:

```
bundle exec rspec
```
