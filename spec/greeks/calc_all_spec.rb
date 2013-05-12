require File.expand_path("../spec_helper.rb", File.dirname(__FILE__))

describe Math::Greeks::CalculatorAll do
  before(:all) {
    @opts = {
      :federal_reserve_interest_rate => 0.0002 * 100,
      :stock_price                   => 3.95,
      :stock_dividend_rate           => 0.0,
      :option_type                   => :call,
      :option_volume                 => 367,
      :option_strike                 => 3.5,
      :option_price                  => 0.45,
      :option_expires_in_days        => 7.0,
    }
    
    @expected = {
      :federal_reserve_interest_rate_f => 0.0002,
      :stock_dividend_rate_f           => 0.0,
      :option_expires_pct_year         => 0.021917808219178082,

      :premium_value                   => @opts[:stock_price] - @opts[:option_strike],
      :time_value                      => nil,

      :break_even                      => 0.48778550844871916,

      :d1                              => 2.0011102561691865,
      :d1_normal_distribution          => 0.9773098152489259,
      :d2                              => 1.9397237611028264,
      :d2_normal_distribution          => 0.9737934342534863,
      :du                              => 0.12095699397930633,
      :eqt                             => 1,
      :nd1                             => 0.05387117871070419,
      :p1                              => 3.95,
      :sqrt_2pi                        => 2.5066282746310002,
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
  
  before(:each) {
    @calc = Math::Greeks::CalculatorAll.new(@opts)
  }


  #it { Math::Greeks::CalculatorAll::SQRT_2PI.should === @expected[:sqrt_2pi] }

  #it { @calc.federal_reserve_interest_rate_f.should === @expected[:federal_reserve_interest_rate_f] }
  #it { @calc.stock_dividend_rate_f.should === @expected[:stock_dividend_rate_f] }
  #it { @calc.option_expires_pct_year.should === @expected[:option_expires_pct_year] }
  #it { @calc.option_expires_pct_year_sqrt.should === @expected[:st] }
  #it { @calc.premium_value.should === @expected[:premium_value] }
  #it { @calc.time_value.should === @expected[:time_value] }
  #it { @calc.annualized_premium_value.should === @expected[:annualized_premium_value] }
  #it { @calc.annualized_time_value.should === @expected[:annualized_time_value] } 
  ##it { @calc.du.should === @expected[:du] }
  #it { @calc.eqt.should === @expected[:eqt] }
  #it { @calc.p1.should === @expected[:p1] }
  #it { @calc.x1.should === @expected[:x1] }
  #it { @calc.d1.should === @expected[:d1] }
  ##it { @calc.d1_normal_distribution.should === @expected[:d1_normal_distribution] }
  ##it { @calc.nd1.should === @expected[:nd1] }
  ##it { @calc.d2.should === @expected[:d2] }
  ##it { @calc.d2_normal_distribution.should === @expected[:d2_normal_distribution] }
  #it { @calc.iv.should === @expected[:iv] }
  ##it { @calc.vega.should === @expected[:vega] }
  ##it { @calc.theta.should === @expected[:theta] }
  ##it { @calc.rho.should === @expected[:rho] }
  ##it { @calc.gamma.should === @expected[:gamma] }
  ##it { @calc.delta.should === @expected[:delta] }
  ##it { @calc.break_even.should === @expected[:break_even] }
  ##it { @calc.to_hash[:deta_vs_theta].should === @expected[:deta_vs_theta] }
  #it { @calc.to_hash[:iv].should === @hash[:iv] }
  ##it { @calc.to_hash[:vega].should === @hash[:vega] }
  ##it { @calc.to_hash[:theta].should === @hash[:theta] }
  ##it { @calc.to_hash[:rho].should === @hash[:rho] }
  ##it { @calc.to_hash[:gamma].should === @hash[:gamma] }
  ##it { @calc.to_hash[:delta].should === @hash[:delta] }
  ##it { @calc.to_hash[:delta_vs_theta].should === @hash[:delta_vs_theta] }
end



describe "Math::GreekCalculations::iv_du" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate_f) { 0.00 }
  let(:option_expires_pct_year) { 1.00 }
  
  def var_du
    iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
  end
  
  context "exactly at the money" do
    let(:option_strike) { 10.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.00 }

      it { var_du().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.0002 }

      it { var_du().should === expected }
    end
  end
  
  context "out of the money" do
    let(:option_strike) { 15.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { -0.40546510810816444 }

      it { var_du().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { -0.40526510810816446 }

      it { var_du().should === expected }
    end
  end
  
  context "in of the money" do
    let(:option_strike) { 5.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.6931471805599453 }

      it { var_du().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.6933471805599453 }

      it { var_du().should === expected }
    end
  end
end



describe "Math::GreekCalculations::iv_price_vs_rate_vs_expires" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:option_expires_pct_year) { 1.00 }
  let(:stock_dividend_rate_f) { 0.05 }
  let(:expected) { 9.51229424500714 }
  subject { iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f) }
  
  it { should === expected }
end



describe "Math::GreekCalculations::iv_vega" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate_f) { 0.00 }
  let(:option_expires_pct_year) { 1.00 }
  let(:volatility_guess) { 0.50 }

  def var_du
    iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
  end

  def var_price_vs_rate_vs_expires
    iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f)
  end
  
  def var_vega
    iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
  end
  
  context "exactly at the money" do
    let(:option_strike) { 10.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 3.866681168028493 }
      
      it { var_vega().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 3.866294209940902 }
      
      it { var_vega().should === expected }
    end
  end
  
  context "out of the money" do
    let(:option_strike) { 15.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 3.4086802947730774 }
      
      it { var_vega().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 3.4094449205351056 }
      
      it { var_vega().should === expected }
    end
  end
  
  context "in of the money" do
    let(:option_strike) { 5.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 1.045940982192684 }
      
      it { var_vega().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 1.045256535627944 }
      
      it { var_vega().should === expected }
    end
  end
