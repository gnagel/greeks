require File.expand_path("../../spec_helper.rb", File.dirname(__FILE__))

describe "Math::GreekCalculations::iv_approximation" do
  extend  Math::GreekCalculations
  include Math::GreekCalculations

  before(:all) {
    @opts = {
      :volatility_assumption         => 0.06677339613442257,
      :federal_reserve_interest_rate => 0.0,
      :stock_dividend_rate           => 0.0,
      :stock_price                   => 1558.86,
      :option_expires_in_days        => 2,
      :option_type                   => nil,
      :option_strike                 => 1555.0,
      :option_expires_pct_year       => (2.0 + 1.0) / 365.0,
    }
  }
  
  context "call options" do
    before(:all) { @call_opts = @opts.merge(:option_type => :call) }

    it "should take 0.0005s per calculation" do
      test_speed(0.0005) { iv_approximation(@call_opts) }
    end

    it "should calculate the iv_approximation for call options" do
      iv_approximation(@call_opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.06677339613442257)).should === 6.00107195188707
      iv_approximation(@call_opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.07107985109297155)).should === 6.2252002661155075
      iv_approximation(@call_opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.7767120139768976)).should === 45.68560652631322
      iv_approximation(@call_opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.07527610801601367)).should === 3.7000002563002
      iv_approximation(@call_opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.07552765261587197)).should === 3.7141067663948206
      iv_approximation(@call_opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.42176476544518277)).should === 23.221131720133826
      iv_approximation(@call_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.0779960405797778)).should === 2.0000017634203004
      iv_approximation(@call_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.07813292732725367)).should === 2.0066292948365003
      iv_approximation(@call_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.08735521764131016)).should === 2.4605950257197264
      iv_approximation(@call_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.9780351979867221)).should === 52.21726606581467
      iv_approximation(@call_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.3435337766271465)).should === 758.8600005013102
      iv_approximation(@call_opts.merge(:option_strike => 800.0, :volatility_assumption => 12.740771633200708)).should === 965.5145139463043
      iv_approximation(@call_opts.merge(:option_strike => 800.0, :volatility_assumption => 3.514987520617601)).should === 761.180608568741
      iv_approximation(@call_opts.merge(:option_strike => 800.0, :volatility_assumption => 5.344225349125736)).should === 779.3062103270099
    end
  end
  
  context "put options" do
    before(:all) { @put_opts = @opts.merge(:option_type => :put) }

    it "should take 0.0005s per calculation" do
      test_speed(0.0005) { iv_approximation(@put_opts) }
    end

    it "should calculate the iv_approximation for put options" do
      iv_approximation(@put_opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.17420232380521405)).should === 8.0000045908738
      iv_approximation(@put_opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.17527391126836678)).should === 8.059610246476154
      iv_approximation(@put_opts.merge(:option_strike => 1555.0, :volatility_assumption => 0.7767120139768976)).should === 41.82560652631332
      iv_approximation(@put_opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.17414278115684817)).should === 10.402340321608108
      iv_approximation(@put_opts.merge(:option_strike => 1560.0, :volatility_assumption => 0.42176476544518277)).should === 24.361130083927492
      iv_approximation(@put_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.181240092859984)).should === 13.600074181757122
      iv_approximation(@put_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.1841966933132152)).should === 13.762453623925467
      iv_approximation(@put_opts.merge(:option_strike => 1565.0, :volatility_assumption => 0.9780351979867221)).should === 58.357264429608335
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.5393962108083743)).should === 2.629019627922171e-05
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.6067241201549014)).should === 7.568356970618674e-05
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.6834074050713879)).should === 0.00021921204632999354
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.771767439716307)).should === 0.0006394104760457618
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.8750034162804263)).should === 0.0018804588644171366
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 1.9976636941128336)).should === 0.005584769195816824
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 12.740771633200708)).should === 206.65451394630452
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 2.146464011824484)).should === 0.016786172347868167
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 2.3317969713539255)).should === 0.05122222614503946
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 2.570738257468368)).should === 0.15942558719093025
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 2.8936600070770004)).should === 0.509909715874568
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 3.3608957289108887)).should === 1.6978567650117729
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 4.114040744822018)).should === 6.038729525242829
      iv_approximation(@put_opts.merge(:option_strike => 800.0, :volatility_assumption => 5.598593988181911)).should === 24.478368022721696
    end
  end
end
