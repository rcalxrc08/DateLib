using DateLib
using Base.Test

for i=1:100
	FOY=DateClass(1,1,1890+i);
	@test 1==FOY.day;
	@test 1==FOY.month;
	@test 1890+i==FOY.year;
end
println("Simple Test Passed")

println("Starting Domain Test")
for i=1:100
	j=(i%2==0)?i-1:i;
	@test_throws(ErrorException, DateClass(29,2,1900+j))
end

for i=0:100
	@test_throws(ErrorException, DateClass(1,1,1900+i*1.0000001))
end
for i=0:11
	@test_throws(ErrorException, DateClass(1,1+i*1.0000001,1900))
end
for i=0:20
	@test_throws(ErrorException, DateClass(1+i*1.0000001,1,1900+i))
end
println("Domain Test Passed")

println("Starting Last of February Test")

@test true==isLeapYear(1904) ;
@test true==isLeapYear(1908) ;
@test true==isLeapYear(1912) ;
@test true==isLeapYear(1916) ;
@test true==isLeapYear(1920) ;
@test true==isLeapYear(1924) ;
@test true==isLeapYear(1928) ;
@test true==isLeapYear(1932) ;
@test true==isLeapYear(1936) ;
@test true==isLeapYear(1940) ;
@test true==isLeapYear(1944) ;
@test true==isLeapYear(1948) ;
@test true==isLeapYear(1952) ;
@test true==isLeapYear(1956) ;
@test true==isLeapYear(1960) ;
@test true==isLeapYear(1964) ;
@test true==isLeapYear(1968) ;
@test true==isLeapYear(1972) ;
@test true==isLeapYear(1976) ;
@test true==isLeapYear(1980) ;
@test true==isLeapYear(1984) ;
@test true==isLeapYear(1988) ;
@test true==isLeapYear(1992) ;
@test true==isLeapYear(1996) ;
@test true==isLeapYear(2000) ;
@test true==isLeapYear(2004) ;
@test true==isLeapYear(2008) ;
@test true==isLeapYear(2012) ;
@test true==isLeapYear(2016) ;
@test true==isLeapYear(2020) ;
@test true==isLeapYear(2024) ;
@test true==isLeapYear(2028) ;
@test true==isLeapYear(2032) ;
@test true==isLeapYear(2036) ;
@test true==isLeapYear(2040) ;
@test true==isLeapYear(2044) ;
@test true==isLeapYear(2048) ;
@test true==isLeapYear(2052) ;
@test true==isLeapYear(2056) ;
@test true==isLeapYear(2060) ;
@test true==isLeapYear(2064) ;
@test true==isLeapYear(2068) ;
@test true==isLeapYear(2072) ;
@test true==isLeapYear(2076) ;

println("Test Last of February Passed")


