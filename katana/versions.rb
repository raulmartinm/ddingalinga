=begin
Ruby SDK for the KATANA(tm) Framework (http://katana.kusanagi.io)

Copyright (c) 2016-2017 KUSANAGI S.L. All rights reserved.

Distributed under the MIT license.

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.

=end

require_relative 'errors'

# Testing in Ruby http://rubular.com/ or Python http://pythex.org/

# Regexp to remove duplicated '*' in versions
DUPLICATES = /(\*)\1+/

# Regexp to check version pattern for invalid chars
INVALID_PATTERN = /[^a-zA-Z0-9*.,_-]/  # Any single character except a-zA-Z...


# Exception raised when a version pattern is not valid.
#
class InvalidVersionPattern < KatanaError

    def initialize(pattern)
        super("Invalid version pattern: '#{pattern}'")
        @pattern = pattern
end

# Exception raised when a version is not found.
#
class VersionNotFound < KatanaError

    def initialize(pattern)
        super("Service version not found for pattern: '#{pattern}'")
        @pattern = pattern
end


class VersionString
    def initialize(version)
        # Validate pattern characters
        if (version =~ INVALID_PATTERN).nil?
            raise InvalidVersionPattern(version)
        end

        # Remove duplicated special chars from version
        @version = version.gsub(DUPLICATES)

        if @version.include? "*"
            # Create a pattern to be use for comparison
            @pattern = re.compile(re.sub(r'\*+', '[^*.]+', @version))
        else
            @pattern = nil
        end
    end

    def version()
        return @version
    end

    def pattern()
        return @pattern
    end

    def compare_none(part1, part2)
        if part1 == part2
            return 0
        elsif part2 == nil
            # The one that DO NOT have more parts is greater
            return 1
        else
            return -1
        end
    end

    def compare_sub_parts(sub1, sub2)
        # Sub parts are equal
        if sub1 == sub2
            return 0
        end

        # Check if any sub part is an integer
        is_integer = [false, false]
        [sub1, sub2].each_with_index { |value, index| 
            begin
                Integer(value)
            rescue ArgumentError
                is_integer[index] = false
            else
                is_integer[index] = true
            end
        }

        # Compare both sub parts according to their type
        if is_integer[0] != is_integer[1]
            # One is an integer. The integer is higher than the non integer.
            # Check if the first sub part is an integer, and if so it means
            # sub2 is lower than sub1.
            return if is_integer[0] ? -1 : 1
        end

        # Both sub parts are of the same type
        return if sub1 < sub2 ? 1 : -1
    end

    def compare(ver1, ver2)
        # Versions are equal
        if ver1 == ver2
            return 0
        end

        for part1, part2 in zip_longest(ver1.split('.'), ver2.split('.'))
            # One of the parts is nil
            if part1 == nil || part2 == nil
                return self.compare_none(part1, part2)
            end

            for sub1, sub2 in zip_longest(part1.split('-'), part2.split('-'))
                # One of the sub parts is nil
                if sub1 is None || sub2 is nil
                    # Sub parts are different, because one have a
                    # value and the other not.
                    return self.compare_none(sub1, sub2)
                end

                # Both sub parts have a value
                result = self.compare_sub_parts(sub1, sub2)
                if result
                    # Sub parts are not equal
                    return result
                end
            end
        end
    end

    def match(version)
        if self.pattern
            return self.version == version
        else
            # If the whole string matches the regular expression pattern, return a corresponding match object. 
            # Return None if the string does not match the pattern; note that this is different from a zero-length match.
            return self.pattern.fullmatch(version) != nil
        end
    end

    def resolve(versions)
        valid_versions = [ver for ver in versions if self.match(ver)]
        if !valid_versions
            raise VersionNotFound(self.pattern)
        end

        valid_versions.sort(key=cmp_to_key(self.compare))
        return valid_versions[0]
    end
end