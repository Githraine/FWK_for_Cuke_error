module AppHelpers
  require 'date'
  require 'spreadsheet'
  include PageObject
  include PageObject::PageFactory
  require 'nokogiri'
  require 'csv'

  def parse_relative_date(value)
    # <Day:Today+1;Month:Today;Year:today-60>
    # <Day:15;Month:Today;Year:1976>
    mod_date = Date.today
    value = value.gsub(/[<>]/, '')
    ary_date_parts = string_to_hash(value,';',':')
    mod_date = do_date_math('Year', ary_date_parts['Year'], mod_date)
    mod_date = do_date_math('Month', ary_date_parts['Month'], mod_date)
    mod_date = do_date_math('Day', ary_date_parts['Day'], mod_date)

    output_text "Relative Date resolves to #{mod_date.strftime('%m/%d/%Y')}."
    mod_date.strftime('%m/%d/%Y')
  end
  module_function :parse_relative_date

  def do_date_math(type, value, mod_date)
    if value.upcase.include? 'Today'.upcase
      if value.include? '+'
        value_nbr = value.split('+')[1]
        value_operator = '+'
      elsif value.include? '-'
        value_nbr = value.split('-')[1]
        value_operator = '-'
      elsif value.casecmp('Today'.upcase).zero?
        return mod_date
      else
        raise "Mathematical operator in #{value} is not valid. Only '+' and '-' are supported."
      end

      case type.upcase
        when 'Day'.upcase
          if value_operator == '+'
            mod_date + value_nbr.to_i
          else
            mod_date - value_nbr.to_i
          end
        when 'Month'.upcase
          if value_operator == '+'
            mod_date >> value_nbr.to_i
          else
            mod_date << value_nbr.to_i
          end
        when 'Year'.upcase
          if value_operator == '+'
            mod_date >> (value_nbr.to_i * 12)
          else
            mod_date << (value_nbr.to_i * 12)
          end
        else
          raise "Type: #{type} is not valid."
      end
    elsif value.upcase.include? 'Last'.upcase
      Date.new(mod_date.year, mod_date.month, -1)
    else
      case type.upcase
      when 'Day'.upcase
        Date.new(mod_date.year, mod_date.month, value.to_i)
      when 'Month'.upcase
        Date.new(mod_date.year, value.to_i, mod_date.day)
      when 'Year'.upcase
        Date.new(value.to_i, mod_date.month, mod_date.day)
      else
        raise "Type: #{type} is not valid."
      end
    end
  end
  module_function :do_date_math

  def get_page_name(page, type)
    load_yaml('page_name_resolver.yml')[page][type]
  end
  module_function :get_page_name

  def output_warning(warning_text, warning_flag='GENERIC')
    output_text "<<< #{warning_flag}_WARNING >>> #{warning_text}"
  end
  module_function :output_warning

  def output_text(text_to_output)
    data = GlobalVars.instance
    data.output_text << text_to_output
  end
  module_function :output_text

  def publish_output_text(include_snapshot = false, page = nil, step_name = 'placeholder')
    data = GlobalVars.instance
    output_temp = ''
    output_temp = data.output_text.join("\n") unless data.output_text.empty?
    data.output_text = []
    if include_snapshot
      output_temp = "#{output_temp}\n#{stage_screenshot(page, step_name)}"
    end
    output_temp
  end
  module_function :publish_output_text

  def fail_text(text_to_output)
    #page.execute_script("return '< < < < < #{text_to_output.gsub("'", '_').gsub('%', '_').gsub("\n", ';')} > > > > >'")
    data = GlobalVars.instance
    data.output_text << " < < <#{text_to_output} > > >"
    fail publish_output_text
  end
  module_function :fail_text

  def stage_screenshot(page, step_name)
    data = GlobalVars.instance
    if data.image_hash.nil?
      data.image_hash = Hash.new
      image_count = 0
    else
      image_count = data.image_hash.keys.count
    end

    image_count += 1
    pic_dir = 'screenshots/scenario_temp_images'
    pic_name = "image_#{image_count}_#{Time.now.strftime('%s_%L')}.png"
    pic_src = "#{pic_dir}/#{pic_name}"
    Dir.mkdir('screenshots') unless File.directory?('screenshots')
    Dir.mkdir(pic_dir) unless File.directory?(pic_dir)
    page.screenshot.save(pic_src)
    hash_temp = {image_count => {:pic_dir => pic_dir, :pic_name => pic_name, :step_name => step_name}}
    data.image_hash.merge! hash_temp
    "took Snapshot #{pic_src}"
  end
  module_function :stage_screenshot

  def enter_data_with_browser_exceptions(page, elem_name, value, use_send_keys)
    case page.driver.browser
      when :chrome, :internet_explorer
        if use_send_keys and !elem_name.include? 'select'
          puts 'using send keys'
          page.send("#{elem_name}_element").when_present
          sleep 0.4
          page.send("#{elem_name}_element").double_click
          sleep 0.4
          page.send("#{elem_name}_element").send_keys value
          #sleep 0.4

          page.send("#{elem_name}_element").send_keys :tab if elem_name.include? 'year'
          sleep 0.2
        else
          page.send("#{elem_name}=", value)
        end

      when :safari
        if page.send("#{elem_name}_element").attribute('type').include? 'select'
          page.select_list(class: "#{page.send("#{elem_name}_element").attribute('class')}").select! value
        else
          page.send("#{elem_name}=", value)
        end

      when :MicrosoftEdge
        begin
          # if use_send_keys
          #   puts 'using send keys'
          #   page.send("#{elem_name}_element").when_present
          #   sleep 0.2
          #   page.send("#{elem_name}_element").double_click
          #   sleep 0.2
          #   page.send("#{elem_name}_element").send_keys value
          #   #sleep 0.4
          #
          #   page.send("#{elem_name}_element").send_keys :tab if elem_name.include? 'year'
          #   #sleep 0.2
          # else
            page.send("#{elem_name}=", value)
          # end
        rescue
          javascript_element = set_javascript_locator(page, elem_name)
          page.execute_script("#{javascript_element}.value='#{value}';")
        end
      else
        page.send("#{elem_name}=", value)
    end
  end
  module_function :enter_data_with_browser_exceptions

  def enter_data_with_code_exceptions(page, elem_name, value, action_code, use_send_keys = false)
    case action_code.upcase
      when 'SpecialBirthday'.upcase
        date_parts = value.split('/')
        page.birthday_month = date_parts[0]
        page.birthday_day = date_parts[1]
        page.birthday_year = date_parts[2]
      when 'Delete'.upcase
        page.send("#{elem_name}_element").send_keys :delete
      else
      unless page.send("#{elem_name}_element").present?
        unless page.send("#{elem_name}_element").exists?
          fail_text " Object #{elem_name} does not exist."
        end
        #scroll_modal_window(page, elem_name)
      end
      AppHelpers.scroll_to_object(page, elem_name)
      enter_data_with_browser_exceptions(page, elem_name, value, use_send_keys)
    end
  end
  module_function :enter_data_with_code_exceptions

  def click_element_with_browser_exceptions(page, elem_name)
    case page.driver.browser
      # when :chrome
      # when :firefox
      # when :safari
      when :MicrosoftEdge
        begin
          page.send("#{elem_name}_element").wait_until_present(timeout:5).click
        rescue
          js_element = set_javascript_locator(page, elem_name)
          page.execute_script("#{js_element}.click();")
        end
      else
        page.send("#{elem_name}_element").wait_until_present(timeout:5).click
    end
  end
  module_function :click_element_with_browser_exceptions

  #if using class name, need unique class name
  def set_javascript_locator(page, elem_name)
    element = page.send("#{elem_name}_element")
    if (element_id = element.attribute('id')) != ''
      "document.getElementById('#{element_id}')"
    elsif (element_id = element.attribute('name')) != ''
      "document.getElementsByName('#{element_id}')[0]"
    elsif (element_id = element.attribute('class_name')) != ''
      "document.getElementsByClassName('#{element_id}')[0]"
    end
  end
  module_function :set_javascript_locator

  def convert_input_for_select(value)
    case value.upcase
      when 'Have'.upcase, 'Plan'.upcase
        'YES'
      when 'Do Not Have'.upcase, 'Do Not Plan'.upcase
        'NO'
      else
        value
    end
  end
  module_function :convert_input_for_select


  def convert_to_proper_type(arg)
    arg.to_i if Integer(arg) rescue arg.to_s
  end
  module_function :convert_to_proper_type

  def wait_times(env)
    env == 'Prod' ? (initial_wait, timeout_wait = 15, 30) : (initial_wait, timeout_wait = 30, 60)
    return initial_wait, timeout_wait
  end
  module_function :wait_times

  def is_element_present(page, element, wait_time = wait_times(FigNewton.env)[0], **type)
    begin
      if type[:element]
        case type[:element]
          when 'named_po' # else scenario and named case scenario are basically same, just kept for better clarification
            return page.send("#{element}_element").wait_until_present(timeout:wait_time).present?
          when 'unnamed_po'
            return element.wait_until_present(timeout:wait_time).present?
          else
            fail_text 'Invalid element type defined'
        end
      else
        return page.send("#{element}_element").wait_until_present(timeout:wait_time).present?
      end
    rescue
      return false
    end
  end
  module_function :is_element_present

  def fast_check_visibility(page, element, duration)
    start_time = Time.now
    begin
      return true if page.send("#{element}_element").visible?
      time_elapsed = (Time.now - start_time) * 1000.0
    end until time_elapsed.round > (duration * 1000.0)
    false
  end
  module_function :fast_check_visibility

  def check_page_name(new_page, existing_page)
    page_name = new_page.match(/.* Page$/)
    page_name == nil ? existing_page : RegLogHelpers.page_name(new_page)
  end
  module_function :check_page_name

  def scroll_to_object(page, object, offset=150)
    location = page.send("#{object}_element").location
    page.scroll.to [location[0],location[1] - offset.to_i]
  end
  module_function :scroll_to_object
end
World(AppHelpers)
