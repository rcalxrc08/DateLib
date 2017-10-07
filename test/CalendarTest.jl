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
	j=(i%2==0) ? i-1 : i;
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

LeapYears=[1904];
push!(LeapYears,1908);
push!(LeapYears,1912);
push!(LeapYears,1916);
push!(LeapYears,1920);
push!(LeapYears,1924);
push!(LeapYears,1928);
push!(LeapYears,1932);
push!(LeapYears,1936);
push!(LeapYears,1940);
push!(LeapYears,1944);
push!(LeapYears,1948);
push!(LeapYears,1952);
push!(LeapYears,1956);
push!(LeapYears,1960);
push!(LeapYears,1964);
push!(LeapYears,1968);
push!(LeapYears,1972);
push!(LeapYears,1976);
push!(LeapYears,1980);
push!(LeapYears,1984);
push!(LeapYears,1988);
push!(LeapYears,1992);
push!(LeapYears,1996);
push!(LeapYears,2000);
push!(LeapYears,2004);
push!(LeapYears,2008);
push!(LeapYears,2012);
push!(LeapYears,2016);
push!(LeapYears,2020);
push!(LeapYears,2024);
push!(LeapYears,2028);
push!(LeapYears,2032);
push!(LeapYears,2036);
push!(LeapYears,2040);
push!(LeapYears,2044);
push!(LeapYears,2048);
push!(LeapYears,2052);
push!(LeapYears,2056);
push!(LeapYears,2060);
push!(LeapYears,2064);
push!(LeapYears,2068);
push!(LeapYears,2072);
push!(LeapYears,2076);
for i=1:length(LeapYears)
	@test true==isLeapYear(LeapYears[i])
end
ii=1;
for i=1904:2076
	if i==LeapYears[ii]
		@test DateClass(29,2,i)==DateClass(29,2,i);
		@test true==isLeapYear(LeapYears[ii])
		ii+=1
	else
		@test_throws(ErrorException, DateClass(29,2,i))
		@test false==isLeapYear(i)
	end
end
println("Test Last of February Passed")


