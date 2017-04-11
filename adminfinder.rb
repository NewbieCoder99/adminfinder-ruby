$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'library', 'colorize')))

require 'colorize'
require 'net/http'
require 'uri'

class Adminfinder


	def cls
		return system 'clear'
	end

	def help
		puts "========================== Admin Finder Help For Use =========================="
		puts "1. get --help || Help for use program"
		puts "2. get --quit || Exit program"
		puts "3. get --url http://www.target.com || Test and search admin page or loginpage"
	end

	def get_list
		# return File.open(File.dirname(__FILE__) + '/page_list/list.txt','w')
		return File.readlines('page_list/lists.txt','r')
	end

	def error_notify(param)
		split = param.split("|")
		if split[0] == "command"
			return "\n [INFO]|Adminfinder|:: #{split[1]}: command not found \n [INFO]|Adminfinder|:: write ".red+"get --help "+"for use.".red
		elsif split[0] == "target_empty"
			return "\n [INFO]|Adminfinder|:: #{split[1]}: target is empty \n [INFO]|Adminfinder|:: write ".red+"get --help "+"for use.".red
		end
	end

	def curl(target)
		begin
			uri 					= URI.parse(target)
			http 					= Net::HTTP.new(uri.host, uri.port)
			request 				= Net::HTTP::Get.new(uri.request_uri)
			response 				= http.request(request)
			return response.code
		rescue
			return exit
		end
	end

	def receive_input(param)
		cls()
		split 		= param.split(" ")
		if split[0] == "get" || split[0] == "GET"

			if split[1] == "--help"
				help()
			elsif split[1] == "--quit"
				exit
			elsif split[1] == "--url"
				if split[2] == nil
					puts error_notify("target_empty|"+split[1])
				else
					IO.foreach('page_list/lists.txt') { |line|
						x = line.split("|")
						puts "[INFO]|Adminfinder|:: is checking...".green
						puts "[INFO]|Adminfinder|:: Total Scan #{x.length - 1}".green
						for i in 0..x.length - 1
							uri_path = "#{split[2]}/#{x[i]}"
							response_code = curl(uri_path)
							if response_code == "301" or response_code == "302" or response_code == "200" or response_code == "403"
								message = "[INFO]|Adminfinder|:: #{uri_path} [Page Found: #{response_code}]".green
								open('logs/page_found.txt', 'a') { |f|
									f << "#{message} \n"
								}
							else
								message = "[INFO]|Adminfinder|:: #{uri_path} [Page Not Found: #{response_code}]".red
								open('logs/page_not_found.txt', 'a') { |f|
									f << "#{message} \n"
								}
							end
							puts "#{message}"
							open('logs/logs.txt', 'a') { |f|
								f << "#{message} \n"
							}
						end
					}
				end

			else
				puts error_notify("command|"+split[1])
			end

		else
			puts error_notify("command|"+split[0])
		end
		second_main()
	end

		def second_main
			print "\n [INFO]|Adminfinder|:: "
			# a = gets.to_i # untuk mengetikan tipe data Integer
			a = gets.chomp # untuk mengetikan tipe data String
			puts receive_input(a)
		end

	def main
		cls()
		print "========================== Admin Finder 1.0 Version =========================="
		print "\n [INFO]|Adminfinder|:: "
		# a = gets.to_i # untuk mengetikan tipe data Integer
		a = gets.chomp # untuk mengetikan tipe data String
		puts receive_input(a)
	end

end

var = Adminfinder.new
var.main
