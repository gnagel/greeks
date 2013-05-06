module Math
  module GreekCalculations
    # Moddeled after the Excel NORMSDIST function
    def normal_distribution(value)
      p  =  0.2316419
      b1 =  0.319381530
      b2 = -0.356563782
      b3 =  1.781477937
      b4 = -1.821255978
      b5 =  1.330274429

      y = value.abs
      z = Math.exp(-y*y/2) / Math.sqrt(2 * Math::PI)
      t = 1 / ( 1 + p * y)
      cum = 1 - z * (b1*t + b2*t*t + b3*t*t*t + b4*t*t*t*t + b5*t*t*t*t*t)

      cum = 1 - cum if (value < 0)
      cum
    end
    

    # Normal distribution function (Gaussian bell curve)
    def normal_distribution_gaussian(value)
      Math.exp(-0.5 * z * z) / Math.sqrt(2 * Math::PI)
    end
  end
end
