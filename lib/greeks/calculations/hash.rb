class Hash
  def requires_fields(*cols)
    cols.each do |required_key|
      if self[required_key].nil?
        raise ArgumentError, "Missing value for key=#{required_key} in opts=#{self.inspect}" 
      end
    end
  end
end
