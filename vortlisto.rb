#!/usr/bin/env ruby

require 'httparty'

GCSELIST_URL = 'http://home.btclick.com/ukc802510745/eo/vortlist/gcselist.htm'
GCSELIST_PATH = File.basename(GCSELIST_URL)
GCSELIST_FIXED_PATH = GCSELIST_PATH.sub(/\./, '.fixed.')

# home.btclick.com rejects bots (despite not having a robots.txt)
FAKE_USER_AGENT = 'Mozilla/5.0'

unless File.exist? GCSELIST_PATH
  File.open(GCSELIST_PATH, 'w') do |file|
    file.write(HTTParty.get GCSELIST_URL, headers: {'User-Agent' => FAKE_USER_AGENT})
  end
end

csv = CSV.open(GCSELIST_FIXED_PATH.sub('htm', 'csv'), 'w')

File.open(GCSELIST_FIXED_PATH) do |file|
  section = ''
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
      when %r[(<b>)?([^<]+)(</b>)?\.{5,}(.+)]
        # puts "$1=#{$1} $2=#{$2} $3=#{$3} $4=#{$4}\n(section=#{section})"
        unless ($1 == '<b>' && $3 == '</b>') || ($1.nil? && $3.nil?)
          raise "Misparse of #{line} #{$1.nil?} #{$3.nil?}"
        end
        common = $1.nil? ? '' : 'common'
        eo = $2; en = $4
        transitive = en.sub!(' <i>(tr)</i>', '') && 'trans.'
        transitive ||= en.sub!(' <i>(intr)</i>', '') && 'intr.'
        csv << [section, common, eo, transitive, en ]
      else
        # Show mis/un-parsed lines
        puts ">> #{line}"
    end
  end
end
csv.close
