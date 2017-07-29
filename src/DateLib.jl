module DateLib

function MonthMatch(i::Integer)

outString=0;
if i==1
	outString="January"
elseif(i==2)
	outString="February"
elseif(i==3)
	outString="March"
elseif(i==4)
	outString="April"
elseif(i==5)
	outString="May"
elseif(i==6)
	outString="June"
elseif(i==7)
	outString="July"
elseif(i==8)
	outString="August"
elseif(i==9)
	outString="September"
elseif(i==10)
	outString="October"
elseif(i==11)
	outString="November"
elseif(i==12)
	outString="December"
end
return outString;
end
#export DataCheck
function DataCheckInternal(d::Integer,m::Integer,y::Integer)
flag=isLeapYear(y);
resFlag=false;
if (d<1||d>31)
	error("The following Day is Invalid : $d")
elseif(m>12||m<1)
	error("The following Month is Invalid : $m")
elseif(m==2)
	if(flag)
		if (d < 30 && d > 0)
			resFlag = true;
		end
	else
		if (d < 29 && d > 0)
			resFlag = true;
		end
	end
else
	if((m==11)||(m==9)||(m==6)||(m==4))
		if (d < 31 && d > 0)
			resFlag = true;
		end
	else
		if (d < 32 && d > 0)
			resFlag = true;
		end
	end
end
if (!resFlag)
	error("The following Date is Invalid: $d / $m / $y")
end
return resFlag;
end

export DateClass
# package code goes here
type DateClass
   day::Integer
   month::Integer
   year::Integer
   DateClass(day,month,year)= DataCheck(day,month,year) ? new(day,month,year) : error("Invalid Costructor");
end

import Base.println;
export println
function println(inDate::DateClass)
println("$(inDate.day) $(MonthMatch(inDate.month)) $(inDate.year) ")
end

export dayNumber
function dayNumber(inDate::DateClass)

	y=Integer(inDate.year);
	m=Integer(inDate.month);
	d=Integer(inDate.day);
	m = (m + 9) % 12;
	y = y - div(m,10);
	return (365*y + div(y,4) - div(y,100) + div(y,400) + div((m*306 + 5),10) + ( d - 1 ));
	
end
export isLeapYear
function isLeapYear(year::Integer)

	return ((year & 3) == 0 && ((year % 25) != 0 || (year & 15) == 0));
	
end

export is30Month
function is30Month(m::Integer)
	return (((m==11)||(m==9)||(m==6)||(m==4)));
end

export lengthMonth
function lengthMonth(m::Integer,y::Integer)
	return is30Month(m)?30:(m==2?isLeapYear(y)+28:31);
end

export dayact
function dayact(Data1::DateClass,Data2::DateClass)
	D1= dayNumber(Data1);
	D2= dayNumber(Data2);
	dayCount=0;
	if (D1>D2)
		dayCount = D1 - D2;
	else
		dayCount=D2-D1;
	end
	return dayCount;
end


export isLastOfFebruary
function isLastOfFebruary(inDate::DateClass)
	return (isLeapYear(inDate.year)&&(inDate.day==29)&&(inDate.month==2))||((!isLeapYear(inDate.year))&&(inDate.day==28)&&(inDate.month==2));
end

export yearfrac
function yearfrac(startDate::DateClass,endDate::DateClass,convention::Integer)
yearFrac=0.0;
tmpDate=1;
if (convention==0) 		#(ACT/ACT)
	Nday=dayact(startDate,endDate);
	yearFrac=(Nday)/ dayact(startDate,DateClass(startDate.day,startDate.month,startDate.year+1));
elseif(convention==1)  	#(30/360 SIA)
	y1=startDate.year;
	m1=startDate.month;
	y2=endDate.year;
	m2=endDate.month;
	d1=startDate.day;
	d2=endDate.day;
	if(isLastOfFebruary(startDate)&&isLastOfFebruary(endDate))
		d2=30;
	end
	if(isLastOfFebruary(startDate)||startDate.day==31)
		d1=30;
	end
	if(d1==30&&d2==31)
		d2=30;
	end
	dy=y2-y1;
	dm=m2-m1;
	dd=d2-d1;
	yearFrac=(360.0*dy+30.0*dm+dd)/360.0;
elseif(convention==2)		#(ACT/360)
	Nday=dayact(startDate,endDate);
	yearFrac=(Nday)/360.0;
elseif(convention==3)		# (ACT/365)
	Nday=dayact(startDate,endDate);
	yearFrac=( Nday)/365.0;	
elseif(convention==4)		# (30/360 PSA)
	y1=startDate.year;
	m1=startDate.month;
	y2=endDate.year;
	m2=endDate.month;
	d1=startDate.day;
	d2=endDate.day;
	if((startDate.day==31)||isLastOfFebruary(startDate))
		d1=30;
	end
	if((startDate.day==30||isLastOfFebruary(startDate))&&endDate.day==31)
		d2=30;
	end
	dy=y2-y1;
	dm=m2-m1;
	dd=d2-d1;
	yearFrac=(360.0*dy+30.0*dm+dd)/360.0;
end
return yearFrac;

end


function DataCheck{T1 <: Number,T2 <: Number,T3 <: Number}(d::T1,m::T2,y::T3)
if !isa(d,Integer)
	error("Day must be an Integer")
elseif !isa(m,Integer)
	error("Month must be an Integer")
elseif !isa(y,Integer)
	error("Year must be an Integer")
end
resFlag=DataCheckInternal(d,m,y);
return resFlag;
end



end # module