end



describe "Math::GreekCalculations::iv_option_price" do
  include Math
  include Math::GreekCalculations

  let(:stock_price) { 10.00 }
  let(:stock_dividend_rate_f) { 0.00 }
  let(:option_type) { :call }
  let(:option_expires_pct_year) { 1.00 }
  let(:volatility_guess) { 0.50 }

  def var_du
    iv_du(stock_price, option_strike, option_expires_pct_year, federal_reserve_interest_rate_f, stock_dividend_rate_f)
  end

  def var_price_vs_rate_vs_expires
    iv_price_vs_rate_vs_expires(stock_price, option_expires_pct_year, stock_dividend_rate_f)
  end
  
  def var_vega
    iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
  end
  
  def var_vega
    iv_vega(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, var_du, var_price_vs_rate_vs_expires)
  end
  
  def var_option_price
    iv_option_price(stock_price, option_strike, option_expires_pct_year, volatility_guess, federal_reserve_interest_rate_f, stock_dividend_rate_f, option_type, var_du, var_price_vs_rate_vs_expires)
  end
  
  context "exactly at the money" do
    let(:option_strike) { 10.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 1.9741254870839384 }
      
      it { var_option_price().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 1.974928148944329 }
      
      it { var_option_price().should === expected }
    end
  end
  
  context "out of the money" do
    let(:option_strike) { 15.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 0.7088126378267057 }
      
      it { var_option_price().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 0.7092458172337022 }
      
      it { var_option_price().should === expected }
    end
  end
  
  context "in of the money" do
    let(:option_strike) { 5.00 }
  
    context "0% interest" do
      let(:federal_reserve_interest_rate_f) { 0.00 }
      let(:expected) { 5.130693877506824 }
      
      it { var_option_price().should === expected }
    end
  
    context "0.02% interest" do
      let(:federal_reserve_interest_rate_f) { 0.0002 }
      let(:expected) { 5.1315659170286185 }
      
      it { var_option_price().should === expected }
    end
  end
end
