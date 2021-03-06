module DateLib
using Iterators
import Base.==,Base.-,Base.+,Base.println,Base.show,Base.display; # we must import a method to add methods (as opposed to replacing it)
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

export println
function println(inDate::DateClass)
println("$(inDate.day) $(MonthMatch(inDate.month)) $(inDate.year)")
end

export display
function display(inDate::DateClass)
display("$(inDate.day) $(MonthMatch(inDate.month)) $(inDate.year)")
end

export show
function show(inDate::DateClass)
show("$(inDate.day) $(MonthMatch(inDate.month)) $(inDate.year)")
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
	return is30Month(m) ? 30 : (m==2 ? isLeapYear(y)+28 : 31);
end

export isEndMonth
function isEndMonth(inDate::DateClass)
		return (lengthMonth(inDate.month,inDate.year)==inDate.day);
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
#########OPERATORS
==(x::DateClass, y::DateClass) = ((x.day==y.day)&&(x.month==y.month)&&(x.year==y.year))
-(x::DateClass, y::DateClass) = dayact(y,x);
+(x::DateClass, y::Integer) = nth(iterate(addoneday,x),y+1);
-(x::DateClass, y::Integer) = nth(iterate(suboneday,x),y+1);


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
	
	#########
elseif(convention==5)		#(30/360 ISDA)
	y1=startDate.year;
	m1=startDate.month;
	y2=endDate.year;
	m2=endDate.month;
	if(startDate.day<31)
		d1=startDate.day;
	else
		d1=30;
	end
	if ((endDate.day==31)&(d1>29))
		d2=30;
	else
		d2=endDate.day;
	end
	yearFrac=(360.0*((y2-y1))+30.0*((m2-m1))+(d2-d1))/360.0;
				
elseif(convention==6)		#(30E/360)
	y1=startDate.year;
	m1=startDate.month;
	y2=endDate.year;
	m2=endDate.month;
	d1=startDate.day;
	d2=endDate.day;
	if(d1==31)
		d1=30;
	end
	if(d2==31)
		d2=30;
	end
	dy=y2-y1;
	dm=m2-m1;
	dd=d2-d1;
	yearFrac=(360.0*dy+30.0*dm+dd)/360.0;
	
	############
end
return yearFrac;

end

currMaxImplemented=6;

export addXMonth
function addXMonth(inDate::DateClass,shiftM::Integer=1)
if(shiftM<0)
	error("It is possible only to add month")
end
if(shiftM==0)
	return inDate;
end
	d1=inDate.day;
	m1=inDate.month;
	y1=inDate.year;
	shiftY=div(shiftM,12);
	shiftM=shiftM%12;
	if(shiftM>12-m1)
		shiftM-=12;
		shiftY=shiftY+1;
	end
	m1+=shiftM;
	y1+=shiftY;
	d1=d1<=lengthMonth(m1,y1)?d1:lengthMonth(m1,y1);
	return DateClass(d1,m1,y1);
end

export addoneday;
function addoneday(inDate::DateClass)

	d=0;#inDate.day;
	m=inDate.month;
	y=inDate.year;
	if(!isEndMonth(inDate))
		d=inDate.day+1;
	elseif(inDate.month!=12)
		d=1;
		m=inDate.month+1;
	else
		m=1;
		d=1;
		y=inDate.year+1;
	end
	return DateClass(d,m,y);
end

export suboneday;
function suboneday(inDate::DateClass)
	d=0;#inDate.day;
	m=inDate.month;
	y=inDate.year;
	if(inDate.day!=1)
		d=inDate.day-1;
	elseif(inDate.month!=1)
		m=inDate.month-1;
		if(is30Month(m))
			d=30;
		elseif(m==2)
		
			if(isLeap(DateClass(1,m,y)))
				d=29;
			else
				d=28;
			end
		else
			d=31;
		end
	else
		m=12;
		d=31;
		y=inDate.year-1;
	end
	return DateClass(d,m,y);
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
