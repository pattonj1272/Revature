# Inventory Management

## Project Description

A system designed to enable wherehouses to track shipmints going into and out of their business. Track current inventory and placement of that inventory in the wherehouse. A portal to allow external partners to order items, update descriptions, and request ship items. Finally this system is built with flexibilty to allow any wherehouse company to use this as a templete with small modifications to meet their proticular needs.

## Technologies Used

* Salesforce - version 49.0
* Visualforce - version 52.0
* Apex - version 33.0
* SOQL - version 52.0
* xml version 1.0

## Features

List of features ready and TODOs for future development
* Custom Inventories - lets manager track items in wherehouse and lets pickers know bin location of items
* Custom Orders - Lets aquasition managers create inbound orders, Managers make outbound orders, and pickers change order status to picked.
* Products - Lets Managers adjust what is able to be sold, and view status of items amounts all throughout the process in summaries.
* Approval Processes - Lets managers approve large purchases (over 100,000 in total price), lets aquasition manager manage purchases that there are not enough incoming or in stock items for. And lets CEO manage all orders over 1,000,000 dollars.
* Experience site for external users.
  * Home tab to view everything that is incoming or outgoing from logged in user.
  * Products tab to view all products that can be ordered and amount to sell.
  * Request to supply so suppliers can put in offer to supply at price book amount.
  * Support to submit cases to management


To-do list:
* Fix Inventory items trigger to accuruatly update products amount in stock
* Fix approval process so it stops setting every order to be canceled then re-enable process that relates to approval process
* NewOrder page if contact isn't already in create the contact
* On pages to submit clear the values
* Allow users that submit a order if not been set to approved yet / cancel the order
* Create approval process for changing description, that relates it back to product owner

## Getting Started
   
Steps to port
  1. Create new playground
  2. Authorize Visual Studio Code into the playground created in step 1
  3. Pull git hub repository into playground created in step 1 
  4. Comment out Network CustomSite and ExperienceBuilder associated code from package.xml
  5. Deploy to org fixing each issue as run into with reference down bottom.

Fix porting

Error with CanAccessCE in profile 
   CanAccessCE must be removed/commented out from each profile

To fix userReturnOrder
  Comment out user permission userReturnOrder and userReturnOrderAPI

To fix flex page error
  Delete flexipage reason
    From line 12 to line 40

To fix cannot validate component
  Comment out network, custom site, and experience builder from package then deploy. Then uncomment and deploy again

To fix the experience must be enabled
    Create domain of with any name from digital experiences

To fix can’t change org wide default sharing  for product
  Comment everything in product2.object-meta.xml (lines 3 to 148)

This record wh.asset resource isn’t in the target org
  Delete wh.asset and associated meta data
  
In field: siteAdmin - no user name ???@email.com found
     Replace email in Inventory management.site-meta (line 25 and 26) and inventoryManagement.network-meta (line 8) emails with email for log in
     
     
Good luck on porting over site, I rebuilt and added pages so some details on setting up site
  Templete Customer Account Portal
  Theme colors Page Background color rgb(0, 102, 153) (Though didn't relize it makes Contact us page so hard to read, so go with different color or fix that.
  Added pages
    Products to hold product visual page height 650
    OrderItems to hold NewOrder height 350
    RequestToSupply SupplyOrdersPage height 400
    Changed home to hold 2 full width visual force pages
      Calander page height 1000
      OrderListPage height 600
      Left Open all open cases at bottom
    
    
   
## Usage

> Set up Inventory management to be default application, add tabs Approval proccess, Products, PriceBook, PriceBookEntry, and ensure copy link to sitbuilder site and bookmark it.

## Contributors

> Nathan Tellez
> Laurent Sanou
> Saif Sayed
> James Patton

## License

All rights reserved 2021 