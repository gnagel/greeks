require File.expand_path("../spec_helper.rb", File.dirname(__FILE__))

describe Math::Greeks::Calculator do
  def compare_csv(days, option_type)
    table = CSV.table(File.join(File.dirname(__FILE__), "#{days}days.#{option_type}s.csv"))
    
    table.each do |row|
      # Convert to a hash
      row = row.to_hash.merge(:option_type => option_type)

      # Strip empty/nil values 
      row.each { |k,v| row[k] = nil if v.to_s === "nil" || v.to_s.strip.empty? }
      
      # Calculate the options
      Math::Greeks::Calculator.new(row).should be_a_greeks_hash row
    end
  end

  context "22 days" do
    it { compare_csv(22, :call) }
    it { compare_csv(22, :put) }
  end

  context "50 days" do
    it { compare_csv(50, :call) }
    it { compare_csv(50, :put) }
  end
end