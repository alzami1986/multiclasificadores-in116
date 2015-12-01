UCI32 dataset 
================
Version 0.1, September 1st 2013
Author: Chun Yang

1. Summary
This package contains 32 datasets from UCI learning repository.
A. Frank and A. Asuncion, UCI machine learning repository, University of California, Irvine, School of Information and Computer Sciences, 2010. [Online]. Available: http://archive.ics.uci.edu/ml

2. Details
Data Set  	Instances	Attributes	Classes		Data Set  	Instances	Attributes	Classes
artificial  	5109		7		10		audiology 	226		69			24
auto-mpg 	399		7		4		autos 		205		25			7
balance-scale	626		4		3		balloons	76		4			2
breast-cancer	286		9		2		bridges2	108		11			6
clean1		476		166		2		colic		368		22			2
credit-a	695		15		2		diabetes	768		8			2
echocardiogram	132		8		2		flag		194		27			6
german		1000		24		2		glass		214		9			7
hayes-roth	132		4		3		heart-c		303		13			5
heart-h		294		13		5		heart-statlog	270		13			2
hepatitis	155		19		2		kr-vs-kp	3196		36			2
led24		3200		24		10		led7		3200		7			10
lymph		148		18		4		machine		209		7			8
sonar		208		60		2		vehicle		848		18			4
vowel		990		13		11		wave21		5000		21			3
wave40		5000		40		3		zoo		104		17			7

All data sets are stored as Mat files. 
In each Mat file, there are two parameters:
input  : an N*Ni matrix, where N is the number of data samples, Ni is the number of features;
target : an N*1 vector.