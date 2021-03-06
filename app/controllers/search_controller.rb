require 'net/http'
require 'mechanize'
require 'thread'
class SearchController < ApplicationController
    def index
        
        # Questa è la versione ordinata per prezzo
        #subito = "http://www.subito.it/annunci-lazio/affitto/camere-posti-letto/roma/roma/?roomtype=1&ps=2&pe=3&sp=1"
        subito = "http://www.subito.it/annunci-lazio/affitto/camere-posti-letto/roma/roma/?roomtype=1&sp=0&ps=2&pe=3"
        subito2 = "http://www.subito.it/annunci-lazio/affitto/camere-posti-letto/roma/roma/?roomtype=1&sp=0&ps=2&pe=3&o=2"
        subito3 = "http://www.subito.it/annunci-lazio/affitto/camere-posti-letto/roma/roma/?roomtype=1&sp=0&o=3&ps=2&pe=3"
        bakeca = "http://roma.bakeca.it/annunci/offro-camera/luogo/Roma/affittocamera/200-300/inserzionistacase/privato/nope/true/"
        bakeca2 = "http://roma.bakeca.it/annunci/offro-camera/luogo/Roma/affittocamera/200-300/inserzionistacase/privato/page/2/nope/true/"
        bakeca3 = "http://roma.bakeca.it/annunci/offro-camera/luogo/Roma/affittocamera/200-300/inserzionistacase/privato/page/3/nope/true/"
        immobiliare = "http://www.immobiliare.it/stanze/Roma/camere-posti_letto-Roma.html?criterio=dataModifica&ordine=desc&prezzoMassimo=300&idMZona[]=10144&idMZona[]=10145&idMZona[]=10146&idMZona[]=10147&idMZona[]=10148&idMZona[]=10149&idMZona[]=10150&idMZona[]=10151&idMZona[]=10152&idMZona[]=10153&idMZona[]=10154&idMZona[]=10155&idMZona[]=10156&idMZona[]=10163&idMZona[]=10170"
        portaportese = "http://www.portaportese.it/rubriche/Immobiliare/Affitto_-_Subaffitto/m-pX000000300?to=ordinaADis&zoomstart=10&latstart=41.8966&lngstart=12.494"
        trovit = "http://case.trovit.it/index.php/cod.search_homes/type.5/what_d.roma/sug.0/isUserSearch.1/origin.11/order_by.source_date/price_min.200/price_max.300/date_from.7/"
        trovit2 = "http://case.trovit.it/index.php/cod.search_homes/type.5/what_d.roma/origin.11/price_min.200/price_max.300/rooms_min.0/bathrooms_min.0/date_from.7/order_by.source_date/resultsPerPage.15/isUserSearch.1/page.2"
        trovit3 = "http://case.trovit.it/index.php/cod.search_homes/type.5/what_d.roma/origin.11/price_min.200/price_max.300/rooms_min.0/bathrooms_min.0/date_from.7/order_by.source_date/resultsPerPage.15/isUserSearch.1/page.3"
        trovit4 = "http://case.trovit.it/index.php/cod.search_homes/type.5/what_d.roma/origin.11/price_min.200/price_max.300/rooms_min.0/bathrooms_min.0/date_from.7/order_by.source_date/resultsPerPage.15/isUserSearch.1/page.4"
        trovit5 = "http://case.trovit.it/index.php/cod.search_homes/type.5/what_d.roma/origin.11/price_min.200/price_max.300/rooms_min.0/bathrooms_min.0/date_from.7/order_by.source_date/resultsPerPage.15/isUserSearch.1/page.5"
        
        idealista = "https://www.idealista.it/affitto-stanze/roma-roma/con-prezzo_300,prezzo-min_200,sesso_ragazza,pubblicato_ultimo-mese/?ordine=pubblicazione-desc"
        
        stanzaroma = "http://www.stanzaroma.com/stanze/?PREZZO=300&ORIGINE=index"
        
        
        
        
        #doc = Nokogiri::HTML.parse(URI.parse(subito))
        #@lista = doc.css('div.heat a').map { |link| link['href'] }
        mechanize = Mechanize.new
        
        
        threads = []
        threads << Thread.new { subito = mechanize.get(subito) }
        threads << Thread.new { subito2 = mechanize.get(subito2) }
        threads << Thread.new { subito3 = mechanize.get(subito3) }
        threads << Thread.new { bakeca = mechanize.get(bakeca) }
        threads << Thread.new { bakeca2 = mechanize.get(bakeca2) }
        threads << Thread.new { bakeca3 = mechanize.get(bakeca3) }
        threads << Thread.new { subito3 = mechanize.get(subito3) }
        threads << Thread.new { immobiliare = mechanize.get(immobiliare) }
        threads << Thread.new { portaportese = mechanize.get(portaportese) }
        threads << Thread.new { trovit = mechanize.get(trovit) }
        threads << Thread.new { trovit2 = mechanize.get(trovit2) }
        threads << Thread.new { trovit3 = mechanize.get(trovit3) }
        threads << Thread.new { trovit4 = mechanize.get(trovit4) }
        threads << Thread.new { trovit5 = mechanize.get(trovit5) }
        threads << Thread.new { idealista = mechanize.get(idealista) }
        threads << Thread.new { stanzaroma = mechanize.get(stanzaroma) }
        threads.each(&:join) 
        
        
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
        
        
        
        subito2.search('.main .items_listing').search('li').each do |item|
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
        
        
        
        subito3.search('.main .items_listing').search('li').each do |item|
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
        
        
        bakeca.search('.bk-annuncio-item').each do |item|
            link = item.search('.bk-annuncio-title a').first['href']
            description = item.search('.bk-annuncio-title').text.strip
            price = item.search('.bk-annuncio-prezzo').text.strip
            image = item.search('.bk-lazy').to_s[36..-3]
            @results[link] = [price,image,description]
        end
        
        
        bakeca2.search('.bk-annuncio-item').each do |item|
            link = item.search('.bk-annuncio-title a').first['href']
            description = item.search('.bk-annuncio-title').text.strip
            price = item.search('.bk-annuncio-prezzo').text.strip
            image = item.search('.bk-lazy').to_s[36..-3]
            @results[link] = [price,image,description]
        end
        
        bakeca3.search('.bk-annuncio-item').each do |item|
            link = item.search('.bk-annuncio-title a').first['href']
            description = item.search('.bk-annuncio-title').text.strip
            price = item.search('.bk-annuncio-prezzo').text.strip
            image = item.search('.bk-lazy').to_s[36..-3]
            @results[link] = [price,image,description]
        end
        
        # CERCO SU IMMOBILIARE
        
        
        immobiliare.search('.wrapper_riga_annuncio').search('.content').each do |item|
            link = item.search('.annuncio_title a').first['href']
            description = item.search('.annuncio_title a').text.strip
            price = item.search('span.price').text
            image = item.search('.wrap_img img').first['src']
            @results[link] = [price,image,description]
        end
            
        # CERCO SU PORTAPORTESE
        
        
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
        
        
        trovit.search('.item_v5').each do |item|
            link = item.search('a.js-item-title').first['href']
            description = item.search('a.js-item-title').first['title']
            if (item.search('.lazyImage').first != nil)
                image = "http://"+item.search('.lazyImage').first['data-src'][2..-1]
            end
            price = item.search('span.amount').text
            
            
            @results[link] = [price,image,description]
            
        end
        
    
        
        trovit2.search('.item_v5').each do |item|
            link = item.search('a.js-item-title').first['href']
            description = item.search('a.js-item-title').first['title']
            if (item.search('.lazyImage').first != nil)
                image = "http://"+item.search('.lazyImage').first['data-src'][2..-1]
            end
            price = item.search('span.amount').text
            @results[link] = [price,image,description]
        end
        
        
        trovit3.search('.item_v5').each do |item|
            link = item.search('a.js-item-title').first['href']
            description = item.search('a.js-item-title').first['title']
            if (item.search('.lazyImage').first != nil)
                image = "http://"+item.search('.lazyImage').first['data-src'][2..-1]
            end
            price = item.search('span.amount').text
            @results[link] = [price,image,description]
        end

        trovit4.search('.item_v5').each do |item|
            link = item.search('a.js-item-title').first['href']
            description = item.search('a.js-item-title').first['title']
            if (item.search('.lazyImage').first != nil)
                image = "http://"+item.search('.lazyImage').first['data-src'][2..-1]
            end
            price = item.search('span.amount').text
            @results[link] = [price,image,description]
        end
        
        trovit5.search('.item_v5').each do |item|
            link = item.search('a.js-item-title').first['href']
            description = item.search('a.js-item-title').first['title']
            if (item.search('.lazyImage').first != nil)
                image = "http://"+item.search('.lazyImage').first['data-src'][2..-1]
            end
            price = item.search('span.amount').text
            @results[link] = [price,image,description]
        end
        
        # CERCO SU IDEALISTA
        
        
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
