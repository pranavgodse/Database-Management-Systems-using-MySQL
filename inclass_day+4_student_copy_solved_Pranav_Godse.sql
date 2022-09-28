
############################################ Questions ############################################

use sql1_day4;

# Question 1:
# 1) Print customer Id, customer name and average account_balance maintained by each customer for all 
# of his/her accounts in the bank.
select bc.customer_id, customer_name, avg(balance_amount)
from bank_customer bc
join bank_account_details bad
on bc.customer_id = bad.customer_id
group by bc.customer_id;

# Question 2:
# 1) Print customer_id , account_number and balance_amount for all the accounts.
# 2) for account_type = "Credit Card" apply the condition that if balance_amount is nil then assign transaction_amount 

SELECT bad.customer_id, bad.account_number,
if(balance_amount = 0, bat.transaction_amount, balance_amount) as new_balance
from bank_account_details bad join bank_account_transaction bat
on bad.account_number = bat.account_number;

# Question 3:
# 3) Print account_number and balance_amount, transaction_amount,Transaction_Date from Bank_Account_Details and 
# bank_account_transaction for all the transactions occurred during march,2020 and april, 2020

select bat.Account_Number,transaction_amount,transaction_date,balance_amount
from bank_account_transaction as bat 
join bank_account_details as bad
on bat.account_number = bad.account_number
where month(Transaction_Date) in (3,4);

# Question 4:
# 4) Print all the customer ids, account number, balance_amount, transaction_amount , Transaction_Date 
# from bank_customer, Bank_Account_Details and bank_account_transaction tables where excluding 
# all of their transactions in march, 2020  month

select bad.customer_id, customer_name, bat.account_number, balance_amount, transaction_amount, transaction_date
from bank_customer as bc 
join bank_account_details as bad
on bc.customer_id = bad.Customer_id
join bank_account_transaction as bat 
on bad.account_number = bat.Account_Number
where month(Transaction_Date) <> 3; 

# Question 5:
# 5) Print the customer ids, account_number, balance_amount,transaction_amount ,transaction_date who did transactions 
# during the first quarter. Do not display the accounts if they have not done any transactions in the first quarter.

select bad.customer_id, bad.Account_Number, balance_amount, transaction_amount, transaction_date
from bank_account_details as bad
join bank_account_transaction as bat 
on bad.account_number = bat.Account_Number
where month(Transaction_Date) in (1,2,3);

# Question 6:
# 6) Print account_number, Event and Customer_message from BANK_CUSTOMER_MESSAGES and Bank_Account_Details to 
# display an “Adhoc" Event for all customers who have  “SAVINGS" account_type account.

select account_number, account_type,
event customer_message
from bank_customer_messages
cross join bank_account_details
where event = "Adhoc" and account_type = "Savings";

# Question 7:
# 7) Print all the Customer_ids, Account_Number, Account_type, and display deducted balance_amount by  
# subtracting only negative transaction_amounts for Relationship_type =
#  "P" ( P - means  Primary , S - means Secondary ) .

select bad.customer_id, bad.account_number , 
bad.account_type, balance_amount as original_ba,
case when bat.transaction_amount<0 then bad.balance_amount + bat.transaction_amount
else bad.balance_amount end as new_balance,
bat.transaction_amount
from bank_account_details bad join bank_Account_transaction bat
on bad.account_number = bat.account_number
where relationship_type = 'P';

# Question 8:
# a) Display records of All Accounts , their Account_types, the balance amount.
# b) Along with first step, Display other columns with corresponding linking account number, account types 

SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    balance_amount AS pr_balance,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type
FROM
    bank_account_details bad
        JOIN
    bank_account_relationship_details bar 
    ON bad.account_number = bar.linking_account_number;

# Question 9:
# a) Display records of All Accounts , their Account_types, the balance amount.
# b) Along with first step, Display other columns with corresponding linking account number, account types 
# c) After retrieving all records of accounts and their linked accounts, display the  
# transaction amount of accounts appeared  in another column.

SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    balance_amount AS pr_balance,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type,
    transaction_amount
FROM
    bank_account_details bad
       left JOIN
    bank_account_relationship_details bar 
    ON bad.account_number = bar.linking_account_number
    join bank_account_transaction as bat;

# Question 10:
# 10) Display all account holders from Bank_Accounts_Details table who have “Add-on Credit Cards" and “Credit cards" 

select * from bank_account_details where account_type like '%credit%';

# Question 11:
# 11)  Display  records of “SAVINGS” accounts linked with “Credit card" account_type and its credit
# aggregate sum of transaction amount.

SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    balance_amount AS pr_balance,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type,
    sum(transaction_amount)
FROM
    bank_account_details bad
        left JOIN
    bank_account_relationship_details bar 
    ON bad.account_number = bar.linking_account_number
    join bank_account_transaction as bat
    on bad.account_number = bat.account_number
    where bad.account_type  = 'Savings' and bar.account_type like '%credit%'
    group by bad.account_number ,
    bar.account_number;

