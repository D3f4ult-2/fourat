require 'sinatra'
require 'shodan'

SHODAN_API_KEY = 'aBFZOaEhYVHPqlyYD3JgQOzzakyvp6wu'

get '/' do
    send_file 'main.html'
end

post '/process_ip' do
  ip_address = params[:ip]
  
  begin
    client = Shodan::Shodan.new(SHODAN_API_KEY)
    host = client.host(ip_address)
    host_info = <<-INFO
      Adresse IP : #{host["ip_str"]}
  Organisation : #{host["org"]}
      OS : #{host["os"]}
      Ports ouverts : #{host["ports"].join(", ")}
    INFO
  rescue StandardError => e
    host_info = "Erreur lors de la récupération des informations : #{e.message}"
  end

  "Informations sur l'adresse IP :<br> #{host_info.gsub("\n", '<br>')}"
end