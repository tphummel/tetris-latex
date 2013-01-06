#! /usr/bin/env sh

cat tnt_2012_04_04.sql | sed 's/ENGINE=MyISAM/ENGINE=InnoDB/g' > tnt_innodb.sql