# LiShop server specification

Pending tasks:     
- Investigate how to share the account without the email. But the method must be super-easy for users to select one or another in roder to simplify UI interaction.

## Synchronization API

### Design

- For the main resource (Article) use a [RESTful API](http://en.wikipedia.org/wiki/Representational_state_transfer)
- Many users or devices can access the same _LIST\_ID_ with its own _API\_KEY_.
- The owner could remove any _API\_KEY_ that has access to its _LIST\_ID_.
- The owner could request a new _API\_KEY_ and share it with other user to let them access to his list.
- Each _API\_KEY_ should be used by only one user. But the same _API\_KEY_ can be set in several devices.
- _LIST\_ID_ numbers never will leave ther server. 

#### Model

* List
	- list_id
	- paymentIdentifier 
	- receipt
	- creationDate
	- modificationDate

$ rails g scaffold List 


* ApiKey:
	- list_id
	- api_key
	- email
	- owner
	- creationDate
	- modificationDate

$ rails g scaffold ApiKey list_id:integer api_key:string email:string owner:boolean


* Article
	- list_id
	- name
	- qty
	- category
	- type
	- shop
	- prize
	- checked
	
$ rails g scaffold Article list_id:integer name:string qty:string category:string type:string shop:string prize:string checked:string

#### Entry points

- **Article RESTful CRUD.** [RESTful API](http://en.wikipedia.org/wiki/Representational_state_transfer)    
To access this resource with any of its URL, the client must specify its _API\_KEY_ in the http header: "api_key" = "\<_API\_KEY_\>"    
if **api_key** doesn't exits or it's not present in the query, the response will be -> http\_status: 401, responseBody: "Unauthorized"        
	Sample URL:
	- http://api.server.com/1.0/articles.js -> returns all the articles
	- http://api.server.com/1.0/articles/2.js -> return article with _id_ = 2

<s>- **recoverApiKey** To recover forgotten accounts.     
The user will receive and email with his _API\_KEY_    
	* Request parameters:    
		- **email**    
	* Responses:    
		- On OK -> http\_status: 200, responseBody: _\<empty/>_     
		- If **email** parameter not indicated -> http\_status: **400**, responseBody: "email parameter required"
		- If **email** not found -> http\_status: **404**, responseBody: "email not found"
</s>     

- **requestNewApiKey** To invite a new user to access owner list.    
The new user will receive and email with his _API\_KEY_.    
Only the list owner can invite others users.      
	* http header 
		- **api_key**
	* Request parameters:    
		- **email**    
	* Responses:    
		- On OK -> http\_status: **200**, responseBody: _\<empty/>_     
		- If **email** not indicated -> http\_status: **400**, responseBody: "email parameter required"
		- If **api_key** not indicated or not found -> http\_status: **401**, responseBody: "Unauthorized"        
		- if **api_key** is not the owner -> http\_status: **403**, responseBody: "Forbidden"        

- **removeApiKey** To close access to other user.        
	* http header 
		- **api_key**
	* Request parameters:    
		- **sharedApiKey**    
	* Responses:    
		- On OK -> http\_status: **200**, responseBody:[ "**api_key**": { "**api_key**" : "\<_API\_KEY1_\>", "**email**" : "\<_email1_>"}, "**api_key**": { "**api_key**" : "\<_API\_KEY2_\>", "**email**" : "\<_email2_>"}]        
		- If **sharedApiKey** not indicated -> http\_status: **400**, responseBody: "sharedApiKey parameter required"
		- If **sharedApiKey** not found -> http\_status: **404**, responseBody: "sharedApiKeynot found"
		- If **api_key** not indicated or not found -> http\_status: **401**, responseBody: "Unauthorized"        
		- if **api_key** is not the owner -> http\_status: **403**, responseBody: "Forbidden"        

- **registerAccount** To create or recover an account.     
The user must specify the receipt to demostrate the new account payment. If it's the first time accesing, a new list will be created. If the account was previously created, only it's **API\_KEY** is returned. But each time is called this method, a new **API\_KEY** must be generated for security.    
	* Request parameters:    
		- **paymentIdentifier**
		- **receipt**
	* Responses:    
		- On OK -> http\_status: 200, responseBody: { "**api_key**" : "\<_API\_KEY_\>"}
		- If any parameter is not indicated -> http\_status: **400**, responseBody: "\<_param_\> parameter required"
		- If **paymentIdentifier** not found -> http\_status: **404**, responseBody: "receipt not found"

- **sharedApiKey** Return the shared keys and its emails.
The owner user **API\_KEY** is not returned.             
	* http header 
		- **api_key**
	* Request parameters:    
	* Responses:    
		- On OK -> http\_status: **200**, responseBody: [ "**api_key**": { "**api_key**" : "\<_API\_KEY1_\>", "**email**" : "\<_email1_>"}, "**api_key**": { "**api_key**" : "\<_API\_KEY2_\>", "**email**" : "\<_email2_>"}]
		- If **api_key** not indicated or not found -> http\_status: **401**, responseBody: "Unauthorized"        
		- if **api_key** is not the owner -> http\_status: **403**, responseBody: "Forbidden"        

<s>- **verifyReceipt** See section *"Receipt verification using App Store"*
	* Request parameters:    
		- **receipt** The base64 encoded receipt data.
		- **deviceIdentifier** UUID base64 encoded. Unique identifier of the device.
		- **debug** Optional. If set to any value, use sandbox varification.
	* Responses:    
		- On OK -> http\_status: 200, responseBody: _\<empty/>_ 
		- If **receipt** is not indicated -> http\_status: **400**, responseBody: "receipt parameter required"
		- If **deviceIdentifier** is not indicated -> http\_status: **400**, responseBody: "deviceIdentifier parameter required"
</s>

  
<s>- **deleteList** Remove all the data of a list. This method will be called if the user don't want to use/pay for the service. The **API\_KEY** must be associated to the owner.
	* http header 
		- **api_key**
	* Request parameters:    
	* Responses:    
		- On OK -> http\_status: **200**, responseBody: _\<empty/>_ 
		- If **api_key** not indicated or not found -> http\_status: **401**, responseBody: "Unauthorized"        
		- if **api_key** is not the owner -> http\_status: **403**, responseBody: "Forbidden"        
</s>

Every http request can be responded with a 503 status to indicate "Service Temporary Unavailable".

#### Security

- Users with a valid **API\_KEY** will access to its **LIST\_ID**. Required.
- Each client could create new **API_KEY** for sharing his list with other users.
- To recover forgotten **API\_KEY**, the user will have a button to request his **API\_KEY** using his **email**.
- SSL: create an owned ssl certificate signed by a personal CA and use it in local to verify. Or verify server certificate with its MD5.

### API Versioning

The version of the API will be indicated in the url.

Sample:

	http://api.server.com/1.0/articles.js

## Receipt verification using App Store

Launch this verification method asynchronously.    
This method is called when a client call the API method "**registerAccount**".      
Make an http call to https://buy.itunes.apple.com/verifyReceipt or https://sandbox.itunes.apple.com/verifyReceipt for debugging.     

### Send the receipt data to the App Store

Create a JSON object with the following keys:

- **receipt-data** The base64 encoded receipt data.
- **password** Only used for receipts that contain auto-renewable subscriptions. Your app’s shared secret (a hexadecimal string).

### Parse the Response

The response’s payload is a JSON object that contains the following keys and values:

- **status** Either 0 if the receipt is valid, or one of the error codes listed in Error Table
- **receipt** A JSON representation of the receipt that was sent for verification

#### Error table

- **21000** 
The App Store could not read the JSON object you provided.
- **21002**
The data in the receipt-data property was malformed or missing.
- **21003**
The receipt could not be authenticated.
- **21004**
The shared secret you provided does not match the shared secret on file for your account.
Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
- **21005**
The receipt server is not currently available.
- **21006**
This receipt is valid but the subscription has expired. When this status code is returned to your server, the receipt data is also decoded and returned as part of the response.
Only returned for iOS 6 style transaction receipts for auto-renewable subscriptions.
- **21007**
This receipt is from the test environment, but it was sent to the production environment for verification. Send it to the test environment instead.
- **21008**
This receipt is from the production environment, but it was sent to the test environment for verification. Send it to the production environment instead.


## Steps to install and configure the server

See document: *"OpenShift management"*

## Backup and restore methods

See document: *"OpenShift management"*

## To prevent attacks from internet

To prevent brute force attacks, develop the following:

### For services using api_key as authentication system. 

To prevent brute force can do the following:

- Save the IP of the peer.
- Save the last date of the IP connection.
- Save the last api_key of that IP.

If at some time you contacted different api_key. It is a brute force attack, there must cancel.


### To prevent attacks of DOS

Count the numbers of connections per second. If there are many, cancel.

### Server 

Use OpenShift. non-scalable Rails 4 app with MySql 5.1

## How to scale

See document: *"OpenShift management"*


## Rails status

400 => :bad_request
401 => :unauthorized
403 => :forbidden
404 => :not_found