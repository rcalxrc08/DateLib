using DateLib
using Base.Test

# write your own tests here
@test 1 == 1



StartDate=DateClass(14,12,1992);
EndDate=DateClass(28,2,1996);
MatlabResults=[ 3.208219178082192;  3.205555555555556;  3.252777777777778; 3.208219178082192 ; 3.205555555555556 ]
TestToll=1e-14;
for i=1:length(MatlabResults)
	@test(abs(MatlabResults[i]-yearfrac(StartDate,EndDate,i-1))<TestToll)
end



EndDate=DateClass(29,2,1996);
MatlabResults=[ 3.210958904109589; 3.208333333333334; 3.255555555555556; 3.210958904109589; 3.208333333333334 ]
TestToll=1e-14;
for i=1:length(MatlabResults)
	@test(abs(MatlabResults[i]-yearfrac(StartDate,EndDate,i-1))<TestToll)
end


println("Test YearFraction Passed")


