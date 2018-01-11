# MMCom Automation Test Framework
## Overview
This is the repository for the source code of the MassMutual.com automated test framework. This framework is built using Ruby with the PageObject model and enables a user to develop behavior-driven front-end tests leveraging Cucumber and Watir. The tests have the capability to do local testing on a plethora of devices using BrowserStack. The tests are configured to launch on a Jenkins server.

## Technologies

### Ruby
> https://www.ruby-lang.org/en/

Ruby is a dynamic, reflective, object-oriented, general-purpose programming language.

### Watir
> http://watir.github.io/

Watir is an acronym for 'Web Application Testing in Ruby' and is a wrapper library built around Selenium. It allows for simple interactions with a browser's DOM through Ruby methods.

### PageObject Model
> https://github.com/SeleniumHQ/selenium/wiki/PageObjects

> https://github.com/cheezy/page-object

Within your web app's UI there are areas that your tests interact with. A Page Object simply models these as objects within the test code. This reduces the amount of duplicated code and means that if the UI changes, the fix need only be applied in one place.

The page-object gem by cheezy is used in this framework to simplify the abstraction layer.

### Cucumber
> https://cucumber.io/

Cucumber is a software tool used by computer programmers for testing other software. It runs automated acceptance tests written in a behavior-driven development (BDD) style. Central to the Cucumber BDD approach is its plain language parser called Gherkin. It allows expected software behaviors to be specified in a logical language that customers can understand. 

### Gherkin
> https://github.com/cucumber/cucumber/wiki/Gherkin

Gherkin is the language that Cucumber uses to define test cases. It is designed to be non-technical and human readable, and collectively describes use cases relating to a software system. The purpose behind Gherkin's syntax is to promote Behavior Driven Development practices across an entire development team, including business analysts and managers. It seeks to enforce firm, unambiguous requirements starting in the initial phases of requirements definition by business management and in other stages of the development lifecycle.

### BrowserStack
> https://www.browserstack.com/

BrowserStack is a cloud-based cross-browser testing tool that enables developers to test their websites across various browsers on different operating systems and mobile devices, without requiring users to install virtual machines, devices or emulators.

## Setup

Clone the repo using:

```
git clone https://bitbucket.org/m38io/mm_com_automation_test_framework.git
```

Change the directory to the project using:

```
cd mm_com_automation_test_framework
```


## Who do I talk to?

Repo is owned by the CXQA Team, use the `MList: CX-QA`

README v1.0 - Revision by Mike Herbert 6.29.2017# FWK_for_Cuke_error
