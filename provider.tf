provider "google" {
credentials = "${file("gcp2.json")}"
project = "peaceful-oath-219123"
region = "us-west1-a"
}
