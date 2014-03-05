csvproc
=======

Utility for processing csv files.


# Examples

	$ cat test/a.csv
    a,b,c,d,e
    1,2,3,4,5
    6,7,8,9,0,no_key
	$ csvproc keyval test/a.csv
    a=1
    b=2
    c=3
    d=4
    e=5
    --------
    a=6
    b=7
    c=8
    d=9
    e=0
    =no_key

# Installation
(Not necessary. You can run script using full path)

        $ git clone https://github.com/jedvardsson/csvproc.git
        $ cd csvproc
        $ ./INSTALL.sh