require 'net/http'
require 'mechanize'
class SearchController < ApplicationController
    def index
        
        # Questa è la versione ordinata per prezzo
        #subito = "http://www.subito.it/annunci-lazio/affitto/camere-posti-letto/roma/roma/?roomtype=1&ps=2&pe=3&sp=1"
        subito = "http://www.subito.it/annunci-lazio/affitto/camere-posti-letto/roma/roma/?roomtype=1&sp=0&ps=2&pe=3"
        bakeca = "http://roma.bakeca.it/annunci/offro-camera/luogo/Roma/affittocamera/200-300/inserzionistacase/privato/nope/true/"
        #immobiliare = "http://www.immobiliare.it/stanze/Roma/camere-posti_letto-Roma.html?criterio=prezzo&ordine=asc&prezzoMassimo=300&idMZona[]=10144&idMZona[]=10145&idMZona[]=10146&idMZona[]=10147&idMZona[]=10148&idMZona[]=10149&idMZona[]=10150&idMZona[]=10151&idMZona[]=10152&idMZona[]=10153&idMZona[]=10154&idMZona[]=10155&idMZona[]=10156&idMZona[]=10163&idMZona[]=10170"
        immobiliare = "http://www.immobiliare.it/stanze/Roma/camere-posti_letto-Roma.html?criterio=dataModifica&ordine=desc&prezzoMassimo=300&idMZona[]=10144&idMZona[]=10145&idMZona[]=10146&idMZona[]=10147&idMZona[]=10148&idMZona[]=10149&idMZona[]=10150&idMZona[]=10151&idMZona[]=10152&idMZona[]=10153&idMZona[]=10154&idMZona[]=10155&idMZona[]=10156&idMZona[]=10163&idMZona[]=10170"
        portaportese = "http://www.portaportese.it/rubriche/Immobiliare/Affitto_-_Subaffitto/m-pX000000300?to=ordinaADis&zoomstart=10&latstart=41.8966&lngstart=12.494"
        #result = Net::HTTP.get(URI.parse(subito))
        trovit = "http://case.trovit.it/index.php/cod.search_adwords_homes/ppc_landing_type.2/type.5/what_d.singola%20roma/sug.0/tracking.%7B%22a%22:5601363252,%20%22k%22:0,%20%22dsa%22:true%7D/isUserSearch.1/origin.11/order_by.source_date/city.Roma/price_min.200/price_max.300/date_from.7/"
        
        idealista = "https://www.idealista.it/affitto-stanze/roma-roma/con-prezzo_300,prezzo-min_200,sesso_ragazza,pubblicato_ultimo-mese/?ordine=pubblicazione-desc"
        
        easystanza = "http://www.easystanza.it/search/rooms?rmin=200&rmax=300&bed=0&pic=0&doub=0&furn=0&shor=0&amin=18&amax=99&gen=2&occ=1&pag=1&srt=3&rad=5000&lat=41.9027835&lng=12.4963655"
        
        stanzaroma = "http://www.stanzaroma.com/stanze/?PREZZO=300&ORIGINE=index"
        
        
        
        
        #doc = Nokogiri::HTML.parse(URI.parse(subito))
        #@lista = doc.css('div.heat a').map { |link| link['href'] }
        mechanize = Mechanize.new
        
        subito = mechanize.get(subito)
        
        @results = {}
        
        # CERCO SU SUBITO
        
        subito.search('.main .items_listing').search('li').each do |item|
            if item.search('span.item_price').text == ""
                next
            else
                link = item.search('a').first['href']
                price = item.search('span.item_price').text
                image = item.search('img').first['src']
                description = item.search('a').last.text.strip
                @results[link] = [price,image,description]
            end
        end
        
        # CERCO SU BAKECA
        
        bakeca = mechanize.get(bakeca)
        bakeca.search('.bk-annuncio-item').each do |item|
            link = item.search('.bk-annuncio-title a').first['href']
            description = item.search('.bk-annuncio-title').text.strip
            price = item.search('.bk-annuncio-prezzo').text.strip
            image = item.search('.bk-lazy').to_s[36..-3]
            @results[link] = [price,image,description]
        end
        
        # CERCO SU IMMOBILIARE
        
        immobiliare = mechanize.get(immobiliare)
        immobiliare.search('.wrapper_riga_annuncio').search('.content').each do |item|
            link = item.search('.annuncio_title a').first['href']
            description = item.search('.annuncio_title a').text.strip
            price = item.search('span.price').text
            image = item.search('.wrap_img img').first['src']
            @results[link] = [price,image,description]
        end
            
        # CERCO SU PORTAPORTESE
        
        portaportese = mechanize.get(portaportese)
        portaportese.search('.ris-body').each do |item|
            link = "http://www.portaportese.it"+item.search('.ris-title a').first['href']
            description = item.search('.ris-title a').first['title']
            price = item.search('span.attr-prezzo').text
            image = item.search('img.ris-photo').first.to_s
            if image != ""
                ind = (image.index(/src/)).to_i + 5
                image = "http://www.portaportese.it"+image[ind..-3].to_s
            end
            
            @results[link] = [price,image,description]
        end
        
        # CERCO SU TROVIT
        
        trovit = mechanize.get(trovit)
        trovit.search('.list li').each do |item|
            link = item.search('a.js-item-title').first['href']
            description = item.search('a.js-item-title').first['title']
            if (item.search('.lazyImage').first != nil)
                image = "http://"+item.search('.lazyImage').first['data-src'][2..-1]
            end
            price = item.search('span.amount').text
            @results[link] = [price,image,description]
        end
        
        # CERCO SU IDEALISTA
        
        idealista = mechanize.get(idealista)
        idealista.search('.item').each do |item|
            link = "https://www.idealista.it"+item.search('.item-link').first['href']
            description = item.search('.item-link').text
            if (item.search('.item-gallery').search('img').first != nil)
                image = item.search('.item-gallery').search('img').first['data-ondemand-img']
            end
            price = item.search('span.item-price').text
            @results[link] = [price,image,description]
        end
        
        # CERCO SU STANZAROMA
        
        stanzaroma = mechanize.get(stanzaroma)
        stanzaroma.search('.TR').each do |item|
            # Evito le righe vuote (Sul sito sono presenti righe vuote nella tabella in cui è inserito del testo commentato "<!--")
            next if (item.search('.TD').text[0] == "<")
            link = item.search('a.linkfoto').first['href']
            description = item.search('td.TD2').search('strong').text
            if (item.search('a.linkfoto').search('img.imglista').first['src'][0] != "/")
                image = item.search('a.linkfoto').search('img.imglista').first['src']
            else
                image = "http://www.stanzaroma.com"+item.search('a.linkfoto').search('img.imglista').first['src']
            end
            price = item.search('td.TD')[3].text
            @results[link] = [price,image,description]
        end
        
        # CERCO SU EASYSTANZA  -- -- -- SEMBRA CI SIANO DEI FILTRI E LA PAGINA NON VIENE ANALIZZATA COME PREVISTO
=begin        
        easystanza = mechanize.get(easystanza)
        puts easystanza.search('div.page-container') #.search('ul.search-results').search('.listing__row')
        easystanza.search('div.listing-meta').each do |item|
            link = "https://www.easystanza.it"+item.search('.listing-meta__link').first['href']
            description = item.search('.listing-meta__link').first['title']
            if (item.search('.listing-img__img').first != nil)
                image = item.search('.listing-img__img').first['src']
            end
            price = item.search('span.listing-img__price').text
            puts link
            puts description
            puts image
            puts price
            puts item
            #@results[link] = [price,image,description]
        end
=end        
        # DATO CHE IL CAMPO "PRICE" CONTIENE TESTO OLTRE ALLA CIFRA, CERCO IL VALORE ESATTO PER POTER POI ORDINARE PER PREZZO
        
        @results.each do |k,v|
            s = v.first.strip
            s = s.scan(/\d+/).first
            @results[k] = [s.to_i,v.second,v.last]
        end
        
        # ORDINO PER PREZZO
        
        @sorted = @results.sort_by {|a| a[1].first}.to_h
        
           
        
    end
end
