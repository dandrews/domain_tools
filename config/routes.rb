Rails.application.routes.draw do
  root 'welcome#index'  
  match 'home'         => 'welcome#home',     :via => :get  
  match 'search'       => 'searches#search',  :via => :post
  match 'whois'        => 'searches#whois',   :via => :get  
end
