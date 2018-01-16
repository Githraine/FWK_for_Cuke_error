require 'json'

def add_feature_to_results(feature, combined_results)
    name = feature['uri']
    feature_in_results = combined_results.index {|feat| feat['uri'] == name}
    unless feature_in_results
        combined_results << feature
    else
        feature['elements'].each do |scenario|
            combined_results[feature_in_results]['elements'] << scenario
        end
    end
    combined_results
end

def add_warnings(feature)
    feature['elements'].each do |scenario|
        $scenario_count += 1 if scenario['keyword'].match(/scenario/i)
        scenario_warnings = []
        scenario['steps'].each do |step| #iterate thru each step
            $fail_count += 1 if step['result']['status'] == 'failed'
            next unless step['output']
            step_warnings = []
            step['output'][0].split("\n").each do |output|
                warning = output.match(/(<<< )(.*)(_WARNING >>>)/)
                step_warnings << warning[2].to_s if warning
            end
            unless step_warnings.empty?
                scenario_warnings << step_warnings
                step['name'] = "<<< WARNING(S): #{step_warnings.join(', ')} >>> #{step['name']}" #prepend warning flags to step name
            end
        end
        unless scenario_warnings.empty?
            scenario['name'] = "<<< WARNING(S): #{scenario_warnings.join(', ')} >>> #{scenario['name']}" #prepend warning flags to scenario name
        end
    end
    feature
end

$scenario_count = 0
$fail_count = 0
combined_results = []
Dir.glob("results/#{ARGV[0]}/#{ARGV[1]}/results_*.json") do |results_json|
    temp_results = JSON.parse!(File.read(results_json))
    next if temp_results == []
    temp_results.each do |feature|
        feature = add_warnings(feature)
        combined_results = add_feature_to_results(feature, combined_results)
    end
    File.delete(results_json)
end

combined_file = File.open("results/#{ARGV[0]}/#{ARGV[1]}/combined_results.json", 'w')
combined_file.write(combined_results.to_json)
combined_file.close

if ENV['FAIL_THRESHOLD']
    fail_percent = 100.0 * $fail_count.to_f / $scenario_count.to_f
    if fail_percent > ENV['FAIL_THRESHOLD'].to_f
        puts false
    else
        puts true
    end
end