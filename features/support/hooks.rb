require 'watir'
require 'restclient'
require 'json'
require 'eyes_selenium'

Before do |scenario|
  #Selenium::WebDriver.logger.level = :info
  #Watir.default_timeout = 120
  @scenario_tags = scenario.source_tag_names
  data = GlobalVars.instance
  data.output_text = []
  STDOUT.puts "Feature: #{scenario.feature}"
  STDOUT.puts "Scenario: #{scenario.name}"
  STDOUT.puts "Local URL: #{ENV['LOCAL_URL']}" unless ENV['LOCAL_URL'].nil?
  AppHelpers.output_text "Feature: #{scenario.feature}, Scenario: #{scenario.name}"
  AppHelpers.output_text "Local URL: #{ENV['LOCAL_URL']}" unless ENV['LOCAL_URL'].nil?
  @browser_vendor = ENV['BROWSER_VENDOR'] || :browser_stack
  @browser_vendor = @browser_vendor.to_sym unless @browser_vendor.is_a? Symbol
  # Download settings
  Watir::HTMLElement.attributes << :test
  case @browser_vendor
    when :firefox
      trusted_profile = Selenium::WebDriver::Firefox::Profile.new
      trusted_profile['browser.download.folderList'] = 2
      trusted_profile['browser.download.manager.showWhenStarting'] = false
      trusted_profile['native_events'] = false
      trusted_profile['dom.forms.number'] = false
      trusted_profile['browser.download.prompt_for_download'] = false
      trusted_profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream,text/csv,application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      trusted_profile['network.automatic-ntlm-auth.trusted-uris'] = FigNewton.base_url
      @browser = Watir::Browser.new @browser_vendor, profile: trusted_profile
    when :chrome
      if RUBY_PLATFORM.include? 'mingw' # If any kind of windows (32/64 bit, Win 7/10/etc) ie. Win 7 64bit = x64-mingw32
        chromedriver_path = 'chromedriver.exe'
      else
        chromedriver_path = '/Users/Shared/chromedriver' # Otherwise, MAC
      end
      prefs = {
        download: {
          prompt_for_download: false,
          default_directory: '/Users/Shared/Downloads'
        }
      }
      @browser = Watir::Browser.new @browser_vendor, prefs: prefs, driver_path: chromedriver_path
    # when :safari
    #      Selenium::WebDriver::Safari.driver_path = "/Applications/Safari Technology Preview.app/Contents/MacOS/safaridriver"
    else
      @browser = Watir::Browser.new(@browser_vendor)
  end

  unless ENV['BROWSERSTACK_DEVICE']
    resolution = ENV['RESOLUTION'] || 'MAX'
    if resolution =='MAX'
      @browser.driver.manage.window.move_to(0,0)
      screen_width = @browser.execute_script('return screen.width;')
      screen_height = @browser.execute_script('return screen.height;')
      @browser.driver.manage.window.resize_to(screen_width,screen_height)
      resolution_inputs = 'MAX'
    else
      resolution_inputs = AppHelpers.load_yaml('resolution.yml')[resolution]
      @browser.window.resize_to(resolution_inputs['x'], resolution_inputs['y'])
    end
  end

end



def output_applitools_results(test_results)

end

def setup_applitools(scenario, resolution, resolution_inputs)

end

def read_and_export_scenario_results(scenario)
  if scenario.failed?
    puts AppHelpers.publish_output_text
    if @browser_vendor != :browser_stack
      pic_dir = 'screenshots'
      pic_name = "ERR_#{@current_page.class}_#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.png"
      pic_src = "#{pic_dir}/#{pic_name}"
      Dir.mkdir(pic_dir) unless File.directory?(pic_dir)
      @browser.screenshot.save(pic_src)
    end
  end
end

# Takes a screenshot of the current screen
# embeds it into the cucumber json report
def embed_screenshots(scenario)

end

# Grabs the url for the video on browserstack
# embeds it into the cucumber json report
def embed_playback_url

end

# Updates status on browserstack session
# status is boolean, true = passed, false = failed
# reason is optional string explaining the status
def browserstack_status(status, reason = '')

end

# Reads the tag collection and extracts a product name from them
def read_product_from_tags()

end