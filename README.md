Product Spec Design: Salon App
Product Design: Salon App
===
# Overview
## Description
Salon App is a web-based application for salon businesses. It provides a comprehensive suite of tools for salon owners, enabling them to manage their business more efficiently and effectively.
## App Evaluation
- **Category**: Business / Customer Service
- **Mobile**: Will focus on a mobile platform for now.
- **Story**: Allows greater online integration supporting easy and robust communication between salon businesses and their clients.
- **Market**: Salon customers who want an easy time finding great relevant salons and scheduling for them. Salon businesses that want to spend more time on cosmetics and less time on management.
- **Habit**: As much as users need to related to salon services/business.
- **Scope**: Connecting users to salons and booking appointments will be the main objective. Broadening later into better support of salon business management and further integration between users and their favorite salons.
## Features
Salon App provides the following features:
- Client Management: Easily manage client information, bookings, and appointments.
- Inventory Management: Track and manage inventory, including stock levels and pricing.
- Employee Management: Manage employee information, timesheets, and payroll.
- Point of Sale: Process payments and issue receipts quickly and securely.
- Reporting: Generate detailed reports to gain insights into your business performance.
## Technology
Salon App is built using modern web technologies in IOS development in Swift and Xcode. It is designed to be fast, secure, and reliable.
## Support
Salon App provides comprehensive customer support, including online help guides and a dedicated customer service team.
## Pricing
Salon App offers a free 14-day trial, after which users can select a subscription plan to suit their needs. Plans start from $9.99 per month for salon owners. It is free for customers/users but they will see some ads.
# Product Spec
## User Stories
### Required Must-have Stories
- [x] User can create a new account
- [x] User can login
- [x] User can search for salons based on their zip code 
- [x] User can view the name, picture, and services offered by a salon
- [x] User can select a service, gender, and date/time for their appointment
- [x] User can cancel their booking and the business owner will be notified automatically
- [x] Business owners can set up their business information (Company Name, Address, Tax ID, Phone Number) and services offered
- [x] Business owners can track service revenue based on bookings, including tip
- [ ] Business owners can track expenses by date, invoice number, description, and price
### Optional Nice-to-have Stories
- [ ] User can receive an email confirmation upon booking
- [ ] User can provide their gender, phone number, and email address
- [x] User can view the list of salons in either list mode or map mode
- [ ] User can like a photo
- [ ] User can add a comment to a photo
- [ ] User can tap a photo to view a more detailed photo screen with comments
- [ ] User can see trending photos
- [ ] User can search for photos by a hashtag
- [ ] User can see notifications when their photo is liked or they are followed
- [ ] User can see their profile page with their photos
- [ ] User can see a list of their followers
- [ ] User can see a list of their following
- [ ] User can view other user’s profiles and see their photo feed
## Screen Archetypes
- [x] Login Screen
- [x] Registration Screen
- [x] Search Screen
- [x] Salon List Screen
- [x] Salon Details Screen
- [x] Appointment Selection Screen
- [x] Confirmation Screen
- [x] Business Setup Screen
- [ ] Revenue Tracking Screen
- [ ] Expense Tracking Screen
## Navigation Tab Navigation (Tab to Screen)
- [x] Home Screen
- [x] Search Screen
- [x] Business Setup Screen
- [ ] Revenue Tracking Screen
- [ ] Expense Tracking Screen
## Flow Navigation (Screen to Screen)
- [x] Login Screen => Home
- [x] Registration Screen => Home
- [x] Search Screen => Salon List Screen
- [x] Salon List Screen => Salon Details Screen
- [x] Salon Details Screen => Appointment Selection Screen
- [x] Appointment Selection Screen => Confirmation Screen
- [x] Confirmation Screen => Home
## Wireframe
<img src="https://puu.sh/JCifc/29474ccd5f.png" width=750>

# Models

### User

id: int (primary key) 

name: varchar(255) 

email: varchar(255)

phone_number: varchar(20)

password: varchar(255)

created_at: datetime
</table>

### Business

id: int (primary key)

name: varchar(255)

address: varchar(255)

tax_id: varchar(20)

phone_number: varchar(20)

subscription_status: boolean

created_at: datetime

### Service

id: int (primary key)

name: varchar(255)

price: decimal(10,2)

duration: int

gender: enum('male', 'female')

business_id: int (foreign key referencing Business)


Appointment_id: int (primary key) 

customer_id: int (foreign key referencing User)

business_id: int (foreign key referencing Business)

service_id: int (foreign key referencing Service)

date_time: datetime

status: enum('booked', 'cancelled', 'completed')

cancelled_by: enum('customer', 'business', null)

created_at: datetime

### Expense

id: int (primary key)

business_id: int (foreign key referencing Business)

invoice_number: varchar(255)

description: text

amount: decimal(10,2)

expense_date: date

created_at: datetime
## Schema 
## Networking

## Salon App Video : https://youtu.be/eaZj0TnrnNI
