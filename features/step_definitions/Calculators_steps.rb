
############################################
###############   Calculators   ############
############################################

## Desc1: Navigates to the specified Calculator page and sets global Vars so all subsequent steps go to the correct Calculator.
Given /I am on the "([^"]*)" calculator page$/ do |page|
  $page = page
  $sub_page = 'M'
  ###### Navigate from MM.Com
  #on(RetirementCalculatorPage).await
  visit(AppHelpers.get_page_name($page, 'page_object')).await
  puts AppHelpers.publish_output_text
end

## Desc1: Opens the Disclosure popup, verify the text against the set Calculator's .yml data, and closes the popup
When /I verify the Disclosure Statement text$/ do
  on(AppHelpers.get_page_name($page, 'page_object')).select_action 'Disclosure Statement'
  on(AppHelpers.get_page_name($page, 'page_object')).verify_disclosures
  on(AppHelpers.get_page_name($page, 'page_object')).close_disclosures
  puts AppHelpers.publish_output_text true, @browser
end

## Desc1: Populate the set Calculator's base page from the named Dataset stored in the set Calculator's .yml file and perform the action specified.
When /I populate the calculator from "([^"]*)" and "([^"]*)"$/ do |dataset, action|
  $sub_page = 'M'
  on(AppHelpers.get_page_name($page, 'page_object')).await
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'base'
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's base page from the named Dataset stored in the set Calculator's .yml file and perform the action specified, with traceability.
When /I populate the calculator from "([^"]*)" and "([^"]*)" with traceability$/ do |dataset, action|
  $sub_page = 'M'
  on(AppHelpers.get_page_name($page, 'page_object')).await
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'base', false, true
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action, true
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's base page from the named Dataset stored in the set Calculator's .yml file and perform the action specified using the Send Keys method to support validation rule triggers.
When /I populate the calculator from "([^"]*)" and "([^"]*)" using SendKeys$/ do |dataset, action|
  $sub_page = 'M'
  on(AppHelpers.get_page_name($page, 'page_object')).await
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'base', true
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Perform the action specified.
When /I do the calculator action "([^"]*)"$/ do |action|
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Perform the action specified and verify Toast Message.
When /I do the calculator action "([^"]*)" and verify Toast Message$/ do |action|
  on(AppHelpers.get_page_name($page, 'page_object')).click_and_verify_toast_msg action
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's widget page from the named Dataset stored in the set Calculator's .yml file and perform the action specified.
When /I populate the widget from "([^"]*)" and "([^"]*)"$/ do |dataset, action|
  $sub_page = 'W'
  on(AppHelpers.get_page_name($page, 'page_object')).await
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'widget'
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's base page from the named Dataset stored in the set Calculator's .yml file and perform the action specified using the Send Keys method to support validation rule triggers.
When /I populate the widget from "([^"]*)" and "([^"]*)" using SendKeys$/ do |dataset, action|
  $sub_page = 'W'
  on(AppHelpers.get_page_name($page, 'page_object')).await
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'widget', true
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Open and Populate the set Calculator's CYI page from the named Dataset stored in the set Calculator's .yml file and perform the action specified.
When /I update More Settings from "([^"]*)" and "([^"]*)"$/ do |dataset, action|
  on(AppHelpers.get_page_name($page, 'page_object')).open_more_settings
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'more'
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Open and Populate the set Calculator's CYI page from the named Dataset stored in the set Calculator's .yml file and perform the action specified, with tractability.
When /I update More Settings from "([^"]*)" and "([^"]*)" with traceability$/ do |dataset, action|
  on(AppHelpers.get_page_name($page, 'page_object')).open_more_settings
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'more', false, true
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action, true
  puts AppHelpers.publish_output_text
end


## Desc1: Open and Populate the set Calculator's CYI page from the named Dataset stored in the set Calculator's .yml file and perform the action specified using the Send Keys method to support validation rule triggers.
When /I update More Settings from "([^"]*)" and "([^"]*)" using SendKeys$/ do |dataset, action|
  on(AppHelpers.get_page_name($page, 'page_object')).open_more_settings
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'more', true
  on(AppHelpers.get_page_name($page, 'page_object')).select_action action
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's Result page from the named Dataset stored in the set Calculator's .yml file.
When /I update "([^"]*)" on the output page$/ do |dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'results_inputs'
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's Result page from the named Dataset stored in the set Calculator's .yml file using the Send Keys method to support validation rule triggers.
When /I update "([^"]*)" on the output page with SendKeys$/ do |dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'results_inputs', true
  puts AppHelpers.publish_output_text
end

## Desc1: Populate the set Calculator's Result page from the named Dataset stored in the set Calculator's .yml file using the Send Keys method to support validation rule triggers.
When /I update "([^"]*)" on the output page using SendKeys$/ do |dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).enter_calculator_data_from dataset, 'results_inputs', true
  puts AppHelpers.publish_output_text
end

## Desc1: Run the quiz from the specified Dataset stored in the SSQ .yml file
When /I run the Quiz with "([^"]*)"$/ do |dataset|
 on(AppHelpers.get_page_name($page, 'page_object')).run_quiz dataset,false
 puts AppHelpers.publish_output_text true, @browser
 end

##Desc1: Run the quiz from the specified Dataset stored in the SSQ .yml file and verify the links are opening without error
When /I run the Quiz with "([^"]*)" and verify links$/ do |dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).run_quiz dataset,true
  puts AppHelpers.publish_output_text true, @browser
end

## Desc1: Verify the results match the named dataset from the set Calculator's .yml file
Then /I verify the quiz is in its initial state$/ do
  on(AppHelpers.get_page_name($page, 'page_object')).verify_quiz_is_in_initial_state
  puts AppHelpers.publish_output_text true, @browser
end

## Desc1: Verify the Tooltips on the specified Page section from the set Calculator's .yml file
Then /the calculator results should match the "([^"]*)" section of "([^"]*)"$/ do |section, dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).verify_calculator_results_from section, dataset
  puts AppHelpers.publish_output_text true, @browser, "Then the calculator results should match the '#{section}' section of '#{dataset}'"
end

## Desc1: Add Your Step Description Here
Then /the tooltips should match "([^"]*)" section of the calculator$/ do |section|
  on(AppHelpers.get_page_name($page, 'page_object')).verify_tooltips section
  puts AppHelpers.publish_output_text true, @browser, "Then the tooltips should match '#{section}' section of the calculator"
end

## Desc1: Verify the popup error text matches the named Dataset from the set Calculator's .yml file
Then /the errors should match "([^"]*)"$/ do |dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).verify_errors dataset
  puts AppHelpers.publish_output_text true, @browser
end

## Desc1: Verify the popup Toast Message matches expected
Then /the Toast Message should match "([^"]*)"$/ do |dataset|
  on(AppHelpers.get_page_name($page, 'page_object')).verify_toast_msg dataset
  puts AppHelpers.publish_output_text true, @browser
end