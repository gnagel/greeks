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



