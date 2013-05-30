require File.expand_path("../spec_helper.rb", File.dirname(__FILE__))

describe Math::Greeks::Calculator do
  let(:entity) do 
    {
      :symbol => 'AMD',
      :type   => :stock,
      :date   => '2013-05-19',
    }
  end
  
  let(:date) { '2013-06-21' }
  let(:days) { 35.0 }
  
  let(:call)  do
    {
      :strike     => 4.50,
      :bid        => 0.16,
      :iv         => 61.92,
      :delta      => 8.59,
      :gamma      => 5.57,
      :vega       => 1.81,
      :rho        => 0.75,
      :theta      => -2.51,
      :break_even => 21.38,
    }
  end

  let(:put) do
    {
      :strike     => 4.50,
      :bid        => 0.59,
      :iv         => 61.93,
      :delta      => -4.57,
      :gamma      => -2.84,
      :vega       => 0.49,
      :rho        => -0.55,
      :theta      => -0.68,
      :break_even => 45.66,
    }
  end
  
  let(:base_opts) do
    {
      :stock_price                   => 4.07,
      :stock_dividend_rate           => 0.00,
      :option_expires_in_days        => 35.0,
      :federal_reserve_interest_rate => 0.01,
      :option_type                   => nil,
      :option_price                  => nil,
      :option_strike                 => nil,
    }
  end
  
  context "call option" do
    let(:opts) do
      base_opts.merge(
        :option_type   => :call,
        :option_price  => call[:bid],
        :option_strike => call[:strike],
      )
    end

    subject(:calc) { Math::Greeks::Calculator.new(opts) }

    it { calc.stock_price.should === opts[:stock_price] }
    it { calc.stock_dividend_rate.should === opts[:stock_dividend_rate] }
    it { calc.option_type.should === opts[:option_type] }
    it { calc.option_price.should === opts[:option_price] }
    it { calc.option_strike.should === opts[:option_strike] }
    it { calc.option_expires_in_days.should === opts[:option_expires_in_days] }
    it { calc.federal_reserve_interest_rate.should === opts[:federal_reserve_interest_rate] }
    
    it { calc.to_hash[:iv].should === call[:iv] }
    it { calc.to_hash[:delta].should === call[:delta] }
    it { calc.to_hash[:gamma].should === call[:gamma] }
    it { calc.to_hash[:vega].should === call[:vega] }
    it { calc.to_hash[:theta].should === call[:theta] }
    it { calc.to_hash[:rho].should === call[:rho] }
    it { calc.to_hash[:break_even].round(2).should === call[:break_even] }
  end
  
  context "put option" do
    let(:opts) do
      base_opts.merge(
        :option_type   => :put,
        :option_price  => put[:bid],
        :option_strike => put[:strike],
      )
    end

    subject(:calc) { Math::Greeks::Calculator.new(opts) }

    it { calc.stock_price.should === opts[:stock_price] }
    it { calc.stock_dividend_rate.should === opts[:stock_dividend_rate] }
    it { calc.option_type.should === opts[:option_type] }
    it { calc.option_price.should === opts[:option_price] }
    it { calc.option_strike.should === opts[:option_strike] }
    it { calc.option_expires_in_days.should === opts[:option_expires_in_days] }
    it { calc.federal_reserve_interest_rate.should === opts[:federal_reserve_interest_rate] }
    
    it { calc.to_hash[:iv].should === put[:iv] }
    it { calc.to_hash[:delta].should === put[:delta] }
    it { calc.to_hash[:gamma].should === put[:gamma] }
    it { calc.to_hash[:vega].should === put[:vega] }
    it { calc.to_hash[:theta].should === put[:theta] }
    it { calc.to_hash[:rho].should === put[:rho] }
    it { calc.to_hash[:break_even].round(2).should === put[:break_even] }
  end
  
  it {
    calculator = Math::Greeks::Calculator.new(:stock_price=>1558.86, :stock_dividend_rate=>0.0, :federal_reserve_interest_rate=>0.0, :option_type=>:call, :option_price=>751.50, :option_strike=>800.00, :option_expires_in_days=>2)
    calculator.iv.should be_nil
    calculator.to_hash[:iv].should be_nil
  }
  
  context "bulk testing" do
    let(:stock_price) { 3.98 }
    let(:dividends) { 0.00 }

    context "23 days" do
      let(:days){ 23 }
      let(:fed) { 0.04 }
      
      context "call" do
        let(:hash) {
          Math::Greeks::Calculator.new(
            :stock_price                   => stock_price,
            :stock_dividend_rate           => dividends,
            :federal_reserve_interest_rate => fed,
            :option_expires_in_days        => days, 
            :option_type                   => :call, 
            :option_strike                 => 3.50,
            :option_price                  => 0.54).to_hash
        }
   
        it { hash[:iv].round(1).should === 58.5.round(1) }
        it { hash[:delta].round(1).should === 6.1.round(1) }
        it { hash[:gamma].round(1).should === 2.1.round(1) }
        it { hash[:vega].round(1).should === 0.29.round(1) }
        it { hash[:rho].round(1).should === 0.33.round(1) }
        it { hash[:theta].round(1).should === -0.60.round(1) }
        it { hash[:delta_vs_theta].round(1).should === -10.20.round(1) }
        it { hash[:break_even].round(1).should === 43.07.round(1) }
      end
      
      context "put" do
        let(:hash) {
          Math::Greeks::Calculator.new(
            :stock_price                   => stock_price,
            :stock_dividend_rate           => dividends,
            :federal_reserve_interest_rate => fed,
            :option_expires_in_days        => days, 
            :option_type                   => :put, 
            :option_strike                 => 3.50,
            :option_price                  => 0.07).to_hash
        }
   
        it { hash[:iv].round(1).should === 62.2.round(1) }
        it { hash[:delta].round(1).should === -10.7.round(1) }
        it { hash[:gamma].round(1).should === -9.0.round(1) }
        it { hash[:vega].round(1).should === 2.44.round(1) }
        it { hash[:rho].round(1).should === -0.77.round(1) }
        it { hash[:theta].round(1).should === -5.08.round(1) }
        it { hash[:delta_vs_theta].round(1).should === 2.10.round(1) }
        it { hash[:break_even].round(1).should === 19.66.round(1) }
      end
    end

    context "597 days" do
      let(:days){ 597 }
      let(:fed) { 0.24 }
      
      context "call" do
        let(:hash) {
          Math::Greeks::Calculator.new(
            :stock_price                   => stock_price,
            :stock_dividend_rate           => dividends,
            :federal_reserve_interest_rate => fed,
            :option_expires_in_days        => days, 
            :option_type                   => :call, 
            :option_strike                 => 3.50,
            :option_price                  => 1.35).to_hash
        }
   
        it { hash[:iv].round(1).should === 58.2.round(1) }
        it { hash[:delta].round(1).should === 2.1.round(1) }
        it { hash[:gamma].round(1).should === 0.7.round(1) }
        it { hash[:vega].round(1).should === 0.75.round(1) }
        it { hash[:rho].round(1).should === 1.79.round(1) }
        it { hash[:theta].round(1).should === -0.06.round(1) }
        it { hash[:delta_vs_theta].round(1).should === -32.81.round(1) }
        it { hash[:break_even].round(1).should === 26.35.round(1) }
      end
      
      context "put" do
        let(:hash) {
          Math::Greeks::Calculator.new(
            :stock_price                   => stock_price,
            :stock_dividend_rate           => dividends,
            :federal_reserve_interest_rate => fed,
            :option_expires_in_days        => days, 
            :option_type                   => :put, 
            :option_strike                 => 3.50,
            :option_price                  => 0.92).to_hash
        }
   
        it { hash[:iv].round(1).should === 61.8.round(1) }
        it { hash[:delta].round(1).should === -1.2.round(1) }
        it { hash[:gamma].round(1).should === -1.5.round(1) }
        it { hash[:vega].round(1).should === 1.17.round(1) }
        it { hash[:rho].round(1).should === -3.66.round(1) }
        it { hash[:theta].round(1).should === -0.10.round(1) }
        it { hash[:delta_vs_theta].round(1).should === 12.93.round(1) }
        it { hash[:break_even].round(1).should === 43.74.round(1) }
      end
    end
  end
end