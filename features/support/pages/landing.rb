class LandingPage
    include PageObject
    include PageObject::PageFactory
  
    page_url(ENV['LOCAL_URL'] || "#{FigNewton.base_url}")

###########################################################
#Base Page Objects
###########################################################

    link(:lnk_sign_up, text: 'Sign Up')
    link(:lnk_login, id:'cms_head_login')

    span(:btn_insurance, text:'Insurance')
    link(:lnk_whole_life, id:'cms_head_wholelife')

    button(:btn_mobile_nav, class:'navbar-toggle')

###########################################################
#Page Methods
###########################################################

    def await
        self.wait_until(10) do
            lnk_login? && (lnk_sign_up? || btn_mobile_nav?)
        end
        AppHelpers.output_text 'I am on the Landing page.'
    end

    def check_element(element, expected=true)
        RegLogHelpers.check_element(self, element, expected)
    end

    def click_element(element)
        send("#{RegLogHelpers.element_name(element)}_element").wait_until_present.click
    end

end