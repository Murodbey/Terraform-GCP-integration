Authenticating to a Cloud API Service
•	Contents
•	Set up an API key
o	Setting up your project
o	Using API-Manager→Credentials
•	Set up a service account
o	Using the GCP Console
o	Authenticating with Application Default Credentials
To allow your application code to use a Cloud API, you will need to set up the proper credentials for your application to authenticate its identity to the service and to obtain authorization to perform tasks. (These credential-related mechanisms are known as authschemes.)
The simplest authentication scheme is that of an API key; however, an API key does not allow you to authorize to the service, so it is only usable on public data or data you pass directly to the RPC API. By contrast, the service account is the most useful auth scheme since you can use it to access a Cloud API by configuring your code to send credentials for the service account to the service.
When accessing a Google Cloud Platform API, we recommend that you set up an API key for testing purposes, and set up a service account for production usage.
Note: Authentication and authorization are large topics; the precise way you may set up your application or service depends on a variety of factors, including whom you wish to authenticate, what tasks you allow the authenticated entity to perform (commonly referred to as authorization), and what, if any, container you use (e.g. Compute Engine vs. App Engine, etc.) See the Google Cloud Platform Auth Guide for more information.
Set up an API key
The simplest authentication mechanism involves passing an API key directly to the service. Because this scheme is limited in both scope and security, we advise only using API keys for testing purposes.
There are two Google Cloud Platform Console flows you can use to get an API key to access a Google Cloud Platform API:
1.	Setting up your project
2.	Using API-Manager→Credentials
Setting up your project
After you enable a Cloud API (as part of Set up your project), you'll see a message that prompts you to get credentials.
 
Click "Go to Credentials" to open the Add Credentials page.
 
Click "API key". The Create a new key dialog appears.
 
Select "Browser key". The Create browser API key page appears.
 
Enter a name for this key ("Curl Test Key" is shown above, but you can choose any name you wish). You can leave the referrer field blank since this browser key is only used for testing purposes, but if you plan to deploy a browser key in production, you should set this field to an appropriate domain.
Click "Create". The Browser API key page lists your newly created key.
 
You may wish to copy your key and keep it secure (you can also retrieve it from the API Manager→Credentials page).
Using API-Manager→Credentials
You can create an API key (and other credentials) by selecting API Manager→Credentialsfrom the GCP Console.
 
Select "Create Credentials→API key," then create a browser key, as explained in Setting up your project.
Set up a service account
Google Cloud Platform API authentication and authorization (commonly grouped together as "auth") is typically done using a service account. A service account allows your code to send application credentials directly to the Cloud API. A service account, like a user account, is represented by an email address. Unlike a user account, however, a service account belongs only to an application, and may only be used to access the API for which it was created. As an example, we will show how to create service account credentials using the Google Cloud Platform Console.
Using the GCP Console
From the GCP Console API Manager→Credentials page, select "Create credentials→Service account key".
 
Next, select "New service account" from the "Service account" dropdown.
 
Type a "Name" for this service account. This name will be used as the default name for your "Service account ID" (to the left of the "@" in the generated service account ID address), but you can change this service account ID name if you wish. These names can be arbitrary; it is only important that you remember them. Under "Key type," we recommend that you leave this value as "JSON". Click "Create", and the GCP Console will generate a JSON key (as a .jsontext file), prompt you to download the file to your computer, and display a Service account created dialog box.
 
The generated JSON key will will be similar to the following sample JSON key:
{
  "type": "service_account",
  "project_id": "project-id",
  "private_key_id": "some_number",
  "private_key": "-----BEGIN PRIVATE KEY-----\n....
  =\n-----END PRIVATE KEY-----\n",
  "client_email": "<api-name>api@project-id.iam.gserviceaccount.com",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://accounts.google.com/o/oauth2/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/...<api-name>api%40project-id.iam.gserviceaccount.com"
}
Store this JSON file securely, as it contains your private key (and this file is the only copy of that key). You will need to refer to this service account key file within your code when you wish to send credentials to the Google Cloud Platform API.
Authenticating with Application Default Credentials
The simplest way for applications to authenticate to a Google Cloud Platform API service is by using Application Default Credentials (ADC). Services using ADC first search for credentials within a GOOGLE_APPLICATION_CREDENTIALS environment variable. Unless you specifically wish to have ADC use other credentials (for example, user credentials), we recommend you set this environment variable to point to your service account key file (the .json file downloaded when you created a service account key, as explained in Set Up a Service Account.
$ export GOOGLE_APPLICATION_CREDENTIALS=’cat path_to_service_account_file’

Creating a Compute Engine Instance with Terraform
This is what you’ve been waiting for! We’re almost ready to use Terraform to create some VM instances. However, we have to do a few more things.

You’ll first need to create a few files to work with. The most important thing is that each file ends in file.tf. This allows Terraform to know what files to work with when initializing, planning, applying, and destroying.

Here are some examples:

$ vim provider.tf
# Specify the provider (GCP, AWS, Azure)
provider “google” {
credentials = “${file(“terraform-account.json”)}”
project = “system-automation-184009”
region = “us-central1”
}
$ vim compute.tf
# Create a new instance
resource "google_compute_instance" "ubuntu-xenial" {
   name = "ubuntu-xenial"
   machine_type = "f1-micro"
   zone = "us-west1-a"
   boot_disk {
      initialize_params {
      image = "ubuntu-1604-lts"
   }
}
network_interface {
   network = "default"
   access_config {}
}
service_account {
   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
   }
}
We’ll also need to follow the proceeding steps to make Terraform aware of the files we just created. Your screen should be similar to what’s presented below.
