require 'csv'
require 'digest/sha1'
require 'optparse'

opt_parser = OptionParser.new do |opts|
  opts.banner = "Usage: gift-certs.rb [options]"
end

opt_parser.parse!(ARGV)

REP_INITIALS = ['AMZ']

SUFFIX = ['a']

# 50 Adults and 50 kids

CSV.open("gift_codes_#{Time.now.to_i}.csv", "w+") do |csv|
  SUFFIX.each do |suffix|
    REP_INITIALS.each do |rep_prefix|
      500.times do |n|
        csv << [%Q{#{rep_prefix}#{Digest::SHA1.hexdigest("#{suffix}-#{n}-#{rand}")[0..4]}#{suffix}}.upcase]
      end
    end
  end
end