# Ref: Use bank_Account_Details for Credit card types
		#Check linking relationship in bank_transaction_relationship_details.
        # Check transaction_amount in bank_account_transaction. 
        
# Question 12:
# 12) Display all type of “Credit cards”  accounts including linked “Add-on Credit Cards" 
# type accounts with their respective aggregate sum of transaction amount.

# Ref: Check Bank_Account_Details_table for all types of credit card.
        # Check transaction_amount in bank_account_transaction. 

SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type,
    SUM(transaction_amount)
FROM
    bank_account_details bad
        JOIN
    bank_account_relationship_details bar ON bad.account_number = bar.linking_account_number
        JOIN
    bank_account_transaction AS bat ON bad.account_number = bat.account_number
WHERE
    bad.account_type = 'Savings'
        AND bar.account_type LIKE '%credit%'
GROUP BY bad.account_number , bar.account_number;

# Question 13:
# 13) Display “SAVINGS” accounts and their corresponding aggregate sum of transaction amount 
# of all recurring deposits

SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type,
    sum(transaction_amount)
FROM
    bank_account_details bad
         JOIN
    bank_account_relationship_details bar 
    ON bad.account_number = bar.linking_account_number
    join bank_account_transaction as bat
    on bad.account_number = bat.account_number
    where bad.account_type  = 'Savings' and bar.account_type like '%recurring%'
    group by bad.account_number ,
    bar.account_number;

# Question 14:
# 14) Display recurring deposits and their transaction amounts in  Feb 2020  along with 
# associated SAVINGS account_number , balance. 

#select bad.account_number as primary_acno,
	#	bad.account_type as primary_actype,
        
SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type,
    sum(bat.transaction_amount)
FROM
    bank_account_details bad
         JOIN
    bank_account_relationship_details bar 
    ON bad.account_number = bar.linking_account_number
    join bank_account_transaction as bat
    on bar.account_number = bat.account_number
    where bad.account_type  = 'Savings' and bar.account_type like '%recurring%' and month(transaction_date)=2
    group by bad.account_number ,
    bar.account_number;

# Question 15:
# 15) Display every account's total no of transactions for every year and each month.
select Account_Number,year(transaction_date),month(transaction_date),count(transaction_date)
  from bank_account_transaction group by Account_Number,year(transaction_date),month(transaction_date);

# Question 16:
# 16) Compare the aggregate sum transaction amount of Feb2020 month versus Jan2020 Month for each account number.
-- Display account_number, transaction_amount , 
-- sum of feb month transaction amount ,
-- sum of Jan month transaction amount , 

select bat1.account_number , sum(bat1.transaction_amount) as Jan_amount , sum(bat2.Transaction_amount) as Feb_amount
from  bank_account_transaction bat1
join  bank_account_transaction bat2
on bat1.account_number = bat2.account_number
where month(bat1.transaction_date) =1 and  month(bat2.transaction_date) =2 
group by bat1.account_number;
 
# Question 17:
# 17) Display the customer names who have all three account types - 
# savings, recurring and credit card account holders.

select customer_name, bc.customer_id, count(distinct(account_type))
from bank_customer as bc
join bank_account_details as bad
on bc.customer_id = bad.customer_id
where account_type in ('savings','recurring deposits','credit card')
group by bc.customer_id
having count(distinct account_type) >= 3;

# Question 18:
# 18) Display savings accounts and its corresponding Recurring deposits transactions that are occuring more than 4 times.

SELECT 
    bad.account_number AS pr_ac_no,
    bad.account_type AS pr_acc_type,
    bar.account_number AS sec_ac_no,
    bar.account_type AS sec_ac_type,
    count(bat.transaction_date)
FROM
    bank_account_details bad
         JOIN
    bank_account_relationship_details bar 
    ON bad.account_number = bar.linking_account_number
    join bank_account_transaction as bat
    on bar.account_number = bat.account_number
    where bad.account_type  = 'savings' and bar.account_type like '%recurring%'
    group by bad.account_number ,
    bar.account_number having  count(bat.transaction_date)>=4;

# Question 19:
# 19) Display savings accounts and its recurring deposits account with their aggregate 
# transactions per month occurs in 3 different months.

select bad.account_number as primary_acno,
        bad.account_type as primary_actype,
        bar.account_number as sec_acno, 
        bar.account_type as sec_actype,
        count(distinct month (bat.transaction_date))
        from bank_account_details bad 
        join 
        bank_account_relationship_details bar
        on bad.account_number = bar.linking_account_number
        join bank_account_transaction bat
        on bar.account_number = bat.account_number
        where bad.account_type = 'savings' and 
        bar.account_type like '%recurring%' 
        group by bad.account_number,  bar.account_number
        having count(distinct month (bat.transaction_date)) >=3;

# Question 20:
# 20) Find the no. of transactions of credit cards including add-on Credit Cards
select bad.account_number , account_type , count(transaction_date)
from bank_account_details bad  join bank_account_transaction bat
on bad.account_number = bat.account_number
where account_type like '%credit%'
group by account_number,  account_type;
