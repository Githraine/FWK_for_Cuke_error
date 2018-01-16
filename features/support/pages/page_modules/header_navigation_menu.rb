class HeaderNavigationMenu
  include PageObject
  include PageObject::PageFactory

  link(:logout, text: 'Logout')
  link(:dashboard, href: '/dashboard')
  link(:payment, href: '/dashboard')
  link(:insurance, id: 'cms_head_insurance')
  link(:retirement, id: 'cms_head_retirement')
  link(:investment, id: 'cms_head_investment')
  link(:planning, id: 'cms_head_planning')
  link(:read_more, text: 'Read More')
  link(:learn_more, text: 'Learn More')
  link(:find_out, id: 'btn_calc_findOut')
  link(:for_business, id: 'cms_head_forbusiness')
  link(:claims, id: 'cms_head_claims')
  link(:payments, id: 'cms_head_payments')
  link(:solutions, id: '')
  button(:nav_toggle, class: 'navbar-toggle')
  button(:search_btn, class: ['icon icon-sm', 'icon-search-white'])
  text_field(:search_bar, name: 'query')
  button(:search_go, type: 'submit')
  button(:search_btn, class: 'search-form-trigger')
  div(:need_to_talk_it_through, class: 'agency-connect-with-us')

  # Account Dropdown Icon + Dropdown (Top Right)
  span(:user_account_icon, class: ['icon', 'icon-user'])
  a(:profile_and_preferences, text: 'Profile and Preferences', href: /\/myaccount\/profile/)
  ul(:account_dropdown_menu, class: ['dropdown-menu'])


  def navigate_to(type, page)
    page_nav = handle_header_menu_navigation(page)
    sleep 1
    case type.upcase
      when 'Insurance'.upcase
        AppHelpers.output_text "I click on #{page_nav['page']} under #{type}"
        self.insurance_element.wait_until_present.click
        sub_menu_click(page_nav['page'], page_nav['intermediate'])
      when 'Retirement'.upcase
        AppHelpers.output_text "I click on #{page_nav['page']} under #{type}"
        self.retirement_element.wait_until_present.click
        sub_menu_click(page_nav['page'], page_nav['intermediate'])
      when 'Investment'.upcase
        AppHelpers.output_text "I click on #{page_nav['page']} under #{type}"
        self.investment_element.wait_until_present.click
        sub_menu_click(page_nav['page'], page_nav['intermediate'], true)
      when 'Planning'.upcase
        AppHelpers.output_text "I click on #{page_nav['page']} under #{type}"
        self.planning_element.wait_until_present.click
        sub_menu_click(page_nav['page'], page_nav['intermediate'])
      when 'Search'.upcase
        AppHelpers.output_text "I click on #{type}"
        self.search_btn
      when 'For_Business'.upcase
        AppHelpers.output_text "I click on #{type}"
        self.for_business
      when 'Payments'.upcase
        AppHelpers.output_text "I click on #{type}"
        self.payments
      when 'Solutions'.upcase
        AppHelpers.output_text "I click on #{page_nav['page']} under #{type}"
        self.solutions_element.wait_until_present.click
        @browser.link(text: page_nav['page']).wait_until_present.click
      else
        AppHelpers.fail_text  "Invalid navigation Type:  #{type}."
    end
    #verify_current_page(page)
  end

  def click_button(button)
    AppHelpers.output_text "I click on the #{button} button/link"
    case button.strip.upcase
      when 'Read More'.upcase
        self.read_more_element.when_present.click
      when 'Learn More'.upcase
        self.learn_more_element.when_present.click
      when 'Find Out'.upcase
        scroll_count = 0
        until self.find_out_element.visible? or scroll_count > 6
          page.send_keys :arrow_down
          scroll_count += 1
        end
        self.find_out_element.when_present.click
      else
        AppHelpers.fail_text   "Invalid button: #{button}."
    end
  end

  # def fail_to_navigate_to(type, page)
  #   case type.upcase
  #     when 'Main'.upcase
  #       # if self.main_expander_element.visible?
  #       #   self.main_expander_element.click
  #       #   if browser.link(title: page).exists?
  #       #     fail "Link #{page} was present"
  #       #   end
  #       # else
  #       #   AppHelpers.output_text 'Menu is not present'
  #       # end
  #     else
  #       fail "Invalid navigation Type:  #{type}."
  #   end
  # end

  def wait_for_current_page_to_be(expected_page_name)
    begin
      wait_time = 10
      i = 0
      while expected_page_name.upcase != self.page_name.upcase and expected_page_name.upcase << ' VIEW' != self.page_name.upcase do
        sleep 1
        i += 1
        if i.to_int > wait_time.to_int
          AppHelpers.fail_text   "Wait Exceeded #{wait_time} seconds, Stopping. Check for Save failure on Page #{expected_page_name}."
        end
      end
    rescue => e
      warn('wait_for_current_page_to_be needed to be rescued')
      AppHelpers.output_text expected_page_name
      AppHelpers.output_text self.page_name
      AppHelpers.output_text e
    end
  end

  def log_out
    unless logout_element.visible?
      click_user_account_icon
    end
    self.logout_element.when_present.fire_event('click')
    sleep 4
    AppHelpers.output_text 'And I Log Out'
  end

  def back
    @browser.back
    AppHelpers.output_text 'And I click the Browser Back Button Boldly'
  end

  def refresh
    @browser.refresh
    AppHelpers.output_text 'And I refresh the page'
  end

  def close_browser
    self.close
    AppHelpers.output_text 'And I close the Browser'
  end

  def long_nav_to(dataset)
    inputs = AppHelpers.load_yaml('navigation.yml')[dataset].split(';')
    inputs.each do |nav_command|
      nav_commands = nav_command.split(',')
      case nav_commands[0].strip
        when 'l'
          #header links
          if nav_commands[1].include? '|'
            link_instructions = nav_commands[1].split('|')
            navigate_to link_instructions[0], link_instructions[1]
          else
            navigate_to nav_commands[1], ''
          end
        when 'b'
          #buttons
          click_button nav_commands[1]
        when 'p'
          #set the page object
          $page = nav_commands[1]
          $sub_page = nav_commands[2]
        when 's'
          #search commands
          global_search(nav_commands[1])
        when 'a'
          #links
          @browser.link(text: nav_commands[1])
        when 'a_id'
          #links
          @browser.link(id: nav_commands[1]).click
        when 'a_id_head'
          #links
          handle_header_menu_navigation('')
          @browser.link(id: nav_commands[1]).click
        when 'd'
          #direct nav
          direct_nav_instructions = nav_commands[1].split('|')
          if FigNewton.env == 'Local'
            direct_url = AppHelpers.load_yaml('navigation.yml')['calcs'][FigNewton.env][direct_nav_instructions[0]][direct_nav_instructions[1]].gsub('[local]', ENV['LOCAL_URL'])
          else
            direct_url = AppHelpers.load_yaml('navigation.yml')['calcs'][FigNewton.env][direct_nav_instructions[0]][direct_nav_instructions[1]]
          end
          AppHelpers.output_text "And I navigate to #{direct_url}"
          @browser.goto direct_url
        else
          AppHelpers.fail_text "#{nav_commands[0]} is not a valid command type"
      end
    end
  end

  def global_search(search_text)
    AppHelpers.output_text "I search for #{search_text}"
    self.search_btn
    AppHelpers.enter_data_with_browser_exceptions(self, 'search_bar', search_text, true)
    AppHelpers.click_element_with_browser_exceptions(self, 'search_go')
  end

  def verify_text_on_page(message)
    if @browser.text.downcase.include? message.downcase
      AppHelpers.output_text "Found '#{message}' on the page."
    else
      AppHelpers.fail_text "Did NOT find '#{message}' on the page."
    end
  end

  def verify_object_on_page(object)
    if self.send("#{object}_element").visible?
      AppHelpers.output_text "Found the object '#{object}' on the page."
    else
      AppHelpers.fail_text "Did NOT find the object '#{object}' on the page."
    end
  end

  def click_user_account_icon
    self.user_account_icon_element.wait_until_present.click
    AppHelpers.output_text 'Clicked user account icon.'
  end

  def click_profile_and_preferences_link
    self.profile_and_preferences_element.wait_until_present.click
    AppHelpers.output_text 'Clicked Profile and Preferences link.'
  end

  def verify_user_account_icon_dropdown
    self.account_dropdown_menu_element.wait_until_present
    AppHelpers.fail_text 'Profile and Preferences link does not exist' unless self.profile_and_preferences_element.exists?
    AppHelpers.fail_text 'Logout link does not exist' unless self.logout_element.exists?
    AppHelpers.output_text 'Verified that the Profile and preferences link and Logout link exists.'
  end

  def sub_menu_click(page, intermediate, indexed=false)
    @browser.link(text: intermediate).wait_until_present.click unless intermediate == ''
    unless indexed
      @browser.link(text: page).wait_until(timeout: 30, message: "#{page} link not found after 30 seconds"){@browser.link(text: page).present?}
      @browser.link(text: page).click
    else
      if @browser.link(text: page).visible?
        @browser.link(text: page).wait_until_present.click
      else
        @browser.link(text: page, index: 1).wait_until_present.click
      end
    end
  end

  def handle_header_menu_navigation(page)
    intermediate = ''
    if self.nav_toggle_element.present?
      self.nav_toggle
      sleep 1
      if page.include? '('
        intermediate = page.split(')')[0].gsub('(','')
        page = page.split(')')[1]
      end
    else
      if page.include? '('
        page = page.split(')')[1]
      end
    end
    {'page' => page, 'intermediate' => intermediate}
  end

end
