class GlobalVars
  include Singleton
  attr_accessor :output_text, :image_hash
  attr_accessor :user, :policy_number, :user_data, :step_profile, :portal
  attr_accessor :response, :expectedAgreementResponse, :pacResponse, :expectedPACResponse
  attr_accessor :agency_search
  attr_accessor :query, :blog
  attr_accessor :global_template
  attr_accessor :service_results_hash
end
