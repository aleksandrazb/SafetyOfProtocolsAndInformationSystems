#!/usr/bin/env ruby -w
require "socket"
require "openssl"



class Client

	def sendText
	  @server.puts ($key.unpack("B*"))
	  @server.puts ($encrypted.unpack("B*"))
	  #@server.close 
	end 

	def sendTextWithIV
	  @server.puts ($iv.unpack("B*"))
	  @server.puts ($key.unpack("B*"))
	  @server.puts ($encrypted.unpack("B*"))
	  #@server.close 
	end 

	def encryption(mode)
		if mode == "des-ecb"
			data = "Hello there!"#File.read("text_to_encrypt.txt")
			puts data

			cipher = OpenSSL::Cipher.new('des-ecb')
			cipher.encrypt
			$key=cipher.random_key

			puts $key

			$encrypted = cipher.update(data)+cipher.final

			puts encrypted
			sendText
		end
		if mode == "3des-cbc"
			data = "Hello there!"#File.read("text_to_encrypt.txt")
			puts data

			cipher = OpenSSL::Cipher.new('des-ede3-cbc')
			cipher.encrypt
			$key=cipher.random_key
			$iv = cipher.random_iv

			$encrypted = cipher.update(data)+cipher.final

			puts $encrypted
			sendTextWithIV
		end
		if mode == "idea-ofb"
			data = "Hello there!"#File.read("text_to_encrypt.txt")
			puts data

			cipher = OpenSSL::Cipher.new('idea-ofb')#not supported
			cipher.encrypt
			$key=cipher.random_key
			$iv = cipher.random_iv

			$encrypted = cipher.update(data)+cipher.final

			puts encrypted
			sendTextWithIV
		end
		if mode == "aes_192-cbc"
			data = "Hello there!"#File.read("text_to_encrypt.txt")
			puts data

			cipher = OpenSSL::Cipher.new('aes-192-cbc')
			cipher.encrypt
			$key=cipher.random_key
			$iv = cipher.random_iv

			$encrypted = cipher.update(data)+cipher.final

			puts encrypted
			sendTextWithIV
		end
		if mode == "rc5-ecb"
			data = "Hello there!"#File.read("text_to_encrypt.txt")
			puts data

			cipher = OpenSSL::Cipher.new('rc5-ecb')#not supported
			cipher.encrypt
			$key=cipher.random_key

			$encrypted = cipher.update(data)+cipher.final

			puts encrypted
			sendText
		end
	end

	def decryption(mode)

		if mode == "des-ecb"
			decipher = OpenSSL::Cipher.new('des-ecb')
			decipher.decrypt
			decipher.key = @server.gets.gsub(/\n$/, '')
			data = @server.gets.gsub(/\n$/, '')
			plaintext = decipher.update(data)+decipher.final

			puts plaintext
			#@server.close
		end
		
		if mode == "3des-cbc"
			decipher = OpenSSL::Cipher.new('des-ede3-cbc')
			decipher.decrypt
			decipher.iv = @server.gets.gsub(/\n$/, '')
			decipher.key = @server.gets.gsub(/\n$/, '')
			data = @server.gets.gsub(/\n$/, '')
			plaintext = decipher.update(data)+decipher.final

			puts plaintext
			#@server.close
		end
		if mode == "idea-ofb"
			decipher = OpenSSL::Cipher.new('idea-ofb')
			decipher.decrypt
			decipher.iv = @server.gets.gsub(/\n$/, '')
			decipher.key = @server.gets.gsub(/\n$/, '')
			data = @server.gets.gsub(/\n$/, '')
			plaintext = decipher.update(data)+decipher.final

			puts plaintext
			#@server.close
		end
		if mode == "aes_192-cbc"
			decipher = OpenSSL::Cipher.new('aes-192-cbc')
			decipher.decrypt
			decipher.iv = @server.gets.gsub(/\n$/, '')
			decipher.key = @server.gets.gsub(/\n$/, '')
			data = @server.gets.gsub(/\n$/, '')
			plaintext = decipher.update(data)+decipher.final

			puts plaintext
			#@server.close
		end
		if mode == "rc5-ecb"
			decipher = OpenSSL::Cipher.new('rc5-ecb')
			decipher.decrypt
			decipher.key = @server.gets.gsub(/\n$/, '')
			data = @server.gets.gsub(/\n$/, '')
			plaintext = decipher.update(data)+decipher.final

			puts plaintext
			#@server.close
		end
	end
	
  def initialize(server)
    @server = server
    @request = nil
    @response = nil
	listen
    send
    @request.join
    @response.join
  end
  
  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets.chomp
        puts "#{msg}"
		if msg == "des-ecb" or msg == "3des-cbc" or msg == "idea-ofb" or msg == "aes_192-cbc" or msg == "rc5-ecb"
			encryption(msg)
		end
      }
    end
  end
  
  def send
    puts "Enter the username:"
    @request = Thread.new do
      loop {
        msg = $stdin.gets.chomp
        @server.puts( msg )
		if msg == "des-ecb" or msg == "3des-cbc" or msg == "idea-ofb" or msg == "aes_192-cbc" or msg == "rc5-ecb"
			decryption(msg)
		end
      }
    end
  end
  
end

server = TCPSocket.open( "localhost", 5444 )
Client.new( server )