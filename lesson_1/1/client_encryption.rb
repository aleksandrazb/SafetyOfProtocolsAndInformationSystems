require 'socket'
require 'openssl'
require 'securerandom'

$hostname = '10.100.5.75'
$port = 5444

while 1
    sock = TCPSocket.open($hostname, $port)
    sock.puts "encryption"
    $mode = sock.gets.gsub(/\n$/, '')
    puts $mode + "\n"
    if $mode == "des-ecb"
        data = File.open("text_to_encrypt.txt")
        data = data.readlines
        data = data.join
        puts "data: " + data

        cipher = OpenSSL::Cipher.new('des-ecb')
        cipher.encrypt
		
        $key=cipher.key=SecureRandom.random_bytes(8) 
        puts "key: " + $key
		
        $encrypted = cipher.update(data)+cipher.final
        puts "encrypted: " + $encrypted
		
		
		sock.puts pkey = $key.unpack("B*")
		puts "send_key: " , pkey 
		
		sock.puts pencrypted = $encrypted.unpack("B*")
		puts "send_encrypted_text: " , pencrypted 
		
		sock.close 
    end
    if $mode == "3des-cbc"
        data = File.open("text_to_encrypt.txt")
        data = data.readlines
        data = data.join
        puts "data: " + data

        cipher = OpenSSL::Cipher.new('des-ede3-cbc')
        cipher.encrypt
		
        $key=cipher.key=SecureRandom.random_bytes(24)
        puts "key: " + $key
		
        $iv = cipher.iv=SecureRandom.random_bytes(8)
        puts "iv: " + $iv

        $encrypted = cipher.update(data)+cipher.final
        puts "encrypted: " + $encrypted
		
		
		sock.puts piv = $iv.unpack("B*")
		puts "send_iv" , piv
		
		sock.puts pkey = $key.unpack("B*")
		puts "send_key" , pkey
		
		sock.puts pencrypted = $encrypted.unpack("B*")
		puts "send_encrypted_text" , pencrypted
		
		sock.close 
    end
    if $mode == "idea-ofb"
        data = File.open("text_to_encrypt.txt")
        data = data.readlines
        data = data.join
        puts "data: " + data

        cipher = OpenSSL::Cipher.new('idea-ofb')#not supported
        cipher.encrypt
        $key=cipher.key=SecureRandom.random_bytes(16)
        puts "key: " + $key
        $iv = cipher.iv=SecureRandom.random_bytes(8)
        puts "iv: " + $iv

        $encrypted = cipher.update(data)+cipher.final

        puts "encrypted: " + $encrypted
		sock.puts piv = $iv.unpack("B*")
		puts "send_iv" , piv
		sock.puts pkey = $key.unpack("B*")
		puts "send_key" , pkey
		sock.puts pencrypted = $encrypted.unpack("B*")
		puts "send_encrypted_text" , pencrypted
		sock.close 
    end
    if $mode == "aes_192-cbc"
        data = File.open("text_to_encrypt.txt")
        data = data.readlines
        data = data.join
        puts "data: " + data

        cipher = OpenSSL::Cipher.new('aes-192-cbc')
        cipher.encrypt
        $key=cipher.key=SecureRandom.random_bytes(24)
        puts "key: " + $key
        $iv = cipher.iv=SecureRandom.random_bytes(16)
        puts "iv: " + $iv

        $encrypted = cipher.update(data)+cipher.final

        puts "encrypted: " + $encrypted
		sock.puts piv = $iv.unpack("B*")
		puts "send_iv" , piv
		sock.puts pkey = $key.unpack("B*")
		puts "send_key" , pkey
		sock.puts pencrypted = $encrypted.unpack("B*")
		puts "send_encrypted_text" , pencrypted
		sock.close 
    end
    if $mode == "rc5-ecb"
        data = File.open("text_to_encrypt.txt")
        data = data.readlines
        data = data.join
        puts "data: " + data

        cipher = OpenSSL::Cipher.new('rc5-ecb')#not supported
        cipher.encrypt
        $key=cipher.key=SecureRandom.random_bytes(16)
        puts "key: " + $key

        $encrypted = cipher.update(data)+cipher.final

        puts "encrypted: " + $encrypted
        #sock.puts "encryption_sendText"
		sock.puts pkey = $key.unpack("B*")
		puts "send_key: " , pkey 
		sock.puts pencrypted = $encrypted.unpack("B*")
		puts "send_encrypted_text: " , pencrypted 
		sock.close 
    end
    
end