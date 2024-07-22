SELECT * FROM bankanalysis_project.finance_1;

use bankanalysis_project;

select * from Finance_1;
select * from Finance_2;

select count(*) from Finance_1;
select count(*) from Finance_2;

/*
 1) Year wise loan amount
 2) Grade-Subgrade wise revolution balance
 3) Total Payment For Verified Status Vs Non Verified Status
 4) State Wise Last credit pull _d Wise Loan Status
 5) Home Ownership Vs Last Payment Date Stats.
 */
 
 #KPI 1 --- Year wise loan amount ---
 select year(issue_d) as Year_of_issue_d, sum(loan_amnt) as Total_loan_amnt from finance_1
 group by 1
 order by 1;
 
#KPI 2 --- Grade-Subgrade wise revolution balance ---
 select grade , sub_grade , sum(revol_bal) as total_revol_bal
 from finance_1 inner join finance_2
 on (finance_1.id = finance_2.id)
 group by 1, 2
 order by 1 , 2;
 
 #KPI 3 --- Total Payment For Verified Status Vs Non Verified Status ---
 select verification_status ,concat("$", format(round(sum(total_pymnt)/1000,2) ,2),"K") as total_payment
 from finance_1 inner join finance_2
 on (finance_1.id = finance_2.id)
 group by 1;
 

#KPI 4 --- State Wise Last credit pull _d Wise Loan Status ---

select addr_state as state,monthname(issue_d) as "Month",
sum(case when loan_status = "Fully Paid" then 1 else 0 end) as "Fully Paid",
sum(case when loan_status="Charged Off" then 1 else 0 end) as "Charged odd",
sum(case when loan_status="Current" then 1 else 0 end) as "Current",
count(*) as "Total count"
from finance_1 
group by addr_state,monthname(issue_d)
order by addr_state , monthname(issue_d) desc;


#KPI 5 --- Home Ownership Vs Last Payment Date Stats. ---

select f1.home_ownership as Ownership, f2.last_pymnt_d as "Date",concat(format(sum(f2.last_pymnt_amnt)/1000,2),"K") as Amount
from finance_1 as f1
join finance_2 as f2 on
f1.id=f2.id
where f2.last_pymnt_d <> ""
group by 1 , 2  
order by 1,2 desc;

