module CalculatorHelpers
  require 'date'
  include PageObject
  include PageObject::PageFactory

  def enter_calculator_data_from(page, dataset, segment, use_send_keys = false, traceability = false)
    inputs = AppHelpers.load_yaml(AppHelpers.get_page_name($page, 'yml_file'))[dataset][segment]
    inputs.each do |elem_name, value|
      if traceability
        enter_data(page, elem_name, value['value'], use_send_keys)
        page.send("#{elem_name}_element").send_keys :tab
        sleep 0.5
        output = page.text.downcase.split("\n").select { |f| /tracking/.match(f) }
#        AppHelpers.output_text "Expected #{value['trace']} in Toast Message. Found '#{output[0]}'" unless output[0] == value['trace'].downcase
        AppHelpers.fail_text "Expected #{value['trace']} in Toast Message. Found '#{output[0]}'" unless output[0] == value['trace'].downcase
        AppHelpers.output_text "Toast Message '#{value['trace']}' found as expected."
        sleep 2
      else
        if elem_name.include? 'more_child_'
          child_number = elem_name.gsub('more_child_', '')
          unless page.send("more_child_#{child_number}_age_element").exist?
            page.more_add_another_child
          end
          value.each do |sub_elem_name, sub_value|
            AppHelpers.output_text "I enter #{sub_value} into #{sub_elem_name}"
            enter_data(page, sub_elem_name, sub_value, use_send_keys)
          end
        else
          AppHelpers.output_text "I enter #{value} into #{elem_name}"
          value = AppHelpers.parse_relative_date(value) if value.to_s.include? '<'
          enter_data(page, elem_name, value, use_send_keys)
        end
      end
    end
    sleep 2
  end
  module_function :enter_calculator_data_from


  def enter_data(page, elem_name, value, use_send_keys)
    if elem_name ==('birthday') or elem_name ==('more_birthday')
      action_mode = 'SpecialBirthday'
    elsif value == 'negative'
      action_mode = value
    elsif value == ':delete:'
      action_mode = 'delete'
    else
      action_mode = ''
    end
    AppHelpers.enter_data_with_code_exceptions(page, elem_name, value, action_mode, use_send_keys)
  end
  module_function :enter_data


  def verify_disclosures(page)
    page.disclosure_text_element.when_present
    #puts page.disclosure_text_element.div(class: 'row', index: key).p(index: sub_key).text.inspect
    inputs = AppHelpers.load_yaml(AppHelpers.get_page_name($page, 'yml_file'))['disclosure']
    inputs.each do |key, value|
      if value.is_a?(::Hash)
        value.each do |sub_key, sub_value|
          if page.disclosure_text_element.div(class: 'row',index: key).p(index: sub_key).text.gsub(/\u00a0/, ' ') != sub_value
            AppHelpers.fail_text "Text Mismatch in segment #{sub_key}. expected: '#{sub_value}'  Actual: #{page.disclosure_text_element.div(class: 'row', index: key).p(index: sub_key).text.inspect}"
          else
            AppHelpers.output_text "Disclosure text matches <expected>:#{sub_value}"
          end
        end
      else
        if page.disclosure_text_element.div(class: 'row',index: key).text.gsub(/\u00a0/, ' ') != value
          AppHelpers.fail_text "Text Mismatch in segment #{key}. expected: '#{value}'  Actual: #{page.disclosure_text_element.div(class: 'row', index: key).text}"
        else
          AppHelpers.output_text "Disclosure text matches <expected>:#{value}"
        end
      end
    end
  end
  module_function :verify_disclosures

  def select_action(page, action, traceability=false)
    AppHelpers.output_text "and I click #{action}"
    case action.upcase
      when 'Disclosure Statement'.upcase
        loop_count = 0
        until page.send('disclosure_statement_btn_element').present? or loop_count > 4
          page.send_keys :arrow_down
          loop_count += 1
        end
        page.open_disclosures
      when 'Calculate'.upcase
        until page.send('calculate_btn_element').visible? do
          page.driver.executeScript('window.scrollBy(0,200)')
        end
        page.send('calculate_btn_element').when_present
        AppHelpers.scroll_to_object(page, 'calculate_btn')
        page.calculate_btn
        sleep 2
        if page.calculate_btn_element.exists?
          AppHelpers.output_text 'Calc btn not found.  Sleeping and retrying'
          sleep 6
          page.calculate_btn if page.calculate_btn_element.exists?
        end
        if traceability
          output = page.text.downcase.split("\n").select { |f| /tracking/.match(f) }
          message = "Tracking form_element \"calculate\" with value \"\"".downcase
          AppHelpers.fail_text "Expected #{message} in Toast Message. Found '#{output[0]}'" unless output[0] == message
          AppHelpers.output_text "Toast Message '#{message}' found as expected."
        end
       when 'Calculate for Errors'.upcase
         until page.send('calculate_btn_element').visible? do
           page.driver.executeScript('window.scrollBy(0,200)')
         end
         page.send('calculate_btn_element').when_present
         page.calculate_btn
      when 'CalculateFast'.upcase
        until page.send('calculate_btn_element').visible? do
          page.driver.executeScript('window.scrollBy(0,200)')
        end
        page.send('calculate_btn_element').when_present
        page.calculate_btn
      when 'More Settings'.upcase
        page.see_results
        page.open_more_settings
        sleep 2
      when 'Save Progress'.upcase
        page.save_progress
      when 'Update More Settings'.upcase
        unless page.send('update_element').present?
          AppHelpers.scroll_to_object(page, 'update')
        end
        page.update
        if traceability
          output_a = page.text.downcase.split("\n")
          output = page.text.downcase.split("\n").select { |f| /tracking/.match(f) }
          message = "Tracking form_element \"updateChangeInfo\" with value \"\"".downcase
          AppHelpers.fail_text "Expected #{message} in Toast Message. Found '#{output[0]}'" unless output[0] == message
          AppHelpers.output_text "Toast Message '#{message}' found as expected."
        end
        sleep 3
        if page.send('update_element').present?
          AppHelpers.fail_text 'Update failed.'
        end
      when 'Cancel More Settings'.upcase
        unless page.send('update_element').present?
          AppHelpers.scroll_to_object(page, 'update')
        end
        page.close_settings_btn
      when 'Get Started'.upcase
        page.get_started
        sleep 2
      when 'None'.upcase
        # do nothing
      when 'Dashboard'.upcase
        AppHelpers.scroll_to_object(page, 'dashboard')
        page.dashboard
      when 'Events'.upcase
        AppHelpers.scroll_to_object(page, 'events')
        page.events
      when 'Saveable'.upcase
        AppHelpers.scroll_to_object(page, 'saveable')
        page.saveable
      when 'Tracking'.upcase
        AppHelpers.scroll_to_object(page, 'tracking')
        page.tracking
      when 'SaveResults'.upcase
        AppHelpers.scroll_to_object(page, 'results_save')
        page.results_save
      when 'Auto-Load'.upcase
        AppHelpers.scroll_to_object(page, 'auto_load')
        page.auto_load
      else
        AppHelpers.fail_text "Invalid Action. #{action} is not recognized"
    end

    sleep 3
  end
  module_function :select_action

  def verify_calculator_tooltips(page,section)
    sleep 1
    inputs = AppHelpers.load_yaml(AppHelpers.get_page_name($page, 'yml_file'))['tooltips'][section]
    if section.upcase == 'more'.upcase
      page.open_more_settings
    end
    inputs.each do |elem_name, value|
      if elem_name.include? '_link'
        page.send("#{elem_name}")
        AppHelpers.fail_text "Expected #{value} on tooltip #{elem_name}.  Found #{page.send("#{elem_name}_element").attribute('data-content')}" unless page.send("#{elem_name}_element").attribute('data-content') == value
      elsif elem_name.include? '_div'
        sleep 1
        page.send("#{elem_name.gsub('div', 'link')}_element").click
        sleep 1
        AppHelpers.fail_text "Expected #{value} on tooltip #{elem_name}.  Found #{page.send("#{elem_name}_element").text}" unless page.send("#{elem_name}_element").text.strip.gsub(/s+/, '') == value.strip.gsub(/s+/, '')
        page.send("#{elem_name.gsub('div', 'link')}_element").click
      else
        page.send("#{elem_name}_element").when_present.hover
        AppHelpers.fail_text "Expected #{value} on tooltip #{elem_name}.  Found #{page.send("#{elem_name}_element").attribute('data-original-title')}" unless page.send("#{elem_name}_element").attribute('data-original-title') == value
      end
      AppHelpers.output_text "Tooltip '#{elem_name}' found with text '#{value}'."
    end
    if section.upcase == 'more'.upcase
      select_action page,'Cancel More Settings'
    end
  end
  module_function :verify_calculator_tooltips

  def verify_calculator_errors(page, dataset)
    inputs = AppHelpers.load_yaml(AppHelpers.get_page_name($page, 'yml_file'))[dataset]['errors']
    if inputs.upcase == 'None'.upcase
      if page.send('error_text_element').exists?
        AppHelpers.fail_text "Expected no error popup.  Found #{page.send('error_text_element').text}"
      else
        AppHelpers.output_text 'Expected no error popup. None found'
      end
    else
      if page.send('error_text_element').exists?
        unless page.send('error_text_element').text == inputs
          AppHelpers.fail_text "Expected #{inputs} in error popup.  Found #{page.send('error_text_element').text}"
        else
          AppHelpers.output_text "Found #{inputs} in error popup, As expected."
        end
      else
        AppHelpers.fail_text "Expected #{inputs} in error popup.  No Popup found."
      end
    end
  end
  module_function :verify_calculator_errors

  def verify_calculator_results_from(page, segment, dataset)
    inputs = AppHelpers.load_yaml(AppHelpers.get_page_name($page, 'yml_file'))[dataset]['results'][segment]
    inputs.each do |elem_name, value|
      scroll_counter = 0
      page.execute_script('window.scroll(0,0)')
      AppHelpers.scroll_to_object(page, elem_name)
      if value.to_s.include? '<'
        value = value.gsub('<', '')
        if (page.send("#{elem_name}").gsub("\n", ';') =~ /#{value}/) != 0
          AppHelpers.fail_text "Expected #{value} on field #{elem_name}.  Found #{page.send("#{elem_name}").gsub("\n", ';')}"
        else
          AppHelpers.output_text "Value on page (#{value}) matches expected for #{elem_name}."
        end
      else
        if page.send("#{elem_name}").gsub("\n", ';') != value
          AppHelpers.fail_text "Expected #{value} on field #{elem_name}.  Found #{page.send("#{elem_name}").gsub("\n", ';')}"
        else
          AppHelpers.output_text "Value on page (#{value}) matches expected for #{elem_name}."
        end
      end
    end
  end
  module_function :verify_calculator_results_from

  def resolve_calc_url(calculator, url_string)
    if FigNewton.env.upcase == 'Calc_Dev'.upcase or FigNewton.env.upcase == 'Local'.upcase
      case calculator.upcase
        when 'College'.upcase
          FigNewton.college_calc_url
        when 'Retirement'.upcase
          FigNewton.retirement_calc_url
        when 'Modal'.upcase
          FigNewton.modal_calc_url
        when 'Life Insurance'.upcase
          FigNewton.life_ins_calc_url
        when 'Disability'.upcase
          FigNewton.disability_calc_url
        when 'Disability Quiz'.upcase
          FigNewton.disability_quiz_url
        when 'Social Security'.upcase
          FigNewton.social_security_url
        else
          AppHelpers.fail_text "#{calculator} is not a valid Calculator Type."
      end
    else
      "#{FigNewton.base_url}#{url_string}"
    end
  end
  module_function :resolve_calc_url

  def open_more_settings(page)
    AppHelpers.scroll_to_object(page, 'more_settings_btn')
    page.more_settings_btn
  end
  module_function :open_more_settings

  def click_and_verify_toast_msg(page, dataset)
    inputs = AppHelpers.load_yaml(AppHelpers.get_page_name($page, 'yml_file'))['toast'][dataset]

    case dataset.upcase
      when 'Calculate'.upcase
        AppHelpers.scroll_to_object(page, 'calculate_btn')
        page.calculate_btn
      when 'SaveResults'.upcase
        AppHelpers.scroll_to_object(page, 'results_save')
        page.results_save
      when 'Dashboard'.upcase
        AppHelpers.scroll_to_object(page, 'dashboard')
        page.dashboard
      else
        AppHelpers.output_text "Dataset '#{dataset}' has no scroll and click activity."
    end
    AppHelpers.fail_text "Expected #{inputs} in Toast Message." unless page.text.downcase.include? inputs.downcase
    AppHelpers.output_text "Toast Message '#{inputs}' found as expected."
  end
  module_function :click_and_verify_toast_msg

end

World(CalculatorHelpers)
