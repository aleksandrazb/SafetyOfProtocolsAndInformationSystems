require 'socket'
require 'openssl'
require 'securerandom'
require 'digest'

hostname = 'localhost'#'10.100.5.75'
port = 5444

sock = TCPSocket.open(hostname, port)

    sock.puts "Bob"
	#sock.gets.gsub(/\n$/, '')
	
	#BOB losuje R1, R2, i sideOfCoin
	R1 = SecureRandom.random_number(1000..9999).to_s
	puts "R1\t" + R1.inspect
	R2 = SecureRandom.random_number(1000..9999).to_s
	puts "R2\t" + R2.inspect
	sideOfCoin = [0, 1].sample.to_s
	puts "sideOfCoin\t" + sideOfCoin.inspect
	to_hash = R1 + R2 + sideOfCoin
	puts "to_hash\t" + to_hash.inspect
	
	#BOB generuje hash(R1,R2,sideOfCoin)
	hash = Digest::SHA512.hexdigest to_hash.to_s
	puts "hash\t" + hash.inspect
	
	#BOB otrzymuje od ALICE jej hash i R1 |||||||||||||||| ALICE ==================>> BOB
	Alice_hash1 = sock.gets.gsub(/\n$/, '')
	puts "Alice_hash1\t" + Alice_hash1.inspect
	Alice_R1 = sock.gets.gsub(/\n$/, '')
	puts "Alice_R1\t" + Alice_R1.inspect
	
	#BOB wysyla do ALICE hash i R1 ||||||||||||||||||||||| ALICE <<================== BOB
	sock.puts hash
	puts "send hash to Alice"
	sock.puts R1
	puts "send R1 to Alice"
	
	#ALICE odkrywa swoje sideOfCoin |||||||||||||||||||||| ALICE ==================>> BOB
	Alice_R1p = sock.gets.gsub(/\n$/, '')
	puts "Alice_R1p\t" + Alice_R1p.inspect
	Alice_R2 = sock.gets.gsub(/\n$/, '')
	puts "Alice_R2\t" + Alice_R2.inspect
	sideOfCoin_Alice = sock.gets.gsub(/\n$/, '')
	puts "sideOfCoin_Alice\t" + sideOfCoin_Alice.inspect
	to_hash_Alice = Alice_R1p + Alice_R2 + sideOfCoin_Alice
	puts "to_hash_Alice\t" + to_hash_Alice.inspect
	Alice_hash2 = Digest::SHA512.hexdigest to_hash_Alice.to_s
	puts "Alice_hash2\t" + Alice_hash2.inspect
	
	
	if(Alice_hash1 != Alice_hash2)
		puts "Alice oszukuje"
	end
	
	
	#BOB odkrywa swoje sideOfCoin_Bob |||||||||||||||||||| ALICE <<================== BOB
	sock.puts R1
	puts "send R1 to Alice"
	sock.puts R2
	puts "send R2 to Alice"
	sock.puts sideOfCoin
	puts "send sideOfCoin to Alice"
	
	#RZUT MONETA
	throw = sideOfCoin_Alice.to_i ^ sideOfCoin.to_i
	puts "throw\t" + throw.inspect
	
	#SPRAWDZENIE ZWYCIEZCY
	if(sideOfCoin.to_i == throw.to_i)
		puts "WYGRANA"
	end
	
	if(sideOfCoin.to_i != throw.to_i)
		puts "PRZEGRANA"
	end

