#!/usr/bin/env ruby

require 'uri'
require 'faraday' # perform http requests
require 'pony' # send mail

# Description goes here in times of need

# Constant Declarations
URL = ARGV[0]
EMAIL_TO = ARGV[1]
EMAIL_FROM = ARGV[2]
EMAIL_SUBJECT = "[DOWN] #{URL}"
EMAIL_BODY = Time.new.strftime("%F %T [DOWN] #{URL}")
LOG_DIR = File.expand_path(ARGV[3] || "~/.site_status_log")

# Usage Validation
if ARGV.length < 4
  puts "Usage: ruby check_site_status.rb <URL> <email_to> <email_from> [alternate_log_directory]"
end

# Setup Methods
def url_valid?
  url = URI.parse(URL) rescue false
  url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
end

def uri
  URI.parse(URL)
end

def http_connection
  Faraday.new(url: uri.to_s)
end

def log(status)
  File.open(File.join(LOG_DIR, "#{uri.host}.log"), 'a') do |f|
    f.puts Time.now.strftime("%F %T [#{status}] #{URL}")
  end
end

def send_email
  begin
    Pony.mail(to: EMAIL_TO, from: EMAIL_FROM, subject: EMAIL_SUBJECT, body: EMAIL_BODY)
  rescue
    puts "Failed to send email"
  end
end

# Start Execution of Script
begin
  site_status_directory = File.expand_path("~/.site_status_logs")
  Dir.mkdir(site_status_directory) unless Dir.exist?(site_status_directory)
rescue
  puts "Could not create directory - #{LOG_DIR}"
end

begin
  if url_valid?
    http_connection.get
    log("UP")
  else
    puts "Invalid URL '#{URL}'"
  end
rescue Errno::ENOENT, Faraday::Error::ConnectionFailed
  log("DOWN")
  send_email
end
