
#  https://gist.github.com/halloffame/5350249
DATE_FORMAT = "%Y-%m-%dT%H:%M:%S.%f+00:00"

# Date format UTC        
# Time.parse(DateTime.now.to_s).utc
# Time.now.utc.to_date.strftime("%FT%T")
# 	%F - The ISO 8601 date format (%Y-%m-%d)
# 	%T - 24-hour time (%H:%M:%S)


# Convert a string date to a datetime object.
#
# :param value: String with a date value.
# :rtype: Datetime object or Nne.
#
def str_to_date(value)
    if value!=nil
        return DateTime.strptime(value, DATE_FORMAT)
    end
end

# Convert a datetime object to string.
#
# :param value: Datetime object.
# :rtype: String or None.
#
def date_to_str(datetime)
    if datetime!=nil
        return datetime.strftime(DATE_FORMAT)
    end
end

# Extend class added new methods
#
class String
  def rtrim(char)
    dump.rtrim!(char)
  end

  def rtrim!(char)
    gsub!(/#{Regexp.escape(char)}+$/, '')
  end

  def ltrim(char)
    dump.ltrim!(char)
  end

  def ltrim!(char)
    gsub!(/^#{Regexp.escape(char)}+/, '')
  end
end