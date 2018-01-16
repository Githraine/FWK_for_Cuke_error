class ModalChargeCalculatorPage
  include PageObject
  include PageObject::PageFactory

  page_url(ENV['LOCAL_URL'] || CalculatorHelpers.resolve_calc_url('Modal', 'planning/calculators/modal-apr-calculator'))

  #---------- base Page Objects -----------------
  div(:page_marker, id: 'calculator-modal')
  text_field(:annual_premium, class: ['input-annual-premium'])
  select_list(:payment_mode_select, class: ['select-payment-mode'])
  text_field(:payment_amount, class: ['input-payment-amount'])
  button(:calculate_btn, class: ['btn','btn-default'], text: 'Calculate')
  link(:disclosure_statement_btn, href: '#', text: 'Review our Disclosure Statement')
  b(:disclosure_title, text: 'Disclosure Statement')
  div(:disclosure_text, class: ['modal-body'])
  button(:close_disclosure_btn, class: ['close'])
  link(:more_settings_btn, class: ['btn','btn-default'], text: 'Change Your Information')
  button(:save_progress_btn, class: ['icon','icon-md','icon-save'])
  div(:error_text, class: ['tooltip','has-error'])

  #---------results objects ------------
  text_field(:result_annual_premium, class: ['input-annual-premium'])
  link(:result_disclosure_statement_btn, class: ['btn-btn-link'], text: 'Review our Disclosure Statement')
  select_list(:result_payment_mode_select, class: ['select-payment-mode'])
  text_field(:result_payment_amount, class: ['input-payment-amount'])
  span(:result_apr, class: ['output-apr'])
  span(:result_charge, class: ['output-modal-charge'])
  span(:result_premium, class: ['output-premium'])
  div(:results_chart, class: ['viz-legend-container','clearfix'])

  #-------Base Page Methods------
  def await
    self.page_marker_element.when_present(timeout = 20)
    AppHelpers.output_text 'I am on the Modal Calculator'
    $eyes.check_window('ModatCharge_Calc-await') if $applitools_on
  end

  def enter_calculator_data_from(dataset, segment, use_send_keys = false)
    CalculatorHelpers.enter_calculator_data_from(self, dataset, segment, use_send_keys)
  end

  def verify_disclosures
    CalculatorHelpers.verify_disclosures(self)
  end

  def select_action(action)
    CalculatorHelpers.select_action(self, action)
  end

  def calculate
    self.calculate_btn_element.when_present.click
    sleep 1
  end

  def open_disclosures
    self.disclosure_statement_btn
    AppHelpers.fail_text  'The Disclosure did not open' unless disclosure_text_element.exists?
    AppHelpers.output_text 'Open Disclosures'
    $eyes.check_window('ModalCharge_Calc-Disclosures') if $applitools_on
  end

  def close_disclosures
    #self.close_disclosure_btn
    # @browser.click(5,5)
    # sleep 1
    # AppHelpers.fail_text  'The Disclosure did not close' if disclosure_title_element.exists?
  end

  def open_more_settings
    self.more_settings_btn
    $eyes.check_window('ModalCharge_Calc-OpenCYI') if $applitools_on
  end

  def save_progress
    self.save_progress_btn
  end

  #------ results Methods ------------
  def verify_calculator_results_from(segment, dataset)
    CalculatorHelpers.verify_calculator_results_from(self, segment, dataset)
    $eyes.check_window('ModalCharge_Calc-VerifyResults') if $applitools_on
  end

  def verify_tooltips(section)
    CalculatorHelpers.verify_calculator_tooltips(self, section)
  end

  def verify_errors(dataset)
    CalculatorHelpers.verify_calculator_errors(self, dataset)
  end
end
