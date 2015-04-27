#!/usr/bin/env ruby

require 'csv'

CSV.foreach('zones_info.csv', {:col_sep => ';'}) do |zone_row|

  puts("### Begin processing #{zone_row[0]} ###")
  
  zone        = zone_row[0]

  next if "#" == zone[0] # comment zone row
    
  ftp_host    = zone_row[1]
  username    = zone_row[2]
  password    = zone_row[3]
  file_path   = zone_row[4]
  outfile     = zone_row[5]
  zip_type    = zone_row[6]
  unzip_file  = outfile.gsub(".#{zip_type}","")

  # step 1 cURL
  puts("Begin FTP #{zone}") # com
  ftp_path  = "ftp://#{ftp_host}/#{file_path}" # ftp://rz.verisign-grs.com/com.zone.gz
  if system("curl -u #{username}:#{password} #{ftp_path} -o #{outfile}")
    puts("Finished FTP #{outfile}") # com.zone.gz
  else
    puts("Failed FTP #{zone}")
    next
  end

  puts("### Finished downloading #{zone} ###")

end
