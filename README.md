User
id: int (primary key)
name: varchar(255)
email: varchar(255)
phone_number: varchar(20)
password: varchar(255)
created_at: datetime
Business
id: int (primary key)
name: varchar(255)
address: varchar(255)
tax_id: varchar(20)
phone_number: varchar(20)
subscription_status: boolean
created_at: datetime
Service
id: int (primary key)
name: varchar(255)
price: decimal(10,2)
duration: int
gender: enum('male', 'female')
business_id: int (foreign key referencing Business)

Appointment
id: int (primary key)
customer_id: int (foreign key referencing User)
business_id: int (foreign key referencing Business)
service_id: int (foreign key referencing Service)
date_time: datetime
status: enum('booked', 'cancelled', 'completed')
cancelled_by: enum('customer', 'business', null)
created_at: datetime
Expense
id: int (primary key)
business_id: int (foreign key referencing Business)
invoice_number: varchar(255)
description: text
amount: decimal(10,2)
expense_date: date
created_at: datetime
