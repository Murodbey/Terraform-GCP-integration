Configuring our Service Account on Google Cloud Platform.

In the following few paragraphs I’ll explain how to create a project, set up a service account and set the correct permissions to manage our project’s resources.

1.Create a project and name it whatever you’d like.

2.Create a service account and specify the compute admin role.

3.Download the generated JSON file and save it to your project’s directory.

Creating a Compute Engine Instance with Terraform

This is what you’ve been waiting for! We’re almost ready to use Terraform to create some VM instances.

However, we have to do a few more things.

You’ll first need to create a few files to work with. The most important thing is that each file ends in file.tf. This allows Terraform to know what files to work with when initializing, planning, applying, and destroying.


$ vim provider.tf

##Specify the provider (GCP, AWS, Azure)


provider “google” {

credentials = “${file(“terraform-account.json”)}”

project = “system-automation-184009”

region = “us-central1”

}
