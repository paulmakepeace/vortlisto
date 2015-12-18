#!/usr/bin/env ruby

require 'httparty'
require 'fileutils'

GCSELIST_URL = 'http://home.btclick.com/ukc802510745/eo/vortlist/gcselist.htm'
GCSELIST_PATH = File.basename(GCSELIST_URL)
GCSELIST_FIXED_PATH = GCSELIST_PATH.sub(/\./, '.fixed.')
CSV_OUTPUT_DIR = 'csv'

# home.btclick.com rejects bots (despite not having a robots.txt)
FAKE_USER_AGENT = 'Mozilla/5.0'

unless File.exist? GCSELIST_PATH
  File.open(GCSELIST_PATH, 'w') do |file|
    file.write(HTTParty.get GCSELIST_URL, headers: {'User-Agent' => FAKE_USER_AGENT})
  end
end

FileUtils.mkdir_p CSV_OUTPUT_DIR

# csv = CSV.open(GCSELIST_FIXED_PATH.sub('htm', 'csv'), 'w')
csv = Hash.new do |h, key|
  h[key] =  CSV.open(File.join(CSV_OUTPUT_DIR, "#{key}.csv"), 'w')
end

File.open(GCSELIST_FIXED_PATH) do |file|
  section = section_filename = ''
  file.each { |line| break if line =~ %r[Index:</h2>] } # skip preamble
  file.each do |line|
    line.chomp!
    line.sub!('<br>', '')

    case line
      when %r[<h2>]
      when %r[<a href="]  # TOC
      when %r[tiu listo estis]  # epilog
        break
      when %r[<a NAME=".*"></a>(?:Topic [0-9]+ - )?(.*)</h2>]
        section = $1
        section_filename = $1.gsub(/\W+/, '_').downcase
      when %r[(<b>)?([^<]+)(</b>)?\.{5,}(.+)]
        # puts "$1=#{$1} $2=#{$2} $3=#{$3} $4=#{$4}\n(section=#{section})"
        unless ($1 == '<b>' && $3 == '</b>') || ($1.nil? && $3.nil?)
          raise "Misparse of #{line} #{$1.nil?} #{$3.nil?}"
        end
        level = $1.nil? ? 'advanced' : 'basic'
        eo = $2; en = $4
        # transitive = en.match(' <i>(tr)</i>') && 'trans.'
        # transitive ||= en.match(' <i>(intr)</i>') && 'intr.'
        csv["#{section_filename}-#{level}"] << [eo, en]
      else
        # Show mis/un-parsed lines
        puts ">> #{line}"
    end
  end
end
csv.values.map(&:close)
