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

FileLeapYears=open("LeapYears.txt");
LeapYearStrings = readlines(FileLeapYears);
LeapYears=Array{Int64}(length(LeapYearStrings));
for i=1:length(LeapYearStrings)
	LeapYears[i]=parse(Int64,LeapYearStrings[i]);
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


