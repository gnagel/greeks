require File.expand_path("../spec_helper.rb", File.dirname(__FILE__))

describe Math::Greeks::CalculatorAll do

  before(:all) {
    @opts = {
      :federal_reserve_interest_rate => 0.02,
      :stock_price                   => 0.45,
      :stock_dividend_rate           => 0,
      :option_type                   => :call,
      :option_volume                 => 367,
      :option_strike                 => 3.5,
      :option_price                  => 0.45,
      :option_expires_in_days        => 7,
    }
    
    @expected = {
      :federal_reserve_interest_rate_f => 0.00002,
      :stock_dividend_rate_f           => 0.0,
      :option_expires_pct_year         => 0.021917808219178082,

      :premium_value                   => 0.4500000000000002,
      :time_value                      => -1.6653345369377348e-16,

      :break_even                      => 48.778550844871916,

      :d1                              => 2.0011102561691865,
      :d1_normal_distribution          => 0.9773098152489259,
      :d2                              => 1.9397237611028264,
      :d2_normal_distribution          => 0.9737934342534863,
      :du                              => 0.12095699397930633,
      :eqt                             => 1,
      :ert                             => 0.999995616447964,
      :nd1                             => 0.05387117871070419,
      :p1                              => 3.95,
      :spi                             => 2.5066282746310002,
      :st                              => 0.14804664203952106,
      :x1                              => 3.499984657567874,

      :iv                              => 0.41464294103998,
      :vega                            => 0.00031503016087781226,
      :theta                           => -0.0008182739935072078,
      :rho                             => 0.0007470163461978153,
      :gamma                           => 0.22217057801678108,
      :delta                           => 0.9773098152489259,
      :annualized_premium_value        => 551.8462850305851,
      :annualized_time_value           => nil,
    }
    
    @hash = {
      :iv                              => (0.41464294103998 * 100).round(2),
      :vega                            => (0.02902778498281647 * 100).round(2),
      :theta                           => (-0.18183866522382397 * 100).round(2),
      :rho                             => (0.1660036324884034 * 100).round(2),
      :gamma                           => (0.897948398218801 * 100).round(2),
      :delta                           => (8.578608378296128 * 100).round(2),
      :deta_vs_theta                   => (-47.177031176162544 * 100).round(2),
    }
  }

  it "should calculate the to_hash[:iv]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:iv].should === @hash[:iv]
  end

  it "should calculate the to_hash[:vega]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:vega].should === @hash[:vega]
  end

  it "should calculate the to_hash[:theta]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:theta].should === @hash[:theta]
  end

  it "should calculate the to_hash[:rho]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:rho].should === @hash[:rho]
  end

  it "should calculate the to_hash[:gamma]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:gamma].should === @hash[:gamma]
  end

  it "should calculate the to_hash[:delta]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:delta].should === @hash[:delta]
  end

  it "should calculate the to_hash[:delta_vs_theta]" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:delta_vs_theta].should === @hash[:delta_vs_theta]
  end


  it "should calculate the federal_reserve_interest_rate_f" do
    Math::Greeks::CalculatorAll.new(@opts).federal_reserve_interest_rate_f.should === @expected[:federal_reserve_interest_rate_f]
  end


  it "should calculate the stock_dividend_rate_f" do
    Math::Greeks::CalculatorAll.new(@opts).stock_dividend_rate_f.should === @expected[:stock_dividend_rate_f]
  end


  it "should calculate the option_expires_pct_year" do
    Math::Greeks::CalculatorAll.new(@opts).option_expires_pct_year.should === @expected[:option_expires_pct_year]
  end



  it "should calculate the premium_value" do
    Math::Greeks::CalculatorAll.new(@opts).premium_value.should === @expected[:premium_value]
  end


  it "should calculate the time_value" do
    Math::Greeks::CalculatorAll.new(@opts).time_value.should === @expected[:time_value]
  end



  it "should calculate the break_even" do
    Math::Greeks::CalculatorAll.new(@opts).break_even.should === @expected[:break_even]
  end



  it "should calculate the d1" do
    Math::Greeks::CalculatorAll.new(@opts).d1.should === @expected[:d1]
  end


  it "should calculate the d1_normal_distribution" do
    Math::Greeks::CalculatorAll.new(@opts).d1_normal_distribution.should === @expected[:d1_normal_distribution]
  end


  it "should calculate the d2" do
    Math::Greeks::CalculatorAll.new(@opts).d2.should === @expected[:d2]
  end


  it "should calculate the d2_normal_distribution" do
    Math::Greeks::CalculatorAll.new(@opts).d2_normal_distribution.should === @expected[:d2_normal_distribution]
  end


  it "should calculate the du" do
    Math::Greeks::CalculatorAll.new(@opts).du.should === @expected[:du]
  end


  it "should calculate the eqt" do
    Math::Greeks::CalculatorAll.new(@opts).eqt.should === @expected[:eqt]
  end


  it "should calculate the ert" do
    Math::Greeks::CalculatorAll.new(@opts).ert.should === @expected[:ert]
  end


  it "should calculate the nd1" do
    Math::Greeks::CalculatorAll.new(@opts).nd1.should === @expected[:nd1]
  end


  it "should calculate the p1" do
    Math::Greeks::CalculatorAll.new(@opts).p1.should === @expected[:p1]
  end


  it "should calculate the spi" do
    Math::Greeks::CalculatorAll.new(@opts).spi.should === @expected[:spi]
  end


  it "should calculate the st" do
    Math::Greeks::CalculatorAll.new(@opts).st.should === @expected[:st]
  end


  it "should calculate the x1" do
    Math::Greeks::CalculatorAll.new(@opts).x1.should === @expected[:x1]
  end



  it "should calculate the iv" do
    Math::Greeks::CalculatorAll.new(@opts).iv.should === @expected[:iv]
  end


  it "should calculate the vega" do
    Math::Greeks::CalculatorAll.new(@opts).vega.should === @expected[:vega]
  end


  it "should calculate the theta" do
    Math::Greeks::CalculatorAll.new(@opts).theta.should === @expected[:theta]
  end


  it "should calculate the rho" do
    Math::Greeks::CalculatorAll.new(@opts).rho.should === @expected[:rho]
  end


  it "should calculate the gamma" do
    Math::Greeks::CalculatorAll.new(@opts).gamma.should === @expected[:gamma]
  end


  it "should calculate the delta" do
    Math::Greeks::CalculatorAll.new(@opts).delta.should === @expected[:delta]
  end


  it "should calculate the deta_vs_theta" do
    Math::Greeks::CalculatorAll.new(@opts).to_hash[:deta_vs_theta].should === @expected[:deta_vs_theta]
  end


  it "should calculate the annualized_premium_value" do
    Math::Greeks::CalculatorAll.new(@opts).annualized_premium_value.should === @expected[:annualized_premium_value]
  end


  it "should calculate the annualized_time_value" do
    Math::Greeks::CalculatorAll.new(@opts).annualized_time_value.should === @expected[:annualized_time_value]
  end
end


