require File.expand_path("../spec_helper.rb", File.dirname(__FILE__))

describe Math::Greeks::Calculator do
  # Helper method to iterate the sample data
  def compare_csv(days, option_type)
    table = CSV.table(File.join(File.dirname(__FILE__), "#{days}days.#{option_type}s.csv"))
    
    table.each do |row|
      # Convert to a hash
      row = row.to_hash

      # Strip empty/nil values 
      row.each do |k,v| 
        if v.to_s === "nil" || v.to_s.strip.empty?
          row[k] = nil
        else
          row[k] = row[k].to_f
        end
      end
      
      # Calculate the options
      row.merge!(:option_type => option_type)
      Math::Greeks::Calculator.new(row).should be_a_greeks_hash row
    end
  end

  it "compute call options @ 22 days" do
    compare_csv(22, :call)
  end

  it "compute put options @ 22 days" do
    compare_csv(22, :put)
  end

  it "compute call options @ 50 days" do
    compare_csv(50, :call)
  end

  it "compute put options @ 50 days" do
    compare_csv(50, :put)
  end
end