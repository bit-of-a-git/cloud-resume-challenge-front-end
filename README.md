# Cloud Resume Challenge - Front-End

This repository holds the front-end section of Forrest Brazzeal's Cloud Resume Challenge, which I built on AWS using Terraform.

<img src="/img/CloudResumeChallenge.drawio.png"/>

## Objectives

To create a CV using HTML and CSS, host it as a HTTPS website using S3, Cloudfront, and ACM, and use Route53 to create your own personal domain.

## Mods

* Cloudfront Security Headers
* DNSSEC
* Origin Access Control used to restrict S3 access to Cloudfront
* The Javascript uses a cookie to check if the user has visited in the last month. If not, a POST request is sent to the API to log the user's IP address.

<img src="/img/DNSSEC.png"/>
<img src="/img/Headers.png"/>

## Reflection

I enjoyed learning about HTML and CSS. I spent quite a bit of time using VSCode's Virtual Server along with "inspect element" to try and target specific elements and tweak them to my liking. I would like to learn more about Javascript as I feel like I have just scratched the surface of the language. Interestingly, I found the Terraform part of this easier than the manual part. Things I wanted to do manually - like the security headers and DNSSEC - were actually easier to accomplish in Terraform.

## Automation and CI/CD

Changes are made to the dev branch, pushed to Github, and then a pull request may be made to main. After passing CodeQL tests, they are allowed merge to main. This triggers Github Actions, which updates the production deployment and invalidates Cloudfront to ensure the new files are correctly served.

## Blog Post

You can find my blog post [here](https://dev.to/bit-of-a-git/a-security-focused-cloud-resume-challenge-16aa).
