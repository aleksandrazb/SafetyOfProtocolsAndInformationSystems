require 'socket'
require 'openssl'

hostname = '10.100.5.75'
port = 5444

sock = TCPSocket.open(hostname, port)

$mode = ARGV[0]


       sock.puts "decryption"
       sock.puts $mode
	   sleep(3)
    if $mode == "des-ecb"
        decipher = OpenSSL::Cipher.new('des-ecb')
        decipher.decrypt
        a = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "key: " + a
        decipher.key = a
        b = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "to_decrypt: " + b
        data = b
        plaintext = decipher.update(data)+decipher.final

        puts "plaintext: " + plaintext
        sock.close
    end
    if $mode == "3des-cbc"
        decipher = OpenSSL::Cipher.new('des-ede3-cbc')
        decipher.decrypt
        a = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "iv: " + a
        decipher.iv = a
        b = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "key: " + b
        decipher.key = b
        c = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "to_decrypt: " + c
        data = c
        plaintext = decipher.update(data)+decipher.final

        puts "plaintext: " + plaintext
		sock.close
    end
    if $mode == "idea-ofb"
        decipher = OpenSSL::Cipher.new('idea-ofb')
        decipher.decrypt
        a = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "iv: " + a
        decipher.iv = a
        b = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "key: " + b
        decipher.key = b
        c = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "to_decrypt: " + c
        data = c
        plaintext = decipher.update(data)+decipher.final

        puts "plaintext: " + plaintext
		sock.close
    end
    if $mode == "aes_192-cbc"
        decipher = OpenSSL::Cipher.new('aes-192-cbc')
        decipher.decrypt
        a = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "iv: " + a
        decipher.iv = a
        b = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "key: " + b
        decipher.key = b
        c = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "to_decrypt: " + c
        data = c
        plaintext = decipher.update(data)+decipher.final

        puts "plaintext: " + plaintext
		sock.close
    end
    if $mode == "rc5-ecb"
        decipher = OpenSSL::Cipher.new('rc5-ecb')
        decipher.decrypt
        a = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "key: " + a
        decipher.key = a
        b = [sock.gets.gsub(/\n$/, '')].pack("B*")
        puts "to_decrypt: " + b
        data = b
        plaintext = decipher.update(data)+decipher.final

        puts "plaintext: " + plaintext
        sock.close
    end

