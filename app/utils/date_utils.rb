class DateUtils
  def self.format
    '%d/%m/%Y'
  end

  def self.parse_date(value)
    Time.strptime(value, format) if value
  end

  def self.format_date(value)
    value.strftime(format)
  end
end
